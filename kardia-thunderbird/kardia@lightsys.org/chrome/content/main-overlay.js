// TO DO on Wednesday: fix multi-select email thing
//
//
//
//
//
// // Stubs to be removed/fixed are marked with comment // FIX STUB
//

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
var trackColors = new Array();

// list of tags
var tagList = new Array();

// can the person log in to Kardia?  if not, don't try
var loginValid = false;

// constant server address (in case it needs to be changed); it is currently connected to the VM
// FIX STUB
const server = "http://192.168.42.128:800/";

// calendar stuff
Components.utils.import("resource://calendar/modules/calUtils.jsm");
var myCal;

var kardiaCalObserver = {
	onStartBatch: function() { },
	onEndBatch: function() { },
	onLoad: function(aCalendar) { },
	onAddItem: function(aItem) {
		// FIX STUB
		// send to Kardia? or delete item
		//window.alert("Item added: " + aItem.title);
	},
	onModifyItem: function(aNewItem, aOldItem) {
		// FIX STUB
		// send to Kardia
		//window.alert("Item modified: " + aNewItem.title);
	},
	onDeleteItem: function(aDeletedItem) {
		// send to Kardia
		// FIX STUB
		//window.alert("Item deleted: " + aDeletedItem.title);
	},
	onError: function(aCalendar, aErrNo, aMessage) {
		Application.console.log(aMessage);
	},
	onPropertyChanged: function(aCalendar, aName, aValue, aOldValue) {},
	onPropertyDeleting: function(aCalendar, aName) {}
}

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

var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.kardia.");
		
updateKardia();

//update periodically based on preferences
function updateKardia() {
	window.setTimeout(function() {
		if (loginValid) {
			// completely refresh/reload
			getTrackTagStaff(prefs.getCharPref("username"), prefs.getCharPref("password"));
		}
		updateKardia();
	}, 60000*prefs.getIntPref("refreshInterval"));
}
	
// what to do when Thunderbird starts up
window.addEventListener("load", function() { 
	// set "show Kardia pane" arrow to the correct image, based on whether it's collapsed
	if (document.getElementById("main-box").collapsed == true) {
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
	}
	
	// get username/password
    var loginInfo = getLogin(false, function(loginInfo2) {

		// store username/password in preferences (this is only important if getLogin() returned something valid)
		var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
		prefs = prefs.getBranch("extensions.kardia.");
		prefs.setCharPref("username",loginInfo2[0]);
		prefs.setCharPref("password",loginInfo2[1]);
		
		//see how many email addresses the person has
		var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);
		var smtpServers = prefs.getCharPref("mail.smtpservers");
		smtpServers = smtpServers.split(",");
		
		// store list of self emails to array so we don't search them in Kardia
		selfEmails = new Array();
		for (var i=0;i<smtpServers.length;i++) {
			selfEmails[i] = prefs.getCharPref("mail.smtpserver." + smtpServers[i] + ".username");
			if (selfEmails[i].indexOf("@") < 0) {
				selfEmails[i] += "@" + prefs.getCharPref("mail.smtpserver." + smtpServers[i] + ".hostname");
			}
		}
		
		getTrackTagStaff(loginInfo2[0], loginInfo2[1]);
	});
	
	// make calendar reload whenever prefs change
	var todosObserver = {
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
	onStartHeaders: function() {findEmails();}
});

window.addEventListener("click", function() {findEmails();}, false);

// what we do to find email addresses from selected messages
function findEmails() {
	// if 0 or > 1 email selected, don't search Kardia
	if (gFolderDisplay.selectedCount < 1 && numSelected >= 1) {
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
				gifts.splice(i,1);
				funds.splice(i,1);
				types.splice(i,1);
				i--;
			}
		}

		// add fake data (really, we should be getting it from Kardia, but we can't until all the CRM stuff is available)
		// FIX STUB by removing this fake stuff
		for (var i=0;i<emailAddresses.length;i++) {
			mainWindow.recentActivity[i] = ["e","2:35p: Hard coded Recent Activity","e","11:40a: Re: Hard coded Recent Activity"];
			//mainWindow.gifts[i] = ["5/2014", "$99.99", "Fund One", "6/2014", "$9.99", "Fund Two","7/2014", "$0.99", "Fund One", "3/2014", "$199.99", "Fund Two"];
			//mainWindow.funds[i] = ["Fund One","Fund Two"];
		}
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
		mainWindow.document.getElementById("bottom-separator").style.visibility = "hidden";
		mainWindow.document.getElementById("record-this-email").style.visibility = "hidden";
		mainWindow.document.getElementById("record-future-emails").style.visibility = "hidden";
		
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
			var arraysToMove = [mainWindow.emailAddresses, mainWindow.ids, mainWindow.addresses, mainWindow.phoneNumbers, mainWindow.allEmailAddresses, mainWindow.websites, mainWindow.engagementTracks, mainWindow.recentActivity, mainWindow.todos, mainWindow.notes, mainWindow.collaborators, mainWindow.documents, mainWindow.tags, mainWindow.data, mainWindow.gifts, mainWindow.funds, mainWindow.types];
			
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
		mainWindow.document.getElementById("bottom-separator").style.visibility = "visible";
		mainWindow.document.getElementById("record-this-email").style.visibility = "visible";
		mainWindow.document.getElementById("record-future-emails").style.visibility = "visible";
		
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
					partners += '<button id="partner-button' + i + '" class="partner-button" label="' + mainWindow.names[i] + ', ID# ' + mainWindow.ids[i] + '" oncommand="choosePartner(\'' + i + '\')"/>';
			}
			mainWindow.document.getElementById("choose-partner-dropdown-menu").innerHTML = partners;
		}
		
		// display contact info based on selected partner
		var contactInfoHTML = "";
		var i;
		for (var i=0;i<mainWindow.addresses[mainWindow.selected].length;i++) {
			var splitAddress = mainWindow.addresses[mainWindow.selected][i].split("\n");
			for (var j=0;j<splitAddress.length;j++) {
				contactInfoHTML += "<label>" + splitAddress[j] + "</label>";
			}
		}
		for (var i=0;i<mainWindow.phoneNumbers[mainWindow.selected].length;i++) {
			contactInfoHTML += "<label>" + mainWindow.phoneNumbers[mainWindow.selected][i] + "</label>";
		}
		for (var i=0;i<mainWindow.allEmailAddresses[mainWindow.selected].length;i++) {
			contactInfoHTML += "<label class='text-link' tooltiptext='Click to compose email' context='emailContextMenu' onclick='if (event.button == 0) sendEmail(\"" + mainWindow.allEmailAddresses[mainWindow.selected][i] + "\")'>" + mainWindow.allEmailAddresses[mainWindow.selected][i] + "</label>";
		}
		for (var i=0;i<mainWindow.websites[mainWindow.selected].length;i++) {
			contactInfoHTML += "<label class='text-link' tooltiptext='Click to open website' context='websiteContextMenu' onclick='if (event.button == 0) openUrl(\"" + mainWindow.websites[mainWindow.selected][i] + "\",true);'>" + mainWindow.websites[mainWindow.selected][i] + "</label>";
		}
		mainWindow.document.getElementById("contact-info-inner-box").innerHTML = contactInfoHTML;
		
		// display engagement tracks
		var tracks = "";
		for (var i=0;i<mainWindow.engagementTracks[mainWindow.selected].length;i+=2) {
			tracks += '<vbox class="engagement-track-color-box" style="background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[mainWindow.selected][i])] + '"><label class="bold-text">' + mainWindow.engagementTracks[mainWindow.selected][i] + '</label><label>Engagement Step: ' + mainWindow.engagementTracks[mainWindow.selected][i+1] + '</label></vbox>';
		}
		tracks += '<hbox><spacer flex="1"/><button class="new-button" label="New Track..." oncommand="newTrack()" tooltiptext="Add engagement track to this partner"/></hbox>';
		mainWindow.document.getElementById("engagement-tracks-inner-box").innerHTML = tracks;				
				
		// display recent activity
		var recent = "";
		for (var i=0;i<mainWindow.recentActivity[mainWindow.selected].length;i+=2) {
			if (mainWindow.recentActivity[mainWindow.selected][i] == "e") {
				recent += '<hbox><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + mainWindow.recentActivity[mainWindow.selected][i+1] + '</label></hbox>';
			}
		}
		mainWindow.document.getElementById("recent-activity-inner-box").innerHTML = recent;	
		
		// display todos
		var toDoText = "";
		for (var i=0;i<mainWindow.todos[mainWindow.selected].length;i+=2) {
			toDoText += '<checkbox id="to-do-item-' + mainWindow.todos[mainWindow.selected][i] + '" oncommand="deleteTodo(' + mainWindow.todos[mainWindow.selected][i] + ')" label="' + mainWindow.todos[mainWindow.selected][i+1] + '"/>';
		}
		mainWindow.document.getElementById("to-dos-inner-box").innerHTML = toDoText;	
		
		// display notes
		var noteText = "";
		for (var i=0;i<mainWindow.notes[mainWindow.selected].length;i+=2) {
			noteText += '<hbox><vbox><spacer height="3"/><image class="note-image"/><spacer flex="1"/></vbox><vbox width="100" flex="1"><description flex="1">' + mainWindow.notes[mainWindow.selected][i] + '</description><description flex="1">' + mainWindow.notes[mainWindow.selected][i+1] + '</description></vbox></hbox>';
		}
		noteText += '<hbox><spacer flex="1"/><button class="new-button" label="New Note/Prayer..." tooltiptext="Create new note/prayer for this partner" oncommand="newNote(\'\',\'\')"/></hbox>';	
		mainWindow.document.getElementById("notes-prayer-inner-box").innerHTML = noteText;
		
		// display collaborators
		var collaboratorText = "";
		for (var i=0;i<mainWindow.collaborators[mainWindow.selected].length;i+=3) {
			// if it's a team/group, show team image  TODO should this be a company?
			if (mainWindow.collaborators[mainWindow.selected][i] == 1) {
				collaboratorText += '<hbox><vbox><image class="team-image"/>';
			}
			else { //if (collaborators[mainWindow.selected][i] == "i") {	//show individual image		// this is commented out so we have a default case
				collaboratorText += '<hbox><vbox><image class="individual-image"/>';
			}
			collaboratorText += '<spacer flex="1"/></vbox><label tooltiptext="Click to view collaborator" width="100" flex="1" class="text-link" onclick="addCollaborator(' + mainWindow.collaborators[mainWindow.selected][i+1] + ')">' + mainWindow.collaborators[mainWindow.selected][i+2] +'</label></hbox>';
		}
		mainWindow.document.getElementById("collaborator-inner-box").innerHTML = collaboratorText;	
		
		// display documents
		var docs = "";
		for (var i=0;i<mainWindow.documents[mainWindow.selected].length;i+=2) {
			docs += '<hbox><vbox><image class="document-image"/><spacer flex="1"/></vbox><label tooltiptext="Click to open document" id="docLabel' + i + '" width="100" flex="1" class="text-link" context="documentContextMenu" onclick="if (event.button == 0) openDocument(\'' + mainWindow.documents[mainWindow.selected][i] + '\',false);">' + mainWindow.documents[mainWindow.selected][i+1] + '</label></hbox>';
		}
		mainWindow.document.getElementById("document-inner-box").innerHTML = docs;
		
		// if Kardia tab is open, add person's info to it, too
		if (kardiaTab != null) {
			// display tags
			kardiaTab.document.getElementById("tab-tags").innerHTML = '<label class="tab-title" value="Tags"/>';

			for (var i=0;i<mainWindow.tags[mainWindow.selected].length;i+=3) {	
				var questionMark = (mainWindow.tags[mainWindow.selected][i+2] <= 0.5) ? "?" : "";
				var filterIndex = mainWindow.tagList.indexOf(mainWindow.tags[mainWindow.selected][i])-1;
				// if positive, use green tags
				if (parseFloat(mainWindow.tags[mainWindow.selected][i+1]) >= 0) {
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + filterIndex + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(86,75%,' + (100-60*mainWindow.tags[mainWindow.selected][i+1]) + '%);"><label value="' + mainWindow.tags[mainWindow.selected][i] + questionMark + '"/></vbox>';
				}
				else {
					// red tags
					kardiaTab.document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + filterIndex + '\', true)" class="tab-tag-color-box" tooltiptext="Click to filter by this tag" style="background-color:hsl(8,100%,' + (100-40*(-1*mainWindow.tags[mainWindow.selected][i+1])) + '%);"><label value="' + mainWindow.tags[mainWindow.selected][i] + questionMark + '"/></vbox>';
				}
			}
			kardiaTab.document.getElementById("tab-tags").innerHTML += '<hbox><spacer flex="1"/><button class="new-button" label="New Tag..." oncommand="newTag()" tooltiptext="Add tag to this partner"/></hbox>';
			
			// display data items
			kardiaTab.document.getElementById("tab-data-items").innerHTML = '<label class="tab-title" value="Data Items"/>';
			for (var i=0;i<mainWindow.data[mainWindow.selected].length;i+=2) {
				if (mainWindow.data[mainWindow.selected][i+1].toString() == "0") {
					// not highlighted, so don't highlight the data item
					kardiaTab.document.getElementById("tab-data-items").innerHTML += '<vbox tooltiptext="Click to filter by this data item" onclick="addFilter(\'d\',\'' + mainWindow.data[mainWindow.selected][i] + '\', false);"><label>' + mainWindow.data[mainWindow.selected][i] + '</label></vbox>';
				}
				else {
					// highlight it
					kardiaTab.document.getElementById("tab-data-items").innerHTML += '<vbox tooltiptext="Click to filter by this data item" class="highlighted" onclick="addFilter(\'d\',\'' + mainWindow.data[mainWindow.selected][i] + '\', false);"><label>' + mainWindow.data[mainWindow.selected][i] + '</label></vbox>';
				}
			}
			
			if (mainWindow.gifts[mainWindow.selected].length <= 0) {
				// show that there is no giving history
				kardiaTab.document.getElementById("tab-no-giving-history").style.display = "inline";
				kardiaTab.document.getElementById("giving-tree").style.visibility = "hidden";
				kardiaTab.document.getElementById("tab-funds").style.visibility = "hidden";
			}
			else {
				kardiaTab.document.getElementById("tab-no-giving-history").style.display = "none";
				kardiaTab.document.getElementById("giving-tree").style.visibility = "visible";
				kardiaTab.document.getElementById("tab-funds").style.visibility = "visible";
			
				// display gifts
				kardiaTab.document.getElementById("giving-tree-children").innerHTML = "";
				for (var i=0;i<mainWindow.gifts[mainWindow.selected].length;i+=4) {
					kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + mainWindow.gifts[mainWindow.selected][i] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+1] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+2] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+3] + '"/></treerow></treeitem>';
				}
				
				// display fund filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML = '<label value="Fund: "/>';
				for (var i=0;i<mainWindow.funds[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-fund").innerHTML += '<checkbox id="filter-gifts-by-f-' + i + '" tooltiptext="Click to filter gifts by this fund" class="tab-filter-checkbox" oncommand="addGiftFilter(\'f\',\'' + i + '\');" label="' + mainWindow.funds[mainWindow.selected][i] + '"/>';
				}
	
				// display type filters for gifts
				kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML = '<label value="Type: "/>';
				for (var i=0;i<mainWindow.types[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-filter-gifts-type").innerHTML += '<checkbox id="filter-gifts-by-t-' + i + '" tooltiptext="Click to filter gifts by this type" class="tab-filter-checkbox" oncommand="addGiftFilter(\'t\',\'' + i + '\');" label="' + mainWindow.types[mainWindow.selected][i] + '"/>';
				}
				
				// display funds
				kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML = '<label class="bold-text" value="Filter partners by fund"/>';
				for (var i=0;i<mainWindow.funds[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-funds-filter-partners").innerHTML += '<vbox tooltiptext="Click to filter partners by this fund" class="tab-fund" onclick="addFilter(\'f\',\'' + mainWindow.funds[mainWindow.selected][i] + '\');"><label>' + mainWindow.funds[mainWindow.selected][i] + '</label></vbox>';
				}
			}
			
			// display dropdown list of person's emails
			kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML = "";
			for (var i=0;i<mainWindow.allEmailAddresses[mainWindow.selected].length;i++) {
				kardiaTab.document.getElementById("tab-filter-select-inner").innerHTML += '<menuitem label="' + mainWindow.allEmailAddresses[mainWindow.selected][i].substring(3, mainWindow.allEmailAddresses[mainWindow.selected][i].length) + '"/>';
			}
			kardiaTab.document.getElementById("tab-filter-select").selectedIndex = 0;
			
			// display dropdown list of addresses and link to map
			if (mainWindow.addresses[mainWindow.selected].length > 0) {
				kardiaTab.document.getElementById("tab-address-map").style.visibility="visible";
				kardiaTab.document.getElementById("tab-address-select-inner").innerHTML = "";
				for (var i=0;i<mainWindow.addresses[mainWindow.selected].length;i++) {
					kardiaTab.document.getElementById("tab-address-select-inner").innerHTML += '<menuitem label="' + mainWindow.addresses[mainWindow.selected][i] + '" style="text-overflow:ellipsis;width:200px;"/>';
				}
				kardiaTab.document.getElementById("tab-address-select").selectedIndex = 0;
				kardiaTab.document.getElementById("tab-map-link").href = "http://www.google.com/maps/place/" + encodeURIComponent(kardiaTab.document.getElementById("tab-address-select").selectedItem.label.substring(3,kardiaTab.document.getElementById("tab-address-select").selectedItem.label.length));
			}
			else {
				// the person has no addresses, so don't show address stuff
				kardiaTab.document.getElementById("tab-address-map").style.visibility="none";
			}
		}
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
	// problems and possible to dos:
	// icons could be added next to notes, collaborators, documents?  They must be unicode characters
	// the fact that we don't want to see printWindow means that the print dialog pops up in the very top of the screen, which is sort of annoying
	
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
	
	for (var i=0;i<mainWindow.addresses[whichPartner].length;i++) {
		var splitAddress = mainWindow.addresses[whichPartner][i].split("\n");
		for (var j=0;j<splitAddress.length;j++) {
			contactPrintString += "</br>" + splitAddress[j];
		}
	}
	for (var i=0;i<mainWindow.phoneNumbers[whichPartner].length;i++) {
		contactPrintString += "</br>" + mainWindow.phoneNumbers[whichPartner][i];
	}
	for (var i=0;i<mainWindow.allEmailAddresses[whichPartner].length;i++) {
		contactPrintString += "</br>" + mainWindow.allEmailAddresses[whichPartner][i];
	}
	for (var i=0;i<mainWindow.websites[whichPartner].length;i++) {
		contactPrintString += "</br>" + mainWindow.websites[whichPartner][i];
		}
	for (var i=0;i<mainWindow.engagementTracks[whichPartner].length;i+=2) {
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
	for (var i=0;i<mainWindow.notes[whichPartner].length;i+=2) {
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
	for (var i=0;i<mainWindow.data[whichPartner].length;i+=2) {
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
						}
					}
				}
				// store temporary array to permanent array
				mainWindow.addresses[index] = addressArray;
				
				// get other contact information
				doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[index] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (phoneResp) {
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
								}
								else if (phoneResp[keys[i]]['contact_type_code'] == "W" || phoneResp[keys[i]]['contact_type_code'] == "B") {
									websiteArray.push(phoneResp[keys[i]]['contact_type_code'] + ": " + phoneResp[keys[i]]['contact']);
								}
								else {
									phoneArray.push(phoneResp[keys[i]]['contact_type_code'] + ": " + phoneResp[keys[i]]['contact']);
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
						// get all the keys from the JSON file
						var keys = [];
						for(var k in trackResp) keys.push(k);
						
						// the key "@id" doesn't correspond to a document, so use all other keys to add track info to temporary array
						var trackArray = new Array();
						for (var i=0;i<keys.length;i++) {
							if (keys[i] != "@id") {
								// add only if this track is current (not completed/exited)
								if (trackResp[keys[i]]['completion_status'] != "c" && trackResp[keys[i]]['completion_status'] != "e") {
									trackArray.push(trackResp[keys[i]]['engagement_track']);
									trackArray.push(trackResp[keys[i]]['engagement_step']);
								}
							}
						}
						// store temporary array to permanent array
						mainWindow.engagementTracks[index] = trackArray;
						
						// get documents information
						doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Documents?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (documentResp) {
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
								// get all the keys from the JSON file
								var keys = [];
								for(var k in noteResp) keys.push(k);

								// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
								var noteArray = new Array();
								for (var i=0;i<keys.length;i++) {
									if (keys[i] != "@id") {
										noteArray.push(noteResp[keys[i]]['subject'] + "- " + noteResp[keys[i]]['notes']);
										noteArray.push(new Date(noteResp[keys[i]]['date_modified']['year'], noteResp[keys[i]]['date_modified']['month']-1, noteResp[keys[i]]['date_modified']['day'], noteResp[keys[i]]['date_modified']['hour'], noteResp[keys[i]]['date_modified']['minute'], noteResp[keys[i]]['date_modified']['second']).toLocaleString());
									}
								}
								// store temporary array to permanent array
								mainWindow.notes[index] = noteArray;
								
								// get collaborators information
								doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] +"/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collaboratorResp) {
									// get all the keys from the JSON file
									var keys = [];
									for(var k in collaboratorResp) keys.push(k);

									// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
									var collaboratorArray = new Array();
									for (var i=0;i<keys.length;i++) {
										if (keys[i] != "@id") {
											collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_type_id']);
											collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_id']);
											collaboratorArray.push(collaboratorResp[keys[i]]['collaborator_name']);
										}
									}
									// store temporary array to permanent array
									mainWindow.collaborators[index] = collaboratorArray;
									
									// get todos information
									doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todosResp) {
										// get all the keys from the JSON file
										var keys = [];
										for(var k in todosResp) keys.push(k);

										// the key "@id" doesn't correspond to a note, so use all other keys to add note info to temporary array
										var todosArray = new Array();
										for (var i=0;i<keys.length;i++) {
											if (keys[i] != "@id") {
												todosArray.push(todosResp[keys[i]]['todo_id']);
												todosArray.push(todosResp[keys[i]]['desc']);
											}
										}
										// store temporary array to permanent array
										mainWindow.todos[index] = todosArray;
									
										// get tags information
										doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
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
												// get all the keys from the JSON file
												var keys = [];
												for(var k in dataResp) keys.push(k);

												// save data items
												var tempArray = new Array();
												for (var i=0; i<keys.length; i++) {
													if (keys[i] != "@id") {
														tempArray.push(dataResp[keys[i]]['item_type_label'] + ": " + dataResp[keys[i]]['item_value']);
														tempArray.push(dataResp[keys[i]]['item_highlight']);
													}
												}
												mainWindow.data[index] = tempArray;
											
												// check donor status
												doHttpRequest("apps/kardia/api/donor/?cx__mode=rest&cx__res_type=collection", function(donorResp) {
													// get all the keys from the JSON file
													var keys = [];
													for (var k in donorResp) keys.push(k);

													// is the partner a donor?
													if (keys.indexOf(mainWindow.ids[index].toString()) >= 0) {
														// get gifts
														doHttpRequest("apps/kardia/api/donor/" + mainWindow.ids[index] + "/Gifts?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(giftResp) {
															
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
															}, false, "", "");
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
											}, false, "", "");				
										}, false, "", "");	
									}, false, "", "");	
								}, false, "", "");
							}, false, "", "");
						}, false, "", "");
					},false, "", "");
				}, false, "", "");
			}, false, "", "");
		}
	}, false, "", "");
}

// get info for one person you're collaborating with
function getCollaborateeInfo(index) {	
	// get the person's engagement tracks
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
		// get all the keys from the JSON file
		var keys = [];
		for(var k in trackResp) keys.push(k);

		// save track info
		var tempArray = new Array();
		for (var i=0;i<keys.length; i++) {
			if (keys[i] != "@id" && trackResp[keys[i]]['is_archived'] != "1") {
				tempArray.push(trackResp[keys[i]]['engagement_track']);
				tempArray.push(trackResp[keys[i]]['engagement_step']);
			}
		}
		mainWindow.collaborateeTracks.push(tempArray);
		
		// get tags
		doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
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
				// get all the keys from the JSON file
				var keys = [];
				for(var k in dataResp) keys.push(k);

				// save data items
				var tempArray = new Array();
				for (var i=0; i<keys.length; i++) {
					if (keys[i] != "@id") {
						tempArray.push(dataResp[keys[i]]['item_type_label'] + ": " + dataResp[keys[i]]['item_value']);
						tempArray.push(dataResp[keys[i]]['item_highlight']);
					}
				}
				mainWindow.collaborateeData.push(tempArray);
			
				doHttpRequest("apps/kardia/api/donor/?cx__mode=rest&cx__res_type=collection", function(donorResp) {
					// get all the keys from the JSON file
					var keys = [];
					for (var k in donorResp) keys.push(k);
					
					// is the partner a donor?
					if (keys.indexOf(mainWindow.collaborateeIds[index]) >= 0) {
						// get gifts
						doHttpRequest("apps/kardia/api/donor/" + mainWindow.collaborateeIds[index] + "/Gifts?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(giftResp) {
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
									
									// reload the Kardia pane so it's blank at first
									reload(false);
								}
								else {
									// go to the next person
									getCollaborateeInfo(index+1);
								}	
							}, false, "", "");
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
							
							// reload the Kardia pane so it's blank at first
							reload(false);
						}
						else {
							// go to the next person
							getCollaborateeInfo(index+1);
						}	
					}
				}, false, "", "");				
			}, false, "", "");	
		}, false, "", "");		
	}, false, "", "");
}
				
// delete the todo with the given id
function deleteTodo(todoId) {
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
					// delete from Kardia  // FIX STUB
					document.getElementById("to-do-item-" + todoId).style.display="none";
					return;
				}
			}  
        }
    };
	
	myCal.getItems(Components.interfaces.calICalendar.ITEM_FILTER_ALL_ITEMS,0,null,null,listener);
}

function newTodo(text) {
	// create new todo
	var todo = Components.classes["@mozilla.org/calendar/todo;1"].createInstance(Components.interfaces.calITodo);	
	todo.title = text;
	
	// find last id used in Kardia and increment
	todo.id="100009";
	
	todo.dueDate = null;
	todo.calendar = myCal;
    createTodoWithDialog(myCal, null, text, todo);
	
	// choose todo type, collaborator, partner, engagement id, document, etc	
	// FIX STUB send todo to Kardia
	window.alert("You sent the todo " + text + " to Kardia!");
}

// import todos into Lightning calendar
function importTodos() {
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
}

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
function getLogin(alreadyFailed, doAfter) {
	var username = "";
	var password = "";
	
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
						// we didn't get success status, so close Kardia pane
						toggleKardiaVisibility(2);
					}
				}
			};
			
			// do nothing if the login request errors
			loginRequest.onerror = function() {};
			
			// send the login HTTP request
			loginRequest.open("GET", loginUrl, true, username, password);
			loginRequest.send(null);
		}
	}
	
	// ask for login info if it's not stored in Login Manager
	if (username == "" && password == "") {
		// open the login dialog
		var returnValues = {username:"", password:"", cancel:false, showFailMessage:alreadyFailed};
		openDialog("chrome://kardia/content/login-dialog.xul", "Login to Kardia", "resizable=yes,chrome,modal,centerscreen=yes", returnValues);
		
		// get the username and password from the dialog's return values
		username = returnValues.username;
		password = returnValues.password;

		// if the user didn't cancel the dialog box, test the login
		if (!returnValues.cancel && username.trim() != '') {
			// try logging in to Kardia using a HTTP request
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
						// we didn't get success status, so ask the user to log in again (they can click cancel to stop this loop)
						getLogin(true, doAfter);
					}
				}
			};
			
			// do nothing if the login request errors
			loginRequest.onerror = function() {};
			
			// send the login HTTP request
			loginRequest.open("GET", loginUrl, false, username, password);
			loginRequest.send(null);
		}
		else if (!returnValues.cancel && username.trim() == '') {
			// blank username, so no need to even try logging in
			//ask the user to log in again (they can click cancel to stop this loop)
			getLogin(true, doAfter);
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

// opens dialog for user to add new engagement track; we can't actually save it because we can't send data to Kardia
function newTrack() {
	// variable where we store our return values
	var returnValues = {track:"", step:""};
	
	// open dialog
	openDialog("chrome://kardia/content/add-track-dialog.xul", "New Engagement Track", "resizable,chrome, modal,centerscreen",trackList, server, returnValues);
	
	// FIX STUB
	if (returnValues.track != "") {
		window.alert("You saved the track " + returnValues.track + " and step " + returnValues.step);
		engagementTracks[selected].push(returnValues.track);
		engagementTracks[selected].push(returnValues.step);
		reload(false);
	}
}

// opens dialog for user to add new note/prayer; we can't actually save it because we can't send data to Kardia
function newNote(title, desc) {
	// where we save returned values	
	var returnValues = {title:title, desc:desc, saveNote:true};
	
	// open dialog
	openDialog("chrome://kardia/content/add-note-prayer.xul", "New Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues);
	
	// FIX STUB
	if (returnValues.saveNote && (returnValues.title.trim() != "" || returnValues.desc.trim() != "")) {
		window.alert("You saved the note " + returnValues.title + "- " + returnValues.desc);
		notes[selected].push(returnValues.title + "- " + returnValues.desc);
		notes[selected].push(new Date().toLocaleString());
		reload(false);
	}
}

// opens dialog for user to add new tag we can't actually save it because we can't send data to Kardia
function newTag() {
	// variable where we store our return values
	var returnValues = {tag:"", magnitude:0.0, certainty:0.0};
	
	// open dialog
	openDialog("chrome://kardia/content/add-tag-dialog.xul", "New Tag", "resizable,chrome, modal,centerscreen", mainWindow.tagList, returnValues);
	
	// FIX STUB
	if (returnValues.tag != "") {
		window.alert("You saved the tag " + returnValues.tag + " with magnitude " + returnValues.magnitude + " and certainty " + returnValues.certainty);
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
	}, true, username, password);
	
	reload(true);
}

// tell Kardia to record this email; we can't do anything yet because we can't send data to Kardia
function recordThisEmail() {	
	// if the box is currently checked, it's about to be unchecked, so don't record the email
	if (document.getElementById("record-this-email").checked) {
		// FIX STUB
		window.alert("You are no longer recording this email in Kardia.");
	}
	else {
		// do record it
		// FIX STUB
		window.alert("You are now recording this email in Kardia.");
	}
}

// tell Kardia to record future emails with this person; we can't do anything yet because we can't send data to Kardia
function recordFutureEmails() {
	// if the box is currently checked, it's about to be unchecked, so don't record future emails
	if (document.getElementById("record-future-emails").checked) {
		// FIX STUB
		window.alert("You are no longer recording future emails with this person in Kardia.");
	}
	else {
		// don't record them
		// FIX STUB
		window.alert("You are now recording future emails with this person in Kardia.");
	}
}

// get info from Kardia with the given parameters
// url - the portion of the url not including the server
// doAfter - the function to do afterwards, which takes the JSON results of the request as a parameter
// authenticate - whether we should send username and password
// username, password - login credentials
function doHttpRequest(url, doAfter, authenticate, username, password) {
	// create HTTP request to get whatever we need
	var httpRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
	var httpUrl = server + url;
	var httpResp;
	
	httpRequest.onreadystatechange  = function(aEvent) {
		// if the request went through and we got success status
		if(httpRequest.readyState == 4 && httpRequest.status == 200) {
			// parse the JSON returned from the request
			doAfter(JSON.parse(httpRequest.responseText));
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
		// get all the keys from the JSON file
		var keys = [];
		for(var k in todoResp) keys.push(k);
		
		// clear todos array
		mainWindow.allTodos = new Array();
		
		// the key "@id" doesn't correspond to a note, so use all other keys to add note info to array
		for (var i=0;i<keys.length;i++) {
			if (keys[i] != "@id") {
				mainWindow.allTodos.push(todoResp[keys[i]]['todo_id']);
				mainWindow.allTodos.push(todoResp[keys[i]]['partner_name'] + "- " + todoResp[keys[i]]['desc']);
				mainWindow.allTodos.push(getTodoDueDate(todoResp[keys[i]]['engagement_start_date'],todoResp[keys[i]]['req_item_due_days_from_step']));
			}
		}
		
		//import todos to calendar
		mainWindow.importTodos();
		
		doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.myId + "/Collaboratees?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collabResp) {

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
		}, false, "", "");
	}, true, username, password);
}

// get e-track list, tag list, me as staff
function getTrackTagStaff(username, password) {	
	// reset Kardia tab sorting
	mainWindow.sortCollaborateesBy = "name";
	mainWindow.sortCollaborateesDescending = true;
	mainWindow.filterBy = "any";
	mainWindow.trackList = new Array();
	mainWindow.trackColors = new Array();
	mainWindow.filterTracks = new Array();
	mainWindow.tagList = new Array();
	mainWindow.filterTags = new Array();
	mainWindow.filterData = new Array();
	mainWindow.filterFunds = new Array();
	mainWindow.giftFilterFunds = new Array();
	mainWindow.giftFilterTypes = new Array();
	
	if (kardiaTab != null) {
		kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
		kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
		kardiaTab.document.getElementById("filter-by-tracks").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Track:"/>';
		kardiaTab.document.getElementById("filter-by-tags").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Tag:"/>';
		kardiaTab.document.getElementById("filter-by-data").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Data items:"/>';
		kardiaTab.reloadFilters(true);
	}

	// get list of engagement tracks and their colors
	doHttpRequest("apps/kardia/api/crm_config/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (trackListResp) {
		// get all the keys from the JSON file
		var keys = [];
		for(var k in trackListResp) keys.push(k);
		
		// the key "@id" doesn't correspond to a track, so use all other keys to save tracks
		for (var i=0;i<keys.length;i++) {
			if (keys[i] != "@id") {
				mainWindow.trackList.push(trackListResp[keys[i]]['track_name']);
				mainWindow.trackColors.push(trackListResp[keys[i]]['track_color']);
				mainWindow.filterTracks.push(false);
			}
		}
		
		// get list of tags
		doHttpRequest("apps/kardia/api/crm_config/TagTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (tagResp) {
			
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
				
			// get my ID		
			findStaff(username, password, function() {
				getMyInfo(username, password);
			});	
		}, false, "", "");
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
			kardiaTab.document.getElementById("giving-tree-children").innerHTML += '<treeitem><treerow><treecell label="' + mainWindow.gifts[mainWindow.selected][i] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+1] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+2] + '"/><treecell label="' + mainWindow.gifts[mainWindow.selected][i+3] + '"/></treerow></treeitem>';
		}
	}
}
