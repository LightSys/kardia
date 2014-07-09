// Stubs to be removed/fixed are marked with comment // FIX STUB
//

// selected email header and number of emails selected (for comparing to see if we need to find users and reload Kardia pane)
var emailHeader = null;
var numSelected = 0;

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

// stuff for Kardia tab-- people you're collaborating with
var collaborateeIds = [];
var collaborateeNames = [];
var collaborateeTracks = [];
var collaborateeActivity = [];
var collaborateeTags = [];
var collaborateeData = [];

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

// my ID for finding self as collaborator, etc
var myId = "";

// how to sort list of collaborating with
var sortCollaborateesBy = "name";
var sortCollaborateesDescending = true;
var filterBy = "any";
var filterTracks = [];
var filterTags = [];
var filterData = [];

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
		
		// get list of engagement tracks and their colors
		doHttpRequest("apps/kardia/api/crm_config/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (trackListResp) {
			// get all the keys from the JSON file
			var keys = [];
			for(var k in trackListResp) keys.push(k);
			
			// the key "@id" doesn't correspond to a track, so use all other keys to save tracks
			for (var i=0;i<keys.length;i++) {
				if (keys[i] != "@id") {
					trackList.push(trackListResp[keys[i]]['track_name']);
					trackColors.push(trackListResp[keys[i]]['track_color']);
					filterTracks.push(false);
				}
			}
		}, true, loginInfo2[0], loginInfo2[1]);
		
		// get list of tags
		doHttpRequest("apps/kardia/api/crm_config/TagTypes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (tagResp) {
			// get all the keys from the JSON file
			var keys = [];
			for(var k in tagResp) keys.push(k);
			
			// the key "@id" doesn't correspond to a tag, so use all other keys to save tags
			for (var i=0;i<keys.length;i++) {
				if (keys[i] != "@id" && tagResp[keys[i]]['is_active']) {
					tagList.push(tagResp[keys[i]]['tag_id']);
					tagList.push(tagResp[keys[i]]['tag_label']);
					filterTags.push(false);
					filterTags.push(false);
				}
			}
		}, true, loginInfo2[0], loginInfo2[1]);
		
		// get my ID		
		findStaff(loginInfo2[0], loginInfo2[1], function() {
			// get all todos and import into calendar
			doHttpRequest("apps/kardia/api/crm/Partners/" + myId + "/CollaboratorTodos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
				// do this after request comes back
				// get all the keys from the JSON file
				var keys = [];
				for(var k in todoResp) keys.push(k);
				
				// clear todos array
				allTodos = new Array();
				
				// the key "@id" doesn't correspond to a note, so use all other keys to add note info to array
				for (var i=0;i<keys.length;i++) {
					if (keys[i] != "@id") {
						allTodos.push(todoResp[keys[i]]['todo_id']);
						allTodos.push(todoResp[keys[i]]['partner_name'] + "- " + todoResp[keys[i]]['desc']);
						allTodos.push(getTodoDueDate(todoResp[keys[i]]['engagement_start_date'],todoResp[keys[i]]['req_item_due_days_from_step']));
					}
				}
				
				//import todos to calendar
				importTodos();
				
				var kardiaTab;
				for (var i=0;i<document.getElementById("tabmail").tabModes["contentTab"].tabs.length;i++) {
					if (document.getElementById("tabmail").tabModes["contentTab"].tabs[i].title == "Kardia") {
						kardiaTab = document.getElementById("tabmail").tabModes["contentTab"].tabs[i];
						break;
					}
				}

				kardiaTab.browser.contentDocument.defaultView.doHttpRequest("apps/kardia/api/crm/Partners/" + myId + "/CollaboratorTodos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
					// do this after request comes back
					// get all the keys from the JSON file
					var keys = [];
					for(var k in todoResp) keys.push(k);

					kardiaTab.browser.contentDocument.getElementById('tab-todos').innerHTML = '<label class="tab-title" value="My To-Dos"/>';
					
					for (var i=0; i<keys.length; i++) {
						if (keys[i] != "@id") {
							kardiaTab.browser.contentDocument.getElementById("tab-todos").innerHTML += '<checkbox label="' + todoResp[keys[i]]['desc'] + ' for ' + todoResp[keys[i]]['partner_name'] + '"/>';
						}
					}
				}, false, "", "");
						
				kardiaTab.browser.contentDocument.defaultView.doHttpRequest("apps/kardia/api/crm/Partners/" + myId + "/Collaboratees?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collabResp) {
					// do this after request comes back
					// refresh collaboratees
					collaborateeIds = new Array();
					collaborateeNames = new Array();
					collaborateeTracks = new Array();
					collaborateeActivity = new Array();
					collaborateeTags = new Array();
					collaborateeData = new Array();
					
					// get all the keys from the JSON file
					var keys = [];
					for(var k in collabResp) keys.push(k);
					
					// save to arrays
					for (var i=0; i<keys.length; i++) {
						if (keys[i] != "@id") {
							collaborateeIds.push(collabResp[keys[i]]['partner_id']);
							collaborateeNames.push(collabResp[keys[i]]['partner_name']);	
						}
					}
					
					// reload the Kardia pane so it's blank at first
					reload(true);
			
					// get other info
					getCollaborateeInfo(0);
				}, false, "", "");
			}, true, loginInfo2[0], loginInfo2[1]);
		});			
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
	var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
	prefs = prefs.getBranch("extensions.kardia.");
	prefs.setCharPref("username","");
	prefs.setCharPref("password","");
}, false);

// what to do when the user clicks something
window.addEventListener("click", function(e) {
	// if 0 or > 1 email selected, don't search Kardia
	if (gFolderDisplay.selectedCount != 1 && numSelected == 1) {
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
		
		// show a blank Kardia pane
		reload(true);
	}
	
	// if one email is selected and it wasn't already selected
	if (gFolderDisplay.selectedCount == 1 && emailHeader != gFolderDisplay.selectedMessage) {
		// select the 0th partner and generate a new list of partners
		selected = 0;
			
		// get email addresses involved in this email message
		var parser = Components.classes["@mozilla.org/messenger/headerparser;1"].getService(Components.interfaces.nsIMsgHeaderParser);
		var senderAddress = {};
		var recipientAddresses = {};
		var ccAddresses = {};
		var bccAddresses = {};
		parser.parseHeadersWithArray(gFolderDisplay.selectedMessage.author, senderAddress, {}, {});
		parser.parseHeadersWithArray(gFolderDisplay.selectedMessage.recipients, recipientAddresses, {}, {});
		parser.parseHeadersWithArray(gFolderDisplay.selectedMessage.ccList, ccAddresses, {}, {});
		parser.parseHeadersWithArray(gFolderDisplay.selectedMessage.bccList, bccAddresses, {}, {});
				
		// combine list of addresses
		var allAddresses = senderAddress.value.concat(recipientAddresses.value);
		allAddresses = allAddresses.concat(ccAddresses.value);
		allAddresses = allAddresses.concat(bccAddresses.value);
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
				i--;
			}
		}
		
		// get data from Kardia
		findUser(0);
		
		// add fake data (really, we should be getting it from Kardia, but we can't until CRM stuff is available)
		// FIX STUB by removing this fake stuff
		for (var i=0;i<emailAddresses.length;i++) {
			recentActivity[i] = ["e","2:35p: Hard coded Recent Activity","e","11:40a: Re: Hard coded Recent Activity"];
			//todos[i] = ["0","To-Do Item 0","1","To-Do Item 1","2","To-Do Item 2"];
			//collaborators[i] = ["t","100002","Jane Smith Team","i","100003", "Greg Beeley"];
			//documents[i] = ["http://www.google.com","Google","http://www.google.com/sites/overview.html","Google html","http://www.irs.gov/pub/irs-pdf/fw4.pdf","Application-Sam Froese.pdf","http://www.acm.org/sigs/publications/pubform.doc","Other Document.doc"];
		}
		
		// save email header so we can see if we still have the same one selected later
		emailHeader = gFolderDisplay.selectedMessage;
	}
		
	// save number of emails selected so we can see if the number of emails selected has changed later
	numSelected = gFolderDisplay.selectedCount;
	
}, false);

// reloads Kardia pane
function reload(isDefault) {		
	// get Kardia tab
	var kardiaTab;
	for (var i=0;i<document.getElementById("tabmail").tabModes["contentTab"].tabs.length;i++) {
		if (document.getElementById("tabmail").tabModes["contentTab"].tabs[i].title == "Kardia") {
			kardiaTab = document.getElementById("tabmail").tabModes["contentTab"].tabs[i];
			break;
		}
	}
	
		// reset Kardia tab sorting
	sortCollaborateesBy = "name";
	sortCollaborateesDescending = true;
	filterBy = "any";

	// if 0 or > 1 emails are selected, we don't display partners, so hide Print context menu if that's the case
	if (emailAddresses.length < 1 || emailAddresses == null) {
		document.getElementById('main-context').hidden = true;
	}
	else {
		document.getElementById('main-context').hidden = false;
	}
	
	// if list of email addresses is empty or null, make everything in Kardia pane blank or hidden
	if (emailAddresses.length < 1 || emailAddresses == null) {
		document.getElementById("name-label").value = "";
		document.getElementById("id-label").value = "";
		document.getElementById("choose-partner-dropdown-button").style.display = "none";
		
		document.getElementById("main-content-box").style.visibility = "hidden";
		document.getElementById("bottom-separator").style.visibility = "hidden";
		document.getElementById("record-this-email").style.visibility = "hidden";
		document.getElementById("record-future-emails").style.visibility = "hidden";
		
		kardiaTab.browser.contentDocument.getElementById("tab-bottom-hbox").style.visibility = "hidden";
		kardiaTab.browser.contentDocument.getElementById("tab-address-map").style.visibility="hidden";
		kardiaTab.browser.contentDocument.getElementById("tab-bottom-name").value = "";
	}
	else if (names[selected] != null && ids[selected] != null) {	// if and only if currently selected partner is not null, we can sort the list
		// sort all items by name order
		var firstIndex;
		var firstItem;
		for (var i=0;i<ids.length;i++) {
			// determine order by first name
			firstIndex = i;
			firstItem = names[i];
			for (var j=i+1;j<names.length;j++) {
				if (firstItem > names[j]) {
					firstIndex = j;
					firstItem = names[j];
				}
			}
			
			names[firstIndex] = names[i];
			names[i] = firstItem;
			
			if (i == selected) {
				selected = firstIndex;
			}
			else if (firstIndex == selected) {
				selected = i;
			}
			
			// move all other items around based on how we sorted names
			firstItem = emailAddresses[firstIndex];
			emailAddresses[firstIndex] = emailAddresses[i];
			emailAddresses[i] = firstItem;
			
			firstItem = ids[firstIndex];
			ids[firstIndex] = ids[i];
			ids[i] = firstItem;

			firstItem = addresses[firstIndex];
			addresses[firstIndex] = addresses[i];
			addresses[i] = firstItem;

			firstItem = phoneNumbers[firstIndex];
			phoneNumbers[firstIndex] = phoneNumbers[i];
			phoneNumbers[i] = firstItem;
			
			firstItem = allEmailAddresses[firstIndex];
			allEmailAddresses[firstIndex] = allEmailAddresses[i];
			allEmailAddresses[i] = firstItem;
			
			firstItem = websites[firstIndex];
			websites[firstIndex] = websites[i];
			websites[i] = firstItem;
			
			firstItem = engagementTracks[firstIndex];
			engagementTracks[firstIndex] = engagementTracks[i];
			engagementTracks[i] = firstItem;
			
			firstItem = recentActivity[firstIndex];
			recentActivity[firstIndex] = recentActivity[i];
			recentActivity[i] = firstItem;
			
			firstItem = todos[firstIndex];
			todos[firstIndex] = todos[i];
			todos[i] = firstItem;
			
			firstItem = notes[firstIndex];
			notes[firstIndex] = notes[i];
			notes[i] = firstItem;
			
			firstItem = collaborators[firstIndex];
			collaborators[firstIndex] = collaborators[i];
			collaborators[i] = firstItem;
			
			firstItem = documents[firstIndex];
			documents[firstIndex] = documents[i];
			documents[i] = firstItem;
		}
		
		// if we're loading the pane for the first time, select the first (0th) item
		if (isDefault) {
			selected = 0;
		}

		// add name to Kardia tab
		if (kardiaTab != null) {
			kardiaTab.browser.contentDocument.getElementById("tab-bottom-name").value = names[selected];
		}

		// show content boxes in case they're hidden
		document.getElementById("main-content-box").style.visibility = "visible";
		document.getElementById("bottom-separator").style.visibility = "visible";
		document.getElementById("record-this-email").style.visibility = "visible";
		document.getElementById("record-future-emails").style.visibility = "visible";
		kardiaTab.browser.contentDocument.getElementById("tab-bottom-hbox").style.visibility = "visible";
		kardiaTab.browser.contentDocument.getElementById("tab-address-map").style.visibility="visible";
		
		// show name and id of selected partner
		document.getElementById("name-label").value = names[selected];
		document.getElementById("id-label").value = "ID# " + ids[selected];

						
		// if only one partner available, hide dropdown arrow
		if (names.length <= 1) {
			document.getElementById("choose-partner-dropdown-button").style.display = "none";
		}
		else {		
			// show dropdown
			document.getElementById("choose-partner-dropdown-button").style.display = "inline";
			
			// set partner options based on list of names
			var partners = "";
			for (var i=0;i<names.length;i++) {
					partners += '<button id="partner-button' + i + '" class="partner-button" label="' + names[i] + ', ID# ' + ids[i] + '" oncommand="choosePartner(\'' + i + '\')"/>';
			}
			document.getElementById("choose-partner-dropdown-menu").innerHTML = partners;
		}
		
		// set contact info based on selected partner
		var contactInfoHTML = "";
		var i;
		for (var i=0;i<addresses[selected].length;i++) {
			var splitAddress = addresses[selected][i].split("\n");
			for (var j=0;j<splitAddress.length;j++) {
				contactInfoHTML += "<label>" + splitAddress[j] + "</label>";
			}
		}
		for (var i=0;i<phoneNumbers[selected].length;i++) {
			contactInfoHTML += "<label>" + phoneNumbers[selected][i] + "</label>";
		}
		for (var i=0;i<allEmailAddresses[selected].length;i++) {
			contactInfoHTML += "<label class='text-link' context='emailContextMenu' onclick='if (event.button == 0) sendEmail(\"" + allEmailAddresses[selected][i] + "\")'>" + allEmailAddresses[selected][i] + "</label>";
		}
		for (var i=0;i<websites[selected].length;i++) {
			contactInfoHTML += "<label class='text-link' context='websiteContextMenu' onclick='if (event.button == 0) openUrl(\"" + websites[selected][i] + "\",true);'>" + websites[selected][i] + "</label>";
		}
		document.getElementById("contact-info-inner-box").innerHTML = contactInfoHTML;
		
		// set engagement tracks
		var tracks = "";
		for (var i=0;i<engagementTracks[selected].length;i+=2) {
			tracks += '<vbox class="engagement-track-color-box" style="background-color:' + trackColors[trackList.indexOf(engagementTracks[selected][i])] + '"><label class="bold-text">' + engagementTracks[selected][i] + '</label><label>Engagement Step: ' + engagementTracks[selected][i+1] + '</label></vbox>';
		}
		tracks += '<hbox><spacer flex="1"/><button class="new-button" label="New Track..." oncommand="newTrack()"/></hbox>';
		document.getElementById("engagement-tracks-inner-box").innerHTML = tracks;				
				
		// set recent activity
		var recent = "";
		for (var i=0;i<recentActivity[selected].length;i+=2) {
			if (recentActivity[selected][i] == "e") {
				recent += '<hbox><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + recentActivity[selected][i+1] + '</label></hbox>';
			}
		}
		document.getElementById("recent-activity-inner-box").innerHTML = recent;	
		
		// set todos
		var toDoText = "";
		for (var i=0;i<todos[selected].length;i+=2) {
			toDoText += '<checkbox id="to-do-item-' + todos[selected][i] + '" oncommand="deleteTodo(' + todos[selected][i] + ')" label="' + todos[selected][i+1] + '"/>';
		}
		document.getElementById("to-dos-inner-box").innerHTML = toDoText;	
		
		// set notes
		var noteText = "";
		for (var i=0;i<notes[selected].length;i+=2) {
			noteText += '<hbox><vbox><spacer height="3"/><image class="note-image"/><spacer flex="1"/></vbox><vbox width="100" flex="1"><description flex="1">' + notes[selected][i] + '</description><description flex="1">' + notes[selected][i+1] + '</description></vbox></hbox>';
		}
		noteText += '<hbox><spacer flex="1"/><button class="new-button" label="New Note/Prayer..." oncommand="newNote(\'\',\'\')"/></hbox>';	
		document.getElementById("notes-prayer-inner-box").innerHTML = noteText;
		
		// set collaborators
		var collaboratorText = "";
		for (var i=0;i<collaborators[selected].length;i+=3) {
			// if it's a team, show team image  TODO should this be a company?
			if (collaborators[selected][i] == 1) {
				collaboratorText += '<hbox><vbox><image class="team-image"/>';
			}
			else { //if (collaborators[selected][i] == "i") {	//show individual image
			// the if part is commented out so we have a default case, but may need to be put back if we have more options than team and individual
				collaboratorText += '<hbox><vbox><image class="individual-image"/>';
			}
			collaboratorText += '<spacer flex="1"/></vbox><label width="100" flex="1" class="text-link" onclick="addCollaborator(' + collaborators[selected][i+1] + ')">' + collaborators[selected][i+2] +'</label></hbox>';
		}
		document.getElementById("collaborator-inner-box").innerHTML = collaboratorText;	
		
		// set documents
		var docs = "";
		for (var i=0;i<documents[selected].length;i+=2) {
			docs += '<hbox><vbox><image class="document-image"/><spacer flex="1"/></vbox><label id="docLabel' + i + '" width="100" flex="1" class="text-link" context="documentContextMenu" onclick="if (event.button == 0) openDocument(\'' + documents[selected][i] + '\',false);">' + documents[selected][i+1] + '</label></hbox>';
		}
		document.getElementById("document-inner-box").innerHTML = docs;
		
		// reload Kardia tab tags
		kardiaTab.browser.contentDocument.getElementById("tab-tags").innerHTML = "";
		for (var i=0;i<collaborateeTags[selected].length;i+=3) {
			var questionMark = (collaborateeTags[selected][i+2] <= 0.5) ? "?" : "";
			var filterIndex = tagList.indexOf(collaborateeTags[selected][i+1]-1);
			kardiaTab.browser.contentDocument.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + filterIndex + '\', true)" class="tab-tag-color-box" style="background-color:hsl(46,100%,' + (100-50*collaborateeTags[selected][i+1]) + '%);"><label value="' + collaborateeTags[selected][i] + questionMark + '"/></vbox>';
		}
		
		// reload Kardia tab data items
		kardiaTab.browser.contentDocument.getElementById("tab-data-items").innerHTML = '<label class="tab-title" value="Data Items"/>';
		for (var i=0;i<collaborateeData[selected].length;i+=2) {
			if (collaborateeData[selected][i+1].toString() == "0") {
				kardiaTab.browser.contentDocument.getElementById("tab-data-items").innerHTML += '<vbox onclick="addFilter(\'d\',\'' + collaborateeData[selected][i] + '\', false);"><label>' + collaborateeData[selected][i] + '</label></vbox>';
			}
			else {
				// highlight it
				kardiaTab.browser.contentDocument.getElementById("tab-data-items").innerHTML += '<vbox onclick="highlighted" oncommand="addFilter(\'d\',\'' + collaborateeData[selected][i] + '\', false);"><label>' + collaborateeData[selected][i] + '</label></vbox>';
			}
		}
		
		// reload list of emails in Kardia tab
		kardiaTab.browser.contentDocument.getElementById("tab-filter-select-inner").innerHTML = "";
		for (var i=0;i<allEmailAddresses[selected].length;i++) {
			kardiaTab.browser.contentDocument.getElementById("tab-filter-select-inner").innerHTML += '<menuitem label="' + allEmailAddresses[selected][i].substring(3, allEmailAddresses[selected][i].length) + '"/>';
		}
		kardiaTab.browser.contentDocument.getElementById("tab-filter-select").selectedIndex = 0;
		
		// add link to map in Kardia tab
		// add list of addresses
		if (addresses[selected].length > 0) {
			kardiaTab.browser.contentDocument.getElementById("tab-address-map").style.visibility="visible";
			kardiaTab.browser.contentDocument.getElementById("tab-address-select-inner").innerHTML = "";
			for (var i=0;i<addresses[selected].length;i++) {
				kardiaTab.browser.contentDocument.getElementById("tab-address-select-inner").innerHTML += '<menuitem label="' + addresses[selected][i] + '"/>';
			}
			kardiaTab.browser.contentDocument.getElementById("tab-address-select").selectedIndex = 0;
			kardiaTab.browser.contentDocument.getElementById("tab-map-link").href="http://www.google.com/maps/place/" + kardiaTab.browser.contentDocument.getElementById("tab-address-select").selectedItem.label.substring(3,kardiaTab.browser.contentDocument.getElementById("tab-address-select").selectedItem.label.length).replace(/ /g, "+");
		}
		else {
			// no addresses, don't show it
			kardiaTab.browser.contentDocument.getElementById("tab-address-map").style.visibility="none";
		}
	}
}

// copy location of clicked link to clipboard
function copyLinkLocation() {
	var websiteAddress = document.popupNode.textContent;
    var clipboard = Components.classes["@mozilla.org/widget/clipboardhelper;1"].getService(Components.interfaces.nsIClipboardHelper);
    clipboard.copyString(websiteAddress.substring(3,websiteAddress.length));
}

// copy location of document to clipboard
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
		
		// save or open, depending on parameter
		// note: html files work, but they don't show a "save as type"
		if (savePage) {
			// not sure why we're getting MIME type twice, but it fails if we take these two lines out
			var mimeService = Components.classes["@mozilla.org/mime;1"].getService().QueryInterface(Components.interfaces.nsIMIMEService);
			var mimeType = mimeService.getTypeFromURI(uriToOpen);
		
			// start save process
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
			// get MIME type and open the file in the appropriate program
			var mimeService = Components.classes["@mozilla.org/mime;1"].getService().QueryInterface(Components.interfaces.nsIMIMEService);
			var mimeType = mimeService.getTypeFromURI(uriToOpen);
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
function printPartner() {	
	// problems and possible to dos:
	// icons could be added next to notes, collaborators, documents?  They must be unicode characters
	// the fact that we don't want to see printWindow means that the print dialog pops up in the very top of the screen, which is sort of annoying
	
	// open new hidden window where we'll put content to print
	var printWindow = window.open("chrome://kardia/content/main-overlay.xul", "test-window", "chrome,left=0,top=-1000,width=1,height=1,toolbar=0,scrollbars=0,status=0");
	
	// it probably is bad practice to hard-code the style, but this is the only way it will work (the window is fussy)
	// get information displayed in main-box and write it to printWindow
	var todosPrintString = "";
	var documentsPrintString = "";
	var i=0;
	while (document.getElementById('to-do-item-' + i) != null) {
		todosPrintString += "</br>&#x2610  " + document.getElementById('to-do-item-' + i).label;
		i++;
	}
	i = 0;
	while (document.getElementById("docLabel" + i) != null) {
		documentsPrintString += "</br>" + document.getElementById("docLabel" + i).innerHTML + "&nbsp;&nbsp;<span style='text-decoration:underline;'>" + document.getElementById("docLabel" + i).onclick.toString().replace("function onclick(event) {","").replace("if (event.button == 0) openDocument('","").replace("',false);","").replace("}","").trim() + "</span>";
		i+=2;
	}
	printWindow.document.write(
		"<span style='font-size:24px; font-weight:bold; font-family:Arial,sans-serif;'>" 
		+ document.getElementById("name-label").value 
		+ "</span> " 
		+ document.getElementById("id-label").value 
		+ "</br></br><b>Contact Information:</b></br>" 
		+ document.getElementById("contact-info-inner-box").innerHTML.replace(/<\/label>/g, "<\label></br>") 
		+ "</br><b>Engagement Tracks:</b>" 
		+ document.getElementById("engagement-tracks-inner-box").innerHTML.replace(/<label>/g, "<label></b>; ").replace(/<label class="bold-text">/g, "<label></br><b>").replace('<button class="new-button" label="New Track..."', "").replace('oncommand="newTrack()"/>', "") 
		+ "</br></br><b>Recent Activity:</b>" 
		+ document.getElementById("recent-activity-inner-box").innerHTML.replace(/<vbox><image class="email-image"\/><spacer flex="1"\/><\/vbox><label width="100" flex="1">/g, "</br><label>&#x2709 ") 
		+ "</br></br><b>To Dos:</b>" 
		+ todosPrintString 
		+ "</br></br><b>Notes and Prayer:</b></br>" 
		+ document.getElementById("notes-prayer-inner-box").innerHTML.replace(/<hbox xmlns="http:\/\/www.mozilla.org\/keymaster\/gatekeeper\/there.is.only.xul"><vbox><image class="note-image"\/><spacer flex="1"\/><\/vbox><description width="100" flex="1">/g, "").replace(/<hbox xmlns="http:\/\/www.mozilla.org\/keymaster\/gatekeeper\/there.is.only.xul"><spacer flex="1"\/><button class="new-button" label="New Note\/Prayer..." oncommand="newNote\(''\)"\/><\/hbox>/g,"</br>").replace(/<\/description><\/hbox>/g, "</br>") 
		+ "<b>Collaborators:</b></br>" 
		+ document.getElementById("collaborator-inner-box").innerHTML.replace(/<hbox xmlns="http:\/\/www.mozilla.org\/keymaster\/gatekeeper\/there.is.only.xul"><vbox><image class="team-image"\/><spacer flex="1"\/><\/vbox><label width="100" flex="1" class="text-link" onclick="addCollaborator\(/g, "").replace(/<\/label>/g,"</br>").replace(/\)">/g,"").replace(/<\/hbox>/g,"").replace(/<hbox xmlns="http:\/\/www.mozilla.org\/keymaster\/gatekeeper\/there.is.only.xul"><vbox><image class="individual-image"\/><spacer flex="1"\/><\/vbox><label width="100" flex="1" class="text-link" onclick="addCollaborator\(/g, "").replace(/\d/g,"") 
		+ "</br><b>Documents:</b>" 
		+ documentsPrintString
	);
	
	// print printWindow, then close it
	printWindow.print();
	printWindow.close();
}

// find partner in Kardia based on the email address found at position index in the list of email addresses
function findUser(index) {		
	// don't try to access Kardia if the Thunderbird user's login is invalid
	if (loginValid) {
		// start getting username and password from preferences
		var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
		prefs = prefs.getBranch("extensions.kardia.");
		
		// remove dashes from email address so Kardia will take it
		var emailAddress = emailAddresses[index].replace("-","");	
		
		// create HTTP request to get info about partners for the given email address
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
							
				// if the first partner found isn't already in the list, add them to the list
				if (arrayContains(ids, emailResp[keys[1]]['partner_id'], 1) < 0) {
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
				}
				
				// how many extra partners did we add from this email address?
				var numExtra = 0;
				
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
						numExtra++;
					}
				}
				
				// if we aren't at the end of the list of email addresses, find partners for the next address
				if (index+1+numExtra < emailAddresses.length) {
					findUser(index+1+numExtra);
				}
				else {
					// start getting the other information about all the partners we found
					getOtherInfo(0, true, false);
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
				reload(true);
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
function getOtherInfo(index, isDefault, useReload2) {	
	// is user valid?
	var validUser = true;
	
	// get partner name
	doHttpRequest("apps/kardia/api/partner/Partners/" + ids[index] + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic", function (nameResp) {
		// if the partner is not valid
		if (nameResp['is_valid'] == 0 ) {
			validUser = false;
			emailAddresses[index] = "";
			ids[index] = "";
		}
		
		// store partner's name
		names[index] = nameResp['partner_name'];
		
		// get more information only if the partner is valid
		if (validUser) {
			// get address information
			doHttpRequest("apps/kardia/api/partner/Partners/" + ids[index] + "/Addresses?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (addressResp) {
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
				addresses[index] = addressArray;
				
				// get other contact information
				doHttpRequest("apps/kardia/api/partner/Partners/" + ids[index] + "/ContactInfo?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (phoneResp) {
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
					phoneNumbers[index] = phoneArray;
					allEmailAddresses[index] = emailArray;
					websites[index] = websiteArray;
					
					// get engagement tracks information
					doHttpRequest("apps/kardia/api/crm/Partners/" + ids[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
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
						engagementTracks[index] = trackArray;
						
						// get documents information
						// get notes/prayer information
						doHttpRequest("apps/kardia/api/crm/Partners/" + ids[index] + "/Documents?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (documentResp) {
							// do this after request comes back
							// get all the keys from the JSON file
							var keys = [];
							for(var k in documentResp) keys.push(k);

							// the key "@id" doesn't correspond to a document, so use all other keys to add document info to temporary array
							var documentArray = new Array();
							for (var i=0;i<keys.length;i++) {
								if (keys[i] != "@id") {
									// TODO where is "location" -- in apps/kardia, or in the server's home directory?  We leave it this way for now
									documentArray.push(server + documentResp[keys[i]]['location']);
									documentArray.push(documentResp[keys[i]]['title']);
								}
							}
							// store temporary array to permanent array
							documents[index] = documentArray;
							
							// get notes/prayer information
							doHttpRequest("apps/kardia/api/crm/Partners/" + ids[index] + "/ContactHistory?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (noteResp) {
								// do this after request comes back
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
								notes[index] = noteArray;
								
								// get collaborators information
								doHttpRequest("apps/kardia/api/crm/Partners/" + ids[index] +"/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collaboratorResp) {
									// do this after request comes back
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
									collaborators[index] = collaboratorArray;
									
									// get todos information
									doHttpRequest("apps/kardia/api/crm/Partners/" + ids[index] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todosResp) {
										// do this after request comes back
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
										todos[index] = todosArray;
									
										// if there are more partners left to check, go to the next one
										if (index+1 < emailAddresses.length) {
											getOtherInfo(index+1, true, useReload2);
										}
										else {
											// done, so reload Kardia pane
											if (useReload2) {
												reload2(isDefault, null);
											}
											else {
												reload(isDefault);
											}
										}
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

// get info for people you're collaborating with
function getCollaborateeInfo(index) {
	var kardiaTab;
	for (var i=0;i<document.getElementById("tabmail").tabModes["contentTab"].tabs.length;i++) {
		if (document.getElementById("tabmail").tabModes["contentTab"].tabs[i].title == "Kardia") {
			kardiaTab = document.getElementById("tabmail").tabModes["contentTab"].tabs[i];
			break;
		}
	}
	
	kardiaTab.browser.contentDocument.defaultView.doHttpRequest("apps/kardia/api/crm/Partners/" + collaborateeIds[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
		// do this after request comes back
		// get all the keys from the JSON file
		var keys = [];
		for(var k in trackResp) keys.push(k);

		// save to arrays
		var tempArray = new Array();
		for (var i=0;i<keys.length; i++) {
			if (keys[i] != "@id" && trackResp[keys[i]]['is_archived'] != "1") {
				tempArray.push(trackResp[keys[i]]['engagement_track']);
				tempArray.push(trackResp[keys[i]]['engagement_step']);
			}
		}
		collaborateeTracks.push(tempArray);
		
		// get tags
		kardiaTab.browser.contentDocument.defaultView.doHttpRequest("apps/kardia/api/crm/Partners/" + collaborateeIds[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
			// get tag info
			// get all the keys from the JSON file
			var keys = [];
			for(var k in tagResp) keys.push(k);

			// save to arrays
			var tempArray = new Array();
			for (var i=0; i<keys.length; i++) {
				if (keys[i] != "@id") {
					tempArray.push(tagResp[keys[i]]['tag_label']);
					tempArray.push(tagResp[keys[i]]['tag_strength']);
					tempArray.push(tagResp[keys[i]]['tag_certainty']);
				}
			}
			collaborateeTags.push(tempArray);
			
			// get data items
			kardiaTab.browser.contentDocument.defaultView.doHttpRequest("apps/kardia/api/crm/Partners/" + collaborateeIds[index] + "/DataItems?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(dataResp) {
				// get all the keys from the JSON file
				var keys = [];
				for(var k in dataResp) keys.push(k);

				// save to arrays
				var tempArray = new Array();
				for (var i=0; i<keys.length; i++) {
					if (keys[i] != "@id") {
						tempArray.push(dataResp[keys[i]]['item_type_label'] + ": " + dataResp[keys[i]]['item_value']);
						tempArray.push(dataResp[keys[i]]['item_highlight']);
					}
				}
				collaborateeData.push(tempArray);
			
				if (index+1 >= collaborateeIds.length) {
					kardiaTab.browser.contentDocument.getElementById("tab-tags").innerHTML = '<label class="tab-title" value="Tags"/>';
					kardiaTab.browser.contentDocument.defaultView.sortCollaboratees(collaborateeNames, collaborateeIds, collaborateeTracks, collaborateeTags, collaborateeData, sortCollaborateesBy, sortCollaborateesDescending);
					
					// add to collaborators view	
					kardiaTab.browser.contentDocument.getElementById("tab-collaborators-inner").innerHTML = '';
					for (var i=0;i<collaborateeIds.length;i++) {					
						var addString = '<hbox class="tab-collaborator" onclick="addCollaborator2(' + collaborateeIds[i] + ')"><vbox class="tab-collaborator-name"><label class="bold-text" value="' + collaborateeNames[i] + '"/><label value="ID# ' + collaborateeIds[i] + '"/></vbox>';
						
						if (collaborateeTracks[i].length > 1) {
							addString += '<vbox>';
							for (var j=0;j<collaborateeTracks[i].length;j+=2) {
								if (collaborateeTracks[i][j] != "" && collaborateeTracks[i][j+1] != "") { 
									var filterIndex = trackList.indexOf(collaborateeTracks[i][j]);
									addString += '<vbox onclick="addFilter(\'e\',\'' + filterIndex + '\', true)" class="tab-engagement-track-color-box" style="background-color:' + trackColors[trackList.indexOf(collaborateeTracks[i][j])] + '"><label class="bold-text">' + collaborateeTracks[i][j] + '</label><label>Engagement Step: ' + collaborateeTracks[i][j+1] + '</label></vbox>';
								}
							}
							addString += '</vbox>';
						}
						addString += '<hbox flex="1"><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + '2:35p: Hard-Coded Recent Activity' + '</label></hbox>';
						
						if (collaborateeData[i].length > 1) {
							addString += '<vbox>';
							for (var j=0;j<collaborateeData[i].length;j+=2) {
								if (collaborateeData[i][j+1] == "1") { 
									addString += '<button oncommand="addFilter(\'d\',\'' + collaborateeData[i][j] + '\', false);" class="highlighted" label="' + collaborateeData[i][j] + '"/>';
								}
							}
							addString += '</vbox>';
						}
						
						addString += '<spacer flex="2"/><vbox><spacer flex="1"/><image class="tab-select-partner"/><spacer flex="1"/></vbox></hbox>';
						
						kardiaTab.browser.contentDocument.getElementById("tab-collaborators-inner").innerHTML += addString;
						// FIX STUB should also have recent activity
					}
						
					// add engagement track filter buttons
					kardiaTab.browser.contentDocument.getElementById("filter-by-tracks").innerHTML = "<label value='Track:'/>";
					for (var i=0;i<trackList.length;i++) {
						kardiaTab.browser.contentDocument.getElementById("filter-by-tracks").innerHTML += '<checkbox id="filter-by-e-' + i + '" class="tab-filter-checkbox" checked="false" label="' + trackList[i] + '" oncommand="addFilter(\'e\', ' + i + ', false)"/>';
					}
					
					// add tag filter buttons
					kardiaTab.browser.contentDocument.getElementById("filter-by-tags").innerHTML = "<label value='Tag:'/>";
					for (var i=0;i<tagList.length;i+=2) {
						kardiaTab.browser.contentDocument.getElementById("filter-by-tags").innerHTML += '<checkbox id="filter-by-t-' + i + '" class="tab-filter-checkbox" checked="false" label="' + tagList[i+1] + '" oncommand="addFilter(\'t\', ' + i + ', false)"/>';
					}
					
					// reload the Kardia pane so it's blank at first
					reload(true);
				}
				else {
					getCollaborateeInfo(index+1);
				}	
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
				// delete item if id is the same
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
	var todo = Components.classes["@mozilla.org/calendar/todo;1"].createInstance(Components.interfaces.calITodo);	
	todo.title = text;
	
	// find last id used in Kardia and increment
	todo.id="100009";
	
	todo.dueDate = null;
	todo.calendar = myCal;
    createTodoWithDialog(myCal, null, text, todo);
	
	// choose todo type, collaborator, partner, engagement id, document, etc	
	// send todo to Kardia
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
	
	var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
	prefs = prefs.getBranch("extensions.kardia.");
	var addToEvents = (prefs.getCharPref("importTodoAsEvent")=="e");
	var addTodosWithNoDate = prefs.getBoolPref("showTodosWithNoDate");
	
	var item;
	var todoAdded = new Array();
	for (var i=0;i<allTodos.length;i++) {
		todoAdded.push(false);
	}
			
	var listener = {
        onOperationComplete: function(aCalendar, aStatus, aOperationType, aId, aDetail)
        {
			// add ones that weren't added
			for (var i=0;i<allTodos.length;i+=3) {
				if (!todoAdded[i]) {					
					if (addToEvents) {
						item = (cal.createEvent());
					}
					else {
						item = (cal.createTodo());
					}
					item.id = allTodos[i];
					item.title = allTodos[i+1];
					item.setProperty("DESCRIPTION", "");
					item.clearAlarms();
			
					var date = Components.classes["@mozilla.org/calendar/datetime;1"].createInstance(Components.interfaces.calIDateTime);
					if (allTodos[i+2] == "") {
						if (addTodosWithNoDate) {
							date.icalString = toIcalString(new Date());
						}
						else {
							continue;
						}
					}
					else {
						date.icalString = allTodos[i+2];
					}
					
					if (addToEvents) {
						item.startDate = date;
						item.endDate = item.startDate.clone();
						item.removeAllAttendees();
					}
					else if (allTodos[i+2] != "") {
						item.dueDate = date;
					}

					item.calendar = myCal;
					item.makeImmutable();
					
					myCal.addItem(item, null);
				}
			}
        },
        onGetResult: function(aCalendar, aStatus, aItemType, aDetail, aCount, aItems)
        {		
			for (var i=0; i<aCount; i++) {
				// update item if it exists
				var j;
				var deleted = false;
				for (j=0;j<allTodos.length;j+=3) {
					if (aItems[i].id == allTodos[j]) {// item already exists
						item = aItems[i].clone();
						todoAdded[j] = true;
						todoAdded[j+1] = true;
						todoAdded[j+2] = true;
						item.id = allTodos[j];
						item.title = allTodos[j+1];
						item.setProperty("DESCRIPTION", "");
						item.clearAlarms();
		
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
						item.calendar = myCal;
						item.makeImmutable();
						myCal.modifyItem(item, aItems[i], null);
						deleted = true;
						break;
					}
				}
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
			window.alert(aCount + aItemType);

			// delete all of the other type
			for (var i=0; i<aCount; i++) {
				myCal.deleteItem(aItems[i], null);
			}	
        }
    };
	
	//TODO don't delete everything (we have to in this case to make it work)
	if (addToEvents) {
		myCal.getItems(myCal.ITEM_FILTER_TYPE_TODO | myCal.ITEM_FILTER_COMPLETED_ALL,0,null,null,deleteListener);
		// todos will not delete
	}
	else {
		myCal.getItems(myCal.ITEM_FILTER_TYPE_EVENT,0,null,null,deleteListener);
	}
}

// format todo due date appropriately
function getTodoDueDate(dateArray, addDays) {
	if (dateArray == null || addDays == null) {
		return "";
	}
	else {
		var date = new Date(dateArray["year"], dateArray["month"]-1, dateArray["day"]+addDays, dateArray["hour"], dateArray["minute"], dateArray["second"]);
		var dateString = date.toISOString();
		dateString = dateString.replace(/-/g, "").replace(/:/g, "");
		dateString = dateString.substring(0,dateString.length-5) + "Z";
		return dateString;
	}
}

// show collaborator based on their partner ID
function addCollaborator(collaboratorId) {
	// if the collaborator isn't already in the list, add them
	if (arrayContains(ids, collaboratorId, 0) < 0) {
		// add them to the list
		emailAddresses.push("");
		names.push("");
		ids.push(collaboratorId);
		addresses.push([]);
		phoneNumbers.push([]);
		allEmailAddresses.push([]);
		websites.push([]);
		engagementTracks.push([]);
		recentActivity.push([]);
		todos.push([]);
		notes.push([]);
		collaborators.push([]);
		documents.push([]);
		selected = ids.length-1;
		// get information about them from Kardia
		getOtherInfo(ids.length-1, false, false);
	}
	else {
		// the collaborator is already in the available partner list, so just select them
		selected = arrayContains(ids, collaboratorId, 0);
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
	// attempt to log in using username/password saved by Login Manager
	var username = "";
	var password = "";
	try {
		// get Login Manager 
		var myLoginManager = Components.classes["@mozilla.org/login-manager;1"].getService(Components.interfaces.nsILoginManager);
		// find the Kardia login
		var logins = myLoginManager.findLogins({}, "chrome://kardia", null, "Kardia Login");
		if (logins.length >= 1) {
			username = logins[0].username;
			password = logins[0].password;
			
			// if the username isn't blank, it's good login information and we're done
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
	}
	catch(ex) {
		// this will only happen if there is no nsILoginManager class; if that's the case, then we can just ask the user for their login
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
		if (!returnValues.cancel) {
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
			loginRequest.open("GET", loginUrl, true, username, password);
			loginRequest.send(null);
		}
		else {
			// the user cancelled the dialog box, so their login isn't valid and we should close the Kardia pane
			toggleKardiaVisibility(2);
		}
	}
	
	// if we got to this point, the user didn't give a valid login, so return blanks (this keeps Kardia from asking for login info, like we want)
	return ["", ""];
}

// opens the Kardia pane if it's currently closed and closes it if it's open
function toggleKardiaVisibility(fromWhat) {
	// if splitter closed the pane
	if (fromWhat == 0) {
		if (document.getElementById("kardia-splitter").state == "open") {
			//close
			document.getElementById("show-kardia-pane-button").checked = false;
			document.getElementById("kardia-splitter").state = "closed";
			document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
			document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		}
		else {
			// open
			document.getElementById("show-kardia-pane-button").checked = true;
			document.getElementById("kardia-splitter").state = "open";
			document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"show-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
			document.getElementById("show-kardia-pane-button").style.backgroundColor = "#edf5fc";
		}
	}
	// buttons closed it
	else if (fromWhat == 1) {
		if (document.getElementById("main-box").collapsed == true) {
			// open
			document.getElementById("main-box").collapsed = false;
			document.getElementById("show-kardia-pane-button").checked = true;
			document.getElementById("kardia-splitter").state = "open";
			document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"show-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
			document.getElementById("show-kardia-pane-button").style.backgroundColor = "#edf5fc";
		}
		else {
			// close
			document.getElementById("main-box").collapsed = true;
			document.getElementById("show-kardia-pane-button").checked = false;
			document.getElementById("kardia-splitter").state = "closed";
			document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
			document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		}
	}
	// failure to log in closed it
	else if (fromWhat == 2) {  
		// close
		document.getElementById("main-box").collapsed = true;
		document.getElementById("show-kardia-pane-button").checked = false;
		document.getElementById("kardia-splitter").state = "closed";
		document.getElementById("show-hide-kardia-pane-arrow").innerHTML = "<image class=\"hide-kardia-pane-arrow\"/><spacer flex=\"1\"/>";
		document.getElementById("show-kardia-pane-button").style.backgroundColor = "rgba(0,0,0,0)";
		// display failure message
		document.getElementById("cant-connect").style.display="inline";
	}
}

// opens/closes an info display section (like Engagement Tracks)
function toggleSectionDisplay(boxId) {
	// find out which section
	var boxName = "";
	if (boxId == 0) {
		boxName = "contact-info-box";
	}
	else if (boxId == 1) {
		boxName = "engagement-tracks-box";
	}
	else if (boxId == 2) {
		boxName = "recent-activity-box";
	}
	else if (boxId == 3) {
		boxName = "to-dos-box";
	}
	else if (boxId == 4) {
		boxName = "notes-prayer-box";
	}
	else if (boxId == 5) {
		boxName = "collaborator-box";
	}
	else if (boxId == 6) {
		boxName = "document-box";
	}
		
	// open if currently closed, close if open
	if (document.getElementById(boxName).collapsed == true) {
		//open
		document.getElementById(boxName).collapsed = false;
	}
	else {
		//close
		document.getElementById(boxName).collapsed = true;
	}
}

// sets the current display to the chosen partner
function choosePartner(whichPartner) {
	selected = whichPartner;
	reload(false);
}

// shows Kardia tab
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

// opens dialog for user to add new engagement track
// we can't actually save it because we can't send data to Kardia
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

// opens dialog for user to add new note/prayer
// we can't actually save it because we can't send data to Kardia
function newNote(title, desc) {
	// where we save returned values	
	var returnValues = {title:title, desc:desc};
	
	// open dialog
	openDialog("chrome://kardia/content/add-note-prayer.xul", "New Note/Prayer", "resizable,chrome, modal,centerscreen", returnValues);
	
	// FIX STUB
	if (returnValues.title.trim() != "" || returnValues.desc.trim() != "") {
		window.alert("You saved the note " + returnValues.title + "- " + returnValues.desc);
		notes[selected].push(returnValues.title + "- " + returnValues.desc);
		notes[selected].push(new Date().toLocaleString());
		reload(false);
	}
}

// pastes email into quick search
function beginQuickFilter(email) {
	// make sure mail tab is selected
	document.getElementById("tabmail").selectTabByMode("folder");

	email = email.substring(3, email.length);
	QuickFilterBarMuxer._showFilterBar(true);
	document.getElementById(QuickFilterManager.textBoxDomId).select();
	
	// chop off last character
	document.getElementById(QuickFilterManager.textBoxDomId).value = email.substring(0, email.length-1);
	var charCode = email.substring(email.length-1, email.length).charCodeAt(0);
	// "type" last character so it searches
	window.QueryInterface(Components.interfaces.nsIInterfaceRequestor).getInterface(Components.interfaces.nsIDOMWindowUtils).sendKeyEvent("keypress", charCode, charCode, null, false);
	
	// user still has to press "enter" to search
}

// find given username/password as staff in Kardia
function findStaff(username, password, doAfter) {
	doHttpRequest("apps/kardia/api/partner/Staff?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (staffResp) {
		// do this after request comes back
		// get all the keys from the JSON file
		var keys = [];
		for(var k in staffResp) keys.push(k);
		
		// see if any of these contain our login
		for (var i=0; i<keys.length; i++) {
			if (keys[i] != "@id") {
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

// should tell Kardia to record this email
// we can't do anything yet because we can't send data to Kardia
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

// should tell Kardia to record future emails with this person
// we can't do anything yet because we can't send data to Kardia
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
// doAfter - the function to do afterward, which takes the JSON results of the request as a parameter
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
	
	// send http request
	if (authenticate) {
		// send username/password
		httpRequest.open("GET", httpUrl, true, username, password);
	}
	else {
		// don't
		httpRequest.open("GET", httpUrl, true);
	}
	httpRequest.send(null);
}