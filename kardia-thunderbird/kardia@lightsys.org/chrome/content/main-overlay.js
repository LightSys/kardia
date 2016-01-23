// vim: set ai shiftwidth=4 cino={1s,\:0,t0,f1s sts=4 ts=4:
//
// Copyright (C) 2014-2015 LightSys Technology Services, Inc.
// This is Free Software; see the LICENSE and COPYING files for details.

// Places where features can be added are marked with comment //FEATURE
// Please check here for a list of known bugs. (feel free to add any you find)
// https://docs.google.com/document/d/1QPitVvT-VSf_bbFGfg_EzJruYXLcjfGdiK_q8DC0lu4/edit

const XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

// selected messages and number of emails selected (for comparing to see if we need to find users and reload Kardia pane)
var numSelected = 0;
var selectedMessages = null;

// list of currently displayable addresses, names, ids, etc
var emailAddresses = [];
var names = [];
var ids = [];
var emailIds = [];
var addresses = [];
var phoneNumbers = [];
var allEmailAddresses = [];
var websites = [];
var engagementTracks = [];
var recentActivity = [];
var profilePhotos = [];
var todos = [];
var allTodos = [];
var notes = [];
var autorecord = [];
var collaborators = [];
var documents = [];
var tags = [];
var data = [];
var dataGroups = [];
var gifts = [];
var funds = [];
var types = [];

// stuff for Kardia tab-- people you're collaborating with
var collaborateeIds = [];
var collaborateeNames = [];
var collaborateeTracks = [];
var collaborateeActivity = [];
var collaborateeTags = [];
var collaborateeData = [];
var collaborateeGifts = [];
var collaborateeFunds = [];

// which partner is selected and list of your own emails (so these aren't searched in Kardia)
var selfEmails;

// list of all partners, for adding collaborators
var partnerList = new Array();

// list of collaborator types

// server address
var server = "";

// calendar stuff
// FEATURE: not needed unless you add to-do items
/*Components.utils.import("resource://calendar/modules/calUtils.jsm");
var myCal;*/

// FEATURE: theoretically, this would be where we send edits from Lightning calendar to Kardia 
/*var kardiaCalObserver = {
	onStartBatch: function() { },
	onEndBatch: function() { },
	onLoad: function(aCalendar) { },
	onAddItem: function(aItem) {
		// delete it
		aItem.calendar.deleteItem(aItem);
		window.alert("You cannot add a to-do this way. Please use the \"Add To-Do\" button.");
		Application.console.log('working');
		Application.console.log('worked');
	},
	onModifyItem: function(aNewItem, aOldItem) {
		// send to Kardia
		// format today's date
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

		var dueDateString = "";
		if (aNewItem.dueDate != null) {
			var dueDateString = '{"year":' + aNewItem.dueDate.getFullYear() + ',"month":' + (aNewItem.dueDate.getMonth()+1) + ',"day":' + aNewItem.dueDate.getDate() + ',"hour":' + aNewItem.dueDate.getHours() + ',"minute":' + aNewItem.dueDate.getMinutes() + ',"second":' + aNewItem.dueDate.getSeconds() + '}';
		}
		
		doPatchHttpRequest('apps/kardia/api/crm/Todos/' + aOldItem.id, '{"desc":"' + aNewItem.title + '"due_date":' + dueDateString + ',"date_modified":"' + dateString + '","modified_by":"' + kardiacrm.username + '"}', false, "", "", function() {
		// TODO add due date
		// display item
			if (mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id) != null) {
				mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id).label=aNewItem.title;
			}
		});	
	},
	onDeleteItem: function(aDeletedItem) {
	   if (kardiacrm.logged_in) {
		// send to Kardia
		// format today's date
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
			
		doPatchHttpRequest('apps/kardia/api/crm/Todos/' + aDeletedItem.id, '{"status_code":"c","completion_date":' + dateString + ',"req_item_completed_by":"' + kardiacrm.username + '"}', false, "", "");
			if (mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id) != null) {
				mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id).style.display="none";
			}
		}
	
	},
	onError: function(aCalendar, aErrNo, aMessage) {
		Application.console.log(aMessage);
	},
	onPropertyChanged: function(aCalendar, aName, aValue, aOldValue) {},
	onPropertyDeleting: function(aCalendar, aName) {}
}*/

// my ID for finding self as collaborator, etc
var myId = "";

// how to sort list of collaborating with
var sortCollaborateesBy = "name";
var sortCollaborateesDescending = true;
var filterBy = "any";
var filterTracks = [];
var filterTags = [];
var filterData = [];
var filterFunds = [];

// filters for gift display in bottom pane
var giftFilterFunds = [];
var giftFilterTypes = [];

// keep track of Kardia tab and this window
if (!kardiaTab)
    var kardiaTab = null;
var mainWindow = this;
var dataTab;

// Various system-wide Kardia CRM data items
var kardiacrm = {
	// Last opened message window
	lastMessageWindow:null,
	last_assignee:null,
	last_todo_type:null,
	last_role_type:null,
	last_due_days:1,
	
	// is the data being refreshed?
	refresh_timer:null,
	refreshing:false,
	refreshes:0,

	ping_interval:null,

	// which partner we're viewing
	selected_partner:null,

	// Is data loaded for the partner list in the current email?
	partners_loaded:false,
	partner_data_loaded:false,
	find_emails_busy:false,

	// current server connection data
	logged_in:false,
	username:"",
	password:"",
	server:"",
	akey:null,

	// Our reference to jQuery
	jQuery:null,

	// Currently open dialog box (this is for debugging due to problems
	// with the Mozilla javascript debugger and popup dialog boxes)
	dialog:null,

	// Data for dropdowns, etc.
	data: {
		defaultCountry: {},
		countries: {},
		noteTypeList: {},
		collabTypeList: {},
		tagList: {},
		trackList: {},
		todoTypeList: {},
		staffList: {},
	},

	// Server API multi-class request dispatcher
	dispatch_parallel_max: 3,
	dispatch_queue: {},

	dispatch: function(dclass) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		while (kardiacrm.dispatch_queue[dclass].active_cnt < kardiacrm.dispatch_parallel_max && kardiacrm.dispatch_queue[dclass].length > 0) {
			let item = kardiacrm.dispatch_queue[dclass].shift();
			kardiacrm.dispatch_queue[dclass].active_cnt++;
			switch(item.req) {
				case 'GET':
				doHttpRequest('apps/kardia/api/' + item.url, function(Resp) {
					if (item.callback)
						item.callback(Resp);
					kardiacrm.dispatch_queue[dclass].active_cnt--;
					kardiacrm.dispatch(dclass);
					if (kardiacrm.dispatch_queue[dclass].length == 0 && kardiacrm.dispatch_queue[dclass].active_cnt == 0 && item.completion) {
						item.completion();
					}
				});
				break;

				case 'POST':
				doPostHttpRequest('apps/kardia/api/' + item.url, item.data, false, kardiacrm.username, kardiacrm.password, function(Resp) {
					if (item.callback)
						item.callback(Resp);
					kardiacrm.dispatch_queue[dclass].active_cnt--;
					kardiacrm.dispatch(dclass);
					if (kardiacrm.dispatch_queue[dclass].length == 0 && kardiacrm.dispatch_queue[dclass].active_cnt == 0 && item.completion) {
						item.completion();
					}
				});
				break;

				case 'PATCH':
				doPatchHttpRequest('apps/kardia/api/' + item.url, item.data, false, kardiacrm.username, kardiacrm.password, function(Resp) {
					if (item.callback)
						item.callback(Resp);
					kardiacrm.dispatch_queue[dclass].active_cnt--;
					kardiacrm.dispatch(dclass);
					if (kardiacrm.dispatch_queue[dclass].length == 0 && kardiacrm.dispatch_queue[dclass].active_cnt == 0 && item.completion) {
						item.completion();
					}
				});
				break;

				case 'DELETE':
				doDeleteHttpRequest('apps/kardia/api/' + item.url, false, kardiacrm.username, kardiacrm.password, function(Resp) {
					if (item.callback)
						item.callback(Resp);
					kardiacrm.dispatch_queue[dclass].active_cnt--;
					kardiacrm.dispatch(dclass);
					if (kardiacrm.dispatch_queue[dclass].length == 0 && kardiacrm.dispatch_queue[dclass].active_cnt == 0 && item.completion) {
						item.completion();
					}
				});
			}
		}
	},

	// The completion function is called when no more requests remain in the current
	// dispatch class (dclass), and the queue is about to go quiescent.  The callback
	// function is called when the HTTP REST request returns.
	//
	requestGet: function(url, dclass, completion, callback) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		kardiacrm.dispatch_queue[dclass].push({url:url, callback:callback, completion:completion, req:'GET'});
		kardiacrm.dispatch(dclass);
	},
	requestPost: function(url, data, dclass, completion, callback) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		kardiacrm.dispatch_queue[dclass].push({url:url, callback:callback, completion:completion, data:data, req:'POST'});
		kardiacrm.dispatch(dclass);
	},
	requestPatch: function(url, data, dclass, completion, callback) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		kardiacrm.dispatch_queue[dclass].push({url:url, callback:callback, completion:completion, data:data, req:'PATCH'});
		kardiacrm.dispatch(dclass);
	},
	requestDelete: function(url, dclass, completion, callback) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		kardiacrm.dispatch_queue[dclass].push({url:url, callback:callback, completion:completion, req:'DELETE'});
		kardiacrm.dispatch(dclass);
	},

	// Determine if request are pending
	isPending: function(dclass) {
		if (kardiacrm.dispatch_queue[dclass] === undefined) {
			kardiacrm.dispatch_queue[dclass] = [];
			kardiacrm.dispatch_queue[dclass].active_cnt = 0;
		}
		return kardiacrm.dispatch_queue[dclass].length > 0 || kardiacrm.dispatch_queue[dclass].active_cnt > 0;
	}
};

if (kardiaTab) {
	kardiaTab.kardiacrm = kardiacrm;
	kardiaTab.find_item = find_item;
}

// Configuration services
var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.kardia.");

// Enables parallel loading of Collaboratees in the Kardia tab. (Not fully functional)
var COLLABORATEES_PARALLEL = false;

function jsondir(json, name) {
	if (json['cx__collection'] && json['cx__collection'][name])
		return json['cx__collection'][name];
	else
		return null;
}

function jsoncoll(json) {
	if (json && json['cx__collection'])
		return json['cx__collection'];
	else
		return null;
}

function jsonel(json) {
	if (json && json['cx__element'])
		return json['cx__element'];
	else
		return null;
}

function find_item(arr, prop, value) {
    for(var k in arr) {
	if (arr[k] && arr[k][prop] === value) {
	    return arr[k];
	}
    }
}

function clone_obj(obj) {
	return kardiacrm.jQuery.extend(true, {}, obj);
}

function remove_atid(arr) {
    delete arr['@id'];
}
		

//update periodically based on preferences
function updateKardia() {
	if (kardiacrm.refresh_timer) {
		window.clearTimeout(kardiacrm.refresh_timer);
	}
	kardiacrm.refresh_timer = window.setTimeout(function() {
		if (kardiacrm.logged_in && !kardiacrm.refreshing) {
			// completely refresh/reload
			kardiacrm.refreshes++;
			getTrackTagStaff(kardiacrm.username, kardiacrm.password);
		}
		updateKardia();
	}, ((kardiacrm.refreshes > 0)?60000:600)*prefs.getIntPref("refreshInterval"));
}

// manually update
function manualUpdate() {
  document.getElementById("manual-refresh").style.backgroundColor = "#cccccc";
  setTimeout(function() {document.getElementById("manual-refresh").style.backgroundColor = "#ffffff";},200);

  if (mainWindow.kardiacrm.refreshing) {
  }
  if (kardiacrm.logged_in && !mainWindow.kardiacrm.refreshing) {
	// completely refresh/reload
	mainWindow.getTrackTagStaff(mainWindow.kardiacrm.username, mainWindow.kardiacrm.password);
  }
}

function doLogin(callback) {
    // get username/password
    var loginInfo = getLogin(false, false, function(loginInfo2) {

	    // store username/password in preferences (this is only important if getLogin() returned something valid)
	    kardiacrm.username = loginInfo2[0];
	    kardiacrm.password = loginInfo2[1];
	    
	    //see how many email addresses the person has
	    var prefs2 = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
	    var smtpServers = prefs2.getCharPref("mail.smtpservers");
	    smtpServers = smtpServers.split(",");
	    
	    // store list of self emails to array so we don't search them in Kardia
	    selfEmails = new Array();
	    for (var i=0;i<smtpServers.length;i++) {
		    selfEmails[i] = prefs2.getCharPref("mail.smtpserver." + smtpServers[i] + ".username");
		    if (selfEmails[i].indexOf("@") < 0) {
			    selfEmails[i] += "@" + prefs2.getCharPref("mail.smtpserver." + smtpServers[i] + ".hostname");
		    }
	    }
	    
	  // Short term solution #FIX
	  var tabExistsOnStart = false;
	  for (var i=0;i<document.getElementById("tabmail").tabModes["contentTab"].tabs.length;i++) {
	     if (document.getElementById("tabmail").tabModes["contentTab"].tabs[i].title == "Kardia") {
		tabExistsOnStart = true;
		break;
	     }
	  }
	  // if not, open it
	  if (!tabExistsOnStart) {
	     document.getElementById("tabmail").openTab("contentTab", {title: "Kardia", contentPage: "chrome://kardia/content/kardia-tab.xul"});
		  document.getElementById("tabmail").tabContainer.selectedIndex = 0;
	  }
	  if (kardiaTab)
		kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.png";
	  // End of short term solution
	 
	    getTrackTagStaff(loginInfo2[0], loginInfo2[1]);

	    toggleKardiaVisibility(3);
	    updateKardia();

	    if (callback) callback();

    });
}
	
// what to do when Thunderbird starts up
window.addEventListener("load", function() { 

	// For whatever reason this listener is getting called twice by TB. :(
	if (!document.getElementById("main-box"))
		return;

	// Load jQuery
	var loader = Components.classes["@mozilla.org/moz/jssubscript-loader;1"].getService(Components.interfaces.mozIJSSubScriptLoader);
	loader.loadSubScript("chrome://messenger/content/jquery.js", window);
	kardiacrm.jQuery = window.jQuery.noConflict(true);

	// set "show Kardia pane" arrow to the correct image, based on whether it's collapsed
	if (document.getElementById("main-box") && document.getElementById("main-box").collapsed == true) {
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
	}

   if (! document.getElementById("kardia-tab-button")) {
      installButton("mail-menubar", "kardia-tab-button");
   }

	// Present the login dialog (or draw from the LoginManager), and attempt to log in.
	doLogin(null);
	
	// make calendar reload whenever prefs change
	var todosObserver = { // TumblerQ: Calender functions Muted? Why not this?
		register: function() {
			this.branch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.kardia.");
			this.branch.addObserver("", this, false);
		},
		unregister: function() {
			this.branch.removeObserver("", this);
		},
		observe: function (aSubject, aTopic, aData) {
			// if either calendar pref changes, re-import
			if (aData == "importTodoAsEvent" || aData == "showTodosWithNoDate") {
				importTodos();
			}
		}
	}
	todosObserver.register();

   // sets up the open CRM and new data button
   mainWindow.document.getElementById("open-CRM-button").addEventListener("click", function() {
	if (mainWindow.ids[kardiacrm.selected_partner]) {
	    openURL(mainWindow.server + "/apps/kardia/modules/crm/profile.app?partner_key=" + escape(mainWindow.ids[kardiacrm.selected_partner]), false);
	}
	else {
	    openURL(mainWindow.server + "/apps/kardia/modules/crm", false);
	}
   });
   mainWindow.document.getElementById("new-data-button").addEventListener("click", function() {newNote("","")});

    if (window.gMessageListeners) {
	    gMessageListeners.push({
		    onEndHeaders: function () {},
		    onStartHeaders: function() {if (kardiacrm.logged_in) {findEmails(gFolderDisplay.selectedMessages, false);}}
		    });
    }

   updateKardia();

}, false);

// what to do when Thunderbird is closed
window.addEventListener("close", function() {
	// set username and password in preferences to blank values
	kardiacrm.username = "";
	kardiacrm.password = "";
}, false);

window.addEventListener("click", function() {if (kardiacrm.logged_in) {findEmails(gFolderDisplay.selectedMessages, false);}}, false);

function findEmails(selected, force) {

	// This routine isn't reentrant.
	if (kardiacrm.find_emails_busy) {
		return;
	}

	kardiacrm.find_emails_busy = true;
	kardiacrm.partners_loaded = false;
	kardiacrm.partner_data_loaded = false;
	
	// if 0 or > 1 email selected, don't search Kardia
	//if (gFolderDisplay.selectedCount < 1 && numSelected >= 1) {   // TumblerQ: Logic doesn't match comment. This intended?
	if (selected.length < 1 && numSelected >= 1) {   // TumblerQ: Logic doesn't match comment. This intended?
		// clear all partner info
		kardiacrm.selected_partner = 0;
		emailAddresses = new Array();
		names = new Array();
		ids = new Array();
		emailIds = [];
		addresses = new Array();
		phoneNumbers = new Array();
		allEmailAddresses = new Array();
		websites = new Array();
		engagementTracks = new Array();
		recentActivity = new Array();
		profilePhotos = [];
		todos = new Array();
		notes = new Array();
		autorecord = new Array();
		collaborators = new Array();
		documents = new Array();
		tags = new Array();
		data = new Array();
		dataGroups = new Array();
		gifts = new Array();
		funds = new Array();
		types = new Array();
		
		// show a blank Kardia pane
		reload(true);
	}

	// if one or more emails are selected 
	//if (gFolderDisplay.selectedCount >= 1 && !headersMatch(selectedMessages, gFolderDisplay.selectedMessages)) {
	if (selected.length >= 1 && (!headersMatch(selectedMessages, selected) || force)) {
		// select the 0th partner and generate a new list of partners
		kardiacrm.selected_partner = 0;
			
		// get email addresses involved in this email message
		var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces["nsIMsg" + "HeaderParser"]); // workaround for overzealous regex on AMO.
		var senderAddress = {};
		var recipientAddresses = {};
		var ccAddresses = {};
		var bccAddresses = {};
		var allAddresses = new Array();
		for (var i=0; i<selected.length; i++) {
			parser.parseHeadersWithArray(selected[i].author, senderAddress, {}, {});
			parser.parseHeadersWithArray(selected[i].recipients, recipientAddresses, {}, {});
			parser.parseHeadersWithArray(selected[i].ccList, ccAddresses, {}, {});
			parser.parseHeadersWithArray(selected[i].bccList, bccAddresses, {}, {});
							
			// combine list of addresses
			allAddresses = allAddresses.concat(senderAddress.value);
			allAddresses = allAddresses.concat(recipientAddresses.value);
			allAddresses = allAddresses.concat(ccAddresses.value);
			allAddresses = allAddresses.concat(bccAddresses.value);
		}
		
		// remove duplicates and self
		allAddresses = parser.removeDuplicateAddresses(allAddresses, selfEmails, {}).toLowerCase();

		// create array of addresses
		var addressArray = [];
		// if there are addresses, put them in the array
		if (allAddresses != null) {
			var addressArray = allAddresses.split(", ");
			addressArray.sort();
		}

		// save email addresses and initialize other information about partner
		emailAddresses = addressArray;
		names = new Array(emailAddresses.length);
		ids = new Array(emailAddresses.length);
		emailIds = new Array(emailAddresses.length);
		addresses = new Array(emailAddresses.length);
		phoneNumbers = new Array(emailAddresses.length);
		allEmailAddresses = new Array(emailAddresses.length);
		websites = new Array(emailAddresses.length);
		engagementTracks = new Array(emailAddresses.length);
		recentActivity = new Array(emailAddresses.length);
		profilePhotos = new Array(emailAddresses.length);
		todos = new Array(emailAddresses.length);
		notes = new Array(emailAddresses.length);
		autorecord = new Array(emailAddresses.length);
		collaborators = new Array(emailAddresses.length);
		documents = new Array(emailAddresses.length);
		tags = new Array(emailAddresses.length);
		data = new Array(emailAddresses.length);
		dataGroups = new Array(emailAddresses.length);
		gifts = new Array(emailAddresses.length);
		funds = new Array(emailAddresses.length);
		types = new Array(emailAddresses.length);

		// remove blank (and therefore invalid) partners
		for (var i=0;i<emailAddresses.length;i++) {
			if (emailAddresses[i] == "") {
				emailAddresses.splice(i,1);
				names.splice(i,1);
				ids.splice(i,1);
				emailIds.splice(i,1);
				addresses.splice(i,1);
				phoneNumbers.splice(i,1);
				allEmailAddresses.splice(i,1);
				websites.splice(i,1);
				engagementTracks.splice(i,1);
				recentActivity.splice(i,1);
				profilePhotos.splice(i,1);
				todos.splice(i,1);
				notes.splice(i,1);
				autorecord.splice(i,1);
				collaborators.splice(i,1);
				documents.splice(i,1);
				tags.splice(i,1);
				data.splice(i,1);
				dataGroups.splice(i,1);
				gifts.splice(i,1);
				funds.splice(i,1);
				types.splice(i,1);
				i--;
			}
		}
		// remove all Kardia buttons in the email message
		clearKardiaButton();

		// save headers
		selectedMessages = selected;
		
		// get data from Kardia
		findUser(0);
	}
	else {
	      // Update newly opened message window
	      kardiacrm.partners_loaded = true;
	      kardiacrm.partner_data_loaded = true;
	      if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
		    kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
	      }
	      kardiacrm.find_emails_busy = false;
	}
               
	// save number of emails selected so we can see if the number of emails selected has changed later
	numSelected = selected.length;

}

// do email header lists match?
function headersMatch(first, second) {
	if (first == null || second == null || first.length != second.length) {
		return false;
	}
	else {
		for (var k in first) {
			if (!Object.is(first[k], second[k])) {
				return false;
			}
		}
	}
	return true;
}

// builds recent activity data
function appendActivity(container, activity_list) {
	container.empty();
	for (var i=0;i<activity_list.length && i<3;i++) {
		var activity = activity_list[i];
		if (activity) {
			var info_vbox = 
				kardiacrm.jQuery('<vbox>', {})
					.append(kardiacrm.jQuery('<label>', {flex: '1', class:'act-date'})
						.text(datetimeToString(activity['activity_date']))
						.click(function(event) {
							kardiacrm.jQuery(event.target).parent().find('.act-info-2').css({ display:'block' });
						})
					)
				;
			var para = activity['info'].split('\n');
			for(var p=0; p<para.length; p++) {
				info_vbox.append(kardiacrm.jQuery('<label>', {class:(p==0)?'act-info':'act-info-2'})
					.text(para[p])
					.click(function(event) {
						kardiacrm.jQuery(event.target).parent().find('.act-info-2').css({ display:'block' });
					})
				)
			}
			container
				.append(kardiacrm.jQuery('<hbox>', {class:'hover-box'})
					.append(info_vbox)
				);
		}
	}
}

// reloads Kardia pane
function reload(isDefault) {

	var context = kardiacrm.jQuery(mainWindow.document);

	// if list of email addresses is empty or null, make everything in Kardia pane blank or hidden and hide Print context menu
	if (mainWindow.emailAddresses.length < 1 || mainWindow.emailAddresses == null) {
		mainWindow.document.getElementById('main-context').hidden = true;
		
		mainWindow.document.getElementById("name-label").value = "";
		mainWindow.document.getElementById("id-label").value = "";
		mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "none";
		mainWindow.document.getElementById("no-findy").style.display = "block";
		
		mainWindow.document.getElementById("main-content-box").style.visibility = "hidden";
		// FEATURE: Uncomment the following when recording emails in Kardia is implemented
		// mainWindow.document.getElementById("bottom-separator").style.visibility = "hidden";
		// mainWindow.document.getElementById("record-this-email").style.visibility = "hidden";
		// mainWindow.document.getElementById("record-future-emails").style.visibility = "hidden";
		
		if (kardiaTab != null) {
			kardiaTab.document.getElementById("tab-bottom-hbox").style.visibility = "hidden";
			kardiaTab.document.getElementById("tab-address-map").style.visibility="hidden";
			kardiaTab.document.getElementById("tab-bottom-name").value = "";
			kardiaTab.document.getElementById('print-context').hidden = true;
		}
	}
	else if (mainWindow.names[kardiacrm.selected_partner] != null && mainWindow.ids[kardiacrm.selected_partner] != null) {
		// show Print context menu
		mainWindow.document.getElementById('main-context').hidden = false;
		if (kardiaTab != null) {
			kardiaTab.document.getElementById('print-context').hidden = false;
		}
		// if and only if currently selected partner is not null, sort the list by first name
		var firstIndex;
		var firstItem;
		for (var i=0;i<mainWindow.ids.length;i++) {
			// determine order by first name
			firstIndex = i;
			firstItem = mainWindow.names[i];
			for (var j=i+1;j<mainWindow.names.length;j++) {
				if (firstItem > mainWindow.names[j]) {
					firstIndex = j;
					firstItem = mainWindow.names[j];
				}
			}
			
			mainWindow.names[firstIndex] = mainWindow.names[i];
			mainWindow.names[i] = firstItem;
			
			if (i == kardiacrm.selected_partner) {
				kardiacrm.selected_partner = firstIndex;
			}
			else if (firstIndex == kardiacrm.selected_partner) {
				kardiacrm.selected_partner = i;
			}
			
			// move all other items around based on how we sorted names
			var arraysToMove = [mainWindow.emailAddresses, mainWindow.ids, mainWindow.emailIds, mainWindow.addresses, mainWindow.phoneNumbers, mainWindow.allEmailAddresses, mainWindow.websites, mainWindow.engagementTracks, mainWindow.recentActivity, mainWindow.profilePhotos, mainWindow.todos, mainWindow.notes, mainWindow.autorecord, mainWindow.collaborators, mainWindow.documents, mainWindow.tags, mainWindow.data, mainWindow.dataGroups, mainWindow.gifts, mainWindow.funds, mainWindow.types];
			
			for (var j=0;j<arraysToMove.length;j++) {
				firstItem = arraysToMove[j][firstIndex];
				arraysToMove[j][firstIndex] = arraysToMove[j][i];
				arraysToMove[j][i] = firstItem;
			}
		}
		
		// if we're loading the pane for the first time, select the first (0th) item
		if (isDefault) {
			kardiacrm.selected_partner = 0;
		}

		// show content boxes in case they're hidden
		mainWindow.document.getElementById("main-content-box").style.visibility = "visible";
      mainWindow.document.getElementById('loading-gif-container').style.visibility = "collapse";
		// FEATURE: Uncomment the following when recording emails in Kardia is impmented
		// mainWindow.document.getElementById("bottom-separator").style.visibility = "visible";
		// mainWindow.document.getElementById("record-this-email").style.visibility = "visible";
		// mainWindow.document.getElementById("record-future-emails").style.visibility = "visible";
		
		// show name and id of selected partner
		mainWindow.document.getElementById("name-label").value = mainWindow.names[kardiacrm.selected_partner];
		mainWindow.document.getElementById("id-label").value = "ID# " + mainWindow.ids[kardiacrm.selected_partner];

		// if Kardia tab is open, show bottom box and add name
		if (kardiaTab != null) {
			kardiaTab.document.getElementById("tab-bottom-hbox").style.visibility = "visible";
			kardiaTab.document.getElementById("tab-address-map").style.visibility="visible";
			kardiaTab.document.getElementById("tab-bottom-name").value = mainWindow.names[kardiacrm.selected_partner];
		}
						
		// if only one partner available, hide dropdown arrow
		if (mainWindow.names.length <= 1) {
			mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "none";
		}
		else {		
			// show dropdown
			mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "inline";
			
			// display choices of partners to view
			context
			    .find("#choose-partner-dropdown-menu")
			    .empty();
			for (var i=0;i<mainWindow.names.length;i++) {
				let id = i;
				context
					.find("#choose-partner-dropdown-menu")
					.append(
						kardiacrm.jQuery("<button>", {
							id:'partner-button' + parseInt(id),
							class:'partner-button',
							label:mainWindow.names[id] + ', ID# ' + mainWindow.ids[id],
						})
						.bind('command', function(event) {
							choosePartner(id);
						})
					);
			}
		}

		// display contact info based on selected partner
		// First - mailing addresses
		var contactbox = context.find("#contact-info-inner-box");
		contactbox.empty();
		for (var i=0;i<mainWindow.addresses[kardiacrm.selected_partner].length;i+=2) {
			let addr_id = i;

			contactbox
				.append(kardiacrm.jQuery("<hbox>", {class:'hover-box'})
					.append(kardiacrm.jQuery("<vbox>", {flex:'1', id:'contact-info-addrlist' + addr_id}))
					.append(kardiacrm.jQuery("<vbox>", {})
						.append(kardiacrm.jQuery("<spacer>", {height:'3px'}))
						.append(kardiacrm.jQuery("<image>", {class:'edit-image'})
							.click(function (event) {
								editContactInfo('A', mainWindow.addresses[kardiacrm.selected_partner][addr_id+1]);
							})
						.append(kardiacrm.jQuery("<spacer>", {flex:'1'}))
						)
					.append(kardiacrm.jQuery("<spacer>", {width:'3px'}))
					)
				)

			var splitAddress = mainWindow.addresses[kardiacrm.selected_partner][i].split("\n");
			for (var j=0;j<splitAddress.length;j++) {
				context.find("#contact-info-addrlist" + addr_id).append(kardiacrm.jQuery("<label>", {}).text(splitAddress[j]));
			}
		}

		// Next - phone numbers
		for (var i=0;i<mainWindow.phoneNumbers[kardiacrm.selected_partner].length;i+=2) {
			let cont_id = i;

			contactbox
				.append(kardiacrm.jQuery("<hbox>", {class:'hover-box'})
					.append(kardiacrm.jQuery("<vbox>", {flex:'1'})
						.append(kardiacrm.jQuery("<label>", {})
							.text(mainWindow.phoneNumbers[kardiacrm.selected_partner][i])
						)
					)
					.append(kardiacrm.jQuery("<vbox>", {})
						.append(kardiacrm.jQuery("<spacer>", {height:'3px'}))
						.append(kardiacrm.jQuery("<image>", {class:'edit-image'})
							.click(function(event) {
								editContactInfo('P', mainWindow.phoneNumbers[kardiacrm.selected_partner][cont_id+1]);
							})
						)
						.append(kardiacrm.jQuery("<spacer>", {flex:'1'}))
					)
					.append(kardiacrm.jQuery("<spacer>", {width:'3px'}))
				);
		}

		// Then - email addresses
		for (var i=0;i<mainWindow.allEmailAddresses[kardiacrm.selected_partner].length;i+=2) {
			let cont_id = i;

			contactbox
				.append(kardiacrm.jQuery("<hbox>", {class:'hover-box'})
					.append(kardiacrm.jQuery("<vbox>", {flex:'1'})
						.append(kardiacrm.jQuery("<label>", {class:'text-link', tooltiptext:'Click to compose email', context:'emailContextMenu'})
							.text(mainWindow.allEmailAddresses[kardiacrm.selected_partner][i])
							.click(function(event) {
								if (event.button == 0)
									sendEmail(mainWindow.allEmailAddresses[kardiacrm.selected_partner][cont_id]);
							})
						)
					)
					.append(kardiacrm.jQuery("<vbox>", {})
						.append(kardiacrm.jQuery("<spacer>", {height:'3px'}))
						.append(kardiacrm.jQuery("<image>", {class:'edit-image'})
							.click(function(event) {
								editContactInfo('E', mainWindow.allEmailAddresses[kardiacrm.selected_partner][cont_id+1]);
							})
						)
						.append(kardiacrm.jQuery("<spacer>", {flex:'1'}))
					)
					.append(kardiacrm.jQuery("<spacer>", {width:'3px'}))
				);
		}

		// Finally - Website URLs
		for (var i=0;i<mainWindow.websites[kardiacrm.selected_partner].length;i+=2) {
			let cont_id = i;

			contactbox
				.append(kardiacrm.jQuery("<hbox>", {class:'hover-box'})
					.append(kardiacrm.jQuery("<vbox>", {flex:'1'})
						.append(kardiacrm.jQuery("<label>", {class:'text-link', tooltiptext:'Click to visit website', context:'websiteContextMenu'})
							.text(mainWindow.websites[kardiacrm.selected_partner][i])
							.click(function(event) {
								if (event.button == 0)
									openUrl(mainWindow.websites[kardiacrm.selected_partner][cont_id], true);
							})
						)
					)
					.append(kardiacrm.jQuery("<vbox>", {})
						.append(kardiacrm.jQuery("<spacer>", {height:'3px'}))
						.append(kardiacrm.jQuery("<image>", {class:'edit-image'})
							.click(function(event) {
								editContactInfo('W', mainWindow.websites[kardiacrm.selected_partner][cont_id+1]);
							})
						)
						.append(kardiacrm.jQuery("<spacer>", {flex:'1'}))
					)
					.append(kardiacrm.jQuery("<spacer>", {width:'3px'}))
				);
		}

		// this provides the button to add a new contact info record...
		contactbox
			.append(kardiacrm.jQuery('<hbox>', {})
				.append(kardiacrm.jQuery('<spacer>', {flex:'1'}))
				.append(kardiacrm.jQuery('<button>', {class:'new-button', label:'New Contact Info...', tooltiptext:'Create new contact information item for this partner'})
					.bind('command', function(event) {
						newContactInfo();
					})
				)
			);
		
		// display engagement tracks
		var tracks = "";
		context.find('#engagement-tracks-inner-box').empty();
		if (mainWindow.engagementTracks[kardiacrm.selected_partner]) {
			for (var i=0;i<mainWindow.engagementTracks[kardiacrm.selected_partner].length;i+=3) {
				// Taking out edit button for now. #Muted
				//tracks += '<hbox class="engagement-track-color-box" style="background-color:' + htmlEscape(mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[kardiacrm.selected_partner][i])]) + '"><vbox flex="1"><label class="bold-text">' + htmlEscape(mainWindow.engagementTracks[kardiacrm.selected_partner][i]) + '</label><label>Engagement Step: ' + htmlEscape(mainWindow.engagementTracks[kardiacrm.selected_partner][i+1]) + '</label></vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editTrack(\'' + htmlEscape(mainWindow.engagementTracks[kardiacrm.selected_partner][i+2]) + '\',\'' + htmlEscape(mainWindow.engagementTracks[kardiacrm.selected_partner][i+1]) + '\')"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
				var track = find_item(kardiacrm.data.trackList, 'track_name', mainWindow.engagementTracks[kardiacrm.selected_partner][i]);
				if (track) {
					context
						.find('#engagement-tracks-inner-box')
						.append(kardiacrm.jQuery('<hbox>', {class:'engagement-track-color-box', id:'eng-trk-color-box-' + i})
							.css({
								'background-color': track.track_color,
							})
							.append(kardiacrm.jQuery('<vbox>', {flex:'1'})
								.append(kardiacrm.jQuery('<label>', {class:'bold-text'})
									.text(track.track_name)
								)
								.append(kardiacrm.jQuery('<label>', {})
									.text('Engagement Step: ' + mainWindow.engagementTracks[kardiacrm.selected_partner][i+1])
								)
							)
							.append(kardiacrm.jQuery('<vbox>', {})
								.append(kardiacrm.jQuery('<spacer>', {height:'3px'}))
								.append(kardiacrm.jQuery('<spacer>', {flex:'1'}))
							)
							.append(kardiacrm.jQuery('<spacer>', {width:'3px'}))
						);

					// Try to intelligently set text (foreground) color
					var bgcolor = context.find('#eng-trk-color-box-' + i).css('background-color').match(/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i);
					if (bgcolor) {
						var lum = parseInt(bgcolor[1]) + parseInt(bgcolor[2]) + parseInt(bgcolor[3]);
						context.find('#eng-trk-color-box-' + i).css({'color': (lum>=384)?'black':'white'});
					}
				}
			}
		}

		// Muting this button for now #Muted
		//tracks += '<hbox><spacer flex="1"/><button class="new-button" label="New Track..." oncommand="newTrack()" tooltiptext="Add engagement track to this partner"/></hbox>';
		
		// display recent activity
		appendActivity(context.find('#recent-activity-inner-box'), mainWindow.recentActivity[kardiacrm.selected_partner]);

		// display photo
		var photo = "";
		if (profilePhotos[kardiacrm.selected_partner]) {
			photo += "<hbox pack=\"center\"><image src=\"" + htmlEscape(server + "/apps/kardia/api/crm/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/ProfilePicture/" + profilePhotos[kardiacrm.selected_partner].photo_filename) + "\" style=\"max-width:200px; max-height:120px;\"/></hbox>";
		}
		mainWindow.document.getElementById("profile-photo-inner-box").innerHTML = photo;
		
		// display todos
		var toDoText = "";
		for (var i=0;i<mainWindow.todos[kardiacrm.selected_partner].length;i+=2) {
			toDoText += '<checkbox id="to-do-item-' + htmlEscape(mainWindow.todos[kardiacrm.selected_partner][i]) + '" oncommand="deleteTodo(' + htmlEscape(mainWindow.todos[kardiacrm.selected_partner][i]) + ')" label="' + htmlEscape(mainWindow.todos[kardiacrm.selected_partner][i+1]) + '"/>';
		}
		// FEATURE: uncomment this when adding to-do items is implemented
		// toDoText += '<hbox><spacer flex="1"/><button class="new-button" label="New To-Do..." oncommand="newTodo()" tooltiptext="Create new to-do item for this partner"/></hbox>'; 
		//mainWindow.document.getElementById("to-dos-inner-box").innerHTML = "";
      // Muted for now #Muted
		mainWindow.document.getElementById("to-dos-inner-box").innerHTML = toDoText;	
		
		// Muted for now #Muted (CAUTION: When unmuting this it could reintroduce bug #11)
		// display notes
		/*var noteText = "";
		for (var i=mainWindow.notes[kardiacrm.selected_partner].length-1;i>=0;i-=3) {
			noteText += '<hbox class="hover-box"><vbox><spacer height="3"/><image class="note-image"/><spacer flex="1"/></vbox><vbox width="100" flex="1"><description flex="1">' + htmlEscape(mainWindow.notes[kardiacrm.selected_partner][i-2]) + '</description><description flex="1">' + htmlEscape(mainWindow.notes[kardiacrm.selected_partner][i-1]) + '</description></vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editNote(\'' + htmlEscape(mainWindow.notes[kardiacrm.selected_partner][i-2]) + '\',' + htmlEscape(mainWindow.notes[kardiacrm.selected_partner][i]) + ');"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
		}
		noteText += '<hbox><spacer flex="1"/><button class="new-button" label="New Note/Prayer..." tooltiptext="Create new note/prayer for this partner" oncommand="newNote(\'\',\'\')"/></hbox>';	*/
		mainWindow.document.getElementById("notes-prayer-inner-box").innerHTML = "";
		//mainWindow.document.getElementById("notes-prayer-inner-box").innerHTML = noteText;
		
		// display collaborators
		var collaboratorText = "";
		for (var i=0;i<mainWindow.collaborators[kardiacrm.selected_partner].length;i+=3) {
			// if it's a team/group, show team image 
			if (mainWindow.collaborators[kardiacrm.selected_partner][i] == 0) {
				collaboratorText += '<hbox><vbox><image class="team-image"/>';
			}
			else {
				//show individual image
				collaboratorText += '<hbox><vbox><image class="individual-image"/>';
			}
			collaboratorText += '<spacer flex="1"/></vbox><label tooltiptext="Click to view collaborator" width="100" flex="1" class="text-link" onclick="addCollaborator(' + mainWindow.collaborators[kardiacrm.selected_partner][i+1] + ')">' + mainWindow.collaborators[kardiacrm.selected_partner][i+2] +'</label></hbox>';
		}
		collaboratorText += '<hbox><spacer flex="1"/></hbox>';
		// Add new collaborator button muted for now untill fixed. Code below Includes it, code above removes it.
		//collaboratorText += '<hbox><spacer flex="1"/><button class="new-button" label="New Collaborator..." tooltiptext="Create new collaborator for this partner" oncommand="newCollaborator()"/></hbox>';
		
		mainWindow.document.getElementById("collaborator-inner-box").innerHTML = "";	
		// Muted for now #Muted
		//mainWindow.document.getElementById("collaborator-inner-box").innerHTML = collaboratorText;	
		
		// display documents
		context.find("#document-inner-box").empty();
		for (var i=0;i<mainWindow.documents[kardiacrm.selected_partner].length;i+=2) {
		    let docid = i;

		    context
				.find("#document-inner-box")
				.append(kardiacrm.jQuery('<hbox>')
					.append(kardiacrm.jQuery('<vbox>')
						.append(kardiacrm.jQuery('<image>', {class:'document-image'}))
						.append(kardiacrm.jQuery('<spacer>', {flex:'1'}))
					)
					.append(kardiacrm.jQuery('<label>', { tooltiptext:'Click to open document', id:'docLabel' + parseInt(docid), width:'100', flex:'1', class:'text-link', context:'documentContextMenu' })
						.text(mainWindow.documents[kardiacrm.selected_partner][docid+1])
						.click(
							function(event) {
							if (event.button == 0)
								openDocument(kardiacrm.selected_partner, docid, false);
							}
						)
					)
				);
		}
		
		// if Kardia tab is open, add person's info to it, too
		if (kardiaTab != null) {
			// display tags
			kardiaTab.document.getElementById("tab-tags").innerHTML = '<label class="tab-title" value="Tags"/>';

			for (var i=0;i<mainWindow.tags[kardiacrm.selected_partner].length;i+=3) {	
				var questionMark = (mainWindow.tags[kardiacrm.selected_partner][i+2] <= 0.5) ? "?" : "";
				var filterIndex = find_item(kardiacrm.data.tagList, 'tag_label', mainWindow.tags[kardiacrm.selected_partner][i]).tag_id;
				// if positive, use green tags
				if (parseFloat(mainWindow.tags[kardiacrm.selected_partner][i+1]) >= 0) {
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + htmlEscape(filterIndex) + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(86,75%,' + htmlEscape((100-60*mainWindow.tags[kardiacrm.selected_partner][i+1])) + '%);"><label value="' + htmlEscape(mainWindow.tags[kardiacrm.selected_partner][i] + questionMark) + '"/></vbox>';
				}
				else {
					// red tags
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + htmlEscape(filterIndex) + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(8,100%,' + htmlEscape((100-40*(-1*mainWindow.tags[kardiacrm.selected_partner][i+1]))) + '%);"><label value="' + htmlEscape(mainWindow.tags[kardiacrm.selected_partner][i] + questionMark) + '"/></vbox>';
				}
			}
			kardiaTab.document.getElementById("tab-tags").innerHTML += '<hbox><spacer flex="1"/></hbox>';
         // New tag button muted for now.
			//kardiaTab.document.getElementById("tab-tags").innerHTML += '<hbox><spacer flex="1"/><button class="new-button" label="New Tag..." oncommand="newTag()" tooltiptext="Add tag to this partner"/></hbox>';
			
			// display data item groups
			if (mainWindow.dataGroups[kardiacrm.selected_partner].length > 0) {
				kardiaTab.document.getElementById("tab-data-items").innerHTML = '<label class="tab-title" value="Data Items"/>';
			
				for (var i=0;i<mainWindow.dataGroups[kardiacrm.selected_partner].length;i+=2) {
					kardiaTab.document.getElementById("tab-data-items").innerHTML += '<label class="new-button" value="' + htmlEscape(mainWindow.dataGroups[kardiacrm.selected_partner][i+1]) + '..." onclick="openDataTab(\'' + htmlEscape(mainWindow.dataGroups[kardiacrm.selected_partner][i]) + '\',\'' + htmlEscape(mainWindow.dataGroups[kardiacrm.selected_partner][i+1]) + '\')"/>';
				}
				// show data items
				kardiaTab.document.getElementById("tab-data-items").style.visibility="visible";
			}
			else {
				// hide data items
				kardiaTab.document.getElementById("tab-data-items").style.visibility="collapse";
			}

			if (mainWindow.gifts[kardiacrm.selected_partner].length <= 0) {
				// show that there is no giving history
				kardiaTab.document.getElementById("tab-no-giving-history").style.display = "inline";
				kardiaTab.document.getElementById("giving-tree").style.visibility = "collapse";
				kardiaTab.document.getElementById("tab-funds").style.visibility = "collapse";
			}
			else {
				kardiaTab.document.getElementById("tab-no-giving-history").style.display = "none";
				kardiaTab.document.getElementById("giving-tree").style.visibility = "visible";
				kardiaTab.document.getElementById("tab-funds").style.visibility = "visible";
			
				// display gifts
				kardiaTab.document.getElementById("giving-tree-children").innerHTML = "";
				for (var i=0;i<mainWindow.gifts[kardiacrm.selected_partner].length;i+=4) {
					kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+1]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+2]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+3]) + '"/></treerow></treeitem>';
				}
				
				// display fund filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML = '<label value="Fund: "/>';
				for (var i=0;i<mainWindow.funds[kardiacrm.selected_partner].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML += '<button id="filter-gifts-by-f-' + i + '" type="checkbox" checkState="0" tooltiptext="Click to filter gifts by this fund" class="tab-filter-checkbox" oncommand="addGiftFilter(\'f\',\'' + i + '\');" label="' + htmlEscape(mainWindow.funds[kardiacrm.selected_partner][i]) + '"/>';
				}
	
				// display type filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML = '<label value="Type: "/>';
				for (var i=0;i<mainWindow.types[kardiacrm.selected_partner].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML += '<button id="filter-gifts-by-t-' + i + '" type="checkbox" checkState="0" tooltiptext="Click to filter gifts by this type" class="tab-filter-checkbox" oncommand="addGiftFilter(\'t\',\'' + i + '\');" label="' + htmlEscape(mainWindow.types[kardiacrm.selected_partner][i]) + '"/>';
				}
				
				// display funds
				kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML = '<label class="bold-text" value="Filter partners by fund"/>';
				for (var i=0;i<mainWindow.funds[kardiacrm.selected_partner].length;i++) {
					kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML += '<vbox tooltiptext="Click to filter partners by this fund" class="tab-fund" onclick="addFilter(\'f\',\'' + htmlEscape(mainWindow.funds[kardiacrm.selected_partner][i]) + '\');"><label>' + htmlEscape(mainWindow.funds[kardiacrm.selected_partner][i]) + '</label></vbox>';
				}
			}
			
			// display dropdown list of person's emails
			kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML = "";
			for (var i=0;i<mainWindow.allEmailAddresses[kardiacrm.selected_partner].length;i+=2) {
				kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML += '<menuitem label="' + htmlEscape(mainWindow.allEmailAddresses[kardiacrm.selected_partner][i].substring(3, mainWindow.allEmailAddresses[kardiacrm.selected_partner][i].length)) + '"/>';
			}
			kardiaTab.document.getElementById("tab-filter-select").selectedIndex = 0;
			
			// display dropdown list of addresses and link to map
			if (mainWindow.addresses[kardiacrm.selected_partner].length > 0) {
				kardiaTab.document.getElementById("tab-location").style.visibility="visible";
				kardiaTab.document.getElementById("tab-address-select-inner").innerHTML = "";
				for (var i=0;i<mainWindow.addresses[kardiacrm.selected_partner].length;i+=2) {
					kardiaTab.document.getElementById("tab-address-select-inner").innerHTML += '<menuitem label="' + htmlEscape(mainWindow.addresses[kardiacrm.selected_partner][i]) + '" style="text-overflow:ellipsis;width:200px;"/>';
				}
				kardiaTab.document.getElementById("tab-address-select").selectedIndex = 0;
				kardiaTab.document.getElementById("tab-map-link").href = "http://www.google.com/maps/place/" + encodeURIComponent(kardiaTab.document.getElementById("tab-address-select").selectedItem.label.substring(3,kardiaTab.document.getElementById("tab-address-select").selectedItem.label.length));
			}
			else {
				// the person has no addresses, so don't show address stuff
				kardiaTab.document.getElementById("tab-location").style.visibility="collapse";
			}
		}
	}
   // Done loading, remove loading gif
   mainWindow.document.getElementById('loading-gif-container').style.visibility = "collapse";
   if (kardiaTab != null) {
      kardiaTab.processingClick = false;
   }
   if (kardiaTab != null) {
      //kardiaTab.filterBy();
   }

}

// copy location of clicked link to clipboard
function copyLinkLocation() {
   var websiteAddress = document.popupNode.textContent;
   var clipboard = Components.classes["@mozilla.org/widget/clipboardhelper;1"].getService(Components.interfaces.nsIClipboardHelper);
   clipboard.copyString(websiteAddress.substring(3,websiteAddress.length));
}

// copy location of clicked link to clipboard
function copyMapLocation() {
	var websiteAddress = document.popupNode.href;
    var clipboard = Components.classes["@mozilla.org/widget/clipboardhelper;1"].getService(Components.interfaces.nsIClipboardHelper);
    clipboard.copyString(websiteAddress);
}

// copy location of selected document to clipboard
function copyDocLinkLocation(idString) {
	var num = idString.substring(idString.length-1, idString.length);
    var clipboard = Components.classes["@mozilla.org/widget/clipboardhelper;1"].getService(Components.interfaces.nsIClipboardHelper);
    clipboard.copyString(documents[kardiacrm.selected_partner][num]);
}

// open the given URL in default browser
function openUrl(url, isContact) {
	// if necessary, delete "W: " or "B: " prefix
	if (isContact) {
		url = url.substring(3,url.length);
	}
	// if URL doesn't have "http://", add it
	if (url.indexOf("http://") != 0 && url.indexOf("https://") != 0) {
		url = "http://" + url;
	}
	// create URI and open
	var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
	var uriToOpen = ioService.newURI(url, null, null);
	Components.classes["@mozilla.org/uriloader/external-protocol-service;1"].getService(Components.interfaces.nsIExternalProtocolService).loadURI(uriToOpen);
}

// open the given document in default program
function openDocument(index, docid, savePage) {
	if (!mainWindow.documents[index] || !mainWindow.documents[index][docid])
	    return;
	var url = mainWindow.documents[index][docid];
	// if URL doesn't have "http://", add it
	if (url.indexOf("http://") < 0) {
		url = "http://" + url;
	}
	// create URI and make nsIURL from it
	var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
	var uriToOpen = ioService.newURI(url, null, null);
	var urlToOpen = uriToOpen.QueryInterface(Components.interfaces.nsIURL);
	
	try {
		// get MIME type
		var mimeService = Components.classes["@mozilla.org/mime;1"].getService().QueryInterface(Components.interfaces.nsIMIMEService);
		var mimeType = mimeService.getTypeFromURI(uriToOpen);
		
		// save or open, depending on parameter; note: html files work, but they don't show a "save as type"
		if (savePage) {	
			// start saving
			var file;	
			var fileInfo = new FileInfo(urlToOpen.fileName);
			initFileInfo(fileInfo, urlToOpen, null, null, null, null); 

			var fpParams = {
				fpTitleKey: null,
				fileInfo: fileInfo,
				contentType: mimeType,
				saveMode: 0x00,
				saveAsType: 0,
				file: file
			};

			getTargetFile(fpParams, function(aDialogCancelled) {
				if (aDialogCancelled)
					return;

				file = fpParams.file;
	
				var persistArgs = {
				  sourceURI         : uriToOpen,
				  sourceReferrer    : null,
				  sourceDocument    : null,
				  targetContentType : null,
				  targetFile        : file,
				  sourceCacheKey    : null,
				  sourcePostData    : null,
				  bypassCache       : true,
				  initiatingWindow  : document.defaultView
				};

				// do the internal saving process
				internalPersist(persistArgs);
				  
			}, true, null);

			//			
		}
		else {
			// just open it
			messenger.openAttachment(mimeType, url, encodeURIComponent(urlToOpen.fileName), uriToOpen, true);
		}
	}
	catch (e) {
		// finding MIME type failed, we can't save, so we just open the URL
		openUrl(url, false);
	}
}

// see if the document given by the ID can be saved, and if not, gray out the option to save it
function setSaveable(idString) {
	var num = idString.substring(idString.length-1, idString.length);
	var url = documents[kardiacrm.selected_partner][num];
	var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
	var uriToOpen = ioService.newURI(url, null, null);
	try {
		// try to get MIME type; if it succeeds, un-gray out the option to save
		var mimeService = Components.classes["@mozilla.org/mime;1"].getService().QueryInterface(Components.interfaces.nsIMIMEService);
		var mimeType = mimeService.getTypeFromURI(uriToOpen);
		document.getElementById('save-link-as').removeAttribute('disabled');
	}
	catch(e) {
		// we couldn't get MIME type, so it can't be saved and we gray out the option
		document.getElementById('save-link-as').disabled='true';
	}
}

// find document url based on ID and open it
function findAndOpenDocument(idString, savePage) {
	var num = idString.substring(idString.length-1, idString.length);
	openDocument(kardiacrm.selected_partner, num, savePage);
}

// create a new email with this address as recipient
function sendEmail(recipient) {
	// remove "E: " prefix from email
	recipient = recipient.substring(3,recipient.length);
	// set email properties
	var msgComposeType = Components.interfaces.nsIMsgCompType;
	var msgComposeSvc = Components.classes['@mozilla.org/messengercompose;1'].getService();
	msgComposeSvc = msgComposeSvc.QueryInterface(Components.interfaces.nsIMsgComposeService);
	var params = Components.classes['@mozilla.org/messengercompose/composeparams;1'].createInstance(Components.interfaces.nsIMsgComposeParams);
	params.type = msgComposeType.Template;
	params.format = 0;
	var composeFields = Components.classes['@mozilla.org/messengercompose/composefields;1'].createInstance(Components.interfaces.nsIMsgCompFields);
	composeFields.to = recipient;
	composeFields.body = "";
	composeFields.subject = "";
	params.composeFields = composeFields;

	// open compose window
	msgComposeSvc.OpenComposeWindowWithParams(null, params);
}

// save email address to contacts
function saveToContacts(emailAddress) {
  kardiacrm.dialog = window.openDialog("chrome://messenger/content/addressbook/abNewCardDialog.xul","","chrome,resizable=no,titlebar,modal,centerscreen",{primaryEmail: emailAddress.substring(3,emailAddress.length), displayName: names[kardiacrm.selected_partner]});
}

// print currently selected partner
function printPartner(whichPartner) {	
	if (whichPartner == null) {
		whichPartner = kardiacrm.selected_partner;
	}
	// open new hidden window where we'll put content to print
	var printWindow = window.open("about:blank", "test-window", "chrome,left=0,top=-1000,width=500,height=800,toolbar=0,scrollbars=0,status=0");
	
	// it probably is bad practice to hard-code the style, but this is the only way it will work (the window is fussy)
	// get information displayed in main-box and write it to printWindow
	var contactPrintString = "";
	var trackPrintString = "";
	var todosPrintString = "";
	var documentsPrintString = "";
	var activityPrintString = "";
	var notesPrintString = "";
	var collaboratorsPrintString = "";
	var tagsPrintString = "";
	var dataPrintString = "";
	var giftsPrintString = "";
	var fundsPrintString = "";
	
	for (var i=0;i<mainWindow.addresses[whichPartner].length;i+=2) {
		var splitAddress = mainWindow.addresses[whichPartner][i].split("\n");
		for (var j=0;j<splitAddress.length;j++) {
			contactPrintString += "</br>" + splitAddress[j];
		}
	}
	for (var i=0;i<mainWindow.phoneNumbers[whichPartner].length;i+=2) {
		contactPrintString += "</br>" + mainWindow.phoneNumbers[whichPartner][i];
	}
	for (var i=0;i<mainWindow.allEmailAddresses[whichPartner].length;i+=2) {
		contactPrintString += "</br>" + mainWindow.allEmailAddresses[whichPartner][i];
	}
	for (var i=0;i<mainWindow.websites[whichPartner].length;i+=2) {
		contactPrintString += "</br>" + mainWindow.websites[whichPartner][i];
		}
	for (var i=0;i<mainWindow.engagementTracks[whichPartner].length;i+=3) {
		trackPrintString += '</br><span style="padding:2px; background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[whichPartner][i])] + '"><b>' + mainWindow.engagementTracks[whichPartner][i] + '</b>&nbsp;&nbsp;Engagement Step: ' + mainWindow.engagementTracks[whichPartner][i+1] + '</span>';
	}	
	for (var i=0;i<mainWindow.recentActivity[whichPartner].length;i++) {
		if (mainWindow.recentActivity[whichPartner][i]['activity_type'] == "e") {
			activityPrintString += '</br>&#x2709&nbsp;' + mainWindow.recentActivity[whichPartner][i]['activity_date'] + ': ' + mainWindow.recentActivity[whichPartner][i]['info'];
		}
	}	
	for (var i=1;i<mainWindow.todos[whichPartner].length;i+=2) {
		todosPrintString += "</br>&#x2610  " + mainWindow.todos[whichPartner][i];
	}
	for (var i=0;i<mainWindow.notes[whichPartner].length;i++) {
		notesPrintString += '</br>' + mainWindow.notes[whichPartner].text + '&nbsp;&nbsp;(' + mainWindow.notes[whichPartner].date + ")";
	}
	for (var i=0;i<mainWindow.collaborators[whichPartner].length;i+=3) {
		collaboratorsPrintString += '</br>' + mainWindow.collaborators[whichPartner][i+2];
	}
	for (var i=0;i<mainWindow.documents[whichPartner].length;i+=2) {
		documentsPrintString += "</br>" + mainWindow.documents[whichPartner][i+1] + "&nbsp;&nbsp;<span style='text-decoration:underline;'>" + mainWindow.documents[whichPartner][i] +  "</span>";
	}
	for (var i=0;i<mainWindow.tags[whichPartner].length;i+=3) {
		var questionMark = (mainWindow.tags[whichPartner][i+2] <= 0.5) ? "?" : "";
		tagsPrintString += '</br><span style="background-color:hsl(46,100%,' + (100-50*mainWindow.tags[whichPartner][i+1]) + '%);">' + mainWindow.tags[whichPartner][i] + questionMark + '</span>';
	}	
	for (var i=0;i<mainWindow.data[whichPartner].length;i+=3) {
		if (mainWindow.data[whichPartner][i+1].toString() == "0") {
			// not highlighted, so don't highlight the data item
			dataPrintString += '</br>' + mainWindow.data[whichPartner][i];
		}
		else {
			// highlight it
			dataPrintString += '</br><span style="background-color:#fff4a3;">' + mainWindow.data[whichPartner][i] + '</span>';
		}
	}
	for (var i=0;i<mainWindow.gifts[whichPartner].length;i+=4) {
		giftsPrintString += '</br>' + mainWindow.gifts[whichPartner][i] + "&nbsp;&nbsp;" + mainWindow.gifts[whichPartner][i+1] + " by " + mainWindow.gifts[whichPartner][i+3] + " to " + mainWindow.gifts[whichPartner][i+2];
	}
	for (var i=0;i<mainWindow.funds[whichPartner].length;i++) {
		fundsPrintString += '</br>' + mainWindow.funds[whichPartner][i];
	}
	
	// write the stuff we want to print to the window
	printWindow.document.write(
		"<span style='font-size:24px; font-weight:bold; font-family:Arial,sans-serif;'>" 
		+ mainWindow.names[whichPartner] 
		+ "</span> " 
		+ mainWindow.ids[whichPartner] 
		+ "</br></br><b>Contact Information:</b>" 
		+ contactPrintString
		+ "</br></br><b>Engagement Tracks:</b>" 
		+ trackPrintString
		+ "</br></br><b>Recent Activity:</b>" 
		+ activityPrintString
		+ "</br></br><b>To Dos:</b>" 
		+ todosPrintString 
		+ "</br></br><b>Notes and Prayer:</b>" 
		+ notesPrintString
		+ "</br></br><b>Collaborators:</b>" 
		+ collaboratorsPrintString
		+ "</br></br><b>Documents:</b>" 
		+ documentsPrintString
		+ "</br></br><b>Tags:</b>" 
		+ tagsPrintString
		+ "</br></br><b>Data Items:</b>" 
		+ dataPrintString
		+ "</br></br><b>Gifts:</b>" 
		+ giftsPrintString
		+ "</br></br><b>Funds Contributed To:</b>" 
		+ fundsPrintString
	);
	
	// print printWindow, then close it
	printWindow.print();
	printWindow.close();
}

// find partner in Kardia based on the email address found at position "index" in the list of email addresses
function findUser(index) {	
      // Set loading gif state until finished loading partner
      mainWindow.document.getElementById('loading-gif-container').style.visibility = "visible";
      mainWindow.document.getElementById('main-content-box').style.visibility = "hidden";
      mainWindow.document.getElementById('name-label').value = "Loading...";
      mainWindow.document.getElementById('id-label').value = "";
	  mainWindow.document.getElementById("no-findy").style.display = "none";

      // don't try to access Kardia if the Thunderbird user's Kardia login is invalid
      if (kardiacrm.logged_in) {		
         // remove dashes from email address so Kardia will take it
         var emailAddress = emailAddresses[index].replace("-","");	
         
         // create HTTP request to get info about partners for the given email address; we don't use doHttpRequest because we want to do things if it fails
         var emailRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
         var emailResp;
         var emailUrl = server + "apps/kardia/api/partner/ContactTypes/Email/" + emailAddress + "/Partners?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
         
         emailRequest.onreadystatechange = function(aEvent) {
            // if the request went through and result was returned, continue
            if(emailRequest.readyState == 4 && emailRequest.status == 200) {
               // parse the JSON file we received
               emailResp = JSON.parse(emailRequest.responseText);
               
               // get the keys in the JSON file
               var keys = [];
               for(var k in emailResp) keys.push(k);
                        
               // how many extra partners did we add from this email address?
               var numExtra = 0;
               
               // if the first partner found isn't already in the list, add them to the list
               if (ids.indexOf(emailResp[keys[1]]['partner_id']) < 0) {
                  ids[index] = emailResp[keys[1]]['partner_id'];
		  emailIds[index] = emailResp[keys[1]]['name'];
               }
               else {
                  // remove this email address because it's a duplicate
                  emailAddresses.splice(index,1);
                  names.splice(index,1);
                  ids.splice(index,1);
		  emailIds.splice(index,1);
                  addresses.splice(index,1);
                  phoneNumbers.splice(index,1);
                  allEmailAddresses.splice(index,1);
                  websites.splice(index,1);
                  engagementTracks.splice(index,1);
                  recentActivity.splice(index,1);
		  profilePhotos.splice(index,1);
                  todos.splice(index,1);
                  notes.splice(index,1);
                  autorecord.splice(index,1);
                  collaborators.splice(index,1);
                  documents.splice(index,1);
                  tags.splice(index,1);
                  data.splice(index,1);
                  dataGroups.splice(index,1);
                  gifts.splice(index,1);
                  funds.splice(index,1);
                  types.splice(index,1);
                  numExtra--;
               }
               
               // add the other partners we found with this email
               for (var i=2;i<keys.length;i++) {
                  // if the partner found isn't already in the list, add them and increment numExtra
                  if (arrayContains(ids, emailResp[keys[i]]['partner_id'], 0) < 0) {
                     emailAddresses.splice(index+1,0,emailAddress);
                     names.splice(index+1,0,"");
                     ids.splice(index+1,0,emailResp[keys[i]]['partner_id']);
		     emailIds.splice(index+1,0,emailResp[keys[i]]['name']);
                     addresses.splice(index+1,0,[]);
                     phoneNumbers.splice(index+1,0,[]);
                     allEmailAddresses.splice(index+1,0,[]);
                     websites.splice(index+1,0,[]);
                     engagementTracks.splice(index+1,0,[]);
                     recentActivity.splice(index+1,0,[]);
		     profilePhotos.splice(index+1,0,[]);
                     todos.splice(index+1,0,[]);
                     notes.splice(index+1,0,[]);
                     autorecord.splice(index+1,0,[]);
                     collaborators.splice(index+1,0,[]);
                     documents.splice(index+1,0,[]);
                     tags.splice(index+1,0,[]);
                     data.splice(index+1,0,[]);
                     dataGroups.splice(index+1,0,[]);
                     gifts.splice(index+1,0,[]);
                     funds.splice(index+1,0,[]);
                     types.splice(index+1,0,[]);
                     numExtra++;
                  }
               }
               
               
               // if we aren't at the end of the list of email addresses, find partners for the next address
               if (index+1+numExtra < emailAddresses.length) {
                  findUser(index+1+numExtra);
               }
               else {
		  kardiacrm.partners_loaded = true;

                  // add little Kardia icon in email
                  addKardiaButton(mainWindow);

		  // And newly opened message window
		  if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
			kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
		  }
               
                  // start getting the other information about all the partners we found
                  getOtherInfo(0, true);
               }
            }
            else if (emailRequest.readyState == 4) {
               // we didn't get the 200 success status, so no partners were found with this email; remove the partner and reload the Kardia pane
               emailAddresses.splice(index,1);
               names.splice(index,1);
               ids.splice(index,1);
	       emailIds.splice(index,1);
               addresses.splice(index,1);
               phoneNumbers.splice(index,1);
               allEmailAddresses.splice(index,1);
               websites.splice(index,1);
               engagementTracks.splice(index,1);
               recentActivity.splice(index,1);
	       profilePhotos.splice(index,1);
               todos.splice(index,1);
               notes.splice(index,1);
               autorecord.splice(index,1);
               collaborators.splice(index,1);
               documents.splice(index,1);		
               tags.splice(index,1);	
               data.splice(index,1);	
               dataGroups.splice(index,1);
               gifts.splice(index,1);	
               funds.splice(index,1);	
               types.splice(index,1);	
               
               // if we aren't at the end of the list of email addresses, find partners for the next address
               if (index < emailAddresses.length) {
                  findUser(index);
               }
               else {
		  kardiacrm.partners_loaded = true;

                  // start getting the other information about all the partners we found
                  if (emailAddresses.length > 0) {
                     // add little Kardia icon in email
                     addKardiaButton(mainWindow);
                     
		     // And newly opened message window
		     if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
			   kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
		     }
               
                     getOtherInfo(0, true);
                  }
                  else {
		     // No email addresses to look up.
		     kardiacrm.partner_data_loaded = true;
		     if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
			kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
		     }
		     kardiacrm.find_emails_busy = false;
                     reload(false);
                  }
               }
            }
         };
         
         // on error...
         emailRequest.onerror = function() {
		kardiacrm.partners_loaded = true;
		kardiacrm.partner_data_loaded = true;
		if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
			kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
		}
		kardiacrm.find_emails_busy = false;
	 };
         
         // send the HTTP request
         emailRequest.open("GET", emailUrl, true, kardiacrm.username, kardiacrm.password);
         emailRequest.send(null);
      }
}

// get all other info about the partner whose information is stored at position index
function getOtherInfo(start, isDefault) {	
	// variable to store whether user is valid
	var validUser = true;

	// This completion func is called once all queued and in-progress REST
	// requests have completed.  It is NOT called for each REST request
	// completion, just once when the queue is going idle.
	//
	var complete = function() {
		kardiacrm.partner_data_loaded = true;
		if (kardiacrm.lastMessageWindow && kardiacrm.lastMessageWindow.messageWindow && kardiacrm.lastMessageWindow.messageWindow.reEvaluate) {
			kardiacrm.lastMessageWindow.messageWindow.reEvaluate(null);
		}
		kardiacrm.find_emails_busy = false;
		reload(isDefault);
	}

	// Loop through the partners
	for(var idx=start; idx<mainWindow.emailAddresses.length; idx++) {
		let index = idx;
		// get partner name
		kardiacrm.requestGet("partner/Partners/" + mainWindow.ids[index] + "?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic&cx__res_levels=3", "mlist", complete, function (nameResp) {
			// If not 404
			if (nameResp != null && nameResp['cx__element']) {
				// if the partner is not valid, make them blank/invalid
				if (nameResp['cx__element']['is_valid'] == 0 ) {
					validUser = false;
					mainWindow.emailAddresses[index] = "";
					mainWindow.ids[index] = "";
				}
		 
				// store partner's name
				mainWindow.names[index] = nameResp['cx__element']['partner_name'];
		 
				// get more information only if the partner is valid
				if (validUser) {
					var addressResp = jsoncoll(jsondir(nameResp, 'Addresses'));
					var phoneResp = jsoncoll(jsondir(nameResp, 'ContactInfo'));

					// If not 404
					if (addressResp != null) {
						// get the keys in the JSON file
						var keys = [];
						for(var k in addressResp) keys.push(k);
		     
						// the key "@id" doesn't correspond to an address, so use all other keys to store address information to temporary array
						var addressArray = new Array();
						for (var i=0;i<keys.length;i++) {
							if (keys[i] != "@id") {
								var oneaddr = addressResp[keys[i]]['cx__element'];
								if (oneaddr['is_valid'] != 0) {
									if (oneaddr['country_name'] != null) {
										addressArray.push(oneaddr['location_type_code'] + ": " + oneaddr['address'] + "\n" + oneaddr['country_name']);
									}
									else {
										addressArray.push(oneaddr['location_type_code'] + ": " + oneaddr['address']);
									}
									addressArray.push(oneaddr['location_id']);
								}
							}
						}
						// store temporary array to permanent array
						mainWindow.addresses[index] = addressArray;
					}
		  
					// If not 404
					if (phoneResp != null) {
						// get all the keys from the JSON file
						var keys = [];
						for(var k in phoneResp) keys.push(k);
			
						// the key "@id" doesn't correspond to a contact, so use all other keys to add contact info to temporary arrays
						var phoneArray = new Array();
						var emailArray = new Array();
						var websiteArray = new Array();
						for (var i=0;i<keys.length;i++) {
							if (keys[i] != "@id") {
								var contact = phoneResp[keys[i]]['cx__element'];
								if (contact['is_valid'] != 0) {
									if (contact['contact_type_code'] == "E") {
										emailArray.push("E: " + contact['contact']);
										emailArray.push(contact['contact_id']);
									}
									else if (contact['contact_type_code'] == "W" || contact['contact_type_code'] == "B") {
										websiteArray.push(contact['contact_type_code'] + ": " + contact['contact']);
										websiteArray.push(contact['contact_id']);
									}
									else {
										phoneArray.push(contact['contact_type_code'] + ": " + contact['contact']);
										phoneArray.push(contact['contact_id']);
									}
								}
							}
						}
						// store temporary arrays to permanent arrays
						mainWindow.phoneNumbers[index] = phoneArray;
						mainWindow.allEmailAddresses[index] = emailArray;
						mainWindow.websites[index] = websiteArray;
					}
				
					// get engagement tracks information
					kardiacrm.requestGet("crm/Partners/" + mainWindow.ids[index] + "?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic&cx__res_levels=3", "mlist", complete, function(Resp) {
						var trackResp = jsoncoll(jsondir(Resp, 'Tracks'));
						var documentResp = jsoncoll(jsondir(Resp, 'Documents'));
						var noteResp = jsoncoll(jsondir(Resp, 'ContactHistory'));
						var arResp = jsoncoll(jsondir(Resp, 'ContactAutorecord'));
						var collaboratorResp = jsoncoll(jsondir(Resp, 'Collaborators'));
						var todosResp = jsoncoll(jsondir(Resp, 'Todos'));
						var tagResp = jsoncoll(jsondir(Resp, 'Tags'));
						var dataResp = jsoncoll(jsondir(Resp, 'DataItems'));
						var activityResp = jsoncoll(jsondir(Resp, 'Activity'));
						var photoResp = jsonel(jsondir(Resp, 'ProfilePicture'))

						// If not 404
						if (trackResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in trackResp) keys.push(k);
				      
							// the key "@id" doesn't correspond to a document, so use all other keys to add track info to temporary array
							var trackArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									// add only if this track is current (not completed/exited)
									var track = trackResp[keys[i]]['cx__element'];
									if (track['completion_status'].toLowerCase() == "i") {
										trackArray.push(track['engagement_track']);
										trackArray.push(track['engagement_step']);
										trackArray.push(track['name']);
									}
								}
							}
							// store temporary array to permanent array
							mainWindow.engagementTracks[index] = trackArray;
						}

						// If not 404
						if (documentResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in documentResp) keys.push(k);

							// the key "@id" doesn't correspond to a document, so use all other keys to add document info to temporary array
							var documentArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									// TODO where is "location" -- in apps/kardia, or in the server's home directory?  We leave it as server's home directory for now
									var doc = documentResp[keys[i]]['cx__element'];
									documentArray.push(server + doc['location']);
									documentArray.push(doc['title']);
								}
							}
							// store temporary array to permanent array
							mainWindow.documents[index] = documentArray;
						}

						// Notes and contact history items for this person
						if (noteResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in noteResp) keys.push(k);

							// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
							var noteArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									var note = clone_obj(noteResp[keys[i]]['cx__element']);
									note.text = note.subject + " - " + note.notes;
									note.date = datetimeToString(note.date_modified);
									noteArray.push(note);
									/*noteArray.push(note['contact_history_id']);*/
								}
							}
							// store temporary array to permanent array
							mainWindow.notes[index] = noteArray;
						}

						// Contact Autorecord data
						if (arResp != null) {
							var arArray = [];
							for (var k in arResp) {
								// the key "@id" is for the URL for the collection, rather than for element data.
								if (k != "@id") {
									arArray.push(clone_obj(arResp[k]['cx__element']));
								}
							}
							mainWindow.autorecord[index] = arArray;
						}

						// Collaborators working with this person
						if (collaboratorResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in collaboratorResp) keys.push(k);

							// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
							var collaboratorArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									var collab = collaboratorResp[keys[i]]['cx__element'];
									collaboratorArray.push(collab['collaborator_is_individual']);
									collaboratorArray.push(collab['collaborator_id']);
									collaboratorArray.push(collab['collaborator_name']);
								}
							}
							// store temporary array to permanent array
							mainWindow.collaborators[index] = collaboratorArray;
						}

						// If not 404
						if (todosResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in todosResp) keys.push(k);

							// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
							var todosArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									var todo = todosResp[keys[i]]['cx__element'];
									if (todo['status_code'].toLowerCase() == 'i') {
										todosArray.push(todo['todo_id']);
										todosArray.push(todo['desc']);
									}
								}
							}
							// store temporary array to permanent array
							mainWindow.todos[index] = todosArray;
						}

						// If not 404
						if (tagResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in tagResp) keys.push(k);

							// save tag info
							var tempArray = new Array();
							for (var i=0; i<keys.length; i++) {
								if (keys[i] != "@id") {
									var tag = tagResp[keys[i]]['cx__element'];
									// see where we should insert it in the list
									var insertHere = tempArray.length;
									for (var j=0;j<tempArray.length;j+=3) {
										if (parseFloat(tag['tag_strength']) >= parseFloat(tempArray[j+1])) {
											// insert tag before
											insertHere = j;
											break;
										}
									}
									tempArray.splice(insertHere, 0, tag['tag_label'], tag['tag_strength'], tag['tag_certainty']);
								}
							}
							mainWindow.tags[index] = tempArray;
						}

						// If not 404
						if (dataResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in dataResp) keys.push(k);

							mainWindow.dataGroups[index] = new Array();
							// save data items
							var tempArray = new Array();
							for (var i=0; i<keys.length; i++) {
								if (keys[i] != "@id") {
									var data = dataResp[keys[i]]['cx__element'];
									tempArray.push(data['item_type_label'] + ": " + data['item_value']);
									tempArray.push(data['item_highlight']);
									tempArray.push(data['item_group_id']);

									// store data group if it doesn't already exist
									if (mainWindow.dataGroups[index].indexOf(data['item_group_id']) < 0) {
										mainWindow.dataGroups[index].push(data['item_group_id']);
										mainWindow.dataGroups[index].push(data['item_group_name']);
									}
								}
							}
							mainWindow.data[index] = tempArray;
						}

						// If not 404
						if (activityResp != null) {
							// get all the keys from the JSON file
							var keys = [];

							for(var k in activityResp) keys.push(k);

							// save recent activity
							var tempArray = new Array();

							for (var i=0; (i<keys.length && tempArray.length<6); i++) {
								if (keys[i] != "@id") {
									var activity = activityResp[keys[i]]['cx__element'];
									tempArray.push(activity);
								}
							}
							mainWindow.recentActivity[index] = tempArray;
						}

						// store profile pic result for later
						mainWindow.profilePhotos[index] = photoResp;
					});
									  
					// check donor status
					kardiacrm.requestGet("donor/" + mainWindow.ids[index] + "/?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic&cx__res_levels=3", "mlist", complete, function(Resp) {
						if (Resp != null) {
							var giftResp = jsoncoll(jsondir(Resp, 'Gifts'));
							var fundResp = jsoncoll(jsondir(Resp, 'Funds'));

							// If not 404
							if (giftResp != null) {
								// get all the keys from the JSON file
								var keys = [];
								for(var k in giftResp) keys.push(k);

								// save gifts
								var tempArray = new Array();
								mainWindow.types[index] = new Array();
								for (var i=0; i<keys.length; i++) {
									if (keys[i] != "@id") {
										var gift = giftResp[keys[i]]['cx__element'];
										if (gift['gift_date'] != null) {
											tempArray.push(gift['gift_date']['month'] + "/" + gift['gift_date']['day'] + "/" + gift['gift_date']['year']);
										}
										else {
											tempArray.push("n/a");
										}
										tempArray.push(formatGift(gift['gift_amount']['wholepart'], gift['gift_amount']['fractionpart']));
										tempArray.push(gift['gift_fund_desc']);
											  
										// if check, display check number
										if (gift['gift_type'] != null && gift['gift_type'].toLowerCase() == 'check' && gift['gift_check_num'] != null && gift['gift_check_num'].trim() != "") {
											tempArray.push(gift['gift_type'] + " (#" + gift['gift_check_num'] + ")");
										}
										else {
											tempArray.push(gift['gift_type']);
										}
										// save gift type to types array
										if (mainWindow.types[index].indexOf(gift['gift_type']) < 0) {
											mainWindow.types[index].push(gift['gift_type']);
											mainWindow.giftFilterTypes.push(false);
										}
									}
								}
								mainWindow.gifts[index] = tempArray;
							}

							// If not 404
							if (fundResp != null) {
								// get all the keys from the JSON file
								var keys = [];
								for(var k in fundResp) keys.push(k);

								// reset gift filter list
								giftFilterFunds = new Array();
								giftFilterTypes = new Array();
							  
								// save funds
								var tempArray = new Array();
								for (var i=0; i<keys.length; i++) {
									if (keys[i] != "@id") {
										var fund = fundResp[keys[i]]['cx__element'];
										tempArray.push(fund['fund_desc']);
										mainWindow.giftFilterFunds.push(false);
									}
								}
								mainWindow.funds[index] = tempArray;
							}
						}
						else {
							// not a donor, so add blank info
							mainWindow.gifts[index] = new Array();
							mainWindow.types[index] = new Array();
							mainWindow.funds[index] = new Array();
						}
					});
				}
			}
		});
	}
}

// get info for one person you're collaborating with
function getCollaborateeInfo() {

	// This is called when all "collaboratees" have been loaded.
	var complete = function() {
		// sort and reload Collaborating With panel
		if (kardiaTab != null) {
			kardiaTab.sortCollaboratees(false);
			kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.png";
		}
		mainWindow.kardiacrm.refreshing = false;
		
		// reload the Kardia pane so it's blank at first
		reload(false);
	};

	for(idx=0; idx<mainWindow.collaborateeIds.length; idx++) {
		let index = idx;

		// get the person's engagement tracks and other CRM data
		kardiacrm.requestGet("crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tracks?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic", "ktab", complete, function(trackResp) {
			// If not 404
			if (trackResp != null) {
				trackResp = trackResp['cx__collection'];
				/*var trackResp = jsoncoll(jsondir(Resp, 'Tracks'));
				var documentResp = jsoncoll(jsondir(Resp, 'Documents'));
				var noteResp = jsoncoll(jsondir(Resp, 'ContactHistory'));
				var collaboratorResp = jsoncoll(jsondir(Resp, 'Collaborators'));
				var todosResp = jsoncoll(jsondir(Resp, 'Todos'));
				var tagResp = jsoncoll(jsondir(Resp, 'Tags'));
				var dataResp = jsoncoll(jsondir(Resp, 'DataItems'));
				var activityResp = jsoncoll(jsondir(Resp, 'Activity'));
				var photoResp = jsonel(jsondir(Resp, 'ProfilePicture'));*/
		
				if (trackResp) {
					// get all the keys from the JSON file
					var keys = [];
					for(var k in trackResp) keys.push(k);

					// save track info
					var tempArray = new Array();
					for (var i=0;i<keys.length; i++) {
						if (keys[i] != "@id") {
							var track = trackResp[keys[i]]; //['cx__element'];
							if (track['completion_status'].toLowerCase() == "i") {
								tempArray.push(track['engagement_track']);
								tempArray.push(track['engagement_step']);
							}
						}
					}
					mainWindow.collaborateeTracks[index] = tempArray;
				}
			}
		});

		kardiacrm.requestGet("crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tags?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic", "ktab", complete, function(tagResp) {
			// If not 404
			if (tagResp != null) {
				tagResp = tagResp['cx__collection'];
				if (tagResp != null) {
					// get all the keys from the JSON file
					var keys = [];
					for(var k in tagResp) keys.push(k);

					// save tag info
					var tempArray = new Array();
					for (var i=0; i<keys.length; i++) {
						if (keys[i] != "@id") {
							// see where we should insert it in the list
							var insertHere = tempArray.length;
							var tag = tagResp[keys[i]]; //['cx__element'];
							for (var j=0;j<tempArray.length;j+=3) {
								if (parseFloat(tag['tag_strength']) >= parseFloat(tempArray[j+1])) {
									// insert tag before
									insertHere = j;
									break;
								}
							}
							tempArray.splice(insertHere, 0, tag['tag_label'], tag['tag_strength'], tag['tag_certainty']);
						}
					}
					mainWindow.collaborateeTags[index] = tempArray;
				}
			}
		});

		mainWindow.collaborateeActivity[index] = [];
		mainWindow.collaborateeData[index] = [];
               
				/*if (dataResp != null) {
					// get all the keys from the JSON file
					var keys = [];
					for(var k in dataResp) keys.push(k);

					// save data items
					var tempArray = new Array();
					for (var i=0; i<keys.length; i++) {
						if (keys[i] != "@id") {
							var data = dataResp[keys[i]]['cx__element'];
							tempArray.push(data['item_type_label'] + ": " + data['item_value']);
							tempArray.push(data['item_highlight']);
							tempArray.push(data['item_group_id']);
						}
					}
					mainWindow.collaborateeData[index] = tempArray;
				}
                  
				if (activityResp != null) {
					var TempResp = activityResp;
					// get all the keys from the JSON file
					var keys = [];
					for(var k in TempResp) keys.push(k);

					// save activity
					var tempArray = new Array();
					for (var i=0; (i<keys.length && tempArray.length<6); i++) {
						if (keys[i] != "@id") {
							var act = TempResp[keys[i]]['cx__element'];
							tempArray.push(act['activity_type']);
							tempArray.push(datetimeToString(act['activity_date']) + ": " + act['info']);
							tempArray.push(act['activity_date']);
						}
					}
					mainWindow.collaborateeActivity[index] = tempArray;
				}*/
                                       
				mainWindow.collaborateeGifts[index] = [];
				mainWindow.collaborateeFunds[index] = [];
				kardiacrm.requestGet("donor/" + mainWindow.collaborateeIds[index] + "/?cx__mode=rest&cx__res_type=both&cx__res_format=attrs&cx__res_attrs=basic&cx__res_levels=3", "ktab", complete, function(Resp) {
					// is the partner a donor?
					if (Resp) {
						var giftResp = jsoncoll(jsondir(Resp, 'Gifts'));
						var fundResp = jsoncoll(jsondir(Resp, 'Funds'));

						if (giftResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in giftResp) keys.push(k);

							// save gifts
							var tempArray = new Array();
							for (var i=0; i<keys.length; i++) {
								if (keys[i] != "@id") {
									var gift = giftResp[keys[i]]['cx__element'];
									if (gift['gift_date'] != null) {
										tempArray.push(gift['gift_date']['month'] + "/" + gift['gift_date']['day'] + "/" + gift['gift_date']['year']);
									}
									else {
										tempArray.push("n/a");
									}
									tempArray.push(formatGift(gift['gift_amount']['wholepart'], gift['gift_amount']['fractionpart']));
									tempArray.push(gift['gift_fund_desc']);
                                             
									// if check, display check number
									if (gift['gift_type'] != null && gift['gift_type'].toLowerCase() == 'check' && gift['gift_check_num'] != null && gift['gift_check_num'].trim() != "") {
										tempArray.push(gift['gift_type'] + " (#" + gift['gift_check_num'] + ")");
									}
									else {
										tempArray.push(gift['gift_type']);
									}
								}
							}
							mainWindow.collaborateeGifts[index] = tempArray;
						}
                                    
						if (fundResp != null) {
							// get all the keys from the JSON file
							var keys = [];
							for(var k in fundResp) keys.push(k);
                                             
							var tempArray = new Array();
							for (var i=0; i<keys.length; i++) {
								if (keys[i] != "@id") {
									var fund = fundResp[keys[i]]['cx__element'];
									tempArray.push(fund['fund_desc']);
								}
							}
							mainWindow.collaborateeFunds[index] = tempArray;
						}
					}

					// Show partial results as the people come in.
					//kardiaTab.sortSomeCollaboratees(index);
				});
			/*}
		});*/
	}
}
                                                                  

// delete the todo with the given id
function deleteTodo(todoId) {
	// delete from Kardia		
	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}'
	
	doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Todos/' + todoId, '{"status_code":"c","completion_date":' + dateString + ',"req_item_completed_by":"' + kardiacrm.username + '"}', false, "", "");
	document.getElementById("to-do-item-" + todoId).style.display="none";
	
	var listener = {
        onOperationComplete: function(aCalendar, aStatus, aOperationType, aId, aDetail)
        { },
        onGetResult: function(aCalendar, aStatus, aItemType, aDetail, aCount, aItems)
        {
            if (!Components.isSuccessCode(aStatus)) {
				return;
			}
			for (var i=0; i<aCount; i++) {
				// delete item if id is the same as the id we asked for
				if (aItems[i].id == todoId) {
					// delete from Lightning
					myCal.deleteItem(aItems[i], null);
					return;
				}
			}
  		}
   };

	myCal.getItems(Components.interfaces.calICalendar.ITEM_FILTER_ALL_ITEMS,0,null,null,listener);
}

// FEATURE: this is where adding new to-do items should go
/*
function newTodo() {
	var text = "demo";
	
	// create new todo
	var todo = Components.classes["@mozilla.org/calendar/todo;1"].createInstance(Components.interfaces.calITodo);	
	todo.title = text;

	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

	// post the new todo
	// TODO add todo types, collaborator, engagement id
	doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Todos','{"e_todo_partner":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_todo_desc":"' + text + '","e_todo_collaborator":"' + '100002' + '","e_todo_type_id":0,"s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function() {

		doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
			// get all the keys from the JSON file
			var keys = [];
			for(var k in todoResp) keys.push(k);
			
			// the key "@id" doesn't correspond to a todo, so use all other keys to find newest item
			var trackIndex = 0;
			for (var i=0;i<keys.length;i++) {
				if (todoResp[keys[i]]['date_created'] != null) {
					var todoDate = new Date(todoResp[keys[i]]['date_created']['year'],(todoResp[keys[i]]['date_created']['month']-1),todoResp[keys[i]]['date_created']['day'],todoResp[keys[i]]['date_created']['hour'],todoResp[keys[i]]['date_created']['minute'],todoResp[keys[i]]['date_created']['second']);
					
					// is this the todo we're looking for?
					if (keys[i] != "@id" && todoDate.toString() == date.toString()) {
						todo.id = todoResp[keys[i]]['todo_id'];
	
						todo.dueDate = null;
						todo.calendar = myCal;
						createTodoWithDialog(myCal, null, text, todo);
						// TODO get due date of todo
						
						// add to todos array
						mainWindow.todos[kardiacrm.selected_partner].push(todo.id);
						mainWindow.todos[kardiacrm.selected_partner].push(mainWindow.names[kardiacrm.selected_partner] + '- ' + text);
						
						// add to all todos
						mainWindow.allTodos[kardiacrm.selected_partner].push(todo.id);
						mainWindow.allTodos[kardiacrm.selected_partner].push(mainWindow.names[kardiacrm.selected_partner] + '- ' + text);
						mainWindow.allTodos[kardiacrm.selected_partner].push(todo.dueDate); 
					
						// add recent activity and reload
						reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
					  
					  	//reload to display
						reload(false);
						break;
					}
				}
			}	
		}, false, "", "");
	});
}*/


// FEATURE: importing to-do items into the Lightning calendar should go here
// import todos into Lightning calendar
/*function importTodos() {
	// reload calendar
	var calendarManager = Components.classes["@mozilla.org/calendar/manager;1"].getService(Components.interfaces.calICalendarManager);

	// see if Kardia calendar exists; if so, we want to use it
	var cals = calendarManager.getCalendars({});
	for (var i=0;i<calendarManager.calendarCount;i++) {
		if (cals[i].name == "Kardia") {
			// store it to myCal
			myCal = cals[i];
			break;
		}
	}
	if (myCal == null) {
		// create a new calendar if the Kardia one didn't exist
		var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
		var preUri = ioService.newURI("chrome://kardia/content/kardia-calendar.ics", null, null);
		var uri = Components.classes["@mozilla.org/chrome/chrome-registry;1"].getService(Components.interfaces.nsIChromeRegistry).convertChromeURL(preUri);
		myCal = calendarManager.createCalendar("storage",uri);
		calendarManager.registerCalendar(myCal);
		myCal.name = "Kardia";
	}
			
	myCal.removeObserver(kardiaCalObserver);
	
	// check import preferences
	var addToEvents = (prefs.getCharPref("importTodoAsEvent")=="e");
	var addTodosWithNoDate = prefs.getBoolPref("showTodosWithNoDate");
	
	// keep track of which todos were added
	var item;
	var todoAdded = new Array();
	for (var i=0;i<allTodos.length;i++) {
		todoAdded.push(false);
	}
			
	var listener = {
        onOperationComplete: function(aCalendar, aStatus, aOperationType, aId, aDetail)
        {
			// after it's done, add todos that weren't added
			for (var i=0;i<allTodos.length;i+=3) {
				// if the todo wasn't added, create it
				if (!todoAdded[i]) {					
					// if user wants to import as events, create event; else, create todo
					if (addToEvents) {
						item = (cal.createEvent());
					}
					else {
						item = (cal.createTodo());
					}
					// set item properties
					item.id = allTodos[i];
					item.title = allTodos[i+1];
					item.setProperty("DESCRIPTION", "");
					item.clearAlarms();
			
					// create date
					var date = Components.classes["@mozilla.org/calendar/datetime;1"].createInstance(Components.interfaces.calIDateTime);
					// if the todo doesn't have a due date...
					if (allTodos[i+2] == "") {
						// import it if user wants us to (just use today's date)
						if (addTodosWithNoDate) {
							date.icalString = toIcalString(new Date());
						}
						else {
							// don't add this item
							continue;
						}
					}
					else {
						// we have a due date, so use it
						date.icalString = allTodos[i+2];
					}
					
					// set date
					if (addToEvents) {
						item.startDate = date;
						item.endDate = item.startDate.clone();
						item.removeAllAttendees();
					}
					else if (allTodos[i+2] != "") {
						// only add due date to todo items if they have due dates
						item.dueDate = date;
					}

					item.calendar = myCal;
					item.makeImmutable();
					
					// add item to calendar
					myCal.addItem(item, null);
				}
			}
			myCal.addObserver(kardiaCalObserver);
        },
        onGetResult: function(aCalendar, aStatus, aItemType, aDetail, aCount, aItems)
        {		
			// check each calendar item to see if it's one of our todos
			for (var i=0; i<aCount; i++) {
				var j;
				var deleted = false;
				for (j=0;j<allTodos.length;j+=3) {
					// if item exists, just update it
					if (aItems[i].id == allTodos[j]) {
						// update properties
						item = aItems[i].clone();
						todoAdded[j] = true;
						todoAdded[j+1] = true;
						todoAdded[j+2] = true;
						item.id = allTodos[j];
						item.title = allTodos[j+1];
						item.setProperty("DESCRIPTION", "");
						item.clearAlarms();
		
						// update date
						var date = Components.classes["@mozilla.org/calendar/datetime;1"].createInstance(Components.interfaces.calIDateTime);
						if (allTodos[j+2] == "") {
							if (addTodosWithNoDate) {
								date.icalString = toIcalString(new Date());
							}
							else {
								continue;
							}
						}
						else {
							date.icalString = allTodos[j+2];
						}	
						if (addToEvents) {
							item.startDate = date;
							item.endDate = item.startDate.clone();
							item.removeAllAttendees();
						}
						else if (allTodos[j+2] != "") {
							item.dueDate = date;
						}
						// finish updating item
						item.calendar = myCal;
						item.makeImmutable();
						myCal.modifyItem(item, aItems[i], null);
						
						// we took care of this item
						deleted = true;
						break;
					}
				}
				// if we didn't modify the item, delete it
				if (!deleted) {
					myCal.deleteItem(aItems[i], null);
				}
			}			
        }
    };
	
	var deleteListener = {
        onOperationComplete: function(aCalendar, aStatus, aOperationType, aId, aDetail)
        {
			// add/update events
			if (addToEvents) {
				myCal.getItems(myCal.ITEM_FILTER_TYPE_EVENT,0,null,null,listener);
			}
			else {
				myCal.getItems(myCal.ITEM_FILTER_TYPE_TODO | myCal.ITEM_FILTER_COMPLETED_ALL,0,null,null,listener);
			}
        },
        onGetResult: function(aCalendar, aStatus, aItemType, aDetail, aCount, aItems)
        {		
			// delete all items of the other type
			for (var i=0; i<aCount; i++) {
				myCal.deleteItem(aItems[i], null);
			}	
        }
    };
	
	// if adding to events, delete all todos
	if (addToEvents) {
		myCal.getItems(myCal.ITEM_FILTER_TYPE_TODO | myCal.ITEM_FILTER_COMPLETED_ALL,0,null,null,deleteListener);
	}
	else {
		// delete events
		myCal.getItems(myCal.ITEM_FILTER_TYPE_EVENT,0,null,null,deleteListener);
	}
}*/

// format todo due date for calendar use
function getTodoDueDate(dateArray, addDays) {
	// return nothing if date info isn't valid
	if (dateArray == null || addDays == null) {
		return "";
	}
	else {
		// format due date
		var date = new Date(dateArray["year"], dateArray["month"]-1, dateArray["day"]+addDays, dateArray["hour"], dateArray["minute"], dateArray["second"]);
		var dateString = date.toISOString();
		dateString = dateString.replace(/-/g, "").replace(/:/g, "");
		dateString = dateString.substring(0,dateString.length-5) + "Z";
		return dateString;
	}
}

// show collaborator based on their partner ID
function addCollaborator(collaboratorId) {
   // Don't process if we're already loading something
   if (!kardiaTab.processingClick) {
      if (kardiaTab != null) {
         kardiaTab.processingClick = true;
      }
      // Set loading state untill finished loading partner
      mainWindow.document.getElementById('loading-gif-container').style.visibility = "visible";
      mainWindow.document.getElementById('main-content-box').style.visibility = "hidden";
      mainWindow.document.getElementById('name-label').value = "Loading...";
      mainWindow.document.getElementById('id-label').value = "";

      // if the partner isn't already in the list, add them
      if (arrayContains(mainWindow.ids, collaboratorId, 0) < 0) {
         mainWindow.emailAddresses.push("");
         mainWindow.names.push("");
         mainWindow.ids.push(collaboratorId);
	 mainWindow.emailIds.push("");
         mainWindow.addresses.push([]);
         mainWindow.phoneNumbers.push([]);
         mainWindow.allEmailAddresses.push([]);
         mainWindow.websites.push([]);
         mainWindow.engagementTracks.push([]);
         mainWindow.recentActivity.push([]);
	 mainWindow.profilePhotos.push([]);
         mainWindow.todos.push([]);
         mainWindow.notes.push([]);
         mainWindow.autorecord.push([]);
         mainWindow.collaborators.push([]);
         mainWindow.documents.push([]);
         mainWindow.tags.push([]);
         mainWindow.data.push([]);
         mainWindow.dataGroups.push([]);
         mainWindow.gifts.push([]);
         mainWindow.funds.push([]);
         mainWindow.types.push([]);
         kardiacrm.selected_partner = mainWindow.ids.length-1;
         // get information about them from Kardia
         getOtherInfo(mainWindow.ids.length-1, false);
      }
      else {
         // the collaborator is already in the available partner list, so just select them
         kardiacrm.selected_partner = arrayContains(mainWindow.ids, collaboratorId, 0);
         reload(false);
      }
   } else {
   }
}

// make Date into ical string  
function toIcalString(date) {
	var dateString = date.toISOString();
	dateString = dateString.replace(/-/g, "").replace(/:/g, "");
	dateString = dateString.substring(0,dateString.length-5) + "Z";
	return dateString;
}

// if an array contains a given value more than numAllowed times, return the last location of the item; otherwise, return -1
function arrayContains(array, value, numAllowed) {
	var numTimes = 0;
	var location = -1;
	for (var i=0;i<array.length;i++) {
		if (array[i] == value) {
			numTimes++;
			location = i;
		}
	}
	if (numTimes > numAllowed) {
		return location;
	}
	return -1;
}

// get Thunderbird user's Kardia login information
function getLogin(prevSaved, prevFail, doAfter) {
	var username = "";
	var password = "";
	server = prefs.getCharPref("server");
	
	// attempt to log in using username/password saved by Login Manager
	// get Login Manager 
	var myLoginManager = Components.classes["@mozilla.org/login-manager;1"].getService(Components.interfaces.nsILoginManager);
	// find the Kardia login
	var logins = myLoginManager.findLogins({}, "chrome://kardia", null, "Kardia Login");
	if (logins.length >= 1) {
		username = logins[0].username;
		password = logins[0].password;
		
		// if the username isn't blank, test whether it works for Kardia login
		if (username != "") {
			// make sure we can log into Kardia
			var loginRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
			var loginResp;
			var loginUrl = server;
			
			loginRequest.onreadystatechange = function(aEvent) {
				// if the HTTP request is done
				if(loginRequest.readyState == 4) {
					// if we got success status, the login is valid and we're done
					if (loginRequest.status == 200) {
						kardiacrm.logged_in = true;
						if (kardiaTab != null) {
							kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
							kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
						}
						document.getElementById("cant-connect").style.display="none";
						doAfter([username, password]);
						return [username, password];
					}
					else {
						// we didn't get success status, so ask for login again
						myLoginManager.removeLogin(logins[0]);
						getLogin(true, true, doAfter);
					}
				}
			};
			
			// do nothing if the login request errors
			loginRequest.onerror = function() {
				// we didn't get success status, so ask for login again
				myLoginManager.removeLogin(logins[0]);
				getLogin(true, true, doAfter);
			};
			
			// send the login HTTP request
			loginRequest.open("GET", loginUrl, true, username, password);
			loginRequest.send(null);
		}
	}
	
	// ask for login info if it's not stored in Login Manager
	if ((username == "" && password == "") || server == "" || server == null) {
		// open the login dialog
		var returnValues = {username:username, password:password, cancel:false, prevSaved:prevSaved, prevFail:prevFail, save:false, server:server};
		kardiacrm.dialog = openDialog("chrome://kardia/content/login-dialog.xul", "Login to Kardia", "resizable=yes,chrome,centerscreen=yes,top=0,width=600,height=240,alwaysRaised", returnValues, function(returnValues) {
		
			// get the username and password from the dialog's return values
			username = returnValues.username;
			password = returnValues.password;
			server = returnValues.server;
			if (server.substring(0,4) != "http") {
				server = "http://" + server;
			}
			// if the user didn't cancel the dialog box, test the login
			if (!returnValues.cancel && username.trim() != '') {
				// try logging in to Kardia using a HTTP request
				var loginRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
				var loginResp;
				
				loginRequest.onreadystatechange = function(aEvent) {
					// if the HTTP request is done
					if(loginRequest.readyState == 4) {
						// if we got success status, the login is valid and we're done
						if (loginRequest.status == 200) {
							kardiacrm.logged_in = true;
							if (kardiaTab != null) {
								kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
								kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
							}
							if (document.getElementById("cant-connect")) {
								document.getElementById("cant-connect").style.display="none";
							}

							prefs.setCharPref("server",server);
							
							if (returnValues.save) {
								// save username/password
								var passwordManager = Components.classes["@mozilla.org/login-manager;1"].getService(
									Components.interfaces.nsILoginManager
								);
								var nsLoginInfo = new Components.Constructor(
									"@mozilla.org/login-manager/loginInfo;1",
									Components.interfaces.nsILoginInfo,
									"init"
								);
								var formLoginInfo = new nsLoginInfo(
									"chrome://kardia",
									null,
									"Kardia Login",
									username,
									password,
									"",
									""
								);
								passwordManager.addLogin(formLoginInfo);
							}
							
							doAfter([username, password]);
							return [username, password];
						}
						else {
							// we didn't get success status, so ask the user to log in again (they can click cancel to stop this loop)
							getLogin(false, true, doAfter);
						}
					}
				};
				
				// do nothing if the login request errors
				loginRequest.onerror = function() {};
				
				// send the login HTTP request
				loginRequest.open("GET", server, true, username, password);
				loginRequest.send(null);
			}
			else if (!returnValues.cancel && username.trim() == '') {
				// blank username, so no need to even try logging in
				//ask the user to log in again (they can click cancel to stop this loop)
				getLogin(false, true, doAfter);
			}
			else {
				// the user cancelled the dialog box, so their login isn't valid and we should close the Kardia pane
				toggleKardiaVisibility(2);
			}
		});
	}
	
	// if we got to this point, the user didn't give a valid login, so return blanks (this keeps Kardia from asking excessively for login info)
	return ["", ""];
}

// opens the Kardia pane if it's currently closed and closes it if it's open
function toggleKardiaVisibility(fromWhat) {
	var closePane = false;

	if (fromWhat == 0 && document.getElementById("kardia-splitter").state == "open") {
		//splitter closed/opened the pane
		closePane = true;
	}	
	else if (fromWhat == 1 && !document.getElementById("main-box").collapsed) {
		// buttons closed/opened it
		closePane = true;
	}
	else if (fromWhat == 2) {
		// failure to log in closed it
		closePane = true;
		// failure message
		mainWindow.document.getElementById("cant-connect").style.display="block";
	}
	
	if (closePane) {
		//close
		mainWindow.document.getElementById("main-box").collapsed = true;
		mainWindow.document.getElementById("show-kardia-pane-button").checked = false;
		mainWindow.document.getElementById("kardia-splitter").state = "closed";
		mainWindow.document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
		mainWindow.document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
	}
	else {
		// open
		mainWindow.document.getElementById("main-box").collapsed = false;
		mainWindow.document.getElementById("show-kardia-pane-button").checked = true;
		mainWindow.document.getElementById("kardia-splitter").state = "open";
		mainWindow.document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"show-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
		mainWindow.document.getElementById("show-kardia-pane-button").style.backgroundColor = "#edf5fc";
	}
}

// opens/closes an info display section (like Engagement Tracks)
function toggleSectionDisplay(boxId) {
	// find out which section
	var boxNames = ["contact-info-box", "engagement-tracks-box", "recent-activity-box", "to-dos-box", "notes-prayer-box", "collaborator-box", "document-box", "profile-photo-box", "contact-info-box", "engagement-tracks-box", "recent-activity-box", "to-dos-box", "notes-prayer-box", "collaborator-box", "document-box", "profile-photo-box"];
		
	// open if currently closed, close if open
	if (document.getElementById(boxNames[boxId]).collapsed == true) {
		//open
		document.getElementById(boxNames[boxId]).collapsed = false;
	}
	else {
		//close
		document.getElementById(boxNames[boxId]).collapsed = true;
	}
}

// sets the current display to the chosen partner
function choosePartner(whichPartner) {
	kardiacrm.selected_partner = whichPartner;
	reload(false);
}

function checkShowKardiaTab() {
	if (kardiacrm.logged_in) {
		showKardiaTab();
	} else {
		doLogin(showKardiaTab);
	}
}

// Tumbler: Need to make this update tab after opens.
// shows Kardia tab-- select if it exists, open if it doesn't
function showKardiaTab() {
	// see if Kardia tab already exists
	var tabExists = false;
	for (var i=0;i<document.getElementById("tabmail").tabModes["contentTab"].tabs.length;i++) {
		if (document.getElementById("tabmail").tabModes["contentTab"].tabs[i].title == "Kardia") {
			tabExists = true;
			// switch to it, if it exists
			document.getElementById("tabmail").tabContainer.selectedIndex = document.getElementById("tabmail").tabInfo.indexOf(document.getElementById("tabmail").tabModes["contentTab"].tabs[i]);
			break;
		}
	}
	// if not, open it
	if (!tabExists) {
		document.getElementById("tabmail").openTab("contentTab", {title: "Kardia", contentPage: "chrome://kardia/content/kardia-tab.xul"});
	}
}

// allows user to edit contact information item
function editContactInfo(type, id) {
	// variable where we store our return values
	var returnValues = {type:type, locationId:"", info:"", setInactive:false};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/edit-contact-dialog.xul", "Edit Contact Info", "resizable,chrome, modal,centerscreen",returnValues,null,server,mainWindow.ids[kardiacrm.selected_partner],id,kardiacrm.data.countries);
	
	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
			  
	var status_code = "A";
	if (returnValues.setInactive) status_code = "O";
			  
	if (returnValues.type == "A" && kardiacrm.logged_in) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Addresses/' + mainWindow.ids[kardiacrm.selected_partner] + "|" + id + "|0",'{"location_type_code":"' + returnValues.locationId + '","address_1":"' + returnValues.info.address1 + '","address_2":"' + returnValues.info.address2 + '","address_3":"' + returnValues.info.address3 + '","city":"' + returnValues.info.city + '","state_province":"' + returnValues.info.state + '","country_code":"' + returnValues.info.country + '","postal_code":"' + returnValues.info.zip + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + kardiacrm.username + '"}', false, "", "", function(patchResp) { if (patchResp) {
			
			var addressLocation = mainWindow.addresses[kardiacrm.selected_partner].indexOf(parseInt(id));
			if (returnValues.setInactive) {
				// remove
				mainWindow.addresses[kardiacrm.selected_partner].splice(addressLocation-1,2);

				// add recent activity and reload
				//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
				
				//reload to display
				reload(false);
            if (kardiaTab != null) {
               kardiaTab.reloadFilters(false);
            }
			}
			else {
				// save
				doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
            // If not 404
            if (contactResp != null) {
                  // get all the keys from the JSON file
                  for(var k in contactResp) {
                     if (k == mainWindow.ids[kardiacrm.selected_partner] + "|" + id + "|0") {				
                        mainWindow.addresses[kardiacrm.selected_partner][addressLocation-1] = contactResp[k]['location_type_code'] + ": " + contactResp[k]['address'] + "\n" + contactResp[k]['country_name'];

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                       
                        //reload to display
                        reload(false);
                        if (kardiaTab != null) {
                           kardiaTab.reloadFilters(false);
                        }
                        break;
                        
                     }
                  }	
                  } else {
                  // 404, do nothing
                  }
				}, false, "", "");  
			}
		}});
	}	
	else if (returnValues.type == "P" && kardiacrm.logged_in) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactInfo/' + mainWindow.ids[kardiacrm.selected_partner] + "|" + id,'{"phone_area_city":"' + returnValues.info.areaCode + '","contact_data":"' + returnValues.info.number + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + kardiacrm.username + '"}', false, "", "", function(patchResp) { if (patchResp) {
			
			var phoneLocation = mainWindow.phoneNumbers[kardiacrm.selected_partner].indexOf(parseInt(id));
			if (returnValues.setInactive) {
				// remove
				mainWindow.phoneNumbers[kardiacrm.selected_partner].splice(phoneLocation-1,2);
			}
			else {
				// save
				mainWindow.phoneNumbers[kardiacrm.selected_partner][phoneLocation-1] = returnValues.type + ": (" + returnValues.info.areaCode + ") " + returnValues.info.number;
			}				

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
				  
			//reload to display
			reload(false);
         if (kardiaTab != null) {
            kardiaTab.reloadFilters(false);
         }
		}});
	}	
	else if ((returnValues.type == "E" || returnValues.type == "W") && kardiacrm.logged_in) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactInfo/' + mainWindow.ids[kardiacrm.selected_partner] + "|" + id,'{"contact_data":"' + returnValues.info + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + kardiacrm.username + '"}', false, "", "", function(patchResp) { if (patchResp) {
			
			if (type == "E") {
				var contactLocation = mainWindow.allEmailAddresses[kardiacrm.selected_partner].indexOf(parseInt(id));
				if (returnValues.setInactive) {
					// remove
					mainWindow.allEmailAddresses[kardiacrm.selected_partner].splice(contactLocation-1,2);
				}
				else {
					// save
					mainWindow.allEmailAddresses[kardiacrm.selected_partner][contactLocation-1] = returnValues.type + ": " + returnValues.info;
				}
			}
			else {
				var contactLocation = mainWindow.websites[kardiacrm.selected_partner].indexOf(parseInt(id));
				if (returnValues.setInactive) {
					// remove
					mainWindow.websites[kardiacrm.selected_partner].splice(contactLocation-1,2);
				}
				else {
					// save
					mainWindow.websites[kardiacrm.selected_partner][contactLocation-1] = returnValues.type + ": " + returnValues.info;
				}
			}		  

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
					  
			//reload to display
			reload(false);
         if (kardiaTab != null) {
            kardiaTab.reloadFilters(false);
         }
		}});
	}
}

//opens dialog for user to add new contact information item
function newContactInfo() {
	// variable where we store our return values
	var returnValues = {type:"", locationId:"", info:""};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/add-contact-dialog.xul", "New Contact Info Item", "resizable,chrome, modal,centerscreen",returnValues,kardiacrm.data.countries,kardiacrm.data.defaultCountry);

	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

	if (returnValues.type == "A" && kardiacrm.logged_in) {
		// post the new address
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Addresses','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","p_location_type":"' + returnValues.locationId + '","p_address_1":"' + returnValues.info.address1 + '","p_address_2":"' + returnValues.info.address2 + '","p_address_3":"' + returnValues.info.address3 + '","p_city":"' + returnValues.info.city + '","p_state_province":"' + returnValues.info.state + '","p_country_code":"' + returnValues.info.country + '","p_postal_code":"' + returnValues.info.zip + '","p_revision_id":0,"p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {

			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
         // If not 404
         if (contactResp != null) {
               // get all the keys from the JSON file
               var keys = [];
               for(var k in contactResp) keys.push(k);
               
               // the key "@id" doesn't correspond to a document, so use all other keys to find newest item
               var contactIndex = 0;
               for (var i=0;i<keys.length;i++) {
                  if (contactResp[keys[i]]['date_created'] != null) {
                     var contactDate = new Date(contactResp[keys[i]]['date_created']['year'],(contactResp[keys[i]]['date_created']['month']-1),contactResp[keys[i]]['date_created']['day'],contactResp[keys[i]]['date_created']['hour'],contactResp[keys[i]]['date_created']['minute'],contactResp[keys[i]]['date_created']['second']);
                     
                     // is this the address we're looking for?
                     if (keys[i] != "@id" && contactDate.toString() == date.toString()) {
                        // add to address array
                        mainWindow.addresses[kardiacrm.selected_partner].push(contactResp[keys[i]]['location_type_code'] + ": " + contactResp[keys[i]]['address'] + "\n" + contactResp[keys[i]]['country_name']);
                        mainWindow.addresses[kardiacrm.selected_partner].push(contactResp[keys[i]]['location_id']);

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                    
                        //reload to display
                        reload(false);
                        if (kardiaTab != null) {
                           kardiaTab.reloadFilters(false);
                        }
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		}});
	}

	else if ((returnValues.type == "P" || returnValues.type == "C" || returnValues.type == "F") && kardiacrm.logged_in) {
		// post the new contact info
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactInfo','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","p_contact_type":"' + returnValues.type + '","p_phone_area_city":"' + returnValues.info.areaCode + '","p_contact_data":"' + returnValues.info.number + '","p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {

			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
         // If not 404
         if (contactResp != null) {
               // get all the keys from the JSON file
               var keys = [];
               for(var k in contactResp) keys.push(k);
               
               // the key "@id" doesn't correspond to a contact, so use all other keys to find newest item
               var contactIndex = 0;
               for (var i=0;i<keys.length;i++) {
                  if (contactResp[keys[i]]['date_created'] != null) {
                     var contactDate = new Date(contactResp[keys[i]]['date_created']['year'],(contactResp[keys[i]]['date_created']['month']-1),contactResp[keys[i]]['date_created']['day'],contactResp[keys[i]]['date_created']['hour'],contactResp[keys[i]]['date_created']['minute'],contactResp[keys[i]]['date_created']['second']);
                     
                     // is this the contact we're looking for?
                     if (keys[i] != "@id" && contactDate.toString() == date.toString()) {
                        // add to phone numbers array
                        mainWindow.phoneNumbers[kardiacrm.selected_partner].push(returnValues.type + ": (" + returnValues.info.areaCode + ") " + returnValues.info.number);
                        mainWindow.phoneNumbers[kardiacrm.selected_partner].push(contactResp[keys[i]]['contact_id']);
                     
                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                    
                        //reload to display
                        reload(false);
                        if (kardiaTab != null) {
                           kardiaTab.reloadFilters(false);
                        }
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");				
		}});
	}

	else if ((returnValues.type == "E" || returnValues.type == "W" || returnValues.type == "B") && kardiacrm.logged_in) {
		// post the new contact info
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactInfo','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","p_contact_type":"' + returnValues.type + '","p_contact_data":"' + returnValues.info + '","p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {
	
			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
         // If not 404
         if (contactResp != null) {
               // get all the keys from the JSON file
               var keys = [];
               for(var k in contactResp) keys.push(k);
               
               // the key "@id" doesn't correspond to a contact, so use all other keys to find newest item
               var contactIndex = 0;
               for (var i=0;i<keys.length;i++) {
                  if (contactResp[keys[i]]['date_created'] != null) {
                     var contactDate = new Date(contactResp[keys[i]]['date_created']['year'],(contactResp[keys[i]]['date_created']['month']-1),contactResp[keys[i]]['date_created']['day'],contactResp[keys[i]]['date_created']['hour'],contactResp[keys[i]]['date_created']['minute'],contactResp[keys[i]]['date_created']['second']);
                     
                     // is this the contact we're looking for?
                     if (keys[i] != "@id" && contactDate.toString() == date.toString()) {
                        // add to email address/website/blog array
                        if (returnValues.type == "E") {
                           mainWindow.allEmailAddresses[kardiacrm.selected_partner].push(returnValues.type + ": " + returnValues.info);
                           mainWindow.allEmailAddresses[kardiacrm.selected_partner].push(contactResp[keys[i]]['contact_id']);
                        }
                        else {
                           mainWindow.websites[kardiacrm.selected_partner].push(returnValues.type + ": " + returnValues.info);	  
                           mainWindow.websites[kardiacrm.selected_partner].push(contactResp[keys[i]]['contact_id']);
                        }

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                    
                        //reload to display
                        reload(false);
                        if (kardiaTab != null) {
                           kardiaTab.reloadFilters(false);
                        }
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		}});
	}
}

// opens dialog for user to edit engagement track
function editTrack(name,step) {
	// variable where we store our return values
	var returnValues = {step:"", action:"q", stepNum:0};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/edit-track-dialog.xul", "Edit Engagement Track", "resizable,chrome,modal,centerscreen",server,returnValues,name.substring(0,name.lastIndexOf('-')),step);

	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
				  
	// if the user didn't cancel and we have a valid login
	if ((returnValues.action == 'e' || returnValues.action == 'c') && kardiacrm.logged_in) {
		
		// send track completion status using patch
		if (returnValues.action == 'e') {
			doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tracks/' + name, '{"completion_status":"e","simple_exited_date":' + dateString + '}', false, "", "");
		}
		else {
			doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tracks/' + name, '{"completion_status":"c","simple_completion_date":' + dateString + '}', false, "", "");
		}

		var trackIndex = mainWindow.engagementTracks[kardiacrm.selected_partner].indexOf(name);
		mainWindow.engagementTracks[kardiacrm.selected_partner].splice(trackIndex-2, 3);
		var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[kardiacrm.selected_partner].toString());
		trackIndex = mainWindow.collaborateeTracks[idLocation].indexOf(name.substring(0,name.lastIndexOf('-')));
		mainWindow.collaborateeTracks[idLocation].splice(trackIndex, 2);
		
		// add recent activity and reload
		//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
		reload(false);
      if (kardiaTab != null) {
         kardiaTab.reloadFilters(false);
      }
	}
	else if (returnValues.action == 'n' && kardiacrm.logged_in) {
		// say completed on the old step
		doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tracks/' + name, '{"completion_status":"c","simple_completion_date":' + dateString + '}', false, "", "");

		// add new step with the same id
		var track = find_item(kardiacrm.data.trackList, "track_name", name);
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tracks','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_engagement_id":' + parseInt(name.substring(name.lastIndexOf('-')+1,name.length)) + ',"e_track_id":' + parseInt(track.track_id) + ',"e_step_id":' + parseInt(returnValues.stepNum) + ',"e_is_archived":0,"e_completion_status":"i","e_desc":"","e_start_date":' + dateString + ',"e_started_by":"' + kardiacrm.username + '","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {
			
		
			var trackIndex = mainWindow.engagementTracks[kardiacrm.selected_partner].indexOf(name);
			mainWindow.engagementTracks[kardiacrm.selected_partner][trackIndex-1] = returnValues.step;

			var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[kardiacrm.selected_partner].toString());
			trackIndex = mainWindow.collaborateeTracks[idLocation].indexOf(name.substring(0,name.lastIndexOf('-')));
			mainWindow.collaborateeTracks[idLocation][trackIndex+1] = returnValues.step;

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
			reload(false);
         if (kardiaTab != null) {
            kardiaTab.reloadFilters(false);
         }
		}});
	}
}

// opens dialog for user to add new engagement track
function newTrack() {
	// variable where we store our return values
	var returnValues = {track:"", trackNum:0, step:"", stepNum:0};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/add-track-dialog.xul", "New Engagement Track", "resizable,chrome, modal,centerscreen", kardiacrm.data.trackList, server, returnValues);
	
	// if we have a valid track and login
	if (returnValues.track != "" && kardiacrm.logged_in) {
		// format today's date
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

		// post the new track
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tracks','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_track_id":' + parseInt(returnValues.trackNum) + ',"e_step_id":' + parseInt(returnValues.stepNum) + ',"e_is_archived":0,"e_completion_status":"i","e_desc":"","e_start_date":' + dateString + ',"e_started_by":"' + kardiacrm.username + '","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {

			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
         // If not 404
         if (trackResp != null) {
               // get all the keys from the JSON file
               var keys = [];
               for(var k in trackResp) keys.push(k);
               
               // the key "@id" doesn't correspond to a document, so use all other keys to find newest item
               var trackIndex = 0;
               for (var i=0;i<keys.length;i++) {
                  if (trackResp[keys[i]]['date_created'] != null) {
                     var trackDate = new Date(trackResp[keys[i]]['date_created']['year'],(trackResp[keys[i]]['date_created']['month']-1),trackResp[keys[i]]['date_created']['day'],trackResp[keys[i]]['date_created']['hour'],trackResp[keys[i]]['date_created']['minute'],trackResp[keys[i]]['date_created']['second']);
                     
                     // is this the track we're looking for?
                     if (keys[i] != "@id" && trackResp[keys[i]]['completion_status'].toLowerCase() == "i" && trackResp[keys[i]]['partner_id'] == mainWindow.ids[kardiacrm.selected_partner].toString() && trackResp[keys[i]]['engagement_track'] == returnValues.track && trackResp[keys[i]]['engagement_step'] == returnValues.step && trackDate.toString() == date.toString()) {
                        // add to e-track array
                        mainWindow.engagementTracks[kardiacrm.selected_partner].push(returnValues.track);
                        mainWindow.engagementTracks[kardiacrm.selected_partner].push(returnValues.step);
                        mainWindow.engagementTracks[kardiacrm.selected_partner].push(trackResp[keys[i]]['name']);
                  
                        // if a person we collaborate with, add to collaboratee tracks too
                        var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[kardiacrm.selected_partner].toString());
                        if (idLocation >= 0) {
                           mainWindow.collaborateeTracks[idLocation].push(returnValues.track);
                           mainWindow.collaborateeTracks[idLocation].push(returnValues.step);
                        }
                     
                        // add recent activity
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner]);
                        
                        //reload to display
                        reload(false);
                        if (kardiaTab != null) {
                           kardiaTab.reloadFilters(false);
                        }
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		}});
	}
}

// opens dialog for user to edit note/prayer
function editNote(text, key) {
	// where we save returned values	
	var returnValues = {title:text.substring(0,text.indexOf('-')), desc:text.substring(text.indexOf('-')+2,text.length), saveNote:true};

	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/edit-note-prayer.xul", "Edit Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues);

	if (returnValues.saveNote && kardiacrm.logged_in) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		
		doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactHistory/' + key,'{"subject":"' + returnValues.title + '","notes":"' + returnValues.desc + '","date_modified":' + dateString + ',"modified_by":"' + kardiacrm.username + '"}', false, "", "", function(patchResp) { if (patchResp) {
			
			//var noteIndex = mainWindow.notes[kardiacrm.selected_partner].indexOf(parseInt(key))-2;
			var noteIndex = find_item(mainWindow.notes[kardiacrm.selected_partner], 'contact_history_id', parseInt(key));
			mainWindow.notes[kardiacrm.selected_partner][noteIndex].subject = returnValues.title;
			mainWindow.notes[kardiacrm.selected_partner][noteIndex].notes = returnValues.desc;
			mainWindow.notes[kardiacrm.selected_partner][noteIndex].text = returnValues.title + ' - ' + returnValues.desc;
						
			// add recent activity and reload
			//reloadActivity(mainWindow.ids[kardiacrm.selected_partner]);
			reload(false);
		}});
	}
}

// opens dialog for user to add new note/prayer
function newNote(title, desc) {
	// where we save returned values	
	var returnValues = {title:title, desc:desc, saveNote:true, type:0};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/add-note-prayer.xul", "New Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues, kardiacrm.data.noteTypeList);

	if (returnValues.saveNote && (returnValues.title.trim() != "" || returnValues.desc.trim() != "") && kardiacrm.logged_in) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/ContactHistory','{"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_contact_history_type":' + returnValues.type + ',"e_subject":"' + returnValues.title + '","e_notes":"' + returnValues.desc + '","e_whom":"' + mainWindow.myId + '","e_contact_date":' + dateString + ',"s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {
			
			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/ContactHistory?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(noteResp) {
         // If not 404
         if (noteResp != null) {
               // the key "@id" doesn't correspond to a document, so use all other keys to find newest item
               var noteIndex = 0;
               for (var k in noteResp) {
                  if (k != "@id" && noteResp[k]['date_created'] != null) {
                     var noteDate = new Date(noteResp[k]['date_created']['year'],(noteResp[k]['date_created']['month']-1),noteResp[k]['date_created']['day'],noteResp[k]['date_created']['hour'],noteResp[k]['date_created']['minute'],noteResp[k]['date_created']['second']);
                     
                     // is this the note we're looking for?
                     if (noteDate.toString() == date.toString()) {
                        // add to notes array
			notes[kardiacrm.selected_partner].push({subject:returnValues.title, notes:returnValues.desc, text:returnValues.title + ' - ' + returnValues.desc, date:date.toLocaleString(), contact_history_id: noteResp[k]['contact_history_id']});
                        //notes[kardiacrm.selected_partner].push(returnValues.title + "- " + returnValues.desc);
                        //notes[kardiacrm.selected_partner].push(date.toLocaleString());
                        //notes[kardiacrm.selected_partner].push(noteResp[k]['contact_history_id']);

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                    
                        //reload to display
                        reload(false);
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		}});
	}
}

// opens dialog for user to add new collaborator
function newCollaborator() {
	if (partnerList.length <= 0) mainWindow.alert("No partners found! refreshing="+kardiacrm.refreshing);
	
	// variable where we store our return values
	var returnValues = {id:"", name:"", type:0};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/add-collaborator.xul", "New Tag", "resizable,chrome, modal,centerscreen", returnValues, partnerList, kardiacrm.data.collabTypeList);

	if (returnValues.id != "" && returnValues.id != null && kardiacrm.logged_in) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Collaborators','{"e_collaborator":"' + returnValues.id + '","p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_collab_type_id":' + returnValues.type + ',"s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {
			// get collaborator info
			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[kardiacrm.selected_partner] + "/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(collabResp) {
         // If not 404
         if (collabResp != null) {
               // add to collaborators array
               mainWindow.collaborators[kardiacrm.selected_partner].push(collabResp[returnValues.id + "|" + mainWindow.ids[kardiacrm.selected_partner]]['collaborator_is_individual']);
               mainWindow.collaborators[kardiacrm.selected_partner].push(returnValues.id);
               mainWindow.collaborators[kardiacrm.selected_partner].push(returnValues.name);
               
               // add recent activity and reload
               //reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
                    
               //reload to display
               reload(false);
               } else {
               // 404, do nothing
               }
			}, false, "", "");
		}});
	}
}

// opens dialog for user to add new tag
function newTag() {
	// variable where we store our return values
	var returnValues = {tag:"", tagId:0, magnitude:0.0, certainty:0.0};
	
	// open dialog
	kardiacrm.dialog = openDialog("chrome://kardia/content/add-tag-dialog.xul", "New Tag", "resizable,chrome, modal,centerscreen", kardiacrm.data.tagList, returnValues);

	if (returnValues.tag != "") {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
				
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[kardiacrm.selected_partner] + '/Tags','{"e_tag_id":' + returnValues.tagId + ',"p_partner_key":"' + mainWindow.ids[kardiacrm.selected_partner] + '","e_tag_strength":' + returnValues.magnitude.toFixed(2) + ',"e_tag_certainty":' + returnValues.certainty.toFixed(1) + ',"e_tag_volatility":"P","s_date_created":' + dateString + ',"s_created_by":"' + kardiacrm.username + '","s_date_modified":' + dateString + ',"s_modified_by":"' + kardiacrm.username + '"}', false, "", "", function(postResp) { if (postResp) {
			mainWindow.tags[kardiacrm.selected_partner].push(returnValues.tag);
			mainWindow.tags[kardiacrm.selected_partner].push(returnValues.magnitude);
			mainWindow.tags[kardiacrm.selected_partner].push(returnValues.certainty);
			
			// add recent activity and reload
			//reloadActivity(mainWindow.ids[kardiacrm.selected_partner])
			reload(false);
		}});
	}
}

// pastes email into quick search
function beginQuickFilter(email) {
	// make sure mail tab is selected
	document.getElementById("tabmail").selectTabByMode("folder");

	email = email.substring(3, email.length);
	QuickFilterBarMuxer._showFilterBar(true);
	document.getElementById(QuickFilterManager.textBoxDomId).select();
	
	// chop off last character so we can "type" it
	document.getElementById(QuickFilterManager.textBoxDomId).value = email.substring(0, email.length-1);
	var charCode = email.substring(email.length-1, email.length).charCodeAt(0);
	// "type" last character so it searches
	window.QueryInterface(Components.interfaces.nsIInterfaceRequestor).getInterface(Components.interfaces.nsIDOMWindowUtils).sendKeyEvent("keypress", charCode, charCode, null, false);
}

// find given username/password as staff in Kardia
function findStaff(username, password, doAfter) {
	doHttpRequest("apps/kardia/api/partner/Staff?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (staffResp) {
		// If not 404
		if (staffResp != null) {
			kardiacrm.data.staffList = staffResp;
			remove_atid(kardiacrm.data.staffList);
			// get all the keys from the JSON file
			var keys = [];
			for(var k in staffResp) keys.push(k);
         
			// see if any of these contain our login
			for (var i=0; i<keys.length; i++) {
				if (keys[i] != "@id") {
					// if so, save that id as myId
					if (staffResp[keys[i]]["kardia_login"] == username) {
						myId = staffResp[keys[i]]["partner_id"];
						break;
					}
				}
			}
			doAfter();
		} else {
			// 404, do nothing
		}
	}, true, username, password);
	
	reload(true);
}

// FEATURE: Recording emails in Kardia will go here when implemented
/*
// tell Kardia to record this email; we can't do anything yet because we can't send data to Kardia
function recordThisEmail() {	
	// if the box is currently checked, it's about to be unchecked, so don't record the email
	if (document.getElementById("record-this-email").checked) {
		// don't record this email
	}
	else {
		// record this email
	}
}

// tell Kardia to record future emails with this person
function recordFutureEmails() {
	// if the box is currently checked, it's about to be unchecked, so don't record future emails
	if (document.getElementById("record-future-emails").checked) {
		// stop recording emails
	}
	else {
		// start recording emails
	}
}*/

// get info from Kardia with the given parameters
// url - the portion of the url not including the server
// doAfter - the function to do afterwards, which takes the JSON results of the request as a parameter
// authenticate - whether we should send username and password
// username, password - login credentials
function doHttpRequest(url, doAfter, authenticate, username, password) {
	// create HTTP request to get whatever we need
	var httpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
	var httpUrl = mainWindow.server + url;
	var httpResp;
	
	httpRequest.onreadystatechange  = function(aEvent) {
		// if the request went through
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) {
				// parse the JSON returned from the request
				doAfter(JSON.parse(httpRequest.responseText));
			}
			else if (httpRequest.status == 404) {
				doAfter(null); // resource not found
			}
			else {
				doAfter(null); // bad request or invalid authentication
				// failed
				//window.alert(httpRequest.response + "failed");
			}
		}
	};

	// if the http request errors
	httpRequest.onerror = function(aEvent) {
		doAfter(null); // failure to connect, etc.
	};
	
	// send http request; send username and password if our parameter says we should
	//if (authenticate) {
	//	httpRequest.open("GET", httpUrl, true, username, password);
	//}
	//else {
		// don't
		httpRequest.open("GET", httpUrl, true);
	//}
	httpRequest.send(null);
}

// get todos and collaboratees
function getMyInfo(username, password) {
	// get todos
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.myId + "/CollaboratorTodos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
      // If not 404
      if (todoResp != null) {
         // get all the keys from the JSON file
         var keys = [];
         for(var k in todoResp) keys.push(k);
         
         // clear todos array
         allTodos = new Array();
         
         // the key "@id" doesn't correspond to a note, so use all other keys to add note info to array
         for (var i=0;i<keys.length;i++) {
            if (keys[i] != "@id" && todoResp[keys[i]]['status_code'].toLowerCase() == 'i') {
               mainWindow.allTodos.push(todoResp[keys[i]]['todo_id']);
               mainWindow.allTodos.push(todoResp[keys[i]]['partner_name'] + "- " + todoResp[keys[i]]['desc']);
               if (todoResp[keys[i]]['req_item_id'] != null) {
                  mainWindow.allTodos.push(getTodoDueDate(todoResp[keys[i]]['engagement_start_date'],todoResp[keys[i]]['req_item_due_days_from_step']));
               }
               else {
                  mainWindow.allTodos.push(todoResp[keys[i]]['due_date']);
               }			
            }
         }
         
         // FEATURE this is part of importing to-do items
         //import todos to calendar
         //mainWindow.importTodos();
         
         doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.myId + "/Collaboratees?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collabResp) {
            // If not 404
            if (collabResp != null) {

               // refresh collaboratees list
               collaborateeIds = new Array();
               collaborateeNames = new Array();
               collaborateeTracks = new Array();
               collaborateeTags = new Array();
               collaborateeActivity = new Array();
               collaborateeData = new Array();
               collaborateeGifts = new Array();
               collaborateeFunds = new Array();
               
               // get all the keys from the JSON file
               var keys = [];
               for(var k in collabResp) keys.push(k);
               
               // the key "@id" doesn't correspond to anything, so use other keys to save collaboratee IDs and names
               for (var i=0; i<keys.length; i++) {
                  if (keys[i] != "@id") {
                     mainWindow.collaborateeIds.push(collabResp[keys[i]]['partner_id']);
                     mainWindow.collaborateeNames.push(collabResp[keys[i]]['partner_name']);	
                  }
               }


               // get "collaboratee" list
                getCollaborateeInfo();


            } else {
               // 404, do nothing
            }
         }, false, "", "");
      } else {
         // 404, do nothing
      }
	}, true, username, password);
}

// get e-track list, tag list, me as staff
function getTrackTagStaff(username, password) {	
	// set the fact that we are refreshing
	kardiacrm.refreshing = true;

	if (kardiaTab != null) {
		kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.gif";
	}
										
	// reset Kardia tab sorting
	sortCollaborateesBy = "name";
	sortCollaborateesDescending = true;
	filterBy = "any";
	partnerList = new Array();
	filterData = new Array();
	filterFunds = new Array();
	giftFilterFunds = new Array();
	giftFilterTypes = new Array();

	// List of Text Expansions
	kardiacrm.requestGet("crm_config/TextExpansions?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", "meta", null, function (Resp) {
		if (Resp) {
			kardiacrm.data.textExpList = Resp;
			remove_atid(kardiacrm.data.textExpList);
		}
	});
	
	// List of Todo/Task types.
	kardiacrm.requestGet("crm_config/TodoTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", "meta", null, function (todoTypeResp) {
		if (todoTypeResp) {
			kardiacrm.data.todoTypeList = todoTypeResp;
			remove_atid(kardiacrm.data.todoTypeList);
		}
	});
	
	// get list of engagement tracks and their colors
	doHttpRequest("apps/kardia/api/crm_config/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (trackListResp) {
      // If not 404
      if (trackListResp != null) {
	 remove_atid(trackListResp);
         kardiacrm.data.trackList = trackListResp;
	 for(var k in trackListResp) {
	    if (k != '@id') {
		kardiacrm.data.trackList[k].filtered = false;
	    }
	 }

         // get list of tags
         doHttpRequest("apps/kardia/api/crm_config/TagTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (tagResp) {
         // If not 404
         if (tagResp != null) {
	       remove_atid(tagResp);
	       kardiacrm.data.tagList = tagResp;
	       for(var k in tagResp) {
		    if (k != '@id') {
			kardiacrm.data.tagList[k].filtered = false;
		    }
	       }
               
               // get list of contact history item types (note/prayer/etc)
               doHttpRequest("apps/kardia/api/crm_config/ContactHistTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (noteTypeResp) {
               // If not 404
               if (noteTypeResp != null) {
		     remove_atid(noteTypeResp);
		     kardiacrm.data.noteTypeList = noteTypeResp;
		     for(var k in noteTypeResp) {
			if (k != '@id') {
			    kardiacrm.data.noteTypeList[k].filtered = false;
			}
		     }
                     
                     // get list of countries
                     doHttpRequest("apps/kardia/api/crm_config/Countries?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (countryResp) {
                     // If not 404
                     if (countryResp != null) {
			   remove_atid(countryResp);
			   kardiacrm.data.countries = countryResp;
			   for(var k in countryResp) {
				// FIXME hard-coded default country code here (arrgh).  Make this configurable
				// or else derive from office address and make the office ID configurable.
				if (countryResp[k].country_code == 'US') {
				    kardiacrm.data.defaultCountry = kardiacrm.data.countries[k];
				}
			   }
                           
                           // TumblerQ: What does this do? Commented it out to reduce large API calls. Opened Thunderbird but can't find any differences.
                           //doHttpRequest("apps/kardia/api/partner/Partners?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (partnerResp) {
                           // If not 404
                           //if (partnerResp != null) {
                              
                                 //for(var k in partnerResp) {
                                    //// the key "@id" doesn't correspond to a partner, so use all other keys to save partners
                                    //if (k != "@id") {
                                       //// see where we should insert partner in the list
                                       //var insertHere = partnerList.length;
                                       //for (var j=0;j<partnerList.length;j+=2) {
                                          //if (partnerResp[k]["partner_name"] <= partnerList[j]) {
                                             //// insert partner before
                                             //insertHere = j;
                                             //break;
                                          //}
                                       //}
                                       //partnerList.splice(insertHere,0,partnerResp[k]["partner_name"],partnerResp[k]["partner_id"]);	
                                    //}
                                 //}
                                 
                                 doHttpRequest("apps/kardia/api/crm_config/CollaboratorTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collabResp) {
                                 // If not 404
                                 if (collabResp != null) {
				       remove_atid(collabResp);
				       kardiacrm.data.collabTypeList = collabResp;
                                 
                                       if (kardiaTab != null) {
                                          kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
                                          kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
					  // GRB - the == means these do nothing... commenting out for now.
                                          //kardiaTab.document.getElementById("filter-by-tracks").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Track:"/>';
                                          //kardiaTab.document.getElementById("filter-by-tags").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Tag:"/>';
                                          //kardiaTab.document.getElementById("filter-by-data").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Data items:"/>';
                                          kardiaTab.reloadFilters(true);
                                       }
                                       
                                       // get my ID		
                                       findStaff(username, password, function() {
                                          getMyInfo(username, password);
                                       });
                                    } else {
				       // 404
				       kardiacrm.refreshing = false;
                                    }
                                 }, false, "", "");
                              //} else {
                                 //// 404, do nothing
                              //}
                           //}, false, "", "");
                        } else {
			   // 404
			   kardiacrm.refreshing = false;
                        }
                     }, false, "", "");
                  } else {
                     // 404
		     kardiacrm.refreshing = false;
                  }
               }, false, "", "");
            } else {
               // 404
	       kardiacrm.refreshing = false;
            }
         }, false, "", "");
      } else {
         // 404
         kardiacrm.refreshing = false;
      }
	}, true, username, password);
}

// format gift for display
function formatGift(dollars, fraction) {
	var cents = (parseInt(fraction)/100).toString();
	while (cents.length < 2) {
		cents = "0" + cents;
	}
	return "$" + dollars + "." + cents;
}

// enable/disable gifts max amount textbox
function toggleGiftMaxAmount() {
	kardiaTab.document.getElementById('tab-filter-gifts-max-amount').disabled = kardiaTab.document.getElementById('tab-filter-gifts-no-max-amount').checked;	 
	reloadGifts();	
}

// enable/disable gifts min/max date textboxes
function toggleGiftDateRange() {
	kardiaTab.document.getElementById('tab-filter-gifts-min-date').disabled = kardiaTab.document.getElementById('tab-filter-gifts-no-min-date').checked;	 
	kardiaTab.document.getElementById('tab-filter-gifts-max-date').disabled = kardiaTab.document.getElementById('tab-filter-gifts-no-max-date').checked;	 
	reloadGifts();	
}

// reload gifts
function reloadGifts() {
	// display gifts
	kardiaTab.document.getElementById("giving-tree-children").innerHTML = "";
	var filterByAll = (document.getElementById("filter-gifts-by-type").selectedItem.value == "all");
	
	for (var i=0;i<mainWindow.gifts[kardiacrm.selected_partner].length;i+=4) {
		var displayGift = true;
		if (parseFloat(mainWindow.gifts[kardiacrm.selected_partner][i+1].substring(1,mainWindow.gifts[kardiacrm.selected_partner][i+1].length)) < parseFloat(kardiaTab.document.getElementById('tab-filter-gifts-min-amount').value)) {
			displayGift = false;
		}
		else if (!kardiaTab.document.getElementById('tab-filter-gifts-no-max-amount').checked && parseFloat(mainWindow.gifts[kardiacrm.selected_partner][i+1].substring(1,mainWindow.gifts[kardiacrm.selected_partner][i+1].length)) > parseFloat(kardiaTab.document.getElementById('tab-filter-gifts-max-amount').value))
		{
			 displayGift = false;
		}

		var currentDate = mainWindow.gifts[kardiacrm.selected_partner][i];
		var currentDateObject;
		var minDate;
		var minDateObject;
		var maxDate;
		var maxDateObject;

		if(currentDate != null) {
			var currentDateObject = new Date(currentDate.substring(currentDate.indexOf('/',currentDate.indexOf('/')+1)+1,currentDate.indexOf('/',currentDate.indexOf('/')+1)+5),currentDate.substring(0,currentDate.indexOf('/'))-1, currentDate.substring(currentDate.indexOf('/')+1,currentDate.indexOf('/',currentDate.indexOf('/')+1)));
		}
		if (!kardiaTab.document.getElementById('tab-filter-gifts-no-min-date').checked) {
			// get min date as a Date object
			minDateObject = kardiaTab.document.getElementById('tab-filter-gifts-min-date').dateValue;
		}
		if (!kardiaTab.document.getElementById('tab-filter-gifts-no-max-date').checked) {
			// get max date as a Date object
			maxDateObject = kardiaTab.document.getElementById('tab-filter-gifts-max-date').dateValue;
		}

		// check dates
		// only check if no gift boundaries, or if "all" is selected
		var noAmountSelected = (parseFloat(kardiaTab.document.getElementById('tab-filter-gifts-min-amount').value)*1 == 0 && kardiaTab.document.getElementById('tab-filter-gifts-no-max-amount').checked);
		var noDateSelected = (kardiaTab.document.getElementById('tab-filter-gifts-no-min-date').checked && kardiaTab.document.getElementById('tab-filter-gifts-no-max-date').checked);

		if (filterByAll || noAmountSelected) {
			if (currentDateObject != null && ((!kardiaTab.document.getElementById('tab-filter-gifts-no-min-date').checked && currentDateObject < minDateObject) || (!kardiaTab.document.getElementById('tab-filter-gifts-no-max-date').checked && currentDateObject > maxDateObject))) {
				displayGift = false;
			}
		}

		// check fund filters
		var fundsSelected = false;
		for (var j=0;j<mainWindow.giftFilterFunds.length;j++) {
			if (mainWindow.giftFilterFunds[j]) {
				fundsSelected = true;
				break;
			}
		}
		if (fundsSelected) {
			// if "filter by any" and it's false or it's only true because we haven't yet filtered by something else (date, amount)
			if (!filterByAll && (!displayGift || (noAmountSelected && noDateSelected))) {
				displayGift = false;
				for (var j=0;j<mainWindow.giftFilterFunds.length;j++) {
					if (mainWindow.giftFilterFunds[j] && mainWindow.gifts[kardiacrm.selected_partner][i+2] == mainWindow.funds[kardiacrm.selected_partner][j]) {
						displayGift = true;
						break;
					}
				}
			}
			// else if "filter by all" and displayGift is true
			else if (filterByAll && displayGift) {
				for (var j=0;j<mainWindow.giftFilterFunds.length;j++) {
					if (mainWindow.giftFilterFunds[j] && mainWindow.gifts[kardiacrm.selected_partner][i+2] != mainWindow.funds[kardiacrm.selected_partner][j]) {
						displayGift = false;
						break;
					}
				}
			}	
		}

		// check type filters
		var typeSelected = false;
		for (var j=0;j<mainWindow.giftFilterTypes.length;j++) {
			if (mainWindow.giftFilterTypes[j]) {
				typeSelected = true;
				break;
			}
		}
		if (typeSelected) {
			// if "filter by any" and it's false or it's only true because we haven't yet filtered by something else (date, amount, fund)
			if (!filterByAll && (!displayGift || (noAmountSelected && noDateSelected && !fundsSelected))) {
				displayGift = false;
				for (var j=0;j<mainWindow.giftFilterTypes.length;j++) {
					if (mainWindow.giftFilterTypes[j] && mainWindow.gifts[kardiacrm.selected_partner][i+3].indexOf(mainWindow.types[kardiacrm.selected_partner][j]) >= 0) {
						displayGift = true;
						break;
					}
				}
			}
			// else if "filter by all" and displayGift is true
			else if (filterByAll && displayGift) {
				for (var j=0;j<mainWindow.giftFilterTypes.length;j++) {
					if (mainWindow.giftFilterTypes[j] && mainWindow.gifts[kardiacrm.selected_partner][i+3].indexOf(mainWindow.types[kardiacrm.selected_partner][j]) < 0) {
						displayGift = false;
						break;
					}
				}
			}	
		}	

		// do amount, date, or type filters say not to display the gift?
		if (displayGift) {
			kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+1]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+2]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[kardiacrm.selected_partner][i+3]) + '"/></treerow></treeitem>';
		}
	}
}

// get authentication token for patch and post requests
function getAuthToken(authenticate, username, password, doAfter) {
	if (kardiacrm.akey !== null && kardiacrm.akey != "") {
		// already got token, don't get it again
		doAfter(true);
	}
	else {
		// get authentication token
		var httpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var httpUrl = server + "?cx__mode=appinit&cx__appname=TBext";
		var httpResp;
		
		httpRequest.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(httpRequest.readyState == 4 && httpRequest.status == 200) {
				// parse the JSON returned from the request
				var httpResp = JSON.parse(httpRequest.responseText);
				kardiacrm.akey = httpResp['akey'];
				
				// add keep-alive ping
				if (kardiacrm.ping_interval)
					window.clearInterval(kardiacrm.ping_interval);
				kardiacrm.ping_interval = window.setInterval(function() {
					// ping server
					var pingRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
					var pingUrl = server + "INTERNAL/ping?cx__akey=" + kardiacrm.akey;
				
					pingRequest.onreadystatechange = function(aEvent) {
						// if the request went through and we got success status
						if(pingRequest.readyState == 4 && pingRequest.status == 200) {
							// check status
							var resp = pingRequest.responseText;
							if (resp.substring(resp.indexOf("TARGET")+7,resp.length-7) == "ERR") {
								// key expired, get a new one
								var newHttpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
								var newHttpUrl = server + "?cx__mode=appinit&cx__appname=MozillaThunderbird";
								var newHttpResp;
								newHttpRequest.onreadystatechange  = function(aEvent) {
									// if the request went through and we got success status
									if(newHttpRequest.readyState == 4 && newHttpRequest.status == 200) {
										// parse the JSON returned from the request
										var newHttpResp = JSON.parse(newHttpRequest.responseText);
										kardiacrm.akey = newHttpResp['akey'];
									}
								}
								newHttpRequest.onerror = function(aEvent) {
									kardiacrm.akey = null;
								};
								newHttpRequest.open("GET", newHttpUrl, true);
								newHttpRequest.send();						
							}
						}
						else if (pingRequest.readyState == 4 && pingRequest.status != 200) {
							// failed
						}
					};
	
					// do nothing if the http request errors
					pingRequest.onerror = function(aEvent) {};
					
					// send http request
					pingRequest.open("GET", pingUrl, true);
					pingRequest.send();
					
				},httpResp['watchdogtimer']*500);
	
				doAfter(true);
			}
			else if (httpRequest.readyState == 4 && httpRequest.status != 200) {
				// failed
				doAfter(false);
			}
		};

		// do nothing if the http request errors
		httpRequest.onerror = function(aEvent) {
			doAfter(false);
		};
		
		// send http request; send username and password if our parameter says we should
		if (authenticate) {
			httpRequest.open("GET", httpUrl, true, username, password);
		}
		else {
			// don't
			httpRequest.open("GET", httpUrl, true);
		}
		httpRequest.send(null);
	}
}


// send the given data to Kardia using patch
function doPatchHttpRequest(url, data, authenticate, username, password, doAfter) {
	// get authentication token if we don't have it yet
	getAuthToken(authenticate, username, password, function(stat) {
		if (stat) {
			// actually send info
			var httpRequest2 = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
			var httpUrl2 = server + url + "?cx__mode=rest&cx__res_format=attrs&cx__akey=" + kardiacrm.akey;

			httpRequest2.onreadystatechange  = function(aEvent) {
				// if the request went through and we got success status
				if(httpRequest2.readyState == 4 && httpRequest2.status == 200) {
					// done
					doAfter({
						StatusCode:200,
						Data: httpRequest2.responseText?(JSON.parse(httpRequest2.responseText)):null,
					});
				}
				else if (httpRequest2.readyState == 4 && httpRequest2.status != 200) {
					doAfter(null);
					// failed
				}
			};
			// do nothing if the http request errors
			httpRequest2.onerror = function(aEvent) {
				doAfter(null);
			};
			
			// send http request
			httpRequest2.open("PATCH", httpUrl2, true);
			httpRequest2.setRequestHeader("Content-type","application/json");
			if (typeof data !== "string" && !(data instanceof String)) {
				data = JSON.stringify(data);
			}
			httpRequest2.send(data);
		}
		else {
			doAfter(null);
		}
	});
}

// send the given data to Kardia using post
function doPostHttpRequest(url, data, authenticate, username, password, doAfter) {
	// get authentication token if we don't have it yet
	getAuthToken(authenticate, username, password, function(stat) {
		if (stat) {
			// actually send info
			var httpRequest2 = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
			var httpUrl2 = server + url + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection&cx__akey=" + kardiacrm.akey;

			httpRequest2.onreadystatechange = function(aEvent) {
				// if the request went through and we got success status
				if(httpRequest2.readyState == 4) {
					// done
					doAfter({
						Location: httpRequest2.getResponseHeader("Location"),
						Data: httpRequest2.responseText?(JSON.parse(httpRequest2.responseText)):null,
					});
				}
			};
			// do nothing if the http request errors
			httpRequest2.onerror = function(aEvent) {
				doAfter(null);
			};
			
			// send http request
			httpRequest2.open("POST", httpUrl2, true);
			httpRequest2.setRequestHeader("Content-type","application/json");
			if (typeof data !== "string" && !(data instanceof String)) {
				data = JSON.stringify(data);
			}
			httpRequest2.send(data);
		}
		else {
			doAfter(null);
		}
	});
}

// delete an object using DELETE
function doDeleteHttpRequest(url, authenticate, username, password, doAfter) {
	// get authentication token if we don't have it yet
	getAuthToken(authenticate, username, password, function(stat) {
		if (stat) {
			// actually send info
			var httpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
			var httpUrl = server + url + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=element&cx__akey=" + kardiacrm.akey;

			httpRequest.onreadystatechange = function(aEvent) {
				// if the request went through and we got success status
				if(httpRequest.readyState == 4) {
					// done
					doAfter({
						ResponseCode: httpRequest.status,
					});
				}
			};

			// do nothing if the http request errors
			httpRequest.onerror = function(aEvent) {
				doAfter(null);
			};
			
			// send http request
			httpRequest.open("DELETE", httpUrl, true);
			httpRequest.send(null);
		}
		else {
			doAfter(null);
		}
	});
}

// insert Kardia logo buttons next to each Kardia address in the current email
// clicking the button takes you to that person in the Kardia pane
function addKardiaButton(win){
	// save list of header views we need to check
	if (win.gExpandedHeaderView.from) {
		var headersArray = [win.gExpandedHeaderView.from.textNode.childNodes, win.gExpandedHeaderView.to.textNode.childNodes, win.gExpandedHeaderView.cc.textNode.childNodes, win.gExpandedHeaderView.bcc.textNode.childNodes];
		// iterate through header views
		for (var j=0;j<headersArray.length;j++) {
			var nodeArray = headersArray[j];
		
			// iterate through children in the header view
			for (var i=0;i<nodeArray.length;i++) {
				// Normalize email
				var email = nodeArray[i].getAttribute('emailAddress').toLowerCase();

				// check if this node's email address is in the list from Kardia
				if (email != null && email != "" && mainWindow.emailAddresses !== null && mainWindow.emailAddresses.length > 0 && mainWindow.emailAddresses.indexOf(email) >= 0 && kardiacrm.partners_loaded) {
					// if so, make the button visible
					nodeArray[i].setAttribute("kardiaShowing","");
							  
					// make button select the right person on click
					var person = mainWindow.emailAddresses.indexOf(email);
					nodeArray[i].setAttribute("kardiaOnclick","kardiacrm.selected_partner=" + parseInt(person) + "; if (mainWindow.document.getElementById('main-box').collapsed) {mainWindow.toggleKardiaVisibility(3);} mainWindow.reload(false);");
				}
				else {
					// the person isn't from Kardia, so hide the button
					nodeArray[i].setAttribute("kardiaShowing","display:none");
				}
			}
		}
	}
}

// remove all the Kardia logo buttons
function clearKardiaButton() {
	// save list of header views in which we need to hide buttons
	var headersArray = [gExpandedHeaderView.from.textNode.childNodes, gExpandedHeaderView.to.textNode.childNodes, gExpandedHeaderView.cc.textNode.childNodes, gExpandedHeaderView.bcc.textNode.childNodes];
	// iterate through header views
	for (var j=0;j<headersArray.length;j++) {
		var nodeArray = headersArray[j];
	
		// iterate through children in header view
		for (var i=0;i<nodeArray.length;i++) {
			// hide the Kardia button
				nodeArray[i].setAttribute("kardiaShowing","display:none");
		}
	}
}

// add new tab to display given data
function openDataTab(groupId, groupName) {
	var dataItemString = "?title=" + mainWindow.names[kardiacrm.selected_partner] + ": " + groupName;
	for (var i=0;i<mainWindow.data[kardiacrm.selected_partner].length;i+=3) {
		if (mainWindow.data[kardiacrm.selected_partner][i+2] == groupId) {
			dataItemString += '&' + (i/3) + '=' + mainWindow.data[kardiacrm.selected_partner][i];
			dataItemString += '&' + (i/3) + 'b=' + mainWindow.data[kardiacrm.selected_partner][i+1];
		}
	}
	mainWindow.document.getElementById("tabmail").openTab("contentTab", {contentPage: "chrome://kardia/content/data-item-group.xul" + dataItemString});
}

// convert JSON datetime to formatted string
function datetimeToString(date) {
   var year = ((date['year'] === undefined) ? 0 : date['year']);
   var month = ((date['month'] === undefined) ? 0 : date['month']);
   var day = ((date['day'] === undefined) ? 0 : date['day']);
   var hour = ((date['hour'] === undefined) ? 0 : date['hour']);
   var minute = ((date['minute'] === undefined) ? 0 : date['minute']);
   var second = ((date['second'] === undefined) ? 0 : date['second']);
	var dateObj = new Date(year, month-1, day, hour, minute, second);
	return dateObj.toLocaleTimeString() + ' ' + date['month'] + '/' + date['day'] + '/' + date['year'];
}

// convert JSON datetime to Date object
function datetimeToDate(date) {
	return new Date(date['year'], date['month']-1, date['day'], date['hour'], date['minute'], date['second']);
}

// reload recent activity
function reloadActivity(partnerId) {
	kardiacrm.requestGet("crm/Partners/" + partnerId + "/Activity?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", "act", null, function(activityResp) {
      // If not 404
      if (activityResp != null) {
         // where this partner is located in the main window list
         var mainIndex = mainWindow.ids.indexOf(partnerId);
         var tabIndex = mainWindow.collaborateeIds.indexOf(partnerId);
         // get all the keys from the JSON file
         var keys = [];

         for(var k in activityResp) keys.push(k);

         // save recent activity
         var tempArray = new Array();
         var tempCollaborateeArray = new Array();

         for (var i=0; (i<keys.length && tempArray.length<6); i++) {
            if (keys[i] != "@id") {
		tempArray.push(activityResp[keys[i]]);
               /*tempArray.push(activityResp[keys[i]]['activity_type']);
               tempArray.push(datetimeToString(activityResp[keys[i]]['activity_date']) + ": " + activityResp[keys[i]]['info']);*/

               if (tempCollaborateeArray.length<6) {
                  tempCollaborateeArray.push(activityResp[keys[i]]['activity_type']);
                  tempCollaborateeArray.push(datetimeToString(activityResp[keys[i]]['activity_date']) + ": " + activityResp[keys[i]]['info']);
                  tempCollaborateeArray.push(activityResp[keys[i]]['activity_date']);
               }
            }
         }
         mainWindow.recentActivity[mainIndex] = tempArray;
         mainWindow.collaborateeActivity[tabIndex] = tempCollaborateeArray;
         
         // display recent activity in panel
	 appendActivity(kardiacrm.jQuery('#recent-activity-inner-box'), mainWindow.recentActivity[mainIndex][i]);

         // display recent activity in tab
         if (kardiaTab != null) {
            kardiaTab.document.getElementById("collaboratee-activity-" + partnerId).innerHTML = "";
            for (var j=1;j<mainWindow.collaborateeActivity[tabIndex].length;j+=3) {
               kardiaTab.document.getElementById("collaboratee-activity-" + partnerId).innerHTML += '<label flex="1">' + htmlEscape(mainWindow.collaborateeActivity[tabIndex][j]) + '</label>';
            }
         }
      } else {
         // 404, do nothing
      }
	}, false, "", "");
}

// Replace special html characters with their encoded version
function htmlEscape(str) {
      return String(str)
         .replace(/&/g, '&amp;')
         .replace(/"/g, '&quot;')
         .replace(/'/g, '&#39;')
         .replace(/</g, '&lt;')
         .replace(/>/g, '&gt;');
}

// installButton 
//   Inserts a button (id) from ToolbarPalette into toolbarId
function installButton(toolbarId, id) {
        var toolbar = document.getElementById(toolbarId);

        var toolbox = document.getElementById("mail-toolbox");
	if (toolbox) {
		var palette = toolbox.palette;
		toolbar.appendChild(palette.getElementsByClassName("kardia-tab-buttonn").item(0));
	}
}
