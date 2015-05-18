// Places where features can be added are marked with comment //FEATURE

// selected messages and number of emails selected (for comparing to see if we need to find users and reload Kardia pane)
var numSelected = 0;
var selectedMessages = null;

// list of currently displayable addresses, names, ids, etc
var emailAddresses = [];
var names = [];
var ids = [];
var addresses = [];
var phoneNumbers = [];
var allEmailAddresses = [];
var websites = [];
var engagementTracks = [];
var recentActivity = [];
var todos = [];
var allTodos = [];
var notes = [];
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
var selected = 0;
var selfEmails;

// colors for engagement tracks
var trackList = new Array();
var trackNumList = new Array();
var trackColors = new Array();

// list of tags
var tagList = new Array();

// list of types of contact history items (note/prayer/etc)
var noteTypeList = new Array();

// list of countries
var countryMenu = "";
var countryIndex = 0;
var countries = new Array();

// list of all partners, for adding collaborators
var partnerList = new Array();

// list of collaborator types
var collabTypeList = new Array();

// can the person log in to Kardia?  if not, don't try
var loginValid = false;

// authentication key for PATCH requests
var akey = "";

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
		
		doPatchHttpRequest('apps/kardia/api/crm/Todos/' + aOldItem.id, '{"desc":"' + aNewItem.title + '"due_date":' + dueDateString + ',"date_modified":"' + dateString + '","modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
		// TODO add due date
		// display item
			if (mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id) != null) {
				mainWindow.document.getElementById("to-do-item-" + aDeletedItem.id).label=aNewItem.title;
			}
		});	
	},
	onDeleteItem: function(aDeletedItem) {
	   if (loginValid) {
		// send to Kardia
		// format today's date
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
			
		doPatchHttpRequest('apps/kardia/api/crm/Todos/' + aDeletedItem.id, '{"status_code":"c","completion_date":' + dateString + ',"req_item_completed_by":"' + prefs.getCharPref("username") + '"}', false, "", "");
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
var kardiaTab;
var mainWindow = this;
var dataTab;

// is the window being refreshed?
var refreshing = false;

var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.kardia.");
		
updateKardia();

//update periodically based on preferences
function updateKardia() {
	window.setTimeout(function() {
		if (loginValid && !refreshing) {
			// completely refresh/reload
			getTrackTagStaff(prefs.getCharPref("username"), prefs.getCharPref("password"));
		}
		updateKardia();
	}, 60000*prefs.getIntPref("refreshInterval"));
}

// manually update
function manualUpdate() {
  document.getElementById("manual-refresh").style.backgroundColor = "#cccccc";
  setTimeout(function() {document.getElementById("manual-refresh").style.backgroundColor = "#ffffff";},200);
  
  if (mainWindow.loginValid && !mainWindow.refreshing) {
	// completely refresh/reload
	mainWindow.getTrackTagStaff(mainWindow.prefs.getCharPref("username"), mainWindow.prefs.getCharPref("password"));
  }
}
	
// what to do when Thunderbird starts up
window.addEventListener("load", function() { 
	// set "show Kardia pane" arrow to the correct image, based on whether it's collapsed
	if (document.getElementById("main-box").collapsed == true) {
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
	}
	
	// get username/password
  	var loginInfo = getLogin(false, false, function(loginInfo2) {

		// store username/password in preferences (this is only important if getLogin() returned something valid)
		prefs.setCharPref("username",loginInfo2[0]);
		prefs.setCharPref("password",loginInfo2[1]);
		
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
		
		getTrackTagStaff(loginInfo2[0], loginInfo2[1]);
	});
	
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

}, false);

// what to do when Thunderbird is closed
window.addEventListener("close", function() {
	// set username and password in preferences to blank values
	prefs.setCharPref("username","");
	prefs.setCharPref("password","");
}, false);

gMessageListeners.push({
	onEndHeaders: function () {},
	onStartHeaders: function() {if (loginValid) {findEmails();}}
	});

window.addEventListener("click", function() {if (loginValid) {findEmails();}}, false);

// what we do to find email addresses from selected messages
function findEmails() {
	// if 0 or > 1 email selected, don't search Kardia
	if (gFolderDisplay.selectedCount < 1 && numSelected >= 1) {   // TumblerQ: Logic doesn't match comment. This intended?
		// clear all partner info
		selected = 0;
		emailAddresses = new Array();
		names = new Array();
		ids = new Array();
		addresses = new Array();
		phoneNumbers = new Array();
		allEmailAddresses = new Array();
		websites = new Array();
		engagementTracks = new Array();
		recentActivity = new Array();
		todos = new Array();
		notes = new Array();
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
	if (gFolderDisplay.selectedCount >= 1 && !headersMatch(selectedMessages, gFolderDisplay.selectedMessages)) {
		// select the 0th partner and generate a new list of partners
		selected = 0;
			
		// get email addresses involved in this email message
		var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces.nsIMsgHeaderParser);
		var senderAddress = {};
		var recipientAddresses = {};
		var ccAddresses = {};
		var bccAddresses = {};
		var allAddresses = new Array();
		for (var i=0; i<gFolderDisplay.selectedMessages.length; i++) {
			parser.parseHeadersWithArray(gFolderDisplay.selectedMessages[i].author, senderAddress, {}, {});
			parser.parseHeadersWithArray(gFolderDisplay.selectedMessages[i].recipients, recipientAddresses, {}, {});
			parser.parseHeadersWithArray(gFolderDisplay.selectedMessages[i].ccList, ccAddresses, {}, {});
			parser.parseHeadersWithArray(gFolderDisplay.selectedMessages[i].bccList, bccAddresses, {}, {});
							
			// combine list of addresses
			allAddresses = allAddresses.concat(senderAddress.value);
			allAddresses = allAddresses.concat(recipientAddresses.value);
			allAddresses = allAddresses.concat(ccAddresses.value);
			allAddresses = allAddresses.concat(bccAddresses.value);
		}
		
		// remove duplicates and self
		allAddresses = parser.removeDuplicateAddresses(allAddresses, selfEmails, true).toLowerCase();

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
		addresses = new Array(emailAddresses.length);
		phoneNumbers = new Array(emailAddresses.length);
		allEmailAddresses = new Array(emailAddresses.length);
		websites = new Array(emailAddresses.length);
		engagementTracks = new Array(emailAddresses.length);
		recentActivity = new Array(emailAddresses.length);
		todos = new Array(emailAddresses.length);
		notes = new Array(emailAddresses.length);
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
				addresses.splice(i,1);
				phoneNumbers.splice(i,1);
				allEmailAddresses.splice(i,1);
				websites.splice(i,1);
				engagementTracks.splice(i,1);
				recentActivity.splice(i,1);
				todos.splice(i,1);
				notes.splice(i,1);
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
		selectedMessages = gFolderDisplay.selectedMessages;
		
		// get data from Kardia
		findUser(0);
	}	
	// save number of emails selected so we can see if the number of emails selected has changed later
	numSelected = gFolderDisplay.selectedCount;	
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

// reloads Kardia pane
function reload(isDefault) {			
	// if list of email addresses is empty or null, make everything in Kardia pane blank or hidden and hide Print context menu
	if (mainWindow.emailAddresses.length < 1 || mainWindow.emailAddresses == null) {
		mainWindow.document.getElementById('main-context').hidden = true;
		
		mainWindow.document.getElementById("name-label").value = "";
		mainWindow.document.getElementById("id-label").value = "";
		mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "none";
		
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
	else if (mainWindow.names[mainWindow.selected] != null && mainWindow.ids[mainWindow.selected] != null) {
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
			
			if (i == mainWindow.selected) {
				mainWindow.selected = firstIndex;
			}
			else if (firstIndex == mainWindow.selected) {
				mainWindow.selected = i;
			}
			
			// move all other items around based on how we sorted names
			var arraysToMove = [mainWindow.emailAddresses, mainWindow.ids, mainWindow.addresses, mainWindow.phoneNumbers, mainWindow.allEmailAddresses, mainWindow.websites, mainWindow.engagementTracks, mainWindow.recentActivity, mainWindow.todos, mainWindow.notes, mainWindow.collaborators, mainWindow.documents, mainWindow.tags, mainWindow.data, mainWindow.dataGroups, mainWindow.gifts, mainWindow.funds, mainWindow.types];
			
			for (var j=0;j<arraysToMove.length;j++) {
				firstItem = arraysToMove[j][firstIndex];
				arraysToMove[j][firstIndex] = arraysToMove[j][i];
				arraysToMove[j][i] = firstItem;
			}
		}
		
		// if we're loading the pane for the first time, select the first (0th) item
		if (isDefault) {
			mainWindow.selected = 0;
		}

		// show content boxes in case they're hidden
		mainWindow.document.getElementById("main-content-box").style.visibility = "visible";
      mainWindow.document.getElementById('loading-gif-container').style.visibility = "collapse";
		// FEATURE: Uncomment the following when recording emails in Kardia is impmented
		// mainWindow.document.getElementById("bottom-separator").style.visibility = "visible";
		// mainWindow.document.getElementById("record-this-email").style.visibility = "visible";
		// mainWindow.document.getElementById("record-future-emails").style.visibility = "visible";
		
		// show name and id of selected partner
		mainWindow.document.getElementById("name-label").value = mainWindow.names[mainWindow.selected];
		mainWindow.document.getElementById("id-label").value = "ID# " + mainWindow.ids[mainWindow.selected];

		// if Kardia tab is open, show bottom box and add name
		if (kardiaTab != null) {
			kardiaTab.document.getElementById("tab-bottom-hbox").style.visibility = "visible";
			kardiaTab.document.getElementById("tab-address-map").style.visibility="visible";
			kardiaTab.document.getElementById("tab-bottom-name").value = mainWindow.names[mainWindow.selected];
		}
						
		// if only one partner available, hide dropdown arrow
		if (mainWindow.names.length <= 1) {
			mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "none";
		}
		else {		
			// show dropdown
			mainWindow.document.getElementById("choose-partner-dropdown-button").style.display = "inline";
			
			// display choices of partners to view
			var partners = "";
			for (var i=0;i<mainWindow.names.length;i++) {
					partners += '<button id="partner-button' + i + '" class="partner-button" label="' + htmlEscape(mainWindow.names[i]) + ', ID# ' + htmlEscape(mainWindow.ids[i]) + '" oncommand="choosePartner(\'' + i + '\')"/>';
			}
			mainWindow.document.getElementById("choose-partner-dropdown-menu").innerHTML = partners;
		}

      // sets up the Add data button
		var addData = "";
		addData += '<button label="Add new info" oncommand="newNote(\'\',\'\')" tooltiptext="Add new information to this partner\'s activity timeline"/><spacer flex="1"/>';	
		mainWindow.document.getElementById("new-data-button").innerHTML = addData;
		
		// display contact info based on selected partner
		var contactInfoHTML = "";
		var i;
		for (var i=0;i<mainWindow.addresses[mainWindow.selected].length;i+=2) {
			var splitAddress = mainWindow.addresses[mainWindow.selected][i].split("\n");
			var addressHTML = "";
			for (var j=0;j<splitAddress.length;j++) {
				addressHTML += "<label>" + splitAddress[j] + "</label>";
			}
			contactInfoHTML += '<hbox class="hover-box"><vbox flex="1">' + addressHTML + '</vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editContactInfo(\'A\',\'' + htmlEscape(mainWindow.addresses[mainWindow.selected][i+1]) + '\');"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
		}
		for (var i=0;i<mainWindow.phoneNumbers[mainWindow.selected].length;i+=2) {
			contactInfoHTML += '<hbox class="hover-box"><vbox flex="1"><label>' + htmlEscape(mainWindow.phoneNumbers[mainWindow.selected][i]) + '</label></vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editContactInfo(\'P\',\'' + htmlEscape(mainWindow.phoneNumbers[mainWindow.selected][i+1]) + '\');"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>' 
		}
		for (var i=0;i<mainWindow.allEmailAddresses[mainWindow.selected].length;i+=2) {
			contactInfoHTML += "<hbox class='hover-box'><vbox flex='1'><label class='text-link' tooltiptext='Click to compose email' context='emailContextMenu' onclick='if (event.button == 0) sendEmail(\"" + htmlEscape(mainWindow.allEmailAddresses[mainWindow.selected][i]) + "\")'>" + htmlEscape(mainWindow.allEmailAddresses[mainWindow.selected][i]) + "</label></vbox><vbox><spacer height='3px'/><image class='edit-image' onclick='editContactInfo(\"E\",\"" + htmlEscape(mainWindow.allEmailAddresses[mainWindow.selected][i+1]) + "\");'/><spacer flex='1'/></vbox><spacer width='3px'/></hbox>";
		}
		for (var i=0;i<mainWindow.websites[mainWindow.selected].length;i+=2) {
			contactInfoHTML += "<hbox class='hover-box'><vbox flex='1'><label class='text-link' tooltiptext='Click to open website' context='websiteContextMenu' onclick='if (event.button == 0) openUrl(\"" + htmlEscape(mainWindow.websites[mainWindow.selected][i]) + "\",true);'>" + htmlEscape(mainWindow.websites[mainWindow.selected][i]) + "</label></vbox><vbox><spacer height='3px'/><image class='edit-image' onclick='editContactInfo(\"W\",\"" + htmlEscape(mainWindow.websites[mainWindow.selected][i+1]) + "\");'/><spacer flex='1'/></vbox><spacer width='3px'/></hbox>";
		}
		contactInfoHTML += '<hbox><spacer flex="1"/><button class="new-button" label="New Contact Info..." oncommand="newContactInfo()" tooltiptext="Create new contact information item for this partner"/></hbox>';
		mainWindow.document.getElementById("contact-info-inner-box").innerHTML = contactInfoHTML;
		
		// display engagement tracks
		var tracks = "";
		for (var i=0;i<mainWindow.engagementTracks[mainWindow.selected].length;i+=3) {
         // Taking out edit button for now. Uncomment this and delete next line to re-enable. #Muted
			//tracks += '<hbox class="engagement-track-color-box" style="background-color:' + htmlEscape(mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[mainWindow.selected][i])]) + '"><vbox flex="1"><label class="bold-text">' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i]) + '</label><label>Engagement Step: ' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i+1]) + '</label></vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editTrack(\'' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i+2]) + '\',\'' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i+1]) + '\')"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
			tracks += '<hbox class="engagement-track-color-box" style="background-color:' + htmlEscape(mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[mainWindow.selected][i])]) + '"><vbox flex="1"><label class="bold-text">' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i]) + '</label><label>Engagement Step: ' + htmlEscape(mainWindow.engagementTracks[mainWindow.selected][i+1]) + '</label></vbox><vbox><spacer height="3px"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
		}
      // Muting this button for now #Muted
		//tracks += '<hbox><spacer flex="1"/><button class="new-button" label="New Track..." oncommand="newTrack()" tooltiptext="Add engagement track to this partner"/></hbox>';
		mainWindow.document.getElementById("engagement-tracks-inner-box").innerHTML = tracks;				
		
		// display recent activity
		var recent = "";
		for (var i=0;i<mainWindow.recentActivity[mainWindow.selected].length;i+=2) {
			recent += '<hbox class="hover-box"><label width="100" flex="1">' + htmlEscape(mainWindow.recentActivity[mainWindow.selected][i+1]) + '</label></hbox>';
		}
		mainWindow.document.getElementById("recent-activity-inner-box").innerHTML = recent;	
		
		// display todos
		var toDoText = "";
		for (var i=0;i<mainWindow.todos[mainWindow.selected].length;i+=2) {
			toDoText += '<checkbox id="to-do-item-' + htmlEscape(mainWindow.todos[mainWindow.selected][i]) + '" oncommand="deleteTodo(' + htmlEscape(mainWindow.todos[mainWindow.selected][i]) + ')" label="' + htmlEscape(mainWindow.todos[mainWindow.selected][i+1]) + '"/>';
		}
		// FEATURE: uncomment this when adding to-do items is implemented
		// toDoText += '<hbox><spacer flex="1"/><button class="new-button" label="New To-Do..." oncommand="newTodo()" tooltiptext="Create new to-do item for this partner"/></hbox>'; 
		//mainWindow.document.getElementById("to-dos-inner-box").innerHTML = "";
      // Muted for now #Muted
		mainWindow.document.getElementById("to-dos-inner-box").innerHTML = toDoText;	
		
		// display notes
		var noteText = "";
		for (var i=mainWindow.notes[mainWindow.selected].length-1;i>=0;i-=3) {
			noteText += '<hbox class="hover-box"><vbox><spacer height="3"/><image class="note-image"/><spacer flex="1"/></vbox><vbox width="100" flex="1"><description flex="1">' + htmlEscape(mainWindow.notes[mainWindow.selected][i-2]) + '</description><description flex="1">' + htmlEscape(mainWindow.notes[mainWindow.selected][i-1]) + '</description></vbox><vbox><spacer height="3px"/><image class="edit-image" onclick="editNote(\'' + htmlEscape(mainWindow.notes[mainWindow.selected][i-2]) + '\',' + htmlEscape(mainWindow.notes[mainWindow.selected][i]) + ');"/><spacer flex="1"/></vbox><spacer width="3px"/></hbox>';
		}
		noteText += '<hbox><spacer flex="1"/><button class="new-button" label="New Note/Prayer..." tooltiptext="Create new note/prayer for this partner" oncommand="newNote(\'\',\'\')"/></hbox>';	
		mainWindow.document.getElementById("notes-prayer-inner-box").innerHTML = "";
      // Muted for now #Muted (CAUTION: When unmuting this it could reintroduce bug #11)
		//mainWindow.document.getElementById("notes-prayer-inner-box").innerHTML = noteText;
		
		// display collaborators
		var collaboratorText = "";
		for (var i=0;i<mainWindow.collaborators[mainWindow.selected].length;i+=3) {
			// if it's a team/group, show team image 
			if (mainWindow.collaborators[mainWindow.selected][i] == 0) {
				collaboratorText += '<hbox><vbox><image class="team-image"/>';
			}
			else {
				//show individual image
				collaboratorText += '<hbox><vbox><image class="individual-image"/>';
			}
			collaboratorText += '<spacer flex="1"/></vbox><label tooltiptext="Click to view collaborator" width="100" flex="1" class="text-link" onclick="addCollaborator(' + mainWindow.collaborators[mainWindow.selected][i+1] + ')">' + mainWindow.collaborators[mainWindow.selected][i+2] +'</label></hbox>';
		}
		collaboratorText += '<hbox><spacer flex="1"/></hbox>';	
      // Add new collaborator button muted for now untill fixed. Code below Includes it, code above removes it.
		//collaboratorText += '<hbox><spacer flex="1"/><button class="new-button" label="New Collaborator..." tooltiptext="Create new collaborator for this partner" oncommand="newCollaborator()"/></hbox>';	
		
		mainWindow.document.getElementById("collaborator-inner-box").innerHTML = "";	
      // Muted for now #Muted
		//mainWindow.document.getElementById("collaborator-inner-box").innerHTML = collaboratorText;	
		
		// display documents
		var docs = "";
		for (var i=0;i<mainWindow.documents[mainWindow.selected].length;i+=2) {
			docs += '<hbox><vbox><image class="document-image"/><spacer flex="1"/></vbox><label tooltiptext="Click to open document" id="docLabel' + i + '" width="100" flex="1" class="text-link" context="documentContextMenu" onclick="if (event.button == 0) openDocument(\'' + htmlEscape(mainWindow.documents[mainWindow.selected][i]) + '\',false);">' + htmlEscape(mainWindow.documents[mainWindow.selected][i+1]) + '</label></hbox>';
		}
		mainWindow.document.getElementById("document-inner-box").innerHTML = "";
      // #Muted
		//mainWindow.document.getElementById("document-inner-box").innerHTML = docs;
		
		// if Kardia tab is open, add person's info to it, too
		if (kardiaTab != null) {
			// display tags
			kardiaTab.document.getElementById("tab-tags").innerHTML = '<label class="tab-title" value="Tags"/>';

			for (var i=0;i<mainWindow.tags[mainWindow.selected].length;i+=3) {	
				var questionMark = (mainWindow.tags[mainWindow.selected][i+2] <= 0.5) ? "?" : "";
				var filterIndex = mainWindow.tagList.indexOf(mainWindow.tags[mainWindow.selected][i])-1;
				// if positive, use green tags
				if (parseFloat(mainWindow.tags[mainWindow.selected][i+1]) >= 0) {
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + htmlEscape(filterIndex) + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(86,75%,' + htmlEscape((100-60*mainWindow.tags[mainWindow.selected][i+1])) + '%);"><label value="' + htmlEscape(mainWindow.tags[mainWindow.selected][i] + questionMark) + '"/></vbox>';
				}
				else {
					// red tags
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + htmlEscape(filterIndex) + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(8,100%,' + htmlEscape((100-40*(-1*mainWindow.tags[mainWindow.selected][i+1]))) + '%);"><label value="' + htmlEscape(mainWindow.tags[mainWindow.selected][i] + questionMark) + '"/></vbox>';
				}
			}
			kardiaTab.document.getElementById("tab-tags").innerHTML += '<hbox><spacer flex="1"/></hbox>';
         // New tag button muted for now.
			//kardiaTab.document.getElementById("tab-tags").innerHTML += '<hbox><spacer flex="1"/><button class="new-button" label="New Tag..." oncommand="newTag()" tooltiptext="Add tag to this partner"/></hbox>';
			
			// display data item groups
			if (mainWindow.dataGroups[mainWindow.selected].length > 0) {
				kardiaTab.document.getElementById("tab-data-items").innerHTML = '<label class="tab-title" value="Data Items"/>';
			
				for (var i=0;i<mainWindow.dataGroups[mainWindow.selected].length;i+=2) {
					kardiaTab.document.getElementById("tab-data-items").innerHTML += '<label class="new-button" value="' + htmlEscape(mainWindow.dataGroups[mainWindow.selected][i+1]) + '..." onclick="openDataTab(\'' + htmlEscape(mainWindow.dataGroups[mainWindow.selected][i]) + '\',\'' + htmlEscape(mainWindow.dataGroups[mainWindow.selected][i+1]) + '\')"/>';
				}
				// show data items
				kardiaTab.document.getElementById("tab-data-items").style.visibility="visible";
			}
			else {
				// hide data items
				kardiaTab.document.getElementById("tab-data-items").style.visibility="collapse";
			}

			if (mainWindow.gifts[mainWindow.selected].length <= 0) {
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
				for (var i=0;i<mainWindow.gifts[mainWindow.selected].length;i+=4) {
					kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+1]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+2]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+3]) + '"/></treerow></treeitem>';
				}
				
				// display fund filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML = '<label value="Fund: "/>';
				for (var i=0;i<mainWindow.funds[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML += '<button id="filter-gifts-by-f-' + i + '" type="checkbox" checkState="0" tooltiptext="Click to filter gifts by this fund" class="tab-filter-checkbox" oncommand="addGiftFilter(\'f\',\'' + i + '\');" label="' + htmlEscape(mainWindow.funds[mainWindow.selected][i]) + '"/>';
				}
	
				// display type filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML = '<label value="Type: "/>';
				for (var i=0;i<mainWindow.types[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML += '<button id="filter-gifts-by-t-' + i + '" type="checkbox" checkState="0" tooltiptext="Click to filter gifts by this type" class="tab-filter-checkbox" oncommand="addGiftFilter(\'t\',\'' + i + '\');" label="' + htmlEscape(mainWindow.types[mainWindow.selected][i]) + '"/>';
				}
				
				// display funds
				kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML = '<label class="bold-text" value="Filter partners by fund"/>';
				for (var i=0;i<mainWindow.funds[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML += '<vbox tooltiptext="Click to filter partners by this fund" class="tab-fund" onclick="addFilter(\'f\',\'' + htmlEscape(mainWindow.funds[mainWindow.selected][i]) + '\');"><label>' + htmlEscape(mainWindow.funds[mainWindow.selected][i]) + '</label></vbox>';
				}
			}
			
			// display dropdown list of person's emails
			kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML = "";
			for (var i=0;i<mainWindow.allEmailAddresses[mainWindow.selected].length;i+=2) {
				kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML += '<menuitem label="' + htmlEscape(mainWindow.allEmailAddresses[mainWindow.selected][i].substring(3, mainWindow.allEmailAddresses[mainWindow.selected][i].length)) + '"/>';
			}
			kardiaTab.document.getElementById("tab-filter-select").selectedIndex = 0;
			
			// display dropdown list of addresses and link to map
			if (mainWindow.addresses[mainWindow.selected].length > 0) {
				kardiaTab.document.getElementById("tab-location").style.visibility="visible";
				kardiaTab.document.getElementById("tab-address-select-inner").innerHTML = "";
				for (var i=0;i<mainWindow.addresses[mainWindow.selected].length;i+=2) {
					kardiaTab.document.getElementById("tab-address-select-inner").innerHTML += '<menuitem label="' + htmlEscape(mainWindow.addresses[mainWindow.selected][i]) + '" style="text-overflow:ellipsis;width:200px;"/>';
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
   kardiaTab.processingClick = false;
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
    clipboard.copyString(documents[selected][num]);
}

// open the given URL in default browser
function openUrl(url, isContact) {
	// if necessary, delete "W: " or "B: " prefix
	if (isContact) {
		url = url.substring(3,url.length);
	}
	// if URL doesn't have "http://", add it
	if (url.indexOf("http://") < 0) {
		url = "http://" + url;
	}
	// create URI and open
	var ioService = Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService);
	var uriToOpen = ioService.newURI(url, null, null);
	Components.classes["@mozilla.org/uriloader/external-protocol-service;1"].getService(Components.interfaces.nsIExternalProtocolService).loadURI(uriToOpen);
}

// open the given document in default program
function openDocument(url, savePage) {
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
	var url = documents[selected][num];
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
	openDocument(documents[selected][num],savePage);
}

// create a new email with this address as recipient
function sendEmail(recipient) {
	// remove "E: " prefix from email
	recipient = recipient.substring(3,recipient.length);
	// set email properties
	var msgComposeType = Components.interfaces.nsIMsgCompType;
	var msgComposeService = Components.classes['@mozilla.org/messengercompose;1'].getService();
	msgComposeService = msgComposeService.QueryInterface(Components.interfaces.nsIMsgComposeService);
	var params = Components.classes['@mozilla.org/messengercompose/composeparams;1'].createInstance(Components.interfaces.nsIMsgComposeParams);
	params.type = msgComposeType.Template;
	params.format = 0;
	var composeFields = Components.classes['@mozilla.org/messengercompose/composefields;1'].createInstance(Components.interfaces.nsIMsgCompFields);
	composeFields.to = recipient;
	composeFields.body = "";
	composeFields.subject = "";
	params.composeFields = composeFields;

	// open compose window
	msgComposeService.OpenComposeWindowWithParams(null, params);
}

// save email address to contacts
function saveToContacts(emailAddress) {
  window.openDialog("chrome://messenger/content/addressbook/abNewCardDialog.xul","","chrome,resizable=no,titlebar,modal,centerscreen",{primaryEmail: emailAddress.substring(3,emailAddress.length), displayName: names[selected]});
}

// print currently selected partner
function printPartner(whichPartner) {	
	if (whichPartner == null) {
		whichPartner = mainWindow.selected;
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
	for (var i=0;i<mainWindow.recentActivity[whichPartner].length;i+=2) {
		if (mainWindow.recentActivity[whichPartner][i] == "e") {
			activityPrintString += '</br>&#x2709&nbsp;' + mainWindow.recentActivity[whichPartner][i+1];
		}
	}	
	for (var i=1;i<mainWindow.todos[whichPartner].length;i+=2) {
		todosPrintString += "</br>&#x2610  " + mainWindow.todos[whichPartner][i];
	}
	for (var i=0;i<mainWindow.notes[whichPartner].length;i+=3) {
		notesPrintString += '</br>' + mainWindow.notes[whichPartner][i] + '&nbsp;&nbsp;(' + mainWindow.notes[whichPartner][i+1]+ ")";
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

      // don't try to access Kardia if the Thunderbird user's Kardia login is invalid
      if (loginValid) {		
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
               }
               else {
                  // remove this email address because it's a duplicate
                  emailAddresses.splice(index,1);
                  names.splice(index,1);
                  ids.splice(index,1);
                  addresses.splice(index,1);
                  phoneNumbers.splice(index,1);
                  allEmailAddresses.splice(index,1);
                  websites.splice(index,1);
                  engagementTracks.splice(index,1);
                  recentActivity.splice(index,1);
                  todos.splice(index,1);
                  notes.splice(index,1);
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
                     addresses.splice(index+1,0,[]);
                     phoneNumbers.splice(index+1,0,[]);
                     allEmailAddresses.splice(index+1,0,[]);
                     websites.splice(index+1,0,[]);
                     engagementTracks.splice(index+1,0,[]);
                     recentActivity.splice(index+1,0,[]);
                     todos.splice(index+1,0,[]);
                     notes.splice(index+1,0,[]);
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
                  // add little Kardia icon in email
                  addKardiaButton();
               
                  // start getting the other information about all the partners we found
                  getOtherInfo(0, true);
               }
            }
            else if (emailRequest.readyState == 4) {
               // we didn't get the 200 success status, so no partners were found with this email; remove the partner and reload the Kardia pane
               emailAddresses.splice(index,1);
               names.splice(index,1);
               ids.splice(index,1);
               addresses.splice(index,1);
               phoneNumbers.splice(index,1);
               allEmailAddresses.splice(index,1);
               websites.splice(index,1);
               engagementTracks.splice(index,1);
               recentActivity.splice(index,1);
               todos.splice(index,1);
               notes.splice(index,1);
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
                  // start getting the other information about all the partners we found
                  if (emailAddresses.length > 0) {
                     // add little Kardia icon in email
                     addKardiaButton();
                     
                     getOtherInfo(0, true);
                  }
                  else {
                     reload(false);
                  }
               }
            }
         };
         
         // do nothing on error
         emailRequest.onerror = function() {};
         
         // send the HTTP request
         emailRequest.open("GET", emailUrl, true, prefs.getCharPref("username"), prefs.getCharPref("password"));
         emailRequest.send(null);
      }
}

// get all other info about the partner whose information is stored at position index
function getOtherInfo(index, isDefault) {	
	// variable to store whether user is valid
	var validUser = true;
	
	// get partner name
	doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[index] + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic", function (nameResp) {
      // If not 404
      if (nameResp != null) {
         // if the partner is not valid, make them blank/invalid
         if (nameResp['is_valid'] == 0 ) {
            validUser = false;
            mainWindow.emailAddresses[index] = "";
            mainWindow.ids[index] = "";
         }
         
         // store partner's name
         mainWindow.names[index] = nameResp['partner_name'];
         
         // get more information only if the partner is valid
         if (validUser) {
            // get address information
            doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[index] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (addressResp) {
            // If not 404
            if (addressResp != null) {
                  // get the keys in the JSON file
                  var keys = [];
                  for(var k in addressResp) keys.push(k);
                     
                  // the key "@id" doesn't correspond to an address, so use all other keys to store address information to temporary array
                  var addressArray = new Array();
                  for (var i=0;i<keys.length;i++) {
                     if (keys[i] != "@id") {
                        if (addressResp[keys[i]]['is_valid'] != 0) {
                           if (addressResp[keys[i]]['country_name'] != null) {
                              addressArray.push(addressResp[keys[i]]['location_type_code'] + ": " + addressResp[keys[i]]['address'] + "\n" + addressResp[keys[i]]['country_name']);
                           }
                           else {
                              addressArray.push(addressResp[keys[i]]['location_type_code'] + ": " + addressResp[keys[i]]['address']);
                           }
                           addressArray.push(addressResp[keys[i]]['location_id']);
                        }
                     }
                  }
                  // store temporary array to permanent array
                  mainWindow.addresses[index] = addressArray;
                  
                  // get other contact information
                  doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[index] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (phoneResp) {
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
                              if (phoneResp[keys[i]]['is_valid'] != 0) {
                              
                                 if (phoneResp[keys[i]]['contact_type_code'] == "E") {
                                    emailArray.push("E: " + phoneResp[keys[i]]['contact']);
                                    emailArray.push(phoneResp[keys[i]]['contact_id']);
                                 }
                                 else if (phoneResp[keys[i]]['contact_type_code'] == "W" || phoneResp[keys[i]]['contact_type_code'] == "B") {
                                    websiteArray.push(phoneResp[keys[i]]['contact_type_code'] + ": " + phoneResp[keys[i]]['contact']);
                                    websiteArray.push(phoneResp[keys[i]]['contact_id']);
                                 }
                                 else {
                                    phoneArray.push(phoneResp[keys[i]]['contact_type_code'] + ": " + phoneResp[keys[i]]['contact']);
                                    phoneArray.push(phoneResp[keys[i]]['contact_id']);
                                 }
                              }
                           }
                        }
                        // store temporary arrays to permanent arrays
                        mainWindow.phoneNumbers[index] = phoneArray;
                        mainWindow.allEmailAddresses[index] = emailArray;
                        mainWindow.websites[index] = websiteArray;
                        
                        // get engagement tracks information
                        doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
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
                                    if (trackResp[keys[i]]['completion_status'].toLowerCase() == "i") {
                                       trackArray.push(trackResp[keys[i]]['engagement_track']);
                                       trackArray.push(trackResp[keys[i]]['engagement_step']);
                                       trackArray.push(trackResp[keys[i]]['name']);
                                    }
                                 }
                              }
                              // store temporary array to permanent array
                              mainWindow.engagementTracks[index] = trackArray;
                              
                              // get documents information
                              doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Documents?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (documentResp) {
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
                                          documentArray.push(server + documentResp[keys[i]]['location']);
                                          documentArray.push(documentResp[keys[i]]['title']);
                                       }
                                    }
                                    // store temporary array to permanent array
                                    mainWindow.documents[index] = documentArray;
                                    // get notes/prayer information
                                    doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/ContactHistory?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (noteResp) {
                                    // If not 404
                                    if (noteResp != null) {
                                          // get all the keys from the JSON file
                                          var keys = [];
                                          for(var k in noteResp) keys.push(k);

                                          // the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
                                          var noteArray = new Array();
                                          for (var i=0;i<keys.length;i++) {
                                             if (keys[i] != "@id") {
                                                noteArray.push(noteResp[keys[i]]['subject'] + "- " + noteResp[keys[i]]['notes']);
                                                noteArray.push(datetimeToString(noteResp[keys[i]]['date_modified']));
                                                noteArray.push(noteResp[keys[i]]['contact_history_id']);
                                             }
                                          }
                                          // store temporary array to permanent array
                                          mainWindow.notes[index] = noteArray;
                                          
                                          // get collaborators information
                                          doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] +"/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collaboratorResp) {
                                          // If not 404
                                          if (collaboratorResp != null) {
                                                // get all the keys from the JSON file
                                                var keys = [];
                                                for(var k in collaboratorResp) keys.push(k);

                                                // the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
                                                var collaboratorArray = new Array();
                                                for (var i=0;i<keys.length;i++) {
                                                   if (keys[i] != "@id") {
                                                      collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_is_individual']);
                                                      collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_id']);
                                                      collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_name']);
                                                   }
                                                }
                                                // store temporary array to permanent array
                                                mainWindow.collaborators[index] = collaboratorArray;
                                                
                                                // get todos information
                                                doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todosResp) {
                                                // If not 404
                                                if (todosResp != null) {
                                                      // get all the keys from the JSON file
                                                      var keys = [];
                                                      for(var k in todosResp) keys.push(k);

                                                      // the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
                                                      var todosArray = new Array();
                                                      for (var i=0;i<keys.length;i++) {
                                                         if (keys[i] != "@id" && todosResp[keys[i]]['status_code'].toLowerCase() == 'i') {
                                                            todosArray.push(todosResp[keys[i]]['todo_id']);
                                                            todosArray.push(todosResp[keys[i]]['desc']);
                                                         }
                                                      }
                                                      // store temporary array to permanent array
                                                      mainWindow.todos[index] = todosArray;
                                                   
                                                      // get tags information
                                                      doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
                                                      // If not 404
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
                                                                  for (var j=0;j<tempArray.length;j+=3) {
                                                                     if (parseFloat(tagResp[keys[i]]['tag_strength']) >= parseFloat(tempArray[j+1])) {
                                                                        // insert tag before
                                                                        insertHere = j;
                                                                        break;
                                                                     }
                                                                  }
                                                                  tempArray.splice(insertHere,0,tagResp[keys[i]]['tag_label'],tagResp[keys[i]]['tag_strength'],tagResp[keys[i]]['tag_certainty']);
                                                               }
                                                            }
                                                            mainWindow.tags[index] = tempArray;
                                                            
                                                            // get data items
                                                            doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/DataItems?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(dataResp) {
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
                                                                        tempArray.push(dataResp[keys[i]]['item_type_label'] + ": " + dataResp[keys[i]]['item_value']);
                                                                        tempArray.push(dataResp[keys[i]]['item_highlight']);
                                                                        tempArray.push(dataResp[keys[i]]['item_group_id']);

                                                                        // store data group if it doesn't already exist
                                                                        if (mainWindow.dataGroups[index].indexOf(dataResp[keys[i]]['item_group_id']) < 0) {
                                                                           mainWindow.dataGroups[index].push(dataResp[keys[i]]['item_group_id']);
                                                                           mainWindow.dataGroups[index].push(dataResp[keys[i]]['item_group_name']);
                                                                        }
                                                                     }
                                                                  }
                                                                  mainWindow.data[index] = tempArray;

                                                                  doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Activity?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(activityResp) {
                                                                     // If not 404
                                                                     if (activityResp != null) {
                                                                        // get all the keys from the JSON file
                                                                        var keys = [];

                                                                        for(var k in activityResp) keys.push(k);

                                                                        // save recent activity
                                                                        var tempArray = new Array();

                                                                        for (var i=0; (i<keys.length && tempArray.length<6); i++) {
                                                                           if (keys[i] != "@id") {
                                                                              tempArray.push(activityResp[keys[i]]['activity_type']);
                                                                              tempArray.push(datetimeToString(activityResp[keys[i]]['activity_date']) + ": " + activityResp[keys[i]]['info']);
                                                                           }
                                                                        }
                                                                        mainWindow.recentActivity[index] = tempArray;
                                                                  
                                                                        // check donor status
                                                                        doHttpRequest("apps/kardia/api/donor/" + mainWindow.ids[index] + "/?cx__mode=rest&cx__res_type=element&cx__res_format=attrs&cx__res_attrs=basic", function(donorResp) {
                                                                           var notFound = 0;
                                                                           if (donorResp == null) {
                                                                              // 404, donor not found
                                                                              notFound = 1;
                                                                           }

                                                                           // is the partner a donor?
                                                                           if (notFound == 0) {
                                                                              // get gifts
                                                                              doHttpRequest("apps/kardia/api/donor/" + mainWindow.ids[index] + "/Gifts?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(giftResp) {
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
                                                                                          if (giftResp[keys[i]]['gift_date'] != null) {
                                                                                             tempArray.push(giftResp[keys[i]]['gift_date']['month'] + "/" + giftResp[keys[i]]['gift_date']['day'] + "/" + giftResp[keys[i]]['gift_date']['year']);
                                                                                          }
                                                                                          else {
                                                                                             tempArray.push("n/a");
                                                                                          }
                                                                                          tempArray.push(formatGift(giftResp[keys[i]]['gift_amount']['wholepart'], giftResp[keys[i]]['gift_amount']['fractionpart']));
                                                                                          tempArray.push(giftResp[keys[i]]['gift_fund_desc']);
                                                                                          
                                                                                          // if check, display check number
                                                                                          if (giftResp[keys[i]]['gift_type'] != null && giftResp[keys[i]]['gift_type'].toLowerCase() == 'check' && giftResp[keys[i]]['gift_check_num'].trim() != "") {
                                                                                             tempArray.push(giftResp[keys[i]]['gift_type'] + " (#" + giftResp[keys[i]]['gift_check_num'] + ")");
                                                                                          }
                                                                                          else {
                                                                                             tempArray.push(giftResp[keys[i]]['gift_type']);
                                                                                          }
                                                                                          // save gift type to types array
                                                                                          if (mainWindow.types[index].indexOf(giftResp[keys[i]]['gift_type']) < 0) {
                                                                                             mainWindow.types[index].push(giftResp[keys[i]]['gift_type']);
                                                                                             mainWindow.giftFilterTypes.push(false);
                                                                                          }
                                                                                       }
                                                                                    }
                                                                                    mainWindow.gifts[index] = tempArray;

                                                                                    // get funds
                                                                                    doHttpRequest("apps/kardia/api/donor/" + mainWindow.ids[index] + "/Funds?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(fundResp) {
                                                                                       // If not 404
                                                                                       if (fundResp != null) {
                                                                                          // get all the keys from the JSON file
                                                                                          var keys = [];
                                                                                          for(var k in fundResp) keys.push(k);

                                                                                          // reset gift filter list
                                                                                          mainWindow.giftFilterFunds = new Array();
                                                                                          mainWindow.giftFilterTypes = new Array();
                                                                                          
                                                                                          // save funds
                                                                                          var tempArray = new Array();
                                                                                          for (var i=0; i<keys.length; i++) {
                                                                                             if (keys[i] != "@id") {
                                                                                                tempArray.push(fundResp[keys[i]]['fund_desc']);
                                                                                                mainWindow.giftFilterFunds.push(false);
                                                                                             }
                                                                                          }
                                                                                          mainWindow.funds[index] = tempArray;
                                                                                          
                                                                                          // if there are more partners left to get info about, go to the next one
                                                                                          if (index+1 < mainWindow.emailAddresses.length) {
                                                                                             getOtherInfo(index+1, true);
                                                                                          }
                                                                                          else {
                                                                                             // done, so reload Kardia pane
                                                                                             reload(isDefault);
                                                                                          }
                                                                                       } else {
                                                                                          // 404, do nothing
                                                                                       }
                                                                                    }, false, "", "");
                                                                                 } else {
                                                                                    // 404, do nothing
                                                                                 }
                                                                              }, false, "", "");
                                                                           }
                                                                           else {
                                                                              // not a donor, so add blank info
                                                                              mainWindow.gifts[index] = new Array();
                                                                              mainWindow.types[index] = new Array();
                                                                              mainWindow.funds[index] = new Array();

                                                                              // if there are more partners left to get info about, go to the next one
                                                                              if (index+1 < mainWindow.emailAddresses.length) {
                                                                                 getOtherInfo(index+1, true);
                                                                              }
                                                                              else {
                                                                                 // done, so reload Kardia pane
                                                                                 reload(isDefault);
                                                                              }
                                                                           }
                                                                        }, false, "", "");
                                                                     } else {
                                                                        // 404, do nothing
                                                                     }
                                                                  }, false, "", "");
                                                               } else {
                                                                  // 404, do nothing
                                                               }
                                                            }, false, "", "");				
                                                         } else {
                                                            // 404, do nothing
                                                         }
                                                      }, false, "", "");	
                                                   } else {
                                                      // 404, do nothing
                                                   }
                                                }, false, "", "");	
                                             } else {
                                                // 404, do nothing
                                             }
                                          }, false, "", "");
                                       } else {
                                          // 404, do nothing
                                       }
                                    }, false, "", "");
                                 } else {
                                    // 404, do nothing
                                 }
                              }, false, "", "");
                           } else {
                              // 404, do nothing
                           }
                        },false, "", "");
                     } else {
                        // 404, do nothing
                     }
                  }, false, "", "");
               } else {
                  // 404, do nothing
               }
            }, false, "", "");
         }
      } else {
         // 404, do nothing
      }
	}, false, "", "");
}

// get info for one person you're collaborating with
function getCollaborateeInfo(index) {	
	// get the person's engagement tracks
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
      // If not 404
      if (trackResp != null) {
         // get all the keys from the JSON file
         var keys = [];
         for(var k in trackResp) keys.push(k);

         // save track info
         var tempArray = new Array();
         for (var i=0;i<keys.length; i++) {
            if (keys[i] != "@id" && trackResp[keys[i]]['completion_status'].toLowerCase() == "i") {
               tempArray.push(trackResp[keys[i]]['engagement_track']);
               tempArray.push(trackResp[keys[i]]['engagement_step']);
            }
         }
         mainWindow.collaborateeTracks.push(tempArray);
         
         // get tags
         doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
         // If not 404
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
                     for (var j=0;j<tempArray.length;j+=3) {
                        if (parseFloat(tagResp[keys[i]]['tag_strength']) >= parseFloat(tempArray[j+1])) {
                           // insert tag before
                           insertHere = j;
                           break;
                        }
                     }
                     tempArray.splice(insertHere,0,tagResp[keys[i]]['tag_label'],tagResp[keys[i]]['tag_strength'],tagResp[keys[i]]['tag_certainty']);
                  }
               }
               mainWindow.collaborateeTags.push(tempArray);
               
               // get data items
               doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/DataItems?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(dataResp) {
                  // If not 404
                  if (dataResp != null) {
                     // get all the keys from the JSON file
                     var keys = [];
                     for(var k in dataResp) keys.push(k);

                     // save data items
                     var tempArray = new Array();
                     for (var i=0; i<keys.length; i++) {
                        if (keys[i] != "@id") {
                           tempArray.push(dataResp[keys[i]]['item_type_label'] + ": " + dataResp[keys[i]]['item_value']);
                           tempArray.push(dataResp[keys[i]]['item_highlight']);
                           tempArray.push(dataResp[keys[i]]['item_group_id']);
                        }
                     }
                     mainWindow.collaborateeData.push(tempArray);
                  
                     // get recent activity
                     doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Activity?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(activityResp) {
                     // If not 404
                     if (activityResp != null) {
                           // get all the keys from the JSON file
                           var keys = [];
                           for(var k in activityResp) keys.push(k);

                           // save activity
                           var tempArray = new Array();
                           for (var i=0; (i<keys.length && tempArray.length<6); i++) {
                              if (keys[i] != "@id") {
                                 tempArray.push(activityResp[keys[i]]['activity_type']);
                                 tempArray.push(datetimeToString(activityResp[keys[i]]['activity_date']) + ": " + activityResp[keys[i]]['info']);
                                 tempArray.push(activityResp[keys[i]]['activity_date']);
                                    
                              }
                           }
                           mainWindow.collaborateeActivity.push(tempArray);
                                       
                                       
                           //doHttpRequest("apps/kardia/api/donor/?cx__mode=rest&cx__res_type=collection", function(donorResp) {
                           doHttpRequest("apps/kardia/api/donor/" + mainWindow.collaborateeIds[index] + "/?cx__mode=rest&cx__res_type=element&cx__res_format=attrs&cx__res_attrs=basic", function(donorResp) {
                              var notFound = 0;
                              if (donorResp == null) {
                                 // 404, donor not found
                                 notFound = 1;
                              }

                              // is the partner a donor?
                              if (notFound == 0) {
                                 // get gifts
                                 doHttpRequest("apps/kardia/api/donor/" + mainWindow.collaborateeIds[index] + "/Gifts?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(giftResp) {
                                 // If not 404
                                 if (giftResp != null) {
                                       // get all the keys from the JSON file
                                       var keys = [];
                                       for(var k in giftResp) keys.push(k);

                                       // save gifts
                                       var tempArray = new Array();
                                       for (var i=0; i<keys.length; i++) {
                                          if (keys[i] != "@id") {
                                             if (giftResp[keys[i]]['gift_date'] != null) {
                                                tempArray.push(giftResp[keys[i]]['gift_date']['month'] + "/" + giftResp[keys[i]]['gift_date']['day'] + "/" + giftResp[keys[i]]['gift_date']['year']);
                                             }
                                             else {
                                                tempArray.push("n/a");
                                             }
                                             tempArray.push(formatGift(giftResp[keys[i]]['gift_amount']['wholepart'], giftResp[keys[i]]['gift_amount']['fractionpart']));
                                             tempArray.push(giftResp[keys[i]]['gift_fund_desc']);
                                             
                                             // if check, display check number
                                             if (giftResp[keys[i]]['gift_type'] != null && giftResp[keys[i]]['gift_type'].toLowerCase() == 'check' && giftResp[keys[i]]['gift_check_num'].trim() != "") {
                                                tempArray.push(giftResp[keys[i]]['gift_type'] + " (#" + giftResp[keys[i]]['gift_check_num'] + ")");
                                             }
                                             else {
                                                tempArray.push(giftResp[keys[i]]['gift_type']);
                                             }																	
                                          }
                                       }
                                       mainWindow.collaborateeGifts.push(tempArray);
                                    
                                       doHttpRequest("apps/kardia/api/donor/" + mainWindow.collaborateeIds[index] + "/Funds?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(fundResp) {
                                          // If not 404
                                          if (fundResp != null) {
                                             // get all the keys from the JSON file
                                             var keys = [];
                                             for(var k in fundResp) keys.push(k);
                                             
                                             var tempArray = new Array();
                                             for (var i=0; i<keys.length; i++) {
                                                if (keys[i] != "@id") {
                                                   tempArray.push(fundResp[keys[i]]['fund_desc']);
                                                }
                                             }
                                             mainWindow.collaborateeFunds.push(tempArray);
                                                                  
                                             // if we've done all the collaboratees, start loading the Kardia tab stuff
                                             if (index+1 >= mainWindow.collaborateeIds.length) {
                                                // sort and reload Collaborating With panel
                                                kardiaTab.sortCollaboratees(false);
                                                mainWindow.refreshing = false;
                                                kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.png";
                                                
                                                // reload the Kardia pane so it's blank at first
                                                reload(false);
                                             }
                                             else {
                                                // reload
                                                kardiaTab.sortSomeCollaboratees(index);
                                                
                                                // go to the next person
                                                getCollaborateeInfo(index+1);
                                             }	
                                          } else {
                                             // 404, do nothing
                                          }
                                       }, false, "", "");
                                    } else {
                                       // 404, do nothing
                                    }
                                 }, false, "", "");
                              }
                              else {
                                 mainWindow.collaborateeGifts.push(new Array());
                                 mainWindow.collaborateeFunds.push(new Array());
                                 // TODO hide gift area
                                 // if we've done all the collaboratees, start loading the Kardia tab stuff
                                 if (index+1 >= mainWindow.collaborateeIds.length) {								
                                    // sort and reload Collaborating With panel
                                    kardiaTab.sortCollaboratees(false);
                                    mainWindow.refreshing = false;
                                    kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.png";
                                    
                                    // reload the Kardia pane so it's blank at first
                                    reload(false);
                                 }
                                 else {
                                    // reload
                                    kardiaTab.sortSomeCollaboratees(index);
                                    
                                    // go to the next person
                                    getCollaborateeInfo(index+1);
                                 }	
                              }
                           }, false, "", "");	
                        } else {
                           // 404, do nothing
                        }
                     }, false, "", "");			
                  } else {
                     // 404, do nothing
                  }
               }, false, "", "");	
            } else {
               // 404, do nothing
            }
         }, false, "", "");		
      } else {
         // 404, do nothing
      }
	}, false, "", "");
}
				
// delete the todo with the given id
function deleteTodo(todoId) {
	// delete from Kardia		
	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}'
	
	doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Todos/' + todoId, '{"status_code":"c","completion_date":' + dateString + ',"req_item_completed_by":"' + prefs.getCharPref("username") + '"}', false, "", "");
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
	doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Todos','{"e_todo_partner":"' + mainWindow.ids[mainWindow.selected] + '","e_todo_desc":"' + text + '","e_todo_collaborator":"' + '100002' + '","e_todo_type_id":0,"s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {

		doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[mainWindow.selected] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
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
						mainWindow.todos[mainWindow.selected].push(todo.id);
						mainWindow.todos[mainWindow.selected].push(mainWindow.names[mainWindow.selected] + '- ' + text);
						
						// add to all todos
						mainWindow.allTodos[mainWindow.selected].push(todo.id);
						mainWindow.allTodos[mainWindow.selected].push(mainWindow.names[mainWindow.selected] + '- ' + text);
						mainWindow.allTodos[mainWindow.selected].push(todo.dueDate); 
					
						// add recent activity and reload
						reloadActivity(mainWindow.ids[mainWindow.selected])
					  
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
      kardiaTab.processingClick = true;
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
         mainWindow.addresses.push([]);
         mainWindow.phoneNumbers.push([]);
         mainWindow.allEmailAddresses.push([]);
         mainWindow.websites.push([]);
         mainWindow.engagementTracks.push([]);
         mainWindow.recentActivity.push([]);
         mainWindow.todos.push([]);
         mainWindow.notes.push([]);
         mainWindow.collaborators.push([]);
         mainWindow.documents.push([]);
         mainWindow.tags.push([]);
         mainWindow.data.push([]);
         mainWindow.dataGroups.push([]);
         mainWindow.gifts.push([]);
         mainWindow.funds.push([]);
         mainWindow.types.push([]);
         mainWindow.selected = mainWindow.ids.length-1;
         // get information about them from Kardia
         getOtherInfo(mainWindow.ids.length-1, false);
      }
      else {
         // the collaborator is already in the available partner list, so just select them
         mainWindow.selected = arrayContains(mainWindow.ids, collaboratorId, 0);
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
						loginValid = true;
						if (kardiaTab != null) {
							kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
							kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
						}
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
		openDialog("chrome://kardia/content/login-dialog.xul", "Login to Kardia", "resizable=yes,chrome,modal,centerscreen=yes", returnValues);
		
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
						loginValid = true;
						if (kardiaTab != null) {
							kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
							kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
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
			loginRequest.open("GET", server, false, username, password);
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
		document.getElementById("cant-connect").style.display="inline";
	}
	
	if (closePane) {
		//close
		document.getElementById("main-box").collapsed = true;
		document.getElementById("show-kardia-pane-button").checked = false;
		document.getElementById("kardia-splitter").state = "closed";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
	}
	else {
		// open
		document.getElementById("main-box").collapsed = false;
		document.getElementById("show-kardia-pane-button").checked = true;
		document.getElementById("kardia-splitter").state = "open";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"show-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "#edf5fc";
	}
}

// opens/closes an info display section (like Engagement Tracks)
function toggleSectionDisplay(boxId) {
	// find out which section
	var boxNames = ["contact-info-box", "engagement-tracks-box", "recent-activity-box", "to-dos-box", "notes-prayer-box", "collaborator-box", "document-box",  "contact-info-box", "engagement-tracks-box", "recent-activity-box", "to-dos-box", "notes-prayer-box", "collaborator-box", "document-box"];
		
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
	selected = whichPartner;
	reload(false);
}

// Tumbler: Need to make this update tab after opens. Not sure why putting "updateKardia();" at the end doesn't work.
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
	openDialog("chrome://kardia/content/edit-contact-dialog.xul", "Edit Contact Info", "resizable,chrome, modal,centerscreen",returnValues,countryMenu,server,mainWindow.ids[mainWindow.selected],id,countries);
	
	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
			  
	var status_code = "A";
	if (returnValues.setInactive) status_code = "O";
			  
	if (returnValues.type == "A" && loginValid) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/Addresses/' + mainWindow.ids[mainWindow.selected] + "|" + id + "|0",'{"location_type_code":"' + returnValues.locationId + '","address_1":"' + returnValues.info.address1 + '","address_2":"' + returnValues.info.address2 + '","address_3":"' + returnValues.info.address3 + '","city":"' + returnValues.info.city + '","state_province":"' + returnValues.info.state + '","country_code":"' + returnValues.info.country + '","postal_code":"' + returnValues.info.zip + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
			var addressLocation = mainWindow.addresses[mainWindow.selected].indexOf(parseInt(id));
			if (returnValues.setInactive) {
				// remove
				mainWindow.addresses[mainWindow.selected].splice(addressLocation-1,2);

				// add recent activity and reload
				//reloadActivity(mainWindow.ids[mainWindow.selected])
				
				//reload to display
				reload(false);
				kardiaTab.reloadFilters(false);
			}
			else {
				// save
				doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[mainWindow.selected] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
            // If not 404
            if (contactResp != null) {
                  // get all the keys from the JSON file
                  for(var k in contactResp) {
                     if (k == mainWindow.ids[mainWindow.selected] + "|" + id + "|0") {				
                        mainWindow.addresses[mainWindow.selected][addressLocation-1] = contactResp[k]['location_type_code'] + ": " + contactResp[k]['address'] + "\n" + contactResp[k]['country_name'];

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[mainWindow.selected])
                       
                        //reload to display
                        reload(false);
                        kardiaTab.reloadFilters(false);
                        break;
                        
                     }
                  }	
                  } else {
                  // 404, do nothing
                  }
				}, false, "", "");  
			}
		});
	}	
	else if (returnValues.type == "P" && loginValid) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactInfo/' + mainWindow.ids[mainWindow.selected] + "|" + id,'{"phone_area_city":"' + returnValues.info.areaCode + '","contact_data":"' + returnValues.info.number + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
			var phoneLocation = mainWindow.phoneNumbers[mainWindow.selected].indexOf(parseInt(id));
			if (returnValues.setInactive) {
				// remove
				mainWindow.phoneNumbers[mainWindow.selected].splice(phoneLocation-1,2);
			}
			else {
				// save
				mainWindow.phoneNumbers[mainWindow.selected][phoneLocation-1] = returnValues.type + ": (" + returnValues.info.areaCode + ") " + returnValues.info.number;
			}				

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[mainWindow.selected])
				  
			//reload to display
			reload(false);
			kardiaTab.reloadFilters(false);
		});
	}	
	else if ((returnValues.type == "E" || returnValues.type == "W") && loginValid) {
		doPatchHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactInfo/' + mainWindow.ids[mainWindow.selected] + "|" + id,'{"contact_data":"' + returnValues.info + '","record_status_code":"' + status_code + '","date_modified":' + dateString + ',"modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
			if (type == "E") {
				var contactLocation = mainWindow.allEmailAddresses[mainWindow.selected].indexOf(parseInt(id));
				if (returnValues.setInactive) {
					// remove
					mainWindow.allEmailAddresses[mainWindow.selected].splice(contactLocation-1,2);
				}
				else {
					// save
					mainWindow.allEmailAddresses[mainWindow.selected][contactLocation-1] = returnValues.type + ": " + returnValues.info;
				}
			}
			else {
				var contactLocation = mainWindow.websites[mainWindow.selected].indexOf(parseInt(id));
				if (returnValues.setInactive) {
					// remove
					mainWindow.websites[mainWindow.selected].splice(contactLocation-1,2);
				}
				else {
					// save
					mainWindow.websites[mainWindow.selected][contactLocation-1] = returnValues.type + ": " + returnValues.info;
				}
			}		  

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[mainWindow.selected])
					  
			//reload to display
			reload(false);
			kardiaTab.reloadFilters(false);
		});
	}
}

//opens dialog for user to add new contact information item
function newContactInfo() {
	// variable where we store our return values
	var returnValues = {type:"", locationId:"", info:""};
	
	// open dialog
	openDialog("chrome://kardia/content/add-contact-dialog.xul", "New Contact Info Item", "resizable,chrome, modal,centerscreen",returnValues,countryMenu,countryIndex);

	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

	if (returnValues.type == "A" && loginValid) {
		// post the new address
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/Addresses','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","p_location_type":"' + returnValues.locationId + '","p_address_1":"' + returnValues.info.address1 + '","p_address_2":"' + returnValues.info.address2 + '","p_address_3":"' + returnValues.info.address3 + '","p_city":"' + returnValues.info.city + '","p_state_province":"' + returnValues.info.state + '","p_country_code":"' + returnValues.info.country + '","p_postal_code":"' + returnValues.info.zip + '","p_revision_id":0,"p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {

			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[mainWindow.selected] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
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
                        mainWindow.addresses[mainWindow.selected].push(contactResp[keys[i]]['location_type_code'] + ": " + contactResp[keys[i]]['address'] + "\n" + contactResp[keys[i]]['country_name']);
                        mainWindow.addresses[mainWindow.selected].push(contactResp[keys[i]]['location_id']);

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[mainWindow.selected])
                    
                        //reload to display
                        reload(false);
                        kardiaTab.reloadFilters(false);
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		});
	}

	else if ((returnValues.type == "P" || returnValues.type == "C" || returnValues.type == "F") && loginValid) {
		// post the new contact info
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactInfo','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","p_contact_type":"' + returnValues.type + '","p_phone_area_city":"' + returnValues.info.areaCode + '","p_contact_data":"' + returnValues.info.number + '","p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {

			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[mainWindow.selected] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
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
                        mainWindow.phoneNumbers[mainWindow.selected].push(returnValues.type + ": (" + returnValues.info.areaCode + ") " + returnValues.info.number);
                        mainWindow.phoneNumbers[mainWindow.selected].push(contactResp[keys[i]]['contact_id']);
                     
                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[mainWindow.selected])
                    
                        //reload to display
                        reload(false);
                        kardiaTab.reloadFilters(false);
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");				
		});
	}

	else if ((returnValues.type == "E" || returnValues.type == "W" || returnValues.type == "B") && loginValid) {
		// post the new contact info
		doPostHttpRequest('apps/kardia/api/partner/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactInfo','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","p_contact_type":"' + returnValues.type + '","p_contact_data":"' + returnValues.info + '","p_record_status_code":"A","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
	
			doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[mainWindow.selected] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(contactResp) {
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
                           mainWindow.allEmailAddresses[mainWindow.selected].push(returnValues.type + ": " + returnValues.info);
                           mainWindow.allEmailAddresses[mainWindow.selected].push(contactResp[keys[i]]['contact_id']);
                        }
                        else {
                           mainWindow.websites[mainWindow.selected].push(returnValues.type + ": " + returnValues.info);	  
                           mainWindow.websites[mainWindow.selected].push(contactResp[keys[i]]['contact_id']);
                        }

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[mainWindow.selected])
                    
                        //reload to display
                        reload(false);
                        kardiaTab.reloadFilters(false);
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		});
	}
}

// opens dialog for user to edit engagement track
function editTrack(name,step) {
	// variable where we store our return values
	var returnValues = {step:"", action:"q", stepNum:0};
	
	// open dialog
	openDialog("chrome://kardia/content/edit-track-dialog.xul", "Edit Engagement Track", "resizable,chrome,modal,centerscreen",server,returnValues,name.substring(0,name.lastIndexOf('-')),step);

	// format today's date
	var date = new Date();
	var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
				  
	// if the user didn't cancel and we have a valid login
	if ((returnValues.action == 'e' || returnValues.action == 'c') && loginValid) {
		
		// send track completion status using patch
		if (returnValues.action == 'e') {
			doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tracks/' + name, '{"completion_status":"e","simple_exited_date":' + dateString + '}', false, "", "");
		}
		else {
			doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tracks/' + name, '{"completion_status":"c","simple_completion_date":' + dateString + '}', false, "", "");
		}

		var trackIndex = mainWindow.engagementTracks[mainWindow.selected].indexOf(name);
		mainWindow.engagementTracks[mainWindow.selected].splice(trackIndex-2, 3);
		var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[mainWindow.selected].toString());
		trackIndex = mainWindow.collaborateeTracks[idLocation].indexOf(name.substring(0,name.lastIndexOf('-')));
		mainWindow.collaborateeTracks[idLocation].splice(trackIndex, 2);
		
		// add recent activity and reload
		//reloadActivity(mainWindow.ids[mainWindow.selected])
		reload(false);
		kardiaTab.reloadFilters(false);
	}
	else if (returnValues.action == 'n' && loginValid) {
		// say completed on the old step
		doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tracks/' + name, '{"completion_status":"c","simple_completion_date":' + dateString + '}', false, "", "");

		// add new step with the same id
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tracks','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","e_engagement_id":' + parseInt(name.substring(name.lastIndexOf('-')+1,name.length)) + ',"e_track_id":' + parseInt(mainWindow.trackNumList[mainWindow.trackList.indexOf(name.substring(0,name.lastIndexOf('-')))]) + ',"e_step_id":' + parseInt(returnValues.stepNum) + ',"e_is_archived":0,"e_completion_status":"i","e_desc":"","e_start_date":' + dateString + ',"e_started_by":"' + prefs.getCharPref("username") + '","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
		
			var trackIndex = mainWindow.engagementTracks[mainWindow.selected].indexOf(name);
			mainWindow.engagementTracks[mainWindow.selected][trackIndex-1] = returnValues.step;

			var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[mainWindow.selected].toString());
			trackIndex = mainWindow.collaborateeTracks[idLocation].indexOf(name.substring(0,name.lastIndexOf('-')));
			mainWindow.collaborateeTracks[idLocation][trackIndex+1] = returnValues.step;

			// add recent activity and reload
			//reloadActivity(mainWindow.ids[mainWindow.selected])
			reload(false);
			kardiaTab.reloadFilters(false);
		});
	}
}

// opens dialog for user to add new engagement track
function newTrack() {
	// variable where we store our return values
	var returnValues = {track:"", trackNum:0, step:"", stepNum:0};
	
	// open dialog
	openDialog("chrome://kardia/content/add-track-dialog.xul", "New Engagement Track", "resizable,chrome, modal,centerscreen",trackNumList, trackList, server, returnValues);
	
	// if we have a valid track and login
	if (returnValues.track != "" && loginValid) {
		// format today's date
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';

		// post the new track
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tracks','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","e_track_id":' + parseInt(returnValues.trackNum) + ',"e_step_id":' + parseInt(returnValues.stepNum) + ',"e_is_archived":0,"e_completion_status":"i","e_desc":"","e_start_date":' + dateString + ',"e_started_by":"' + prefs.getCharPref("username") + '","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {

			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[mainWindow.selected] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
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
                     if (keys[i] != "@id" && trackResp[keys[i]]['completion_status'].toLowerCase() == "i" && trackResp[keys[i]]['partner_id'] == mainWindow.ids[mainWindow.selected].toString() && trackResp[keys[i]]['engagement_track'] == returnValues.track && trackResp[keys[i]]['engagement_step'] == returnValues.step && trackDate.toString() == date.toString()) {
                        // add to e-track array
                        mainWindow.engagementTracks[mainWindow.selected].push(returnValues.track);
                        mainWindow.engagementTracks[mainWindow.selected].push(returnValues.step);
                        mainWindow.engagementTracks[mainWindow.selected].push(trackResp[keys[i]]['name']);
                  
                        // if a person we collaborate with, add to collaboratee tracks too
                        var idLocation = mainWindow.collaborateeIds.indexOf(mainWindow.ids[mainWindow.selected].toString());
                        if (idLocation >= 0) {
                           mainWindow.collaborateeTracks[idLocation].push(returnValues.track);
                           mainWindow.collaborateeTracks[idLocation].push(returnValues.step);
                        }
                     
                        // add recent activity
                        //reloadActivity(mainWindow.ids[mainWindow.selected]);
                        
                        //reload to display
                        reload(false);
                        kardiaTab.reloadFilters(false);
                        break;
                     }
                  }
               }	
            } else {
               // 404, do nothing
            }
			}, false, "", "");
		});
	}
}

// opens dialog for user to edit note/prayer
function editNote(text, key) {
	// where we save returned values	
	var returnValues = {title:text.substring(0,text.indexOf('-')), desc:text.substring(text.indexOf('-')+2,text.length), saveNote:true};

	// open dialog
	openDialog("chrome://kardia/content/edit-note-prayer.xul", "Edit Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues);

	if (returnValues.saveNote && loginValid) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		
		doPatchHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactHistory/' + key,'{"subject":"' + returnValues.title + '","notes":"' + returnValues.desc + '","date_modified":' + dateString + ',"modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
			var noteIndex = mainWindow.notes[mainWindow.selected].indexOf(parseInt(key))-2;
			mainWindow.notes[mainWindow.selected][noteIndex] = returnValues.title + "- " + returnValues.desc;
						
			// add recent activity and reload
			//reloadActivity(mainWindow.ids[mainWindow.selected]);
			reload(false);
		});
	}
}

// opens dialog for user to add new note/prayer
function newNote(title, desc) {
	// where we save returned values	
	var returnValues = {title:title, desc:desc, saveNote:true, type:0};
	
	// open dialog
	openDialog("chrome://kardia/content/add-note-prayer.xul", "New Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues, noteTypeList);

	if (returnValues.saveNote && (returnValues.title.trim() != "" || returnValues.desc.trim() != "") && loginValid) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/ContactHistory','{"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","e_contact_history_type":' + returnValues.type + ',"e_subject":"' + returnValues.title + '","e_notes":"' + returnValues.desc + '","e_whom":"' + mainWindow.myId + '","e_contact_date":' + dateString + ',"s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			
			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[mainWindow.selected] + "/ContactHistory?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(noteResp) {
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
                        notes[selected].push(returnValues.title + "- " + returnValues.desc);
                        notes[selected].push(date.toLocaleString());
                        notes[selected].push(noteResp[k]['contact_history_id']);

                        // add recent activity and reload
                        //reloadActivity(mainWindow.ids[mainWindow.selected])
                    
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
		});
	}
}

// opens dialog for user to add new collaborator
function newCollaborator() {
	if (partnerList.length <= 0) mainWindow.alert("No partners found! refreshing="+refreshing);
	
	// variable where we store our return values
	var returnValues = {id:"", name:"", type:0};
	
	// open dialog
	openDialog("chrome://kardia/content/add-collaborator.xul", "New Tag", "resizable,chrome, modal,centerscreen", returnValues, partnerList, collabTypeList);

	if (returnValues.id != "" && returnValues.id != null && loginValid) {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
		
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Collaborators','{"e_collaborator":"' + returnValues.id + '","p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","e_collab_type_id":' + returnValues.type + ',"s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			// get collaborator info
			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[mainWindow.selected] + "/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(collabResp) {
         // If not 404
         if (collabResp != null) {
               // add to collaborators array
               mainWindow.collaborators[mainWindow.selected].push(collabResp[returnValues.id + "|" + mainWindow.ids[mainWindow.selected]]['collaborator_is_individual']);
               mainWindow.collaborators[mainWindow.selected].push(returnValues.id);
               mainWindow.collaborators[mainWindow.selected].push(returnValues.name);
               
               // add recent activity and reload
               //reloadActivity(mainWindow.ids[mainWindow.selected])
                    
               //reload to display
               reload(false);
               } else {
               // 404, do nothing
               }
			}, false, "", "");
		});
	}
}

// opens dialog for user to add new tag
function newTag() {
	// variable where we store our return values
	var returnValues = {tag:"", tagId:0, magnitude:0.0, certainty:0.0};
	
	// open dialog
	openDialog("chrome://kardia/content/add-tag-dialog.xul", "New Tag", "resizable,chrome, modal,centerscreen", mainWindow.tagList, returnValues);

	if (returnValues.tag != "") {
		var date = new Date();
		var dateString = '{"year":' + date.getFullYear() + ',"month":' + (date.getMonth()+1) + ',"day":' + date.getDate() + ',"hour":' + date.getHours() + ',"minute":' + date.getMinutes() + ',"second":' + date.getSeconds() + '}';
				
		doPostHttpRequest('apps/kardia/api/crm/Partners/' + mainWindow.ids[mainWindow.selected] + '/Tags','{"e_tag_id":' + returnValues.tagId + ',"p_partner_key":"' + mainWindow.ids[mainWindow.selected] + '","e_tag_strength":' + returnValues.magnitude.toFixed(2) + ',"e_tag_certainty":' + returnValues.certainty.toFixed(1) + ',"e_tag_volatility":"P","s_date_created":' + dateString + ',"s_created_by":"' + prefs.getCharPref("username") + '","s_date_modified":' + dateString + ',"s_modified_by":"' + prefs.getCharPref("username") + '"}', false, "", "", function() {
			mainWindow.tags[mainWindow.selected].push(returnValues.tag);
			mainWindow.tags[mainWindow.selected].push(returnValues.magnitude);
			mainWindow.tags[mainWindow.selected].push(returnValues.certainty);
			
			// add recent activity and reload
			//reloadActivity(mainWindow.ids[mainWindow.selected])
			reload(false);
		});
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
		// if the request went through and we got success status
		if(httpRequest.readyState == 4 && httpRequest.status == 200) {
			// parse the JSON returned from the request
			doAfter(JSON.parse(httpRequest.responseText));
		}
      else if (httpRequest.readyState == 4 && httpRequest.status == 404) {
         doAfter(null); // not found
      }
		else if (httpRequest.readyState == 4 && httpRequest.status != 200) {
			// failed
			//window.alert(httpRequest.response + "failed");
		}
	};
	// do nothing if the http request errors
	httpRequest.onerror = function(aEvent) {};
	
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
         mainWindow.allTodos = new Array();
         
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
               mainWindow.collaborateeIds = new Array();
               mainWindow.collaborateeNames = new Array();
               mainWindow.collaborateeTracks = new Array();
               mainWindow.collaborateeTags = new Array();
               mainWindow.collaborateeActivity = new Array();
               mainWindow.collaborateeData = new Array();
               mainWindow.collaborateeGifts = new Array();
               mainWindow.collaborateeFunds = new Array();
               
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
               
               // get other info
               getCollaborateeInfo(0);
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
	mainWindow.refreshing = true;
	kardiaTab.document.getElementById("manual-refresh").image = "chrome://kardia/content/images/refresh.gif";
										
	
	// reset Kardia tab sorting
	mainWindow.sortCollaborateesBy = "name";
	mainWindow.sortCollaborateesDescending = true;
	mainWindow.filterBy = "any";
	mainWindow.trackList = new Array();
	mainWindow.trackNumList = new Array();
	mainWindow.trackColors = new Array();
	mainWindow.filterTracks = new Array();
	mainWindow.tagList = new Array();
	mainWindow.noteTypeList = new Array();
	mainWindow.countryMenu = "";
	mainWindow.countryIndex = 0;
	mainWindow.countries = new Array();
	mainWindow.partnerList = new Array();
	mainWindow.collabTypeList = new Array();
	mainWindow.filterTags = new Array();
	mainWindow.filterData = new Array();
	mainWindow.filterFunds = new Array();
	mainWindow.giftFilterFunds = new Array();
	mainWindow.giftFilterTypes = new Array();
	
	// get list of engagement tracks and their colors
	doHttpRequest("apps/kardia/api/crm_config/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (trackListResp) {
      // If not 404
      if (trackListResp != null) {
         // get all the keys from the JSON file
         var keys = [];
         for(var k in trackListResp) keys.push(k);
         
         // the key "@id" doesn't correspond to a track, so use all other keys to save tracks
         for (var i=0;i<keys.length;i++) {
            if (keys[i] != "@id") {
               mainWindow.trackList.push(trackListResp[keys[i]]['track_name']);
               mainWindow.trackNumList.push(trackListResp[keys[i]]['track_id']);
               mainWindow.trackColors.push(trackListResp[keys[i]]['track_color']);
               mainWindow.filterTracks.push(false);
            }
         }
         
         // get list of tags
         doHttpRequest("apps/kardia/api/crm_config/TagTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (tagResp) {
         // If not 404
         if (tagResp != null) {
               
               // get all the keys from the JSON file
               var keys = [];
               for(var k in tagResp) keys.push(k);
               
               // the key "@id" doesn't correspond to a tag, so use all other keys to save tags
               for (var i=0;i<keys.length;i++) {
                  if (keys[i] != "@id" && tagResp[keys[i]]['is_active']) {
                     mainWindow.tagList.push(tagResp[keys[i]]['tag_id']);
                     mainWindow.tagList.push(tagResp[keys[i]]['tag_label']);
                     mainWindow.filterTags.push(false);
                     mainWindow.filterTags.push(false);
                  }
               }

               // get list of contact history item types (note/prayer/etc)
               doHttpRequest("apps/kardia/api/crm_config/ContactHistTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (noteTypeResp) {
               // If not 404
               if (noteTypeResp != null) {
                     
                     // get all the keys from the JSON file
                     var keys = [];
                     for(var k in noteTypeResp) keys.push(k);
                     
                     // the key "@id" doesn't correspond to a tag, so use all other keys to save tags
                     for (var i=0;i<keys.length;i++) {
                        if (keys[i] != "@id" && noteTypeResp[keys[i]]['user_selectable'] == 1) {
                           mainWindow.noteTypeList.push(noteTypeResp[keys[i]]['id']);
                           mainWindow.noteTypeList.push(noteTypeResp[keys[i]]['label']);
                        }
                     }

                     // get list of countries
                     doHttpRequest("apps/kardia/api/crm_config/Countries?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (countryResp) {
                     // If not 404
                     if (countryResp != null) {
                           
                           // get all the keys from the JSON file
                           var keys = [];
                           for(var k in countryResp) keys.push(k);
                           
                           // the key "@id" doesn't correspond to a country, so use all other keys to save countries
                           for (var i=0;i<keys.length;i++) {
                              if (keys[i] != "@id") {
                                 countries.push(countryResp[keys[i]]['country_code']);
                                 countryMenu += '<menuitem label="' + countryResp[keys[i]]['name'] + '" value="' + countryResp[keys[i]]['country_code'] + '"/>';
                                 if (countryResp[keys[i]]['country_code'] == "US") {
                                    countryIndex = i-1;
                                 }
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
                                 
                                       if (kardiaTab != null) {
                                          kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
                                          kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
                                          kardiaTab.document.getElementById("filter-by-tracks").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Track:"/>';
                                          kardiaTab.document.getElementById("filter-by-tags").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Tag:"/>';
                                          kardiaTab.document.getElementById("filter-by-data").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Data items:"/>';
                                          kardiaTab.reloadFilters(true);
                                       }
                                       
                                       for(var k in collabResp) {
                                          // the key "@id" doesn't correspond to a partner, so use all other keys to save partners
                                          if (k != "@id") {
                                             collabTypeList.push(collabResp[k]["label"])
                                             collabTypeList.push(collabResp[k]["id"]);
                                          }
                                       }

                                       // get my ID		
                                       findStaff(username, password, function() {
                                          getMyInfo(username, password);
                                       });
                                    } else {
                                       // 404, do nothing
                                    }
                                 }, false, "", "");
                              //} else {
                                 //// 404, do nothing
                              //}
                           //}, false, "", "");
                        } else {
                           // 404, do nothing
                        }
                     }, false, "", "");
                  } else {
                     // 404, do nothing
                  }
               }, false, "", "");
            } else {
               // 404, do nothing
            }
         }, false, "", "");
      } else {
         // 404, do nothing
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
	
	for (var i=0;i<mainWindow.gifts[mainWindow.selected].length;i+=4) {
		var displayGift = true;
		if (parseFloat(mainWindow.gifts[mainWindow.selected][i+1].substring(1,mainWindow.gifts[mainWindow.selected][i+1].length)) < parseFloat(kardiaTab.document.getElementById('tab-filter-gifts-min-amount').value)) {
			displayGift = false;
		}
		else if (!kardiaTab.document.getElementById('tab-filter-gifts-no-max-amount').checked && parseFloat(mainWindow.gifts[mainWindow.selected][i+1].substring(1,mainWindow.gifts[mainWindow.selected][i+1].length)) > parseFloat(kardiaTab.document.getElementById('tab-filter-gifts-max-amount').value))
		{
			 displayGift = false;
		}

		var currentDate = mainWindow.gifts[mainWindow.selected][i];
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
					if (mainWindow.giftFilterFunds[j] && mainWindow.gifts[mainWindow.selected][i+2] == mainWindow.funds[mainWindow.selected][j]) {
						displayGift = true;
						break;
					}
				}
			}
			// else if "filter by all" and displayGift is true
			else if (filterByAll && displayGift) {
				for (var j=0;j<mainWindow.giftFilterFunds.length;j++) {
					if (mainWindow.giftFilterFunds[j] && mainWindow.gifts[mainWindow.selected][i+2] != mainWindow.funds[mainWindow.selected][j]) {
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
					if (mainWindow.giftFilterTypes[j] && mainWindow.gifts[mainWindow.selected][i+3].indexOf(mainWindow.types[mainWindow.selected][j]) >= 0) {
						displayGift = true;
						break;
					}
				}
			}
			// else if "filter by all" and displayGift is true
			else if (filterByAll && displayGift) {
				for (var j=0;j<mainWindow.giftFilterTypes.length;j++) {
					if (mainWindow.giftFilterTypes[j] && mainWindow.gifts[mainWindow.selected][i+3].indexOf(mainWindow.types[mainWindow.selected][j]) < 0) {
						displayGift = false;
						break;
					}
				}
			}	
		}	

		// do amount, date, or type filters say not to display the gift?
		if (displayGift) {
			kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+1]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+2]) + '"/><treecell label="' + htmlEscape(mainWindow.gifts[mainWindow.selected][i+3]) + '"/></treerow></treeitem>';
		}
	}
}

// get authentication token for patch and post requests
function getAuthToken(authenticate, username, password, doAfter) {
	if (akey !== null && akey != "") {
		// already got token, don't get it again
		doAfter();
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
				akey = httpResp['akey'];
				
				// add keep-alive ping
				window.setInterval(function() {
					// ping server
					var pingRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
					var pingUrl = server + "INTERNAL/ping?cx__akey=" + akey;
				
					pingRequest.onreadystatechange = function(aEvent) {
						// if the request went through and we got success status
						if(pingRequest.readyState == 4 && pingRequest.status == 200) {
							// check status
							var resp = pingRequest.responseText;
							if (resp.substring(resp.indexOf("TARGET")+7,resp.length-7) == "ERR") {
								// key expired, get a new one
								var newHttpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
								var newHttpUrl = server + "?cx__mode=appinit&cx__appname=TBext";
								var newHttpResp;	
								newHttpRequest.onreadystatechange  = function(aEvent) {
									// if the request went through and we got success status
									if(newHttpRequest.readyState == 4 && newHttpRequest.status == 200) {
										// parse the JSON returned from the request
										var newHttpResp = JSON.parse(newHttpRequest.responseText);
										akey = newHttpResp['akey'];
									}
								}
								newHttpRequest.onerror = function(aEvent) {};
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
	
				doAfter();
			}
			else if (httpRequest2.readyState == 4 && httpRequest2.status != 200) {
				// failed
			}
		};
		// do nothing if the http request errors
		httpRequest.onerror = function(aEvent) {};
		
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
	getAuthToken(authenticate, username, password, function() {
		// actually send info
		var httpRequest2 = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var httpUrl2 = server + url + "?cx__mode=rest&cx__res_format=attrs&cx__akey=" + akey;

		httpRequest2.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(httpRequest2.readyState == 4 && httpRequest2.status == 200) {
				// done
				doAfter();
			}
			else if (httpRequest2.readyState == 4 && httpRequest2.status != 200) {
				// failed
			}
		};
		// do nothing if the http request errors
		httpRequest2.onerror = function(aEvent) {};
		
		// send http request
		httpRequest2.open("PATCH", httpUrl2, true);
		httpRequest2.setRequestHeader("Content-type","application/json");
		httpRequest2.send(data);
	});
}

// send the given data to Kardia using post
function doPostHttpRequest(url, data, authenticate, username, password, doAfter) {
	// get authentication token if we don't have it yet
	getAuthToken(authenticate, username, password, function() {
		// actually send info
		var httpRequest2 = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var httpUrl2 = server + url + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection&cx__akey=" + akey;

		httpRequest2.onreadystatechange = function(aEvent) {
			// if the request went through and we got success status
			if(httpRequest2.readyState == 4) {
				// done
				doAfter();
			}
		};
		// do nothing if the http request errors
		httpRequest2.onerror = function(aEvent) {};
		
		// send http request
		httpRequest2.open("POST", httpUrl2, true);
		httpRequest2.setRequestHeader("Content-type","application/json");
		httpRequest2.send(data);
	});
}


// insert Kardia logo buttons next to each Kardia address in the current email
// clicking the button takes you to that person in the Kardia pane
function addKardiaButton(){
	// save list of header views we need to check
	var headersArray = [gExpandedHeaderView.from.textNode.childNodes, gExpandedHeaderView.to.textNode.childNodes, gExpandedHeaderView.cc.textNode.childNodes, gExpandedHeaderView.bcc.textNode.childNodes];
	// iterate through header views
	for (var j=0;j<headersArray.length;j++) {
		var nodeArray = headersArray[j];
	
		// iterate through children in the header view
		for (var i=0;i<nodeArray.length;i++) {
			// check if this node's email address is in the list from Kardia
			var email = nodeArray[i].getAttribute('emailAddress').toLowerCase();
			if (email != null && email != "" && mainWindow.emailAddresses !== null && mainWindow.emailAddresses.length > 0 && mainWindow.emailAddresses.indexOf(email) >= 0) {
				// if so, make the button visible
				nodeArray[i].setAttribute("kardiaShowing","");
						  
				// make button select the right person on click
				nodeArray[i].setAttribute("kardiaOnclick","mainWindow.selected = mainWindow.emailAddresses.indexOf('" + email + "'); if (document.getElementById('main-box').collapsed) {toggleKardiaVisibility(3);} reload(false);");
			}
			
			else {
				// the person isn't from Kardia, so hide the button
				nodeArray[i].setAttribute("kardiaShowing","display:none");
			}
		}
	}
}

// remove all the Kardia logo buttons
function clearKardiaButton(){
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
	var dataItemString = "?title=" + mainWindow.names[mainWindow.selected] + ": " + groupName;
	for (var i=0;i<mainWindow.data[mainWindow.selected].length;i+=3) {
		if (mainWindow.data[mainWindow.selected][i+2] == groupId) {
			dataItemString += '&' + (i/3) + '=' + mainWindow.data[mainWindow.selected][i];
			dataItemString += '&' + (i/3) + 'b=' + mainWindow.data[mainWindow.selected][i+1];
		}
	}
	mainWindow.document.getElementById("tabmail").openTab("contentTab", {contentPage: "chrome://kardia/content/data-item-group.xul" + dataItemString});
}

// convert JSON datetime to formatted string
function datetimeToString(date) {
	var dateObj = new Date(date['year'], date['month']-1, date['day'], date['hour'], date['minute'], date['second']);
	return dateObj.toLocaleTimeString() + ' ' + date['month'] + '/' + date['day'] + '/' + date['year'];
}

// convert JSON datetime to Date object
function datetimeToDate(date) {
	return new Date(date['year'], date['month']-1, date['day'], date['hour'], date['minute'], date['second']);
}

// reload recent activity
function reloadActivity(partnerId) {
	doHttpRequest("apps/kardia/api/crm/Partners/" + partnerId + "/Activity?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(activityResp) {
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
               tempArray.push(activityResp[keys[i]]['activity_type']);
               tempArray.push(datetimeToString(activityResp[keys[i]]['activity_date']) + ": " + activityResp[keys[i]]['info']);

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
         var recent = "";
         for (var i=0;i<mainWindow.recentActivity[mainIndex].length;i+=2) {
            recent += '<hbox class="hover-box"><label width="100" flex="1">' + mainWindow.recentActivity[mainIndex][i+1] + '</label></hbox>';
         }
         mainWindow.document.getElementById("recent-activity-inner-box").innerHTML = recent;	

         // display recent activity in tab
         kardiaTab.document.getElementById("collaboratee-activity-" + partnerId).innerHTML = "";
         for (var j=1;j<mainWindow.collaborateeActivity[tabIndex].length;j+=3) {
            kardiaTab.document.getElementById("collaboratee-activity-" + partnerId).innerHTML += '<label flex="1">' + htmlEscape(mainWindow.collaborateeActivity[tabIndex][j]) + '</label>';
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
