//
// Kardia CRM Javascript file for pop-up message composition window
// (c) 2015-2016 LightSys Technology Services, Inc.
//

// We need to link to our CRM data that's over in the main window context.
var mainWindow = Components.classes["@mozilla.org/appshell/window-mediator;1"]
	.getService(Components.interfaces.nsIWindowMediator)
	.getMostRecentWindow("mail:3pane");
var kardiacrm = mainWindow.kardiacrm;

// This is our main object containing all data and state and functionality relating to
// the compose window part of the Kardia CRM interface for TB.  This should be migrated
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
var composeWindow = {
	jQuery:null,
	console:null,
	logging:false,
	updateDialog:null,

	// Whether we've run the controller (reEvaluate) for the first time in this
	// message context.  The first time we run it, there are some additional steps
	// that need to be taken that should NOT be taken afterward.
	initialized:false,

	// These are used for queuing reset and reeval calls.  FIXME this could really
	// itself be replaced by a message queue / dispatch type setup.  But this gets
	// the job done.
	do_reset:false,

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
			if (!no_changes) {
			}
		}
	},


	// Lots of things are inter-related.  We process them here in this controller; the event
	// handlers for the input fields, plus completion callbacks on data retrieval, all point
	// to this controller function.
	//
	reEvaluate: function(event) {
		// If reset pending, don't do this, instead defer until later.
		if (composeWindow.do_reset) {
		}
		composeWindow.log("reEvaluate()");
		composeWindow.do_reeval = false;

		// Load the dropdown that contains the expansion items for manual insertion.
		composeWindow.jQuery("#expansion-item menupopup").empty();
		for (var i in kardiacrm.data.textExpList) {
			var textexp = kardiacrm.data.textExpList[i];
			composeWindow.jQuery("#expansion-item menupopup")
				.append(
					composeWindow.jQuery("<menuitem>", {
						value: textexp.tag,
						label: textexp.tag + ' - ' + textexp.description,
					})
				);
		}

		// Display preview text for the selected expansion item
		var sel_exp = composeWindow.jQuery("#expansion-item").prop("value");
		if (sel_exp && sel_exp != "") {
			var sel_item = mainWindow.find_item(kardiacrm.data.textExpList, "tag", sel_exp);
			if (sel_item) {
				composeWindow.jQuery("#exp-preview").css({display: "block"});
				composeWindow.jQuery("#exp-preview").text(sel_item.expansion);
				composeWindow.jQuery("#exp-insert-btn").removeProp("disabled");
			}
		}
		else {
			composeWindow.jQuery("#exp-preview").css({display: "none"});
			composeWindow.jQuery("#exp-insert-btn").prop("disabled", true);
		}
	},


	// Open the update/add dialog
	cmdOpenUpdateDialog: function() {
		var sel = "";
		var editor = GetCurrentEditor();
		if (editor) {
			sel = editor.selection.toString();
		}
		var curtag = composeWindow.jQuery("#expansion-item").prop("value");
		composeWindow.updateDialog = openDialog("chrome://kardia/content/add-update-expansion-dialog.xul", "Add/Update Text Expansion", "resizable,chrome,modal,centerscreen", kardiacrm, composeWindow, sel, curtag, composeWindow.dialogNotify);
	},


	// Insert an expansion item into the composition editor
	cmdInsertByTag: function(tag) {
		var sel_item = mainWindow.find_item(kardiacrm.data.textExpList, "tag", tag);
		var editor = GetCurrentEditor();
		if (editor && sel_item) {
			// Insert the text.
			editor.beginTransaction();
			editor.insertText(sel_item.expansion);
			editor.endTransaction();

			// Restore the focus to the editor.
			var editor_widget = kardiacrm.lastComposeWindow.composeWindow.jQuery("editor")[0];
			if (editor_widget) {
				editor_widget.focus();
			}
		}
	},


	// Called when the user types in the editor window.
	cmdMonitorKeypress: function(event) {
		var char_str = String.fromCharCode(event.charCode);

		// Get trigger character.
		var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
		var trigger = prefs.getCharPref("extensions.kardia.triggerchar");

		// Look back up to 16 characters to find the text that was typed.
		var editor = GetCurrentEditor();
		if (editor) {
			var focus_node = editor.selection.focusNode;
			if (focus_node) {
				// Get the text content around the insertion point
				var typed = focus_node.data?focus_node.data:"";
				var virtual = focus_node.data?focus_node.data:"";
				virtual = virtual.substring(0, editor.selection.focusOffset) + char_str + virtual.substring(editor.selection.focusOffset);
				var back_scan = focus_node;
				while (typed.length < 16 && back_scan.previousSibling) {
					back_scan = back_scan.previousSibling;
					typed = (back_scan.data?back_scan.data:"") + typed;
					virtual = (back_scan.data?back_scan.data:"") + virtual;
					var trig_pos = typed.lastIndexOf(trigger);
					if (trig_pos >= 0) {
						break;
					}
				}
				var fwd_scan = focus_node;
				while (typed.length < 32 && fwd_scan.nextSibling) {
					fwd_scan = fwd_scan.nextSibling;
					var newdata = (fwd_scan.data?fwd_scan.data:"");
					var fwpos = newdata.indexOf(trigger);
					if (fwpos >= 0) {
						newdata = newdata.substring(0, fwpos);
						typed = typed + newdata;
						virtual = virtual + newdata;
						break;
					}
					typed = typed + newdata;
				}

				// Did we find the trigger char?
				var trig_full_pos = virtual.lastIndexOf(trigger);
				if (trig_full_pos >= 0) {
					// See if we have a match
					for(var i in kardiacrm.data.textExpList) {
						var one_exp = kardiacrm.data.textExpList[i];
						if (one_exp.tag.length > 0 && virtual.indexOf(trigger + one_exp.tag) >= 0) {
							// Got one.  
							var chars_to_erase = trigger.length + one_exp.tag.length;
							var erase_node = back_scan;
							var erasing = false;

							// Select the trigger and tag.  We erase one less than required because
							// one of them hasn't been received by the editor yet (and we're going
							// to, below, cancel the keypress so the editor doesn't receive it.)
							//
							for(var j=0; j<chars_to_erase-1; j++) {
								editor.selection.modify("extend", "backward", "character");
							}

							// Make sure we've selected the right thing.  (i.e., don't do the 
							// substitution if the user just created a valid tag and trigger by
							// typing in the middle of the tag)
							if (editor.selection.toString() != trigger + one_exp.tag.substring(0,one_exp.tag.length-1)) {
								editor.selection.collapseToEnd();
								break;
							}

							// Insert the replacement text.
							editor.beginTransaction();
							editor.insertText(one_exp.expansion);
							editor.endTransaction();

							// Cancel the keypress
							event.stopImmediatePropagation();
							event.preventDefault();

							// Don't look for any more expansions.
							break;
						}
					}
				}
			}
		}
	},


	// Initialization
	cmdInitialize: function () {
		kardiacrm.lastComposeWindow = window;
		composeWindow.reEvaluate(null);

		// set up the contact footer -- for recording the email, etc., in the CRM.
		contactFooter.Initialize({
			getText: function() {
				var editor = GetCurrentEditor();
				return editor.outputToString('text/plain', 8 + 16 + 1024);
			},

			getAddress: function() {
				var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces["nsIMsg" + "HeaderParser"]); // workaround for overzealous regex on AMO.
				var addr = [];
				try {
					parser.parseHeadersWithArray(gMsgCompose.compFields.to, addr, {}, {});
					return addr[0];
				}
				catch (err) {
					return null;
				}
			},

			profileNotify: function() {
				var ident = getCurrentIdentity();
				// Reload the sidebar
				mainWindow.findEmails([{
					author: ident.fullName + ' <' + ident.email + '>',
					recipients: gMsgCompose.compFields.to,
					ccList: gMsgCompose.compFields.cc,
					bccList: gMsgCompose.compFields.bcc,
				}], true);
			},

			getHeaders: function() {
				var ident = getCurrentIdentity();
				return {
					to: gMsgCompose.compFields.to,
					cc: gMsgCompose.compFields.cc,
					bcc: gMsgCompose.compFields.bcc,
					from: ident.fullName + ' <' + ident.email + '>',
					subject: gMsgCompose.compFields.subject,
					date: new Date(),
				};
			},

			evalPoint: "complete",
		});
	},


	// Notification from dialogs
	dialogNotify: function () {
		composeWindow.reEvaluate(null);
	},


	// Disable all controls
	disableControls: function() {
		composeWindow.jQuery("#contact-box").find("textbox,menulist,checkbox").prop("disabled", true);
	},


	// Enable all controls
	enableControls: function() {
		composeWindow.jQuery("#contact-box").find("textbox,menulist,checkbox").removeProp("disabled");
	},


	// Send a log message to the console log.  This is used for certain types of
	// debugging, since 1) this is event-driven and that can get a little crazy, and 2)
	// the Firefox remote debugger's breakpoints do not work in the message window,
	// only in the main 3-pane window.
	//
	log: function(msg) {
		if (composeWindow.logging) {
			var date = new Date();
			var ms = '' + date.getMilliseconds();
			if (date.getMilliseconds() < 100) ms = '0' + ms;
			if (date.getMilliseconds() < 10) ms = '0' + ms;
			composeWindow.console.logStringMessage(date.toTimeString() + "." + ms + " composeWindow " + msg + " do_reset:" + (composeWindow.do_reset?'true':'false') + " partnerlist:" + (kardiacrm.partners_loaded?'true':'false') + " partnerdata:" + (kardiacrm.partner_data_loaded?'true':'false'));
		}
	},


	// Reset the window and checkboxes as if it had just been opened.
	reset: function() {
		composeWindow.log("reset()");
		if (!kardiacrm.isPending('resync')) {
			composeWindow.reSync(composeWindow.reset_bh);
		}
		else {
			composeWindow.do_reset = true;
		}
	},

	// Bottom half of the reset logic; this is where the work is done.
	reset_bh: function () {
		composeWindow.log("reset_bh()");
		composeWindow.disableControls();

		composeWindow.initialized = false;
		composeWindow.do_reset=false;
	}
};


addEventListener("unload", function() {
	composeWindow.log("unload");
	composeWindow.reset();
}, false);


addEventListener("load", function() {
	// Load jQuery
	var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"].getService(Components.interfaces.mozIJSSubScriptLoader);
	//loader.loadSubScript("chrome://messenger/content/jquery.js", window);
	loader.loadSubScript("chrome://kardia/content/jquery-1.11.1.js", window);
	composeWindow.jQuery = window.jQuery.noConflict(true);

	// Gain access to the console for logging
	composeWindow.console = Components.classes["@mozilla.org/consoleservice;1"]
	        .getService(Components.interfaces.nsIConsoleService);
	composeWindow.log("load");

	// Catch events
	composeWindow.jQuery("#expansion-item").bind("command", function(event) {
		composeWindow.reEvaluate(event);
	});
	composeWindow.jQuery("#exp-insert-btn").bind("command", function(event) {
		composeWindow.cmdInsertByTag(composeWindow.jQuery("#expansion-item").prop("value"));
	});
	composeWindow.jQuery("#exp-update-btn").bind("command", function(event) {
		composeWindow.cmdOpenUpdateDialog();
	});

	// Editor keypress events.
	var editor_widget = composeWindow.jQuery("editor")[0];
	if (editor_widget) {
		editor_widget.addEventListener("keypress", function (event) {
			composeWindow.cmdMonitorKeypress(event);
		});
	}

	composeWindow.cmdInitialize();

}, false);

document.getElementById("msgcomposeWindow").addEventListener("compose-window-reopen", function() {
	composeWindow.cmdInitialize();
});
