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
var contactFooter = {
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

	// Information about the message sender
	isNewSender:false,
	authorAddress:null,
	authorFullName:null,
	authorFirstName:null,
	authorLastName:null,

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


	// This function makes the necessary updates into the Kardia database to reflect
	// what the user has asked for on this message display window.
	//
	reSync: function(cb) {
		var date = new Date();
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
		var completion = function(no_changes) {
			if (cb) {
				cb();
			}
			if (contactFooter.do_reset) {
				contactFooter.reset_bh();
			}
			if (!no_changes) {
				contactFooter.reloadMainSidebar(true);
			}
		}

		////
		////  CREATE PHASE - first step, creation of the partner record, if needed.
		////
		if (contactFooter.creatingPartner && contactFooter.newPartnerKey === null) {
			kardiacrm.requestGet('partner/NextPartnerKey?cx__mode=rest&cx__res_type=element&cx__res_format=attrs&cx__res_attrs=basic', 'resync', completion, function(resp) {
				if (resp) {
					kardiacrm.requestPost('partner/Partners', 
							{
							p_partner_key: resp.partner_id,
							p_creating_office: ' ',
							p_partner_class: 'IND',
							p_status_code: 'A',
							p_given_name: contactFooter.curData.first,
							p_surname: contactFooter.curData.last,
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
									contactFooter.newPartnerKey = contactFooter.getKeyFromLocation(resp.Location, '/Partners/');
									contactFooter.prevData.first = contactFooter.curData.first;
									contactFooter.prevData.last = contactFooter.curData.last;
								}
								contactFooter.reSyncPostPartner(completion, false);
							}
					});
				}
			});
		}
		else {
			contactFooter.reSyncPostPartner(completion, true);
		}
	},


	// Done after partner creation, or if no create was needed.
	reSyncPostPartner: function(completion, no_changes) {
		var date = new Date();
		// Make sure we have a partner key.
		var partner = contactFooter.newPartnerKey;
		if (!partner) {
			var idx = contactFooter.getEmailIndex(contactFooter.authorAddress);
			if (idx >= 0) {
				partner = mainWindow.ids[idx];
			}
		}

		////
		////  CREATE PHASE - second step, creation of address, email, todo, and collab,
		////		     records, all of which require that the partner record exist.
		////
		if (partner) {
			// Create partner location record?
			if (contactFooter.creatingLocation && contactFooter.newLocationKey === null) {
				no_changes = false;
				kardiacrm.requestPost('partner/Partners/' + partner + '/Addresses', 
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
							contactFooter.newLocationKey = contactFooter.getKeyFromLocation(resp.Location, '/Addresses/');
						}
				});
			}

			// Create collab record?
			if (contactFooter.creatingCollab && contactFooter.newCollabKey === null && contactFooter.curData.roletype) {
				no_changes = false;
				kardiacrm.requestPost('crm/Partners/' + partner + '/Collaborators', 
						{
						p_partner_key: partner,
						e_collaborator: mainWindow.myId,
						e_collab_type_id: parseInt(contactFooter.curData.roletype),
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							if (resp.Location) {
								contactFooter.newCollabKey = contactFooter.getKeyFromLocation(resp.Location, '/Collaborators/');
								contactFooter.prevData.roletype = contactFooter.curData.roletype;
							}
						}
				});
			}

			// Create todo record?
			if (contactFooter.creatingTodo && contactFooter.newTodoKey === null && contactFooter.curData.todotype && contactFooter.curData.assignee && contactFooter.curData.days) {
				no_changes = false;
				var duedate = new Date(date);
				duedate.setDate(duedate.getDate() + parseInt(contactFooter.curData.days));
				kardiacrm.requestPost('crm/Partners/' + partner + '/Todos', 
						{
						e_todo_type_id: parseInt(contactFooter.curData.todotype),
						e_todo_desc: contactFooter.curData.todo_comment,
						e_todo_status: 'I',
						e_todo_collaborator: contactFooter.curData.assignee,
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
								contactFooter.newTodoKey = contactFooter.getKeyFromLocation(resp.Location, '/Todos/');
								contactFooter.prevData.todotype = contactFooter.curData.todotype;
								contactFooter.prevData.assignee = contactFooter.curData.assignee;
								contactFooter.prevData.days = contactFooter.curData.days;
								contactFooter.prevData.todo_comment = contactFooter.curData.todo_comment;
							}
						}
				});
			}

			// Create email record?
			if (contactFooter.creatingEmail && contactFooter.newEmailKey === null && contactFooter.curData.email) {
				kardiacrm.requestPost('partner/Partners/' + partner + '/ContactInfo', 
						{
						p_partner_key: partner,
						p_contact_type: 'E',
						p_contact_data: contactFooter.curData.email,
						p_record_status_code: 'A',
						s_date_created: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_created_by: kardiacrm.username,
						s_date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
						s_modified_by: kardiacrm.username,
						},
					'resync', completion, function(resp) {
						if (resp) {
							if (resp.Location) {
								contactFooter.newEmailKey = contactFooter.getKeyFromLocation(resp.Location, '/ContactInfo/');
								contactFooter.prevData.email = contactFooter.curData.email;
							}
							contactFooter.reSyncPostEmail(completion, false);
						}
				});
			}
			else {
				contactFooter.reSyncPostEmail(completion, no_changes);
			}
		} else {
			contactFooter.reSyncPostEmail(completion, no_changes);
		}
	},


	// Done after email creation, or if no email creation needed.
	reSyncPostEmail: function(completion, no_changes) {
		var date = new Date();
		// Make sure we have a partner key.
		var partner = contactFooter.newPartnerKey;
		if (!partner) {
			var idx = contactFooter.getEmailIndex(contactFooter.authorAddress);
			if (idx >= 0) {
				partner = mainWindow.ids[idx];
			}
		}

		// Make sure we have an email key.
		var email = contactFooter.newEmailKey;
		if (!email) {
			var idx = contactFooter.getEmailIndex(contactFooter.authorAddress);
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
			if (contactFooter.creatingContactHistory && contactFooter.newContactHistoryKey === null) {
				// Date of email
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
				var email_text = contactFooter.jQuery(contactFooter.jQuery("#messagepane")[0].contentWindow.document.children[0].children[1]).text();
				if (email_text) {
					email_text = email_text.substr(0,900);
				}
				else {
					email_text = "";
				}
				
				// Do the create if we have a valid email contact type.
				if (contact_type) {
					no_changes = false;
					kardiacrm.requestPost('crm/Partners/' + partner + '/ContactHistory', 
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
								contactFooter.newContactHistoryKey = contactFooter.getKeyFromLocation(resp.Location, '/ContactHistory/');
							}
					});
				}
			}

			// Create autorecord record?  (and... when a fox is in the bottle where the tweetle beetles battle...)
			if (contactFooter.creatingAutorecord && contactFooter.newAutorecordKey === null) {
				// Do the create for the e_contact_autorecord data
				if (contact_type) {
					no_changes = false;
					kardiacrm.requestPost('crm/Partners/' + partner + '/ContactAutorecord',
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
								contactFooter.newAutorecordKey = contactFooter.getKeyFromLocation(resp.Location, '/ContactAutorecord/');
							}
					});
				}
			}
		}

		////
		////  MODIFY PHASE - update data if user has modified it, via PATCH REST requests.
		////
		if (contactFooter.creatingPartner && partner && (contactFooter.curData.first != contactFooter.prevData.first || contactFooter.curData.last != contactFooter.prevData.last)) {
			no_changes = false;
			kardiacrm.requestPatch('partner/Partners/' + partner, 
					{
					surname: contactFooter.curData.last,
					given_names: contactFooter.curData.first,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (contactFooter.creatingEmail && email && contactFooter.curData.email != contactFooter.prevData.email) {
			no_changes = false;
			kardiacrm.requestPatch('partner/Partners/' + partner + '/ContactInfo/' + email, 
					{
					contact_data: contactFooter.curData.email,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (contactFooter.creatingCollab && contactFooter.newCollabKey && contactFooter.curData.roletype != contactFooter.prevData.roletype) {
			no_changes = false;
			kardiacrm.requestPatch('crm/Partners/' + partner + '/Collaborators/' + contactFooter.newCollabKey, 
					{
					collaborator_type_id: parseInt(contactFooter.curData.roletype),
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}
		if (contactFooter.creatingTodo && contactFooter.newTodoKey && (contactFooter.curData.todotype != contactFooter.prevData.todotype || contactFooter.curData.assignee != contactFooter.prevData.assignee || contactFooter.curData.todo_comment !=contactFooter.prevData.todo_comment || contactFooter.curData.days != contactFooter.prevData.days)) {
			no_changes = false;
			var duedate = new Date(date);
			duedate.setDate(duedate.getDate() + parseInt(contactFooter.curData.days));
			kardiacrm.requestPatch('crm/Partners/' + partner + '/Todos/' + contactFooter.newTodoKey, 
					{
					todo_type_id: parseInt(contactFooter.curData.todotype),
					desc: contactFooter.curData.todo_comment,
					due_date: {year: duedate.getFullYear(), month: duedate.getMonth()+1, day:duedate.getDate(), hour:duedate.getHours(), minute:duedate.getMinutes(), second:duedate.getSeconds() },
					collaborator_id: contactFooter.curData.assignee,
					date_modified: {year: date.getFullYear(), month: date.getMonth()+1, day:date.getDate(), hour:date.getHours(), minute:date.getMinutes(), second:date.getSeconds() },
					modified_by: kardiacrm.username,
					},
				'resync', completion, function(resp) {
			});
		}

		////
		////  DELETE PHASE - remove data if user changed mind about creating it.
		////
		if (contactFooter.newEmailKey && !contactFooter.creatingEmail && partner) {
			no_changes = false;
			kardiacrm.requestDelete('partner/Partners/' + partner + '/ContactInfo/' + contactFooter.newEmailKey, 'resync', completion, function(resp) {
				contactFooter.newEmailKey = null;
			});
		}
		if (contactFooter.newLocationKey && !contactFooter.creatingLocation && partner) {
			no_changes = false;
			kardiacrm.requestDelete('partner/Partners/' + partner + '/Addresses/' + contactFooter.newLocationKey, 'resync', completion, function(resp) {
				contactFooter.newLocationKey = null;
			});
		}
		if (contactFooter.newCollabKey && !contactFooter.creatingCollab && partner) {
			no_changes = false;
			kardiacrm.requestDelete('crm/Partners/' + partner + '/Collaborators/' + contactFooter.newCollabKey, 'resync', completion, function(resp) {
				contactFooter.newCollabKey = null;
			});
		}
		if (contactFooter.newTodoKey && !contactFooter.creatingTodo && partner) {
			no_changes = false;
			kardiacrm.requestDelete('crm/Partners/' + partner + '/Todos/' + contactFooter.newTodoKey, 'resync', completion, function(resp) {
				contactFooter.newTodoKey = null;
			});
		}
		if (contactFooter.newContactHistoryKey && !contactFooter.creatingContactHistory && partner) {
			no_changes = false;
			kardiacrm.requestDelete('crm/Partners/' + partner + '/ContactHistory/' + contactFooter.newContactHistoryKey, 'resync', completion, function(resp) {
				contactFooter.newContactHistoryKey = null;
			});
		}
		if (contactFooter.newAutorecordKey && !contactFooter.creatingAutorecord && partner) {
			no_changes = false;
			kardiacrm.requestDelete('crm/Partners/' + partner + '/ContactAutorecord/' + contactFooter.newAutorecordKey, 'resync', completion, function(resp) {
				contactFooter.newAutorecordKey = null;
			});
		}
		if (contactFooter.newPartnerKey && !contactFooter.creatingPartner) {
			no_changes = false;
			kardiacrm.requestDelete('partner/Partners/' + contactFooter.newPartnerKey, 'resync', completion, function(resp) {
				contactFooter.newPartnerKey = null;
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
		if (contactFooter.do_reset) {
			contactFooter.do_reeval = true;
			return;
		}
		contactFooter.log("reEvaluate()");

		contactFooter.do_reeval = false;

		// Make a note of current field values, and save previous ones.
		contactFooter.prevData = {};
		for(var k in contactFooter.curData)
			contactFooter.prevData[k] = contactFooter.curData[k];
		contactFooter.curData.assignee = contactFooter.jQuery("#todo-assignee")[0].value;
		contactFooter.curData.todotype = contactFooter.jQuery("#todo-type")[0].value;
		contactFooter.curData.roletype = contactFooter.jQuery("#newperson-role")[0].value;
		contactFooter.curData.days = contactFooter.jQuery("#todo-days")[0].value;
		contactFooter.curData.first = contactFooter.jQuery("#newperson-first")[0].value;
		contactFooter.curData.last = contactFooter.jQuery("#newperson-last")[0].value;
		contactFooter.curData.email = contactFooter.jQuery("#newperson-email")[0].value;
		contactFooter.curData.todo_comment = contactFooter.jQuery("#todo-comment")[0].value;

		// Save current values of fields that may be re-used when the user re-opens
		// this screen later on.
		if (contactFooter.curData.assignee)
			kardiacrm.last_assignee = contactFooter.curData.assignee;
		if (contactFooter.curData.todotype)
			kardiacrm.last_todo_type = contactFooter.curData.todotype;
		if (contactFooter.curData.roletype !== null)
			kardiacrm.last_role_type = contactFooter.curData.roletype;
		if (contactFooter.curData.days)
			kardiacrm.last_due_days = contactFooter.curData.days;

		// Reset the kardia "flags" next to email names in the header
		if (kardiacrm.logged_in) {
			contactFooter.log("addKardiaButton()");
			mainWindow.addKardiaButton(window);
		}

		// Find author of email
		if (gMessageDisplay && gMessageDisplay.displayedMessage) {
			// if a message is displayed, show the toolbar
			contactFooter.jQuery("#contact-box").prop("hidden", false);

			var author = gMessageDisplay.displayedMessage.author;
			var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces["nsIMsg" + "HeaderParser"]); // workaround for overzealous regex on AMO.
			var authorAddressArray = {};
			var authorNameArray = {};
			parser.parseHeadersWithArray(author, authorAddressArray, authorNameArray, {});
			contactFooter.authorAddress = authorAddressArray.value[0];

			// Try to find first and last name if possible
			contactFooter.authorFullName = authorNameArray.value[0];
			contactFooter.authorFirstName = null;
			contactFooter.authorLastName = null;
			if (contactFooter.authorFullName && contactFooter.authorAddress && contactFooter.authorFullName.toLowerCase() != contactFooter.authorAddress.toLowerCase()) {
				var comma_idx = contactFooter.authorFullName.indexOf(',');
				var space_idx = contactFooter.authorFullName.indexOf(' ');
				var space_last_idx = contactFooter.authorFullName.lastIndexOf(' ');
				if (comma_idx >= 0 && (space_idx > comma_idx || space_idx < 0)) {
					contactFooter.authorFirstName = contactFooter.authorFullName.substr(((space_idx == comma_idx+1)?space_idx:comma_idx) + 1);
					contactFooter.authorLastName = contactFooter.authorFullName.substr(0, comma_idx);
				}
				else if (space_last_idx >= 0) {
					contactFooter.authorFirstName = contactFooter.authorFullName.substr(0, space_last_idx);
					contactFooter.authorLastName = contactFooter.authorFullName.substr(space_last_idx + 1);
				}
				else {
					contactFooter.authorFirstName = contactFooter.authorFullName;
					contactFooter.authorLastName = "";
				}
			}
		}
		
		// Things we do only if we've just switched to this particular email message
		if (!contactFooter.initialized) {
			// Is author in Kardia?  If not, note that this is a new sender so that we
			// auto-create a record in Kardia for them when the user wants to record the
			// email or whatnot.
			//
			contactFooter.isNewSender = false;
			if (kardiacrm.partners_loaded && contactFooter.authorAddress && contactFooter.getEmailIndex(contactFooter.authorAddress) < 0)
				contactFooter.isNewSender = true;

			// Automatically check the Record Contact checkbox if this email's Message ID
			// is already in the database.  Also set the newContactHistoryKey value so that
			// the user can "undo" the recording of the email in Kardia by unchecking the box.
			//
			var idx = contactFooter.getEmailIndex(contactFooter.authorAddress);
			if (kardiacrm.partner_data_loaded && idx >= 0 && mainWindow.notes[idx] && gMessageDisplay.displayedMessage) {
				var msgid_exists = false;
				for(var k=0;k<mainWindow.notes[idx].length;k++) {
					var note = mainWindow.notes[idx][k];
					if (note.message_id == gMessageDisplay.displayedMessage.messageId && note.contact_history_type == 'Email') {
						msgid_exists = note.name;
						break;
					}
				}
				if (msgid_exists) {
					contactFooter.jQuery("#record-contact").prop("checked", true);
					contactFooter.newContactHistoryKey = msgid_exists;
				}
			}

			// Also look for a Contact Auto-Record entry in the database, and automatically
			// select that option if so (and set the newAutorecordKey, so that if the user
			// un-checks the box, we can delete the entry from Kardia).
			//
			// FIXME - this currently only works for the simple case of one autorecord entry
			// for the partner.  It does not handle override entries (one system-wide enabled
			// for the partner, and one specific to the collaborator but which is turned off),
			// as that will require additional UI work to properly present to the user.  We
			// will need to update this to solve the override problem once override capability
			// is exposed in the web UI.
			//
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
					contactFooter.jQuery("#record-future").prop("checked", true);
					contactFooter.newAutorecordKey = has_autorecord;
				}
			}

			// If we're auto-recording, BUT this message isn't yet marked for recording, then
			// mark it for recording.  We don't do this automatically when the user checks the
			// "future" checkbox initially.  But if they close and re-open this window right
			// away, or if they open this window on any future or past email from the same
			// email address, this here gets triggered.
			//
			if (kardiacrm.partners_loaded && contactFooter.jQuery("#record-future").prop("checked") && !contactFooter.jQuery("#record-contact").prop("checked")) {
				contactFooter.jQuery("#record-contact").prop("checked", true);
			}
		}

		// Whether to show the new person info box at bottom
		if ((contactFooter.jQuery("#record-contact").prop("checked") || contactFooter.jQuery("#record-todo").prop("checked") || contactFooter.jQuery("#record-future").prop("checked")) && contactFooter.isNewSender) {
			contactFooter.jQuery("#newperson-box").css({display: "block"});
			contactFooter.creatingPartner = true;
			contactFooter.creatingLocation = true;
			contactFooter.creatingEmail = true;

			// Fill the editboxes for email, first name, and last name.
			if (!contactFooter.jQuery("#newperson-email")[0].value) {
				contactFooter.jQuery("#newperson-email").prop("value", contactFooter.authorAddress);
				contactFooter.curData.email = contactFooter.jQuery("#newperson-email")[0].value;
			}
			if (!contactFooter.jQuery("#newperson-first")[0].value) {
				contactFooter.jQuery("#newperson-first").prop("value", contactFooter.authorFirstName);
				contactFooter.curData.first = contactFooter.jQuery("#newperson-first")[0].value;
			}
			if (!contactFooter.jQuery("#newperson-last")[0].value) {
				contactFooter.jQuery("#newperson-last").prop("value", contactFooter.authorLastName);
				contactFooter.curData.last = contactFooter.jQuery("#newperson-last")[0].value;
			}

			// Fill in the role options
			contactFooter.jQuery("#newperson-role menupopup")
				.empty()
				.append(
					contactFooter.jQuery("<menuitem>", {
						value: '',
						label: '(none)',
					})
				);
			for (var i in kardiacrm.data.collabTypeList) {
				contactFooter.jQuery("#newperson-role menupopup")
					.append(
						contactFooter.jQuery("<menuitem>", {
							value: '' + i,
							label: kardiacrm.data.collabTypeList[i].label,
						})
					);
				if (kardiacrm.last_role_type !== null)
					contactFooter.jQuery("#newperson-role")[0].value = kardiacrm.last_role_type;
			}
		}
		else {
			contactFooter.jQuery("#newperson-box").css({display: "none"});
			contactFooter.creatingPartner = false; 
			contactFooter.creatingLocation = false; 
			contactFooter.creatingEmail = false;
		}

		// Whether to create a contact history record for this email
		if (contactFooter.jQuery("#record-contact").prop("checked")) {
			contactFooter.creatingContactHistory = true;
		}
		else {
			contactFooter.creatingContactHistory = false;
		}

		// Whether to create the collaborator record (role not '(none)')
		if (contactFooter.creatingPartner && contactFooter.jQuery("#newperson-role")[0].value) {
			contactFooter.creatingCollab = true;
		}
		else {
			contactFooter.creatingCollab = false;
		}

		// Whether to create an autorecord entry for this person
		if (contactFooter.jQuery("#record-future").prop("checked")) {
			contactFooter.creatingAutorecord = true;
		}
		else {
			contactFooter.creatingAutorecord = false;
		}

		// Whether to show the new task info
		if (contactFooter.jQuery("#record-todo").prop("checked")) {
			contactFooter.jQuery("#todo-options").css({display: "block"});
			contactFooter.creatingTodo = true;

			// Fill in the task type options and assignee options
			contactFooter.jQuery("#todo-type menupopup").empty();
			for (var i in kardiacrm.data.todoTypeList) {
				contactFooter.jQuery("#todo-type menupopup")
					.append(
						contactFooter.jQuery("<menuitem>", {
							value: '' + i,
							label: kardiacrm.data.todoTypeList[i].type_label,
						})
					);
				if (kardiacrm.last_todo_type)
					contactFooter.jQuery("#todo-type")[0].value = kardiacrm.last_todo_type;
			}
			contactFooter.jQuery("#todo-assignee menupopup").empty();
			for (var i in kardiacrm.data.staffList) {
				if (kardiacrm.data.staffList[i].is_staff && kardiacrm.data.staffList[i].kardia_login) {
					contactFooter.jQuery("#todo-assignee menupopup")
						.append(
							contactFooter.jQuery("<menuitem>", {
								value: kardiacrm.data.staffList[i].partner_id,
								label: kardiacrm.data.staffList[i].partner_name,
							})
						);
					if (kardiacrm.last_assignee)
						contactFooter.jQuery("#todo-assignee")[0].value = kardiacrm.last_assignee;
					else
						contactFooter.jQuery("#todo-assignee")[0].value = mainWindow.myId;
				}
			}
			if (kardiacrm.last_due_days)
				contactFooter.jQuery("#todo-days")[0].value = '' + kardiacrm.last_due_days;
		}
		else {
			contactFooter.jQuery("#todo-options").css({display: "none"});
			contactFooter.creatingTodo = false;
		}

		// Mark initialization complete if we operated with full data awareness
		// on this pass.  After initialization, we don't go automatically clicking
		// contact-record checkboxes for the user (we want the user to like us).
		// The check for !do_sidebar here prevents us from calling things initialized
		// if we're about to reload the sidebar from a message context change.
		//
		if (!contactFooter.initialized && kardiacrm.partner_data_loaded && !contactFooter.do_sidebar && gMessageDisplay.displayedMessage) {
			contactFooter.log("initialized");
			contactFooter.enableControls();
			contactFooter.initialized = true;
		}
		else {
			// Wait until it's ready to display everything. The data_loaded and do_sidebar are killing it here and we need
			// to give it a chance to load.		
			$.when(kardiacrm.partner_data_loaded_deferred).then( function(value) {
				contactFooter.log("initialized");
				contactFooter.enableControls();
				contactFooter.initialized = true;
			});
			//if (kardiacrm.partner_data_loaded) kardiacrm.partner_data_loaded_deferred.resolve();
		}
		// Save changes, if needed.
		contactFooter.reSync();

		// Lookup emails, if needed.
		if (contactFooter.do_sidebar) {
			contactFooter.reloadMainSidebar(false);
		}
	},


	// Get index of email address in main email listing for this message.
	getEmailIndex: function(str) {
		if (!str)
			return -1;
		else
			return mainWindow.emailAddresses.indexOf(str.toLowerCase());
	},


	// Disable all controls
	disableControls: function() {
		contactFooter.jQuery("#contact-box").find("textbox,menulist,checkbox").prop("disabled", true);
		contactFooter.jQuery("#contact-box").css({display: "none"});
	},


	// Enable all controls
	enableControls: function() {
		contactFooter.jQuery("#contact-box").find("textbox,menulist,checkbox").removeProp("disabled");
		contactFooter.jQuery("#contact-box").css({display: "block"});
	},


	// Reload the sidebar in the main window.  Set 'force' to true to make it
	// reload even if the email message context has not changed.
	//
	reloadMainSidebar: function(force) {
		contactFooter.log("reloadMainSidebar()");
		contactFooter.do_sidebar = false;
		mainWindow.findEmails([gMessageDisplay.displayedMessage], force);
	},


	// Send a log message to the console log.  This is used for certain types of
	// debugging, since 1) this is event-driven and that can get a little crazy, and 2)
	// the Firefox remote debugger's breakpoints do not work in the message window,
	// only in the main 3-pane window.
	//
	log: function(msg) {
		if (contactFooter.logging) {
			var date = new Date();
			var ms = '' + date.getMilliseconds();
			if (date.getMilliseconds() < 100) ms = '0' + ms;
			if (date.getMilliseconds() < 10) ms = '0' + ms;
			contactFooter.console.logStringMessage(date.toTimeString() + "." + ms + " contactFooter " + msg + " do_reset:" + (contactFooter.do_reset?'true':'false') + " do_reeval:" + (contactFooter.do_reeval?'true':'false') + " do_sidebar:" + (contactFooter.do_sidebar?'true':'false') + " partnerlist:" + (kardiacrm.partners_loaded?'true':'false') + " partnerdata:" + (kardiacrm.partner_data_loaded?'true':'false'));
		}
	},


	// Reset the window and checkboxes as if it had just been opened.
	reset: function() {
		contactFooter.log("reset()");
		console.log("reset");
		contactFooter.jQuery("#contact-box").prop("hidden", true);
		if (!kardiacrm.isPending('resync')) {
			contactFooter.reSync(contactFooter.reset_bh);
		}
		else {
			contactFooter.do_reset = true;
		}
	},

	// Bottom half of the reset logic; this is where the work is done.
	reset_bh: function () {
		contactFooter.log("reset_bh()");
		contactFooter.disableControls();

		contactFooter.initialized = false;
		contactFooter.do_reset=false;
		contactFooter.isNewSender=false;
		contactFooter.authorAddress=null;
		contactFooter.authorFullName=null;
		contactFooter.authorFirstName=null;
		contactFooter.authorLastName=null;

		contactFooter.curData = { assignee:null, todotype:null, roletype:null, days:null, first:null, last:null, email:null, todo_comment:null };
		contactFooter.prevData = { };

		contactFooter.creatingPartner=false;
		contactFooter.creatingLocation=false;
		contactFooter.creatingEmail=false;
		contactFooter.creatingCollab=false;
		contactFooter.creatingContactHistory=false;
		contactFooter.creatingAutorecord=false;
		contactFooter.creatingTodo=false;

		contactFooter.newPartnerKey=null;
		contactFooter.newLocationKey=null;
		contactFooter.newEmailKey=null;
		contactFooter.newCollabKey=null;
		contactFooter.newContactHistoryKey=null;
		contactFooter.newAutorecordKey=null;
		contactFooter.newTodoKey=null;

		contactFooter.jQuery("#record-contact").removeProp("checked");
		contactFooter.jQuery("#record-todo").removeProp("checked");
		contactFooter.jQuery("#record-future").removeProp("checked");

		// Chain to other queued operations that could not be done until
		// after the reset finished.
		//
		if (contactFooter.do_reeval) {
			contactFooter.reEvaluate(null);
		} else if (contactFooter.do_sidebar) {
			contactFooter.reloadMainSidebar(false);
		}
	},

	// Initialize() is called by the embedder, providing our linkages to the
	// outside world, so to speak.
	//
	// 'param' is an object with the following properties:
	//    getText() - returns a string containing the text of the email message
	//    getAddress() - returns a string containing the name and email address of the
	//        person we are corresponding with, i.e., "Joe Smith <joe@example.com>".
	//        If we are composing, this may be the To:.  If we are reading, this may
	//        be the From:.
	//    profileNotify() - called when the footer has caused server data to change
	//        related to a partner profile.  ID of the partner is passed as the first
	//        parameter to this callback.
	//    getHeaders() - returns an object containing the headers of the current
	//        message, in the properties 'to', 'cc', 'bcc', 'from', 'subject',
	//        and 'date' (a Date object).
	//    evalPoint - a string representing at what point we're supposed to actually
	//	  save data to the server.  Can be 'change', meaning to save automatically
	//	  whenever a change happens to the controls, or 'complete', meaning to only
	//	  save data when the Complete() function is called.
	//
	// Expected global variables include:
	//    mainWindow - a reference to the main 3pane mail window
	//    kardiacrm - the application-wide Kardia CRM namespace/object
	//
	Initialize: function(param) {
		contactFooter.config = param;
	},

	// ChangeNotify() is called by the embedder when external data, such as the address
	// of the person we're interacting with (getAddress), has changed and we need to
	// re-evaluate these things.  'kind' can be 'text', 'address', or 'headers'.  The
	// changed data can be retrieved by the callbacks passed to Initialize().
	//
	ChangeNotify: function(kind) {
	},

	// Complete() is called by the embedder when the user is finished, for example
	// on window close or message send.
	//
	Complete: function() {
	}
};

document.getElementById('folderTree').addEventListener("select", function() {
	// hide footer if we changed folders and now no message is displayed
	if (!gMessageDisplay || !gMessageDisplay.displayedMessage) {
		contactFooter.disableControls();
	}
}, false);


addEventListener("unload", function() {
	contactFooter.log("unload");
	contactFooter.reset();
}, false);

addEventListener("load", function(event) {

	// Load jQuery
	var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"].getService(Components.interfaces.mozIJSSubScriptLoader);
	//loader.loadSubScript("chrome://messenger/content/jquery.js", window);
	loader.loadSubScript("chrome://kardia/content/jquery-1.11.1.js", window);
	contactFooter.jQuery = window.jQuery.noConflict(true);

	// Gain access to the console for logging
	contactFooter.console = Components.classes["@mozilla.org/consoleservice;1"]
	        .getService(Components.interfaces.nsIConsoleService);
	contactFooter.log("load");

	// Add the kardia icons/flags when the message is rendered.
	gMessageListeners.push ({
		onEndHeaders: function () {
			kardiacrm.lastMessageWindow = window;
			contactFooter.do_reeval = true;
			contactFooter.do_sidebar = true;
			contactFooter.reset();
		},
		onStartHeaders: function() {},
		onStartAttachments: function () {},
		onEndAttachments: function () {},
		onBeforeShowHeaderPane: function () {},
		onDisplayingFolder: function () {}
	});

	// Trap interactions with the checkboxes
	contactFooter.jQuery("#record-contact").click(function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#record-todo").click(function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#record-future").click(function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#todo-assignee").bind("command", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#todo-type").bind("command", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#newperson-role").bind("command", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#todo-days").bind("change", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#todo-comment").bind("change", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#newperson-email").bind("change", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#newperson-first").bind("change", function(event) {
		contactFooter.reEvaluate(event);
	});
	contactFooter.jQuery("#newperson-last").bind("change", function(event) {
		contactFooter.reEvaluate(event);
	});

}, false);

