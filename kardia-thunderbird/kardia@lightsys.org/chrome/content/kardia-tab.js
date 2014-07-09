var showPane = false;
var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIWebNavigation)
	   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
	   .rootTreeItem
	   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIDOMWindow);
	   
window.addEventListener("load", loadStuff());

// import todos
function tabImportTodos() {
	window.alert("todos imported");
	
}

// sort collaborating with by
function sortBy() {	
	var what = document.getElementById("sort-by").selectedItem.value;
	
	if (mainWindow.sortCollaborateesBy == what) {
		mainWindow.sortCollaborateesDescending = !mainWindow.sortCollaborateesDescending;
		if (mainWindow.sortCollaborateesDescending) {
			document.getElementById("tab-sort-by-" + what).setAttribute("class", "show-kardia-pane-arrow");
		}
		else {
			document.getElementById("tab-sort-by-" + what).setAttribute("class", "hide-kardia-pane-arrow");
		}
	}
	else {
		mainWindow.sortCollaborateesBy = what;
	}

	reloadFilters();
}

// filter collaboratees
function filterBy() {
	mainWindow.filterBy = document.getElementById("filter-by-type").selectedItem.value;
	reloadFilters();
}

// add the given item as a filter
function addFilter(type, id, fromClick) {
	if (fromClick) {
		document.getElementById("filter-by-" + type + "-" + id).checked = true;
	}
	if (type == 'e') {
		mainWindow.filterTracks[id] = document.getElementById("filter-by-e-" + id).checked;
	}
	else if (type == 't') {	
		mainWindow.filterTags[id] = document.getElementById("filter-by-t-" + id).checked;
		mainWindow.filterTags[id*1+1] = document.getElementById("filter-by-t-" + id).checked;
	}
	else if (type == 'd') {
		if (mainWindow.filterData.indexOf(id) < 0) {
			mainWindow.filterData.push(id);
			
			// hide instructions
			document.getElementById("tab-data-instruction").style.display = "none";
			
			// add data filter
			document.getElementById("filter-by-data").innerHTML += '<hbox id="filter-by-' + id + '" class="tab-filter-radio" style="background-color:#cccccc"><vbox style="margin-left:5px;" onclick="removeDataFilter(\'' + id + '\')"><spacer flex="1"/><image class="close-kardia-pane-x"/><spacer flex="1"/></vbox><label value="' + id + '"/></hbox>';
		}
	}
	reloadFilters();
}

// remove given data filter
function removeDataFilter(what) {
	mainWindow.filterData.splice(mainWindow.filterData.indexOf(what),1);
	var element = document.getElementById("filter-by-" + what);
	element.parentNode.removeChild(element);
}

// reload filters
function reloadFilters() {
	sortCollaboratees(mainWindow.collaborateeNames, mainWindow.collaborateeIds, mainWindow.collaborateeTracks, mainWindow.collaborateeTags, mainWindow.collaborateeData, mainWindow.sortCollaborateesBy, mainWindow.sortCollaborateesDescending);
		
	// add to collaborators view	
	document.getElementById("tab-collaborators-inner").innerHTML = '';
	for (var i=0;i<mainWindow.collaborateeIds.length;i++) {					
		var tracksSelected = false;
		var tagsSelected = false;
		for (var j=0;j<mainWindow.filterTracks.length;j++) {
			if (mainWindow.filterTracks[j]) {
				tracksSelected = true;
				break;
			}
		}
		for (var j=0;j<mainWindow.filterTags.length;j++) {
			if (mainWindow.filterTags[j]) {
				tagsSelected = true;
				break;
			}
		}
		
		var addPerson = true;
		// check tracks
		if (tracksSelected) {
			if (mainWindow.filterBy == "any") {
				addPerson = false;
				for (var j=0;j<mainWindow.collaborateeTracks[i].length;j+=2) {
					if (mainWindow.filterTracks[mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j])]) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all") {
				for (var j=0;j<mainWindow.filterTracks.length;j++) {
					if (mainWindow.filterTracks[j]) {
						if (mainWindow.collaborateeTracks[i].indexOf(mainWindow.trackList[j]) < 0) {
							addPerson = false;
							break;
						}
					}
				}
			}
		}
		// check tags
		if (tagsSelected) {
			if (mainWindow.filterBy == "any" && (!addPerson || !tracksSelected)) {
				addPerson = false;
				for (var j=0;j<mainWindow.collaborateeTags[i].length;j+=3) {
					if (mainWindow.filterTags[mainWindow.tagList.indexOf(mainWindow.collaborateeTags[i][j])]) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all" && addPerson) {			
				for (var j=0;j<mainWindow.filterTags.length;j+=2) {
					if (mainWindow.filterTags[j]) {	
						if (mainWindow.collaborateeTags[i].indexOf(mainWindow.tagList[j+1]) < 0) {
							addPerson = false;
							break;
						}
					}
				}
			}
		}
		// check data items
		if (mainWindow.filterData.length > 0) {
			if (mainWindow.filterBy == "any" && (!addPerson || (!tracksSelected && !tagsSelected))) {
				addPerson = false;
				for (var j=0;j<mainWindow.filterData.length;j++) {
					if (mainWindow.collaborateeData[i].indexOf(mainWindow.filterData[j]) >= 0) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all" && addPerson) {			
				for (var j=0;j<mainWindow.filterData.length;j++) {
					if (mainWindow.collaborateeData[i].indexOf(mainWindow.filterData[j]) < 0) {
						addPerson = false;
						break;
					}
				}
			}
		}
		
		// add only if tag, track, and data item filters are valid
		if (addPerson) {
			var addString = '<hbox class="tab-collaborator" onclick="addCollaborator2(' + mainWindow.collaborateeIds[i] + ')"><vbox class="tab-collaborator-name"><label class="bold-text" value="' + mainWindow.collaborateeNames[i] + '"/><label value="ID# ' + mainWindow.collaborateeIds[i] + '"/></vbox>';
			
			if (mainWindow.collaborateeTracks[i].length > 1) {
				addString += '<vbox>';
				for (var j=0;j<mainWindow.collaborateeTracks[i].length;j+=2) {
					if (mainWindow.collaborateeTracks[i][j] != "" && mainWindow.collaborateeTracks[i][j+1] != "") { 
						var filterIndex = mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j]);
						addString += '<vbox onclick="addFilter(\'e\',\'' + filterIndex + '\', true)" class="tab-engagement-track-color-box" style="background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j])] + '"><label class="bold-text">' + mainWindow.collaborateeTracks[i][j] + '</label><label>Engagement Step: ' + mainWindow.collaborateeTracks[i][j+1] + '</label></vbox>';
					}
					
				}
				addString += '</vbox>';
			}
			addString += '<hbox flex="1"><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + '2:35p: Hard-Coded Recent Activity' + '</label></hbox>';
						
			if (mainWindow.collaborateeData[i].length > 1) {
				addString += '<vbox>';
				for (var j=0;j<mainWindow.collaborateeData[i].length;j+=2) {
					if (mainWindow.collaborateeData[i][j+1] == "1") { 
						addString += '<button oncommand="addFilter(\'d\',\'' + mainWindow.collaborateeData[i][j] + '\', false);" class="highlighted" label="' + mainWindow.collaborateeData[i][j] + '"/>';
					}
				}
				addString += '</vbox>';
			}
			
			addString += '<spacer flex="2"/><vbox><spacer flex="1"/><image class="tab-select-partner"/><spacer flex="1"/></vbox></hbox>';
			
			document.getElementById("tab-collaborators-inner").innerHTML += addString;
			// FIX STUB should also have recent activity
		}
	}	
}

// sort collaboratees
function sortCollaboratees(names, ids, tracks, tags, data, sortBy, descending) {
	// sort
	var firstIndex;
	var firstItem;
	for (var i=0;i<names.length;i++) {
		firstIndex = i;
		if (sortBy == "name") {
			// sort by first name
			firstItem = names[i];
			for (var j=i+1;j<names.length;j++) {
				if ((descending && (firstItem > names[j])) || (!descending && (firstItem < names[j]))) {
					firstIndex = j;
					firstItem = names[j];
				}
			}
		}
		else if (sortBy == "id") {
			// sort by id
			firstItem = ids[i];
			for (var j=i+1;j<ids.length;j++) {
				if ((descending && (firstItem > ids[j])) || (!descending && (firstItem < ids[j]))) {
					firstIndex = j;
					firstItem = ids[j];
				}
			}
		}
		else {
			// FIX STUB sort by date
			window.alert("Sort by date is not available.");
		}
		
		// move all other items around based on how we sorted names
		
		firstItem = names[firstIndex];
		names[firstIndex] = names[i];
		names[i] = firstItem;
		
		firstItem = ids[firstIndex];
		ids[firstIndex] = ids[i];
		ids[i] = firstItem;
		
		firstItem = tracks[firstIndex];
		tracks[firstIndex] = tracks[i];
		tracks[i] = firstItem;
		
		firstItem = tags[firstIndex];
		tags[firstIndex] = tags[i];
		tags[i] = firstItem;
		
		firstItem = data[firstIndex];
		data[firstIndex] = data[i];
		data[i] = firstItem;
	}
	
	// reload view
	document.getElementById("tab-collaborators-inner").innerHTML = '';
	for (var i=0;i<mainWindow.collaborateeIds.length;i++) {					
		var addString = '<hbox class="tab-collaborator" onclick="addCollaborator2(' + mainWindow.collaborateeIds[i] + ')"><vbox class="tab-collaborator-name"><label class="bold-text" value="' + mainWindow.collaborateeNames[i] + '"/><label value="ID# ' + mainWindow.collaborateeIds[i] + '"/></vbox>';
		
		if (mainWindow.collaborateeTracks[i].length > 1) {
			addString += '<vbox>';
			for (var j=0;j<mainWindow.collaborateeTracks[i].length;j+=2) {
				if (mainWindow.collaborateeTracks[i][j] != "" && mainWindow.collaborateeTracks[i][j+1] != "") { 
					addString += '<vbox class="tab-engagement-track-color-box" style="background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j])] + '"><label class="bold-text">' + mainWindow.collaborateeTracks[i][j] + '</label><label>Engagement Step: ' + mainWindow.collaborateeTracks[i][j+1] + '</label></vbox>';
				}
			}
			addString += '</vbox>';
		}
		addString += '<hbox flex="1"><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + '2:35p: Hard-Coded Recent Activity' + '</label></hbox>';
						
		if (mainWindow.collaborateeData[i].length > 1) {
			addString += '<vbox>';
			for (var j=0;j<mainWindow.collaborateeData[i].length;j+=2) {
				if (mainWindow.collaborateeData[i][j+1] == "1") { 
					addString += '<button oncommand="addFilter(\'d\',\'' + mainWindow.collaborateeData[i][j] + '\', false);" class="highlighted" label="' + mainWindow.collaborateeData[i][j] + '"/>';
				}
			}
			addString += '</vbox>';
		}
		
		addString += '<spacer flex="2"/><vbox><spacer flex="1"/><image class="tab-select-partner"/><spacer flex="1"/></vbox></hbox>';
		
		document.getElementById("tab-collaborators-inner").innerHTML += addString;
		// FIX STUB should also have recent activity
	}

}

function loadStuff() { 		
	// get todos info
	// get all todos and import into calendar
	var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
	prefs = prefs.getBranch("extensions.kardia.");
		
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.myId + "/CollaboratorTodos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todoResp) {
		// do this after request comes back
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
	}, true, prefs.getCharPref("username"), prefs.getCharPref("password"));
			
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.myId + "/Collaboratees?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collabResp) {
		// do this after request comes back
		// get all the keys from the JSON file
		var keys = [];
		for(var k in collabResp) keys.push(k);
		
		// refresh collaboratees
		mainWindow.collaborateeIds = new Array();
		mainWindow.collaborateeNames = new Array();
		mainWindow.collaborateeTracks = new Array();
		mainWindow.collaborateeTags = new Array();
		mainWindow.collaborateeActivity = new Array();
		mainWindow.collaborateeData = new Array();
		
		// save to arrays
		for (var i=0; i<keys.length; i++) {
			if (keys[i] != "@id") {
				mainWindow.collaborateeIds.push(collabResp[keys[i]]['partner_id']);
				mainWindow.collaborateeNames.push(collabResp[keys[i]]['partner_name']);						
			}
		}
		
		// get other info
		getCollaborateeInfo2(0);
	}, false, "", "");

	if (mainWindow.names != null && mainWindow.names.length > 0) {
		document.getElementById("tab-bottom-name").value = mainWindow.names[mainWindow.selected];
	}
}


// does quick filter from this tab
function quickFilter() {
	mainWindow.beginQuickFilter("E: " + document.getElementById("tab-filter-select").selectedItem.label);
}

// gets and displays other collaboratee info
function getCollaborateeInfo2(index) {
	doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tracks?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(trackResp) {
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
		mainWindow.collaborateeTracks.push(tempArray);
		
		doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/Tags?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(tagResp) {
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
			mainWindow.collaborateeTags.push(tempArray);
			
			// get data items
			doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.collaborateeIds[index] + "/DataItems?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(dataResp) {
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
				mainWindow.collaborateeData.push(tempArray);
				
				if (index+1 >= mainWindow.collaborateeIds.length) {			
					document.getElementById("tab-tags").innerHTML = '<label class="tab-title" value="Tags"/>';

					sortCollaboratees(mainWindow.collaborateeNames, mainWindow.collaborateeIds, mainWindow.collaborateeTracks, mainWindow.collaborateeTags, mainWindow.collaborateeData, mainWindow.sortCollaborateesBy, mainWindow.sortCollaborateesDescending);		
					
					// add to collaborators view	
					document.getElementById("tab-collaborators-inner").innerHTML = '';
					for (var i=0;i<mainWindow.collaborateeIds.length;i++) {					
						var addString = '<hbox class="tab-collaborator" onclick="addCollaborator2(' + mainWindow.collaborateeIds[i] + ')"><vbox class="tab-collaborator-name"><label class="bold-text" value="' + mainWindow.collaborateeNames[i] + '"/><label value="ID# ' + mainWindow.collaborateeIds[i] + '"/></vbox>';
						
						if (mainWindow.collaborateeTracks[i].length > 1) {
							addString += '<vbox>';
							for (var j=0;j<mainWindow.collaborateeTracks[i].length;j+=2) {
								if (mainWindow.collaborateeTracks[i][j] != "" && mainWindow.collaborateeTracks[i][j+1] != "") { 
									var filterIndex = mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j]);
									addString += '<vbox onclick="addFilter(\'e\',\'' + filterIndex + '\', true)" class="tab-engagement-track-color-box" style="background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.collaborateeTracks[i][j])] + '"><label class="bold-text">' + mainWindow.collaborateeTracks[i][j] + '</label><label>Engagement Step: ' + mainWindow.collaborateeTracks[i][j+1] + '</label></vbox>';
								}
							}
							addString += '</vbox>';
						}

						addString += '<hbox flex="1"><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + '2:35p: Hard-Coded Recent Activity' + '</label></hbox>';
						
						if (mainWindow.collaborateeData[i].length > 1) {
							addString += '<vbox>';
							for (var j=0;j<mainWindow.collaborateeData[i].length;j+=2) {
								if (mainWindow.collaborateeData[i][j+1] == "1") { 
									addString += '<button oncommand="addFilter(\'d\',\'' + mainWindow.collaborateeData[i][j] + '\', false);" class="highlighted" label="' + mainWindow.collaborateeData[i][j] + '"/>';
								}
							}
							addString += '</vbox>';
						}
						
						addString += '<spacer flex="2"/><vbox><spacer flex="1"/><image class="tab-select-partner"/><spacer flex="1"/></vbox></hbox>';
						
						document.getElementById("tab-collaborators-inner").innerHTML += addString;
						// FIX STUB should also have recent activity
					}	
			
					// add engagement track filter buttons
					document.getElementById("filter-by-tracks").innerHTML = "<label value='Track:'/>";
					for (var i=0;i<mainWindow.trackList.length;i++) {
						document.getElementById("filter-by-tracks").innerHTML += '<checkbox id="filter-by-e-' + i + '" class="tab-filter-checkbox" checked="false" label="' + mainWindow.trackList[i] + '" oncommand="addFilter(\'e\', ' + i + ', false)"/>';
					}
				
					// add tag filter buttons
					document.getElementById("filter-by-tags").innerHTML = "<label value='Tag:'/>";
					for (var i=0;i<mainWindow.tagList.length;i+=2) {
						document.getElementById("filter-by-tags").innerHTML += '<checkbox id="filter-by-t-' + i + '" class="tab-filter-checkbox" checked="false" label="' + mainWindow.tagList[i+1] + '" oncommand="addFilter(\'t\', ' + i + ', false)"/>';
					}				
					
					// reload Kardia tab
					reload2(true);
				}
				else {
					getCollaborateeInfo2(index+1);
				}
			}, false, "", "");	
		}, false, "", "");
	}, false, "", "");
}

// reloads Kardia pane
function reload2(isDefault) {		
	var whichDoc = mainWindow.document;

	// reset Kardia tab sorting
	mainWindow.sortCollaborateesBy = "name";
	mainWindow.sortCollaborateesDescending = true;
	mainWindow.filterBy = "any";
	
	// if 0 or > 1 emails are selected, we don't display partners, so hide Print context menu if that's the case
	if ((mainWindow.emailAddresses.length < 1 || mainWindow.emailAddresses == null) && !showPane) {
		whichDoc.getElementById('main-context').hidden = true;
	}
	else {
		whichDoc.getElementById('main-context').hidden = false;
	}
	
	// if list of email addresses is empty or null, make everything in Kardia pane blank or hidden
	if ((mainWindow.emailAddresses.length < 1 || mainWindow.emailAddresses == null) && !showPane) {
		whichDoc.getElementById("name-label").value = "";
		whichDoc.getElementById("id-label").value = "";
		whichDoc.getElementById("choose-partner-dropdown-button").style.display = "none";
		
		whichDoc.getElementById("main-content-box").style.visibility = "hidden";
		whichDoc.getElementById("bottom-separator").style.visibility = "hidden";
		whichDoc.getElementById("record-this-email").style.visibility = "hidden";
		whichDoc.getElementById("record-future-emails").style.visibility = "hidden";
		
		document.getElementById("tab-bottom-hbox").style.visibility = "hidden";
		document.getElementById("tab-address-map").style.visibility="hidden";
		document.getElementById("tab-bottom-name").value = "";
	}
	else if (mainWindow.names[mainWindow.selected] != null && mainWindow.ids[mainWindow.selected] != null) {	// if and only if currently selected partner is not null, we can sort the list
		// sort all items by name order
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
			firstItem = mainWindow.emailAddresses[firstIndex];
			mainWindow.emailAddresses[firstIndex] = mainWindow.emailAddresses[i];
			mainWindow.emailAddresses[i] = firstItem;
			
			firstItem = mainWindow.ids[firstIndex];
			mainWindow.ids[firstIndex] = mainWindow.ids[i];
			mainWindow.ids[i] = firstItem;

			firstItem = mainWindow.addresses[firstIndex];
			mainWindow.addresses[firstIndex] = mainWindow.addresses[i];
			mainWindow.addresses[i] = firstItem;

			firstItem = mainWindow.phoneNumbers[firstIndex];
			mainWindow.phoneNumbers[firstIndex] = mainWindow.phoneNumbers[i];
			mainWindow.phoneNumbers[i] = firstItem;
			
			firstItem = mainWindow.allEmailAddresses[firstIndex];
			mainWindow.allEmailAddresses[firstIndex] = mainWindow.allEmailAddresses[i];
			mainWindow.allEmailAddresses[i] = firstItem;
			
			firstItem = mainWindow.websites[firstIndex];
			mainWindow.websites[firstIndex] = mainWindow.websites[i];
			mainWindow.websites[i] = firstItem;
			
			firstItem = mainWindow.engagementTracks[firstIndex];
			mainWindow.engagementTracks[firstIndex] = mainWindow.engagementTracks[i];
			mainWindow.engagementTracks[i] = firstItem;
			
			firstItem = mainWindow.recentActivity[firstIndex];
			mainWindow.recentActivity[firstIndex] = mainWindow.recentActivity[i];
			mainWindow.recentActivity[i] = firstItem;
			
			firstItem = mainWindow.todos[firstIndex];
			mainWindow.todos[firstIndex] = mainWindow.todos[i];
			mainWindow.todos[i] = firstItem;
			
			firstItem = mainWindow.notes[firstIndex];
			mainWindow.notes[firstIndex] = mainWindow.notes[i];
			mainWindow.notes[i] = firstItem;
			
			firstItem = mainWindow.collaborators[firstIndex];
			mainWindow.collaborators[firstIndex] = mainWindow.collaborators[i];
			mainWindow.collaborators[i] = firstItem;
			
			firstItem = mainWindow.documents[firstIndex];
			mainWindow.documents[firstIndex] = mainWindow.documents[i];
			mainWindow.documents[i] = firstItem;
		}
		
		// if we're loading the pane for the first time, select the first (0th) item
		if (isDefault) {
			mainWindow.selected = 0;
		}
		
		// show content boxes in case they're hidden
		whichDoc.getElementById("main-content-box").style.visibility = "visible";
		whichDoc.getElementById("bottom-separator").style.visibility = "visible";
		whichDoc.getElementById("record-this-email").style.visibility = "visible";
		whichDoc.getElementById("record-future-emails").style.visibility = "visible";
		document.getElementById("tab-bottom-hbox").style.visibility = "visible";
		document.getElementById("tab-address-map").style.visibility="visible";
		
		// show name and id of selected partner
		whichDoc.getElementById("name-label").value = mainWindow.names[mainWindow.selected];
		whichDoc.getElementById("id-label").value = "ID# " + mainWindow.ids[mainWindow.selected];
		
		// put name into Kardia tab
		document.getElementById("tab-bottom-name").value = mainWindow.names[mainWindow.selected];

		// if only one partner available, hide dropdown arrow
		if (mainWindow.names.length <= 1) {
			whichDoc.getElementById("choose-partner-dropdown-button").style.display = "none";
		}
		else {		
			// show dropdown
			whichDoc.getElementById("choose-partner-dropdown-button").style.display = "inline";
			
			// set partner options based on list of names
			var partners = "";
			for (var i=0;i<mainWindow.names.length;i++) {
					partners += '<button id="partner-button' + i + '" class="partner-button" label="' + mainWindow.names[i] + ', ID# ' + mainWindow.ids[i] + '" oncommand="choosePartner(\'' + i + '\')"/>';
			}
			whichDoc.getElementById("choose-partner-dropdown-menu").innerHTML = partners;
		}
		
		// set contact info based on selected partner
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
			contactInfoHTML += "<label class='text-link' context='emailContextMenu' onclick='if (event.button == 0) sendEmail(\"" + mainWindow.allEmailAddresses[mainWindow.selected][i] + "\")'>" + mainWindow.allEmailAddresses[mainWindow.selected][i] + "</label>";
		}
		for (var i=0;i<mainWindow.websites[mainWindow.selected].length;i++) {
			contactInfoHTML += "<label class='text-link' context='websiteContextMenu' onclick='if (event.button == 0) openUrl(\"" + mainWindow.websites[mainWindow.selected][i] + "\",true);'>" + mainWindow.websites[mainWindow.selected][i] + "</label>";
		}
		whichDoc.getElementById("contact-info-inner-box").innerHTML = contactInfoHTML;
		
		// set engagement tracks
		var tracks = "";
		for (var i=0;i<mainWindow.engagementTracks[mainWindow.selected].length;i+=2) {
			tracks += '<vbox class="engagement-track-color-box" style="background-color:' + mainWindow.trackColors[mainWindow.trackList.indexOf(mainWindow.engagementTracks[mainWindow.selected][i])] + '"><label class="bold-text">' + mainWindow.engagementTracks[mainWindow.selected][i] + '</label><label>Engagement Step: ' + mainWindow.engagementTracks[mainWindow.selected][i+1] + '</label></vbox>';
		}
		tracks += '<hbox><spacer flex="1"/><button class="new-button" label="New Track..." oncommand="newTrack()"/></hbox>';
		whichDoc.getElementById("engagement-tracks-inner-box").innerHTML = tracks;				
				
		// set recent activity
		var recent = "";
		for (var i=0;i<mainWindow.recentActivity[mainWindow.selected].length;i+=2) {
			if (mainWindow.recentActivity[mainWindow.selected][i] == "e") {
				recent += '<hbox><vbox><image class="email-image"/><spacer flex="1"/></vbox><label width="100" flex="1">' + mainWindow.recentActivity[mainWindow.selected][i+1] + '</label></hbox>';
			}
		}
		whichDoc.getElementById("recent-activity-inner-box").innerHTML = recent;	
		
		// set todos
		var toDoText = "";
		for (var i=0;i<mainWindow.todos[mainWindow.selected].length;i+=2) {
			toDoText += '<checkbox id="to-do-item-' + mainWindow.todos[mainWindow.selected][i] + '" oncommand="deleteTodo(' + mainWindow.todos[mainWindow.selected][i] + ')" label="' + mainWindow.todos[mainWindow.selected][i+1] + '"/>';
		}
		whichDoc.getElementById("to-dos-inner-box").innerHTML = toDoText;	
		
		// set notes
		var noteText = "";
		for (var i=0;i<mainWindow.notes[mainWindow.selected].length;i+=2) {
			noteText += '<hbox><vbox><spacer height="3"/><image class="note-image"/><spacer flex="1"/></vbox><vbox width="100" flex="1"><description flex="1">' + mainWindow.notes[mainWindow.selected][i] + '</description><description flex="1">' + mainWindow.notes[mainWindow.selected][i+1] + '</description></vbox></hbox>';
		}
		noteText += '<hbox><spacer flex="1"/><button class="new-button" label="New Note/Prayer..." oncommand="newNote(\'\',\'\')"/></hbox>';	
		whichDoc.getElementById("notes-prayer-inner-box").innerHTML = noteText;
		
		// set collaborators
		var collaboratorText = "";
		for (var i=0;i<mainWindow.collaborators[mainWindow.selected].length;i+=3) {
			// if it's a team, show team image  TODO should this be a company?
			if (mainWindow.collaborators[mainWindow.selected][i] == 1) {
				collaboratorText += '<hbox><vbox><image class="team-image"/>';
			}
			else { //if (collaborators[mainWindow.selected][i] == "i") {	//show individual image
			// the if part is commented out so we have a default case, but may need to be put back if we have more options than team and individual
				collaboratorText += '<hbox><vbox><image class="individual-image"/>';
			}
			collaboratorText += '<spacer flex="1"/></vbox><label width="100" flex="1" class="text-link" onclick="addCollaborator(' + mainWindow.collaborators[mainWindow.selected][i+1] + ')">' + mainWindow.collaborators[mainWindow.selected][i+2] +'</label></hbox>';
		}
		whichDoc.getElementById("collaborator-inner-box").innerHTML = collaboratorText;	
		
		// set documents
		var docs = "";
		for (var i=0;i<mainWindow.documents[mainWindow.selected].length;i+=2) {
			docs += '<hbox><vbox><image class="document-image"/><spacer flex="1"/></vbox><label id="docLabel' + i + '" width="100" flex="1" class="text-link" context="documentContextMenu" onclick="if (event.button == 0) openDocument(\'' + mainWindow.documents[mainWindow.selected][i] + '\',false);">' + mainWindow.documents[mainWindow.selected][i+1] + '</label></hbox>';
		}
		whichDoc.getElementById("document-inner-box").innerHTML = docs;
		
		// reload Kardia tab tags
		document.getElementById("tab-tags").innerHTML = "";
		var tagsSelected = mainWindow.collaborateeIds.indexOf(mainWindow.ids[mainWindow.selected].toString());
		
		for (var i=0;i<mainWindow.collaborateeTags[tagsSelected].length;i+=3) {
			var questionMark = (mainWindow.collaborateeTags[tagsSelected][i+2] <= 0.5) ? "?" : "";
			var filterIndex = mainWindow.tagList.indexOf(mainWindow.collaborateeTags[tagsSelected][i])-1;
			document.getElementById("tab-tags").innerHTML += '<vbox onclick="addFilter(\'t\',\'' + filterIndex + '\', true)" class="tab-tag-color-box" style="background-color:hsl(46,100%,' + (100-50*mainWindow.collaborateeTags[tagsSelected][i+1]) + '%);"><label value="' + mainWindow.collaborateeTags[tagsSelected][i] + questionMark + '"/></vbox>';
		}
		
		// reload Kardia tab data items
		document.getElementById("tab-data-items").innerHTML = '<label class="tab-title" value="Data Items"/>';
		for (var i=0;i<mainWindow.collaborateeData[tagsSelected].length;i+=2) {
			if (mainWindow.collaborateeData[tagsSelected][i+1].toString() == "0") {
				document.getElementById("tab-data-items").innerHTML += '<vbox onclick="addFilter(\'d\',\'' + mainWindow.collaborateeData[selected][i] + '\', false);"><label>' + mainWindow.collaborateeData[tagsSelected][i] + '</label></vbox>';
			}
			else {
				// highlight it
				document.getElementById("tab-data-items").innerHTML += '<vbox class="highlighted" onclick="addFilter(\'d\',\'' + mainWindow.collaborateeData[selected][i] + '\', false);"><label>' + mainWindow.collaborateeData[tagsSelected][i] + '</label></vbox>';
			}
		}
		
		// reload list of emails in Kardia tab
		document.getElementById("tab-filter-select-inner").innerHTML = "";
		for (var i=0;i<mainWindow.allEmailAddresses[mainWindow.selected].length;i++) {
			document.getElementById("tab-filter-select-inner").innerHTML += '<menuitem label="' + mainWindow.allEmailAddresses[mainWindow.selected][i].substring(3, mainWindow.allEmailAddresses[mainWindow.selected][i].length) + '"/>';
		}
		document.getElementById("tab-filter-select").selectedIndex = 0;
		
		// add link to map in Kardia tab
		// add list of addresses
		if (mainWindow.addresses[mainWindow.selected].length > 0) {
			document.getElementById("tab-address-map").style.visibility="visible";
			document.getElementById("tab-address-select-inner").innerHTML = "";
			for (var i=0;i<mainWindow.addresses[mainWindow.selected].length;i++) {
				document.getElementById("tab-address-select-inner").innerHTML += '<menuitem label="' + mainWindow.addresses[mainWindow.selected][i] + '"/>';
			}
			document.getElementById("tab-address-select").selectedIndex = 0;
			setMapLink();
		}
		else {
			// no addresses, don't show it
			document.getElementById("tab-address-map").style.visibility="none";
		}
	}
}

// set map link based on selection
function setMapLink() {
	document.getElementById("tab-map-link").href="http://www.google.com/maps/place/" + document.getElementById("tab-address-select").selectedItem.label.substring(3,document.getElementById("tab-address-select").selectedItem.label.length).replace(/ /g, "+");
}

// show collaborator based on their partner ID
function addCollaborator2(collaboratorId) {
	showPane = true;
	// if the collaborator isn't already in the list, add them
	if (arrayContains(mainWindow.ids, collaboratorId, 0) < 0) {
		// add them to the list
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
		mainWindow.selected = mainWindow.ids.length-1;
		// get information about them from Kardia
		getOtherInfo2(mainWindow.ids.length-1, false, true);
	}
	else {
		// the collaborator is already in the available partner list, so just select them
		mainWindow.selected = arrayContains(mainWindow.ids, collaboratorId, 0);
		reload2(false);
	}
}

// get all other info about the partner whose information is stored at position index
function getOtherInfo2(index, isDefault, useReload2) {	
	// is user valid?
	var validUser = true;
	
	// get partner name
	doHttpRequest("apps/kardia/api/partner/Partners/" + mainWindow.ids[index] + "?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic", function (nameResp) {
		// if the partner is not valid
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
						// get notes/prayer information
						doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Documents?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (documentResp) {
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
							mainWindow.documents[index] = documentArray;
							
							// get notes/prayer information
							doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/ContactHistory?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (noteResp) {
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
								mainWindow.notes[index] = noteArray;
								
								// get collaborators information
								doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] +"/Collaborators?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function (collaboratorResp) {
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
									mainWindow.collaborators[index] = collaboratorArray;
									
									// get todos information
									doHttpRequest("apps/kardia/api/crm/Partners/" + mainWindow.ids[index] + "/Todos?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic", function(todosResp) {
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
										mainWindow.todos[index] = todosArray;
									
										// if there are more partners left to check, go to the next one
										if (index+1 < emailAddresses.length) {
											getOtherInfo2(index+1, true, useReload2);
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

