//
// Kardia CRM Javascript file for pop-up message display window
// (c) 2015-2016 LightSys Technology Services, Inc.
//

// FIXME - this logic needs to be generalized so we can also use it in the tabmail
// message display tab, the integrated 3-pane message display pane, and in the
// message compose window (with slightly different logic there).  This probably
// involves creating our own XUL overlay for the controls, and loading that XUL
// overlay in each of four XUL overlays for the four places we want to use this
// stuff.

// We need to link to our CRM data that's over in the main window context.
var mainWindow = Components.classes["@mozilla.org/appshell/window-mediator;1"]
	.getService(Components.interfaces.nsIWindowMediator)
	.getMostRecentWindow("mail:3pane");
var kardiacrm = mainWindow.kardiacrm;
//kardiacrm.lastMessageWindow = window;

// This is our main object containing all data and state and functionality relating to
// the message window part of the Kardia CRM interface for TB.  This should be migrated
// to a function (instead of a bare object) (FIXME) to allow private data (via closure)
// in addition to publicly exported functions and properties.
//
// This functionality also fills the function of a persistence layer for this screen.
// We could utilize a more generalized approach for this (FIXME), which will assist as
// later complexity develops, but this approach works.  Backbone.js anyone?  In a XUL
// application? :)
//
// This is all lumped into one file here, but this is actually MVC.  The reSync-series
// functions implement the Model, reEvaluate implements the Controllers, and the
// corresponding .xul file is the View.
//
var messageWindow = {
	jQuery:null,
	console:null,
	logging:false,

	// Whether we've run the controller (reEvaluate) for the first time in this
	// message context.  The first time we run it, there are some additional steps
	// that need to be taken that should NOT be taken afterward.
	initialized:false,

	// These are used for queuing reset and reeval calls.  FIXME this could really
	// itself be replaced by a message queue / dispatch type setup.  But this gets
	// the job done.
	do_reset:false,
	do_reeval:false,
	do_sidebar:false,

	// Information about the message recipient(s) 
	isNewRecipient:false,
	recipientAddresses:[],
	recipientFullNames:[],
	recipientFirstNames:[],
	recipientLastNames:[],

	// Information about the recipients that we get from kardia
	// (For the other footers, this is stored in mainWindow, not here)
	emailAddresses:[],
	names:[],
	ids:[],

	// Deferred object that lets us know when recipient data (names, ids) 
	// has fully arrived from Kardia
	recipient_data_loaded_deferred:null,
	recipient_data_loading:false,

	// Saved copies of data from the form.  This allows us to determine if data has
	// changed from one re-evaluation to another, so we can (for instance) trigger
	// PATCH requests to modify data on the server.
	curData: { assignee:null, todotype:null, roletype:null, days:null, first:null, last:null, email:null, todo_comment:null },
	prevData: { },

	// Flags that tell us whether new records are being created.
	creatingPartner:false,
	creatingLocation:false,
	creatingEmail:false,
	creatingCollab:false,
	creatingContactHistory:false,
	creatingAutorecord:false,
	creatingTodo:false,

	// Here we squirrel away the primary keys (API object names) for the
	// new records we explicitly create.  If the user changes his/her mind,
	// we can know to delete the records via these keys.
	newPartnerKey:null,
	newLocationKey:null,
	newEmailKey:null,
	newCollabKey:null,
	newContactHistoryKey:null,
	newAutorecordKey:null,
	newTodoKey:null,


	// This function extracts a new key out of the Location data that results from
	// a POST request to create a new record.  The key is embedded in the Location:
	// header's filename, and we need to extract it.
	//
	getKeyFromLocation: function(loc, endpoint) {
		if (loc) {
			var qmark_pos = loc.indexOf('?');
			var partners_pos = loc.indexOf(endpoint);
			if (partners_pos >= 0 && qmark_pos > partners_pos) {
				return loc.substring(partners_pos + (new String(endpoint)).length, qmark_pos);
			}
		}
		return null;
	},

	// TEMP AJT
	fakeRequestPost: function(url, data, dclass, completion, callback) {
		console.log(url + " " + data + " " + dclass);
		callback();
		// TODO completion
	},
	
	fakeRequestPatch: function(url, data, dclass, completion, callback) {
		console.log(url + " " + data + " " + dclass);
		callback();
		// TODO completion
	},
	
	fakeRequestDelete: function(url, dclass, completion, callback) {
		console.log(url + " " + dclass);
		callback();
		// TODO completion
	},
	

	// This function makes the necessary updates into the Kardia database to reflect
	// what the user has asked for on this message display window.
	//
	postChanges: function() {
		var date = new Date();
		// TODO AJT creatingPartner always false

		// This is called once all create/update/delete modifications have finished
		// hitting the server.  At that point we call a custom callback, reset the
		// data (this happens if the user just used forward/back in the message window
		// to jump to another email triggering both a data save then a data load of
		// the next email's info), and finally refresh the user's information in the
		// main window.
		//
		// The dispatch logic in main-window.js handles calling this completion routine
		// once the request queue is empty and no requests to the server are still
		// outstanding.
		//
		var completion = function(no_changes) {}; 
		
		////
		////  CREATE PHASE - first step, creation of the partner record, if needed.
		////
		if (messageWindow.creatingPartner && messageWindow.newPartnerKey === null) {
			kardiacrm.requestGet('partner/NextPartnerKey?cx__mode=rest&cx__res_type=element&cx__res_format=attrs&cx__res_attrs=basic', 'resync', completion, function(resp) {
				if (resp) {
					messageWindow.fakeRequestPost('partner/Partners', 
							{
							p_partner_key: resp.partner_id,
							p_creating_office: ' ',
							p_partner_class: 'IND',
							p_status_code: 'A',
							p_given_name: messageWindow.curData.first,
							p_surname: messageWindow.curData.last,
							p_record_status_code: 'A',
							p_surname_first: 0,
							p_no_solicitations: 0,
							p_no_mail: 0,
							s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_created_by: kardiacrm.username,
							s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_modified_by: kardiacrm.username,
							},
						'resync', completion, function(resp) {
							if (resp) {
								if (resp.Location) {
									messageWindow.newPartnerKey = messageWindow.getKeyFromLocation(resp.Location, '/Partners/');
									messageWindow.prevData.first = messageWindow.curData.first;
									messageWindow.prevData.last = messageWindow.curData.last;
								}
								messageWindow.reSyncPostPartner(completion, false);
							}
					});
				}
			});
		}
		else {
			messageWindow.reSyncPostPartner(completion, true);
		}
	},

	// Done after partner creation, or if no create was needed.
	reSyncPostPartner: function(completion, no_changes) {
		var date = new Date();
		// Make sure we have a partner key.
		var partner = messageWindow.newPartnerKey;
		if (!partner && messageWindow.recipientAddresses.length > 0) {
			var idx = messageWindow.getEmailIndex(messageWindow.recipientAddresses[document.getElementById("contact-which-recipient").selectedIndex]); 
			
			if (idx >= 0) {
				partner = messageWindow.ids[idx];
			}
		}

		////
		////  CREATE PHASE - second step, creation of address, email, todo, and collab,
		////		     records, all of which require that the partner record exist.
		////
		if (partner) {
			// Create partner location record?
			if (messageWindow.creatingLocation && messageWindow.newLocationKey === null) {
				no_changes = false;
				messageWindow.fakeRequestPost('partner/Partners/' + partner + '/Addresses', 
						{
						p_partner_key: partner,
						p_revision_id: 0,
						p_location_type: 'H',
						p_record_status_code: 'A',
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							messageWindow.newLocationKey = messageWindow.getKeyFromLocation(resp.Location, '/Addresses/');
						}
				});
			}

			// Create collab record?
			if (messageWindow.creatingCollab && messageWindow.newCollabKey === null && messageWindow.curData.roletype) {
				no_changes = false;
				messageWindow.fakeRequestPost('crm/Partners/' + partner + '/Collaborators', 
						{
						p_partner_key: partner,
						e_collaborator: mainWindow.myId,
						e_collab_type_id: parseInt(messageWindow.curData.roletype),
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							if (resp.Location) {
								messageWindow.newCollabKey = messageWindow.getKeyFromLocation(resp.Location, '/Collaborators/');
								messageWindow.prevData.roletype = messageWindow.curData.roletype;
							}
						}
				});
			}

			// Create todo record?
			if (messageWindow.creatingTodo && messageWindow.newTodoKey === null && messageWindow.curData.todotype && messageWindow.curData.assignee && messageWindow.curData.days) {
				no_changes = false;
				var duedate = new Date(date);
				duedate.setDate(duedate.getDate() + parseInt(messageWindow.curData.days));
				messageWindow.fakeRequestPost('crm/Partners/' + partner + '/Todos', 
						{
						e_todo_type_id: parseInt(messageWindow.curData.todotype),
						e_todo_desc: messageWindow.curData.todo_comment,
						e_todo_status: 'I',
						e_todo_collaborator: messageWindow.curData.assignee,
						e_todo_partner: partner,
						e_todo_due_date: {year: duedate.getFullYear(), month: duedate.getMonth()+1, day:duedate.getDate(), hour:duedate.getHours(), minute:duedate.getMinutes(), second:duedate.getSeconds() },
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							if (resp.Location) {
								messageWindow.newTodoKey = messageWindow.getKeyFromLocation(resp.Location, '/Todos/');
								messageWindow.prevData.todotype = messageWindow.curData.todotype;
								messageWindow.prevData.assignee = messageWindow.curData.assignee;
								messageWindow.prevData.days = messageWindow.curData.days;
								messageWindow.prevData.todo_comment = messageWindow.curData.todo_comment;
							}
						}
				});
			}

			// Create email record?
			if (messageWindow.creatingEmail && messageWindow.newEmailKey === null && messageWindow.curData.email) {
				messageWindow.fakeRequestPost('partner/Partners/' + partner + '/ContactInfo', 
						{
						p_partner_key: partner,
						p_contact_type: 'E',
						p_contact_data: messageWindow.curData.email,
						p_record_status_code: 'A',
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							if (resp.Location) {
								messageWindow.newEmailKey = messageWindow.getKeyFromLocation(resp.Location, '/ContactInfo/');
								messageWindow.prevData.email = messageWindow.curData.email;
							}
							messageWindow.reSyncPostEmail(completion, false);
						}
				});
			}
			else {
				messageWindow.reSyncPostEmail(completion, no_changes);
			}
		} else {
			messageWindow.reSyncPostEmail(completion, no_changes);
		}
	},


	// Done after email creation, or if no email creation needed.
	reSyncPostEmail: function(completion, no_changes) {
		var date = new Date();
		// Make sure we have a partner key.
		var partner = messageWindow.newPartnerKey;
		if (!partner && messageWindow.recipientAddresses.length > 0) {
			var idx = messageWindow.getEmailIndex(messageWindow.recipientAddresses[document.getElementById("contact-which-recipient").selectedIndex]); 
			if (idx >= 0) {
				partner = messageWindow.ids[idx];
			}
		}

		// Make sure we have an email key.
		var email = messageWindow.newEmailKey;
		if (!email && messageWindow.recipientAddresses.length > 0) {
			var idx = messageWindow.getEmailIndex(messageWindow.recipientAddresses[document.getElementById("contact-which-recipient").selectedIndex]); 
			if (idx >= 0) {
				email = mainWindow.emailIds[idx];
			}
		}
		var email_id = null;
		if (email) {
			email_id = parseInt(email.substr(email.indexOf('|') + 1));
		}

		////
		////  CREATE PHASE - third step, final creation of contact history and autorecord records,
		////		     both of which require that the partner and email records exist.
		////
		if (partner && email) {
			// determine Email contact type
			var contact_type = null;
			for(var k in kardiacrm.data.noteTypeList) {
				if (kardiacrm.data.noteTypeList[k].label == 'Email') {
					contact_type = kardiacrm.data.noteTypeList[k].id;
					break;
				}
			}

			// Create contact history record?
			if (messageWindow.creatingContactHistory && messageWindow.newContactHistoryKey === null) {
				// Date of email
				// TODO AJT
				var email_date = new Date(gMessageDisplay.displayedMessage.dateInSeconds * 1000);

				// Text content preview of email.  This is a very rough cut here and loses ALL
				// formatting, but to preserve formatting we're dealing with parsing HTML, and
				// since this is the message window context there are some constraints on what
				// jQuery can do that ordinarily would be allowed, due to security restrictions
				// in the message display (no scripts in messagepane, which is implemented oddly
				// for our purposes).
				//
				// We'd also like to capture just the *selected text* if the user chooses to do
				// that, but we're again dealing with some restrictions there that have to be
				// worked around somehow.
				//
				var email_text = messageWindow.jQuery(messageWindow.jQuery("#messagepane")[0].contentWindow.document.children[0].children[1]).text();
				if (email_text) {
					email_text = email_text.substr(0,900);
				}
				else {
					email_text = "";
				}
				
				// Do the create if we have a valid email contact type.
				if (contact_type) {
					no_changes = false;
					messageWindow.fakeRequestPost('crm/Partners/' + partner + '/ContactHistory', 
							{
							p_partner_key: partner,
							e_contact_history_type: contact_type,
							p_contact_id: email_id,
							e_whom: mainWindow.myId,
							e_initiation: 'P',
							e_subject: gMessageDisplay.displayedMessage.subject,
							e_message_id: gMessageDisplay.displayedMessage.messageId,
							e_contact_date: {year: email_date.getFullYear(), month: email_date.getMonth()+1, day:email_date.getDate(), hour:email_date.getHours(), minute:email_date.getMinutes(), second:email_date.getSeconds() },
							e_notes: email_text,
							s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_created_by: kardiacrm.username,
							s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_modified_by: kardiacrm.username,
							},
						'resync', completion, function(resp) {
							if (resp) {
								messageWindow.newContactHistoryKey = messageWindow.getKeyFromLocation(resp.Location, '/ContactHistory/');
							}
					});
				}
			}

			// Create autorecord record?  (and... when a fox is in the bottle where the tweetle beetles battle...)
			if (messageWindow.creatingAutorecord && messageWindow.newAutorecordKey === null) {
				// Do the create for the e_contact_autorecord data
				if (contact_type) {
					no_changes = false;
					messageWindow.fakeRequestPost('crm/Partners/' + partner + '/ContactAutorecord',
							{
							p_partner_key: partner,
							e_collaborator_id: mainWindow.myId,
							e_contact_history_type: contact_type,
							p_contact_id: email_id,
							e_auto_record: 1,
							e_auto_record_apply_all: 1,
							s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_created_by: kardiacrm.username,
							s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
							s_modified_by: kardiacrm.username,
							},
						'resync', completion, function(resp) {
							if (resp) {
								messageWindow.newAutorecordKey = messageWindow.getKeyFromLocation(resp.Location, '/ContactAutorecord/');
							}
					});
				}
			}
		}

		////
		////  MODIFY PHASE - update data if user has modified it, via PATCH REST requests.
		////
		if (messageWindow.creatingPartner && partner && (messageWindow.curData.first != messageWindow.prevData.first || messageWindow.curData.last != messageWindow.prevData.last)) {
			no_changes = false;
			messageWindow.fakeRequestPatch('partner/Partners/' + partner, 
					{
					surname: messageWindow.curData.last,
					given_names: messageWindow.curData.first,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (messageWindow.creatingEmail && email && messageWindow.curData.email != messageWindow.prevData.email) {
			no_changes = false;
			messageWindow.fakeRequestPatch('partner/Partners/' + partner + '/ContactInfo/' + email, 
					{
					contact_data: messageWindow.curData.email,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (messageWindow.creatingCollab && messageWindow.newCollabKey && messageWindow.curData.roletype != messageWindow.prevData.roletype) {
			no_changes = false;
			messageWindow.fakeRequestPatch('crm/Partners/' + partner + '/Collaborators/' + messageWindow.newCollabKey, 
					{
					collaborator_type_id: parseInt(messageWindow.curData.roletype),
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (messageWindow.creatingTodo && messageWindow.newTodoKey && (messageWindow.curData.todotype != messageWindow.prevData.todotype || messageWindow.curData.assignee != messageWindow.prevData.assignee || messageWindow.curData.todo_comment !=messageWindow.prevData.todo_comment || messageWindow.curData.days != messageWindow.prevData.days)) {
			no_changes = false;
			var duedate = new Date(date);
			duedate.setDate(duedate.getDate() + parseInt(messageWindow.curData.days));
			messageWindow.fakeRequestPatch('crm/Partners/' + partner + '/Todos/' + messageWindow.newTodoKey, 
					{
					todo_type_id: parseInt(messageWindow.curData.todotype),
					desc: messageWindow.curData.todo_comment,
					due_date: {year: duedate.getFullYear(), month: duedate.getMonth()+1, day:duedate.getDate(), hour:duedate.getHours(), minute:duedate.getMinutes(), second:duedate.getSeconds() },
					collaborator_id: messageWindow.curData.assignee,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}

		////
		////  DELETE PHASE - remove data if user changed mind about creating it.
		////
		if (messageWindow.newEmailKey && !messageWindow.creatingEmail && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('partner/Partners/' + partner + '/ContactInfo/' + messageWindow.newEmailKey, 'resync', completion, function(resp) {
				messageWindow.newEmailKey = null;
			});
		}
		if (messageWindow.newLocationKey && !messageWindow.creatingLocation && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('partner/Partners/' + partner + '/Addresses/' + messageWindow.newLocationKey, 'resync', completion, function(resp) {
				messageWindow.newLocationKey = null;
			});
		}
		if (messageWindow.newCollabKey && !messageWindow.creatingCollab && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('crm/Partners/' + partner + '/Collaborators/' + messageWindow.newCollabKey, 'resync', completion, function(resp) {
				messageWindow.newCollabKey = null;
			});
		}
		if (messageWindow.newTodoKey && !messageWindow.creatingTodo && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('crm/Partners/' + partner + '/Todos/' + messageWindow.newTodoKey, 'resync', completion, function(resp) {
				messageWindow.newTodoKey = null;
			});
		}
		if (messageWindow.newContactHistoryKey && !messageWindow.creatingContactHistory && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('crm/Partners/' + partner + '/ContactHistory/' + messageWindow.newContactHistoryKey, 'resync', completion, function(resp) {
				messageWindow.newContactHistoryKey = null;
			});
		}
		if (messageWindow.newAutorecordKey && !messageWindow.creatingAutorecord && partner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('crm/Partners/' + partner + '/ContactAutorecord/' + messageWindow.newAutorecordKey, 'resync', completion, function(resp) {
				messageWindow.newAutorecordKey = null;
			});
		}
		if (messageWindow.newPartnerKey && !messageWindow.creatingPartner) {
			no_changes = false;
			messageWindow.fakeRequestDelete('partner/Partners/' + messageWindow.newPartnerKey, 'resync', completion, function(resp) {
				messageWindow.newPartnerKey = null;
			});
		}
		
		// If no requests are pending, call completion now.
		if (!kardiacrm.isPending('resync')) {
			completion(no_changes);
		}
	},


	// Lots of things are inter-related.  We process them here in this controller; the event
	// handlers for the input fields, plus completion callbacks on data retrieval, all point
	// to this controller function.
	//
	reEvaluate: function(event) {
		// If reset pending, don't do this, instead defer until later.
		if (messageWindow.do_reset) {
			messageWindow.do_reeval = true;
			return;
		}
		messageWindow.log("reEvaluate()");
		messageWindow.do_reeval = false;

		if (!event) { // only redo email address list if it wasn't a click event
			
			// Make a note of current field values, and save previous ones.
			messageWindow.prevData = {};
			for(var k in messageWindow.curData)
				messageWindow.prevData[k] = messageWindow.curData[k];
			messageWindow.curData.assignee = messageWindow.jQuery("#todo-assignee")[0].value;
			messageWindow.curData.todotype = messageWindow.jQuery("#todo-type")[0].value;
			messageWindow.curData.roletype = messageWindow.jQuery("#newperson-role")[0].value;
			messageWindow.curData.days = messageWindow.jQuery("#todo-days")[0].value;
			messageWindow.curData.first = messageWindow.jQuery("#newperson-first")[0].value;
			messageWindow.curData.last = messageWindow.jQuery("#newperson-last")[0].value;
			messageWindow.curData.email = messageWindow.jQuery("#newperson-email")[0].value;
			messageWindow.curData.todo_comment = messageWindow.jQuery("#todo-comment")[0].value;
	
			// Save current values of fields that may be re-used when the user re-opens
			// this screen later on.
			if (messageWindow.curData.assignee)
				kardiacrm.last_assignee = messageWindow.curData.assignee;
			if (messageWindow.curData.todotype)
				kardiacrm.last_todo_type = messageWindow.curData.todotype;
			if (messageWindow.curData.roletype !== null)
				kardiacrm.last_role_type = messageWindow.curData.roletype;
			if (messageWindow.curData.days)
				kardiacrm.last_due_days = messageWindow.curData.days;
	
			// Find recipient(s) of email
			var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces["nsIMsg" + "HeaderParser"]); // workaround for overzealous regex on AMO.
				
			messageWindow.recipientAddresses=[];
			messageWindow.recipientFullNames=[];
			messageWindow.recipientFirstNames=[];
			messageWindow.recipientLastNames=[];
	
			var i=1;
			var field = document.getElementById("addressCol2#" + i);
			if (document.getElementById("contact-which-recipient"))
				document.getElementById("contact-which-recipient").removeAllItems();
			
			while (field) {
				if (field.value && field.value.trim().length > 0) {
					var recipient = field.value;
					var addressArray = {};
					var nameArray = {};
					parser.parseHeadersWithArray(recipient, addressArray, nameArray, {});
					messageWindow.recipientAddresses.push(addressArray.value[0]);
					var fullName = nameArray.value[0];
					messageWindow.recipientFullNames.push(fullName);
	
					// Try to find first and last name if possible			
					if (fullName && fullName.toLowerCase() != addressArray.value[0].toLowerCase()) {
						var comma_idx = fullName.indexOf(',');
						var space_idx = fullName.indexOf(' ');
						var space_last_idx = fullName.lastIndexOf(' ');
						if (comma_idx >= 0 && (space_idx > comma_idx || space_idx < 0)) {
							messageWindow.recipientFirstNames.push(fullName.substr(((space_idx == comma_idx+1)?space_idx:comma_idx) + 1));
							messageWindow.recipientLastNames.push(fullName.substr(0, comma_idx));
						}
						else if (space_last_idx >= 0) {
							messageWindow.recipientFirstNames.push(fullName.substr(0, space_last_idx));
							messageWindow.recipientLastNames.push(fullName.substr(space_last_idx + 1));
						}
						else {
							messageWindow.recipientFirstNames.push(fullName);
							messageWindow.recipientLastNames.push("");
						}
					}
					else {
						messageWindow.recipientFirstNames.push(fullName);
						messageWindow.recipientLastNames.push("");
					}
					document.getElementById("contact-which-recipient").appendItem(recipient, addressArray.value[0], null);
						
				}
	
				field = document.getElementById("addressCol2#" + ++i);
			}
			document.getElementById("contact-which-recipient").selectedIndex = 0;

			// update email address list
			if (messageWindow.recipientAddresses.length > 0) messageWindow.findRecipientEmails(messageWindow.recipientAddresses);
		}
		else {
			messageWindow.jQuery.when(messageWindow.recipient_data_loaded_deferred).then( function(value) {
				// a checkbox was clicked, so do tasks relevant to the selected item
				// Is recipient in Kardia?  If not, note that this is a new recipient so that we
				// auto-create a record in Kardia for them when the user wants to record the
				// email or whatnot.
				messageWindow.isNewRecipient = false;
				if (kardiacrm.partners_loaded && messageWindow.recipientAddresses.length > 0
					&& messageWindow.getEmailIndex(messageWindow.recipientAddresses[y]) < 0)
					messageWindow.isNewRecipient = true;


				// The Message ID can't already be in the Kardia DB, because it doesn't exist yet.
				// The note or task cannot be saved until the email is sent, because that is when the ID is generated.
			
				var idx = messageWindow.getEmailIndex(messageWindow.recipientAddresses[document.getElementById("contact-which-recipient").selectedIndex]);

				// Look for a Contact Auto-Record entry in the database, and automatically
				// select that option if so (and set the newAutorecordKey, so that if the user
				// un-checks the box, we can delete the entry from Kardia).
				//
				// TODO AJT should this really be here??
				// FIXME - this currently only works for the simple case of one autorecord entry
				// for the partner.  It does not handle override entries (one system-wide enabled
				// for the partner, and one specific to the collaborator but which is turned off),
				// as that will require additional UI work to properly present to the user.  We
				// will need to update this to solve the override problem once override capability
				// is exposed in the web UI.
				//
				// TODO AJT testing
				// TODO remove partner_data_loaded?
				if (kardiacrm.partner_data_loaded && idx >= 0 && mainWindow.autorecord[idx]) {
					var has_autorecord = false;
					for(var k=0;k<mainWindow.autorecord[idx].length;k++) {
						var ar = mainWindow.autorecord[idx][k];
						if (ar.auto_record && (ar.collab_partner_id == mainWindow.myId || ar.auto_record_apply_all)) {
							has_autorecord = ar.name;
							break;
						}
					}
					if (has_autorecord) {
						messageWindow.jQuery("#record-future").prop("checked", true);
						messageWindow.newAutorecordKey = has_autorecord;
					}
				}

				// If we're auto-recording, BUT this message isn't yet marked for recording, then
				// mark it for recording.  We don't do this automatically when the user checks the
				// "future" checkbox initially.  But if they close and re-open this window right
				// away, or if they open this window on any future or past email from the same
				// email address, this here gets triggered.
				//
				if (kardiacrm.partners_loaded && messageWindow.jQuery("#record-future").prop("checked") && !messageWindow.jQuery("#record-contact").prop("checked")) {
					messageWindow.jQuery("#record-contact").prop("checked", true);
				}
			});
		}

		recipientIndex = document.getElementById("contact-which-recipient").selectedIndex;

		// Whether to show the new person info box at bottom
		if ((messageWindow.jQuery("#record-contact").prop("checked") || messageWindow.jQuery("#record-todo").prop("checked") || messageWindow.jQuery("#record-future").prop("checked")) && messageWindow.isNewRecipient) {
			messageWindow.jQuery("#newperson-box").css({display: "block"});
			messageWindow.creatingPartner = true;
			messageWindow.creatingLocation = true;
			messageWindow.creatingEmail = true;

			// Fill the editboxes for email, first name, and last name.
			if (!messageWindow.jQuery("#newperson-email")[0].value) {
				messageWindow.jQuery("#newperson-email").prop("value", messageWindow.recipientAddresses[recipientIndex]);
				messageWindow.curData.email = messageWindow.jQuery("#newperson-email")[0].value;
			}
			if (!messageWindow.jQuery("#newperson-first")[0].value) {
				messageWindow.jQuery("#newperson-first").prop("value", messageWindow.recipientFirstNames[recipientIndex]);
				messageWindow.curData.first = messageWindow.jQuery("#newperson-first")[0].value;
			}
			if (!messageWindow.jQuery("#newperson-last")[0].value) {
				messageWindow.jQuery("#newperson-last").prop("value", messageWindow.recipientLastNames[recipientIndex]);
				messageWindow.curData.last = messageWindow.jQuery("#newperson-last")[0].value;
			}

			// Fill in the role options
			messageWindow.jQuery("#newperson-role menupopup")
				.empty()
				.append(
					messageWindow.jQuery("<menuitem>", {
						value: '',
						label: '(none)',
					})
				);
			for (var i in kardiacrm.data.collabTypeList) {
				messageWindow.jQuery("#newperson-role menupopup")
					.append(
						messageWindow.jQuery("<menuitem>", {
							value: '' + i,
							label: kardiacrm.data.collabTypeList[i].label,
						})
					);
				if (kardiacrm.last_role_type !== null)
					messageWindow.jQuery("#newperson-role")[0].value = kardiacrm.last_role_type;
			}
		}
		else {
			messageWindow.jQuery("#newperson-box").css({display: "none"});
			messageWindow.creatingPartner = false; 
			messageWindow.creatingLocation = false; 
			messageWindow.creatingEmail = false;
		}

		// Whether to create a contact history record for this email
		if (messageWindow.jQuery("#record-contact").prop("checked")) {
			messageWindow.creatingContactHistory = true;
		}
		else {
			messageWindow.creatingContactHistory = false;
		}

		// Whether to create the collaborator record (role not '(none)')
		if (messageWindow.creatingPartner && messageWindow.jQuery("#newperson-role")[0].value) {
			messageWindow.creatingCollab = true;
		}
		else {
			messageWindow.creatingCollab = false;
		}

		// Whether to create an autorecord entry for this person
		if (messageWindow.jQuery("#record-future").prop("checked")) {
			messageWindow.creatingAutorecord = true;
		}
		else {
			messageWindow.creatingAutorecord = false;
		}

		// Whether to show the new task info
		if (messageWindow.jQuery("#record-todo").prop("checked")) {
			messageWindow.jQuery("#todo-options").css({display: "block"});
			messageWindow.creatingTodo = true;

			// Fill in the task type options and assignee options
			messageWindow.jQuery("#todo-type menupopup").empty();
			for (var i in kardiacrm.data.todoTypeList) {
				messageWindow.jQuery("#todo-type menupopup")
					.append(
						messageWindow.jQuery("<menuitem>", {
							value: '' + i,
							label: kardiacrm.data.todoTypeList[i].type_label,
						})
					);
				if (kardiacrm.last_todo_type)
					messageWindow.jQuery("#todo-type")[0].value = kardiacrm.last_todo_type;
			}
			messageWindow.jQuery("#todo-assignee menupopup").empty();
			for (var i in kardiacrm.data.staffList) {
				if (kardiacrm.data.staffList[i].is_staff && kardiacrm.data.staffList[i].kardia_login) {
					messageWindow.jQuery("#todo-assignee menupopup")
						.append(
							messageWindow.jQuery("<menuitem>", {
								value: kardiacrm.data.staffList[i].partner_id,
								label: kardiacrm.data.staffList[i].partner_name,
							})
						);
					if (kardiacrm.last_assignee)
						messageWindow.jQuery("#todo-assignee")[0].value = kardiacrm.last_assignee;
					else
						messageWindow.jQuery("#todo-assignee")[0].value = mainWindow.myId;
				}
			}
			if (kardiacrm.last_due_days)
				messageWindow.jQuery("#todo-days")[0].value = '' + kardiacrm.last_due_days;
		}
		else {
			messageWindow.jQuery("#todo-options").css({display: "none"});
			messageWindow.creatingTodo = false;
		}

		// This footer is different in that we want to re-initialize every time the email
		// address list changes. 
		
		// Mark initialization complete if we operated with full data awareness
		// on this pass.  After initialization, we don't go automatically clicking
		// contact-record checkboxes for the user (we want the user to like us).
		// The check for !do_sidebar here prevents us from calling things initialized
		// if we're about to reload the sidebar from a message context change.
		//
		if (!messageWindow.initialized && !messageWindow.do_sidebar && messageWindow.recipientAddresses.length > 0) {
			// disable until all data is ready
			messageWindow.disableControls();
			messageWindow.jQuery.when(messageWindow.recipient_data_loaded_deferred).then(function(value) {
				messageWindow.log("initialized");
				messageWindow.enableControls();
				messageWindow.initialized = true;
			});
		}
		else if (messageWindow.recipientAddresses.length == 0) messageWindow.disableControls();

		// Save changes, if needed.
		if (messageWindow.do_reset) {
			messageWindow.reset_bh();
		}

		// Lookup emails, if needed.
		if (messageWindow.do_sidebar) {
			messageWindow.reloadMainSidebar(false);
		}
	},


	// Get index of email address in main email listing for this message.
	getEmailIndex: function(str) {
		if (!str)
			return -1;
		else
			return messageWindow.emailAddresses.indexOf(str.toLowerCase());
	},


	// Disable all controls
	disableControls: function() {
		messageWindow.jQuery("#contact-box").find("textbox,menulist,checkbox").prop("disabled", true);
	},


	// Enable all controls
	enableControls: function() {
		messageWindow.jQuery("#contact-box").find("textbox,menulist,checkbox").removeProp("disabled");
	},


	// Reload the sidebar in the main window.  Set 'force' to true to make it
	// reload even if the email message context has not changed.
	//
	reloadMainSidebar: function(force) {
		messageWindow.log("reloadMainSidebar()");
		messageWindow.do_sidebar = false;
		messageWindow.findRecipientEmails(messageWindow.recipientAddresses);
	},

	// Given the array of email addresses, query kardia db for associated partner ids and names
	// Store the result in messageWindow.emailAddresses, names, ids
	findRecipientEmails: function(addrs) {
		if (messageWindow.recipient_data_loading) return;
		messageWindow.recipient_data_loading = true;
		
		getNext = function(addressArray) {
			if (addressArray.length > 0) {
				kardiacrm.requestGet('partner/ContactTypes/Email/' + addressArray[0].replace("-", "") + '/Partners?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic', 'resync', function(){}, function(resp) {
					if (resp) {
						for (key in resp) {
							if (key != "@id") {
								var recipient = resp[key];
								messageWindow.emailAddresses.push(addressArray[0]);
								messageWindow.names.push(recipient.partner_name);
								messageWindow.ids.push(recipient.partner_id);
							}
						}
					}
					getNext(addressArray.slice(1));
				});
			}
			else {
				messageWindow.recipient_data_loaded_deferred.resolve();
				messageWindow.recipient_data_loading = false;
			}
		}

		messageWindow.recipient_data_loaded_deferred = messageWindow.jQuery.Deferred();
		messageWindow.emailAddresses = [];
		messageWindow.names = [];
		messageWindow.ids = [];
		getNext(addrs);
	},


	// Send a log message to the console log.  This is used for certain types of
	// debugging, since 1) this is event-driven and that can get a little crazy, and 2)
	// the Firefox remote debugger's breakpoints do not work in the message window,
	// only in the main 3-pane window.
	//
	log: function(msg) {
		if (messageWindow.logging) {
			var date = new Date();
			var ms = '' + date.getMilliseconds();
			if (date.getMilliseconds() < 100) ms = '0' + ms;
			if (date.getMilliseconds() < 10) ms = '0' + ms;
			messageWindow.console.logStringMessage(date.toTimeString() + "." + ms + " messageWindow " + msg + " do_reset:" + (messageWindow.do_reset?'true':'false') + " do_reeval:" + (messageWindow.do_reeval?'true':'false') + " do_sidebar:" + (messageWindow.do_sidebar?'true':'false') + " partnerlist:" + (kardiacrm.partners_loaded?'true':'false') + " partnerdata:" + (kardiacrm.partner_data_loaded?'true':'false'));
		}
	},


	// Reset the window and checkboxes as if it had just been opened.
	reset: function() {
		messageWindow.log("reset()");
		if (!kardiacrm.isPending('resync')) {
			messageWindow.reset_bh();
			if (messageWindow.do_reset) {
				messageWindow.reset_bh();
			}
		}
		else {
			messageWindow.do_reset = true;
		}
	},

	// Bottom half of the reset logic; this is where the work is done.
	reset_bh: function () {
		messageWindow.log("reset_bh()");
		messageWindow.disableControls();

		messageWindow.initialized = false;
		messageWindow.do_reset=false;
		messageWindow.isNewRecipient=false;
		messageWindow.recipientAddresses=[];
		messageWindow.recipientFullNames=[];
		messageWindow.recipientFirstNames=[];
		messageWindow.recipientLastNames=[];

		messageWindow.emailAddresses = [];
		messageWindow.names = [];
		messageWindow.ids = [];

		messageWindow.curData = { assignee:null, todotype:null, roletype:null, days:null, first:null, last:null, email:null, todo_comment:null };
		messageWindow.prevData = { };

		messageWindow.creatingPartner=false;
		messageWindow.creatingLocation=false;
		messageWindow.creatingEmail=false;
		messageWindow.creatingCollab=false;
		messageWindow.creatingContactHistory=false;
		messageWindow.creatingAutorecord=false;
		messageWindow.creatingTodo=false;

		messageWindow.newPartnerKey=null;
		messageWindow.newLocationKey=null;
		messageWindow.newEmailKey=null;
		messageWindow.newCollabKey=null;
		messageWindow.newContactHistoryKey=null;
		messageWindow.newAutorecordKey=null;
		messageWindow.newTodoKey=null;

		messageWindow.jQuery("#record-contact").removeProp("checked");
		messageWindow.jQuery("#record-todo").removeProp("checked");
		messageWindow.jQuery("#record-future").removeProp("checked");

		// Chain to other queued operations that could not be done until
		// after the reset finished.
		//
		if (messageWindow.do_reeval) {
			messageWindow.reEvaluate(null);
		} else if (messageWindow.do_sidebar) {
			messageWindow.reloadMainSidebar(false);
		}
	},

	customOnRecipientsChanged : function() {
		messageWindow.initialized = false;
		messageWindow.reEvaluate(null);
	}	
};

addEventListener("load", function() {
	// Load jQuery
	var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"].getService(Components.interfaces.mozIJSSubScriptLoader);
	//loader.loadSubScript("chrome://messenger/content/jquery.js", window);
	loader.loadSubScript("chrome://kardia/content/jquery-1.11.1.js", window);
	messageWindow.jQuery = window.jQuery.noConflict(true);

	// Gain access to the console for logging
	messageWindow.console = Components.classes["@mozilla.org/consoleservice;1"]
	        .getService(Components.interfaces.nsIConsoleService);
	messageWindow.log("load");

	// Add the kardia icons/flags when the message is rendered.
	/*gMessageListeners.push ({
		onEndHeaders: function () {*/
			kardiacrm.lastMessageWindow = window;
			messageWindow.do_reeval = true;
			messageWindow.do_sidebar = true;
			messageWindow.reset();
	/*	},
		onStartHeaders: function() {},
		onStartAttachments: function () {},
		onEndAttachments: function () {},
		onBeforeShowHeaderPane: function () {},
	});*/

	// Trap interactions with the checkboxes
	messageWindow.jQuery("#record-contact").click(function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#record-todo").click(function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#record-future").click(function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#todo-assignee").bind("command", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#todo-type").bind("command", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#newperson-role").bind("command", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#todo-days").bind("change", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#todo-comment").bind("change", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#newperson-email").bind("change", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#newperson-first").bind("change", function(event) {
		messageWindow.reEvaluate(event);
	});
	messageWindow.jQuery("#newperson-last").bind("change", function(event) {
		messageWindow.reEvaluate(event);
	});

}, false);

// capture the send event AFTER message id was generated and post changes at that time
function MyMsgSendListener(){
	this.onStartSending = function(aMsgId, aMsgSize) {};
	this.onProgress = function(aMsgID, aProgress, aProgressMax){};
	this.onStatus = function(aMsgID, aMsg){};
	this.onGetDraftFolderURI = function(aFolderUri){};
	this.onStopSending = function(aMsgID, aStatus, aMsg, aFile){
		console.log("done: " + aMsgID);
		messageWindow.postChanges();
	};
	this.onSendNotPerformed = function(aMsgID, aStatus){};
};
var observerService = Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService);
observerService.addObserver({
	observe: function(subject, topic, data) {
		subject.gMsgCompose.addMsgSendListener(new MyMsgSendListener());
	}
}, "mail:composeOnSend", false);