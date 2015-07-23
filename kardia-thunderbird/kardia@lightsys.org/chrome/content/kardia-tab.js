// One global copy so both tabs can keep track
var processingClicks = false;

// keep track of this window and Kardia tab
var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIWebNavigation)
	   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
	   .rootTreeItem
	   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIDOMWindow);

mainWindow.kardiaTab = this;
var kardiaTab = this;

if (mainWindow.kardiacrm)
    var kardiacrm = mainWindow.kardiacrm;

window.addEventListener('load', function() {
	if (mainWindow.loginValid) {
		
		if (kardiaTab != null) {
			kardiaTab.document.getElementById("tab-main").style.visibility = "visible";
			kardiaTab.document.getElementById("tab-cant-connect").style.display="none";
			kardiaTab.document.getElementById("filter-by-tracks").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Track:"/>';
			kardiaTab.document.getElementById("filter-by-tags").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Tag:"/>';
			kardiaTab.document.getElementById("filter-by-data").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Data items:"/>';
			kardiaTab.reloadFilters(true);
		}
	}
}, false);

// filter collaboratees
function filterBy() {
	mainWindow.filterBy = document.getElementById("filter-by-type").selectedItem.value;
	reloadFilters(false);
}

// sort collaborating with by whatever the buttons say
function sortBy() {
	// find out what we're sorting by
	var what = document.getElementById("sort-by").selectedItem.value;
	
	// set arrows based on that
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

	// reload filters/sorting
	reloadFilters(false);
}

// add the given item as a filter
function addFilter(type, id, fromClick) {	
	// if a button was clicked to add the filter, set the corresponding checkbox to checked
	if (fromClick) {
		kardiaTab.document.getElementById("filter-by-" + type + "-" + id).checkState = 1;
	}
	if (type == 'e') {
		// add to engagement track filters
		find_item(kardiacrm.data.trackList, 'track_id', id).filtered = (kardiaTab.document.getElementById("filter-by-e-" + id).checkState==1);
	}
	else if (type == 't') {	
		// add to tag filters
		find_item(kardiacrm.data.tagList, 'tag_id', id).filtered = (kardiaTab.document.getElementById("filter-by-t-" + id).checkState==1);
	}
	else if (type == 'd') {
		// add to data filters
		if (mainWindow.filterData.indexOf(id) < 0) {
			mainWindow.filterData.push(id);
			
			// hide instructions
			kardiaTab.document.getElementById("tab-data-instruction").style.display = "none";
			
			// add data filter
			kardiaTab.document.getElementById("filter-by-data").innerHTML += '<hbox id="filter-by-d-' + id + '" class="tab-filter-radio" style="background-color:#cccccc"><vbox style="margin-left:5px;" onclick="removeFilter(\'d\',\'' + id + '\')"><spacer flex="1"/><image class="close-kardia-pane-x"/><spacer flex="1"/></vbox><label value="' + id + '"/></hbox>';
		}
	}
	else if (type == 'f') {
		// add to fund filters
		if (mainWindow.filterFunds.indexOf(id) < 0) {
			mainWindow.filterFunds.push(id);
			
			// hide instructions
			kardiaTab.document.getElementById("tab-funds-instruction").style.display = "none";
			
			// add fund filter
			kardiaTab.document.getElementById("filter-by-funds").innerHTML += '<hbox id="filter-by-f-' + id + '" class="tab-filter-radio" style="background-color:#cccccc"><vbox style="margin-left:5px;" onclick="removeFilter(\'f\',\'' + id + '\')"><spacer flex="1"/><image class="close-kardia-pane-x"/><spacer flex="1"/></vbox><label value="' + id + '"/></hbox>';
		}
	}	
	// reload filters/sorting
	reloadFilters(false);
}

// add the given item as a filter for the gift display
function addGiftFilter(type, id) {	
	if (type == 'f') {
		// add to gift filters
		mainWindow.giftFilterFunds[id] = !mainWindow.giftFilterFunds[id];
		document.getElementById("filter-gifts-by-f-" + id).checked = mainWindow.giftFilterFunds[id];
	}
	else if (type == 't') {
		// add to gift filters
		mainWindow.giftFilterTypes[id] = !mainWindow.giftFilterTypes[id];
		document.getElementById("filter-gifts-by-t-" + id).checked = mainWindow.giftFilterTypes[id];
	}

	// reload filters/sorting
	reloadGifts();
}

// remove given data filter
function removeFilter(type,what) {
	if (type == 'd') {
		mainWindow.filterData.splice(mainWindow.filterData.indexOf(what),1);
		var element = document.getElementById("filter-by-d-" + what);
	}
	else if (type == 'f') {
		mainWindow.filterFunds.splice(mainWindow.filterFunds.indexOf(what),1);
		var element = document.getElementById("filter-by-f-" + what);
	}
	element.parentNode.removeChild(element);
	reloadFilters(false);
}

// reload filters
function reloadFilters(addButtons) {
	sortCollaboratees(addButtons);
	
	kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '';

	// add to my collaborators view
	for (var i=0;i<mainWindow.collaborateeIds.length;i++) {					
		var tracksSelected = false;
		var tagsSelected = false;
		for(var k in kardiacrm.data.trackList) {
		    if (kardiacrm.data.trackList[k].filtered)
			tracksSelected = true;
		}
		for(var k in kardiacrm.data.tagList) {
		    if (kardiacrm.data.tagList[k].filtered)
			tagsSelected = true;
		}
		
		var addPerson = true;
		// check whether the person should be displayed based on tracks
		if (tracksSelected) {
			if (mainWindow.filterBy == "any") {
				addPerson = false;
				for (var j=0;j<mainWindow.collaborateeTracks[i].length;j+=2) {
					var onetrack = find_item(kardiacrm.data.trackList, "track_name", mainWindow.collaborateeTracks[i][j]);
					if (onetrack.filtered) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all") {
				for (var k in kardiacrm.data.trackList) {
					var onetrack = kardiacrm.data.trackList[k];
					if (onetrack.filtered) {
						if (mainWindow.collaborateeTracks[i].indexOf(onetrack.track_name) < 0) {
							addPerson = false;
							break;
						}
					}
				}
			}
		}
		// check tags
		if (tagsSelected) {
			// find magnitude and certainty thresholds
			var tagMagMin = kardiaTab.document.getElementById("filter-by-magnitude-min").value/100;
			var tagMagMax = kardiaTab.document.getElementById("filter-by-magnitude-max").value/100;
			var tagCertThreshold = kardiaTab.document.getElementById("filter-by-certainty").value/100;
			
			if (mainWindow.filterBy == "any" && (!addPerson || !tracksSelected)) {
				addPerson = false;
				for (var j=0;j<mainWindow.collaborateeTags[i].length;j+=3) {
					var onetag = find_item(kardiacrm.data.tagList, "tag_label", mainWindow.collaborateeTags[i][j]);
					if (onetag.filtered && mainWindow.collaborateeTags[i][j+1]*1 >= tagMagMin && mainWindow.collaborateeTags[i][j+1]*1 <= tagMagMax && mainWindow.collaborateeTags[i][j+2]*1 >= tagCertThreshold) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all" && addPerson) {
				for (var k in kardiacrm.data.tagList) {
					var onetag = kardiacrm.data.tagList[k];
					if (onetag.filtered) {	
						if (mainWindow.collaborateeTags[i].indexOf(onetag.tag_label) < 0 || mainWindow.collaborateeTags[i][mainWindow.collaborateeTags[i].indexOf(onetag.tag_label)+1]*1 < tagMagMin || mainWindow.collaborateeTags[i][mainWindow.collaborateeTags[i].indexOf(onetag.tag_label)+1]*1 > tagMagMax || mainWindow.collaborateeTags[i][mainWindow.collaborateeTags[i].indexOf(onetag.tag_label)+1]*1 < tagCertThreshold) {
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
		
		// check funds
		if (mainWindow.filterFunds.length > 0) {
			if (mainWindow.filterBy == "any" && (!addPerson || (!tracksSelected && !tagsSelected && mainWindow.filterData.length <= 0))) {
				addPerson = false;
				for (var j=0;j<mainWindow.filterFunds.length;j++) {
					if (mainWindow.collaborateeFunds[i].indexOf(mainWindow.filterFunds[j]) >= 0) {
						addPerson = true;
						break;
					}
				}
			}
			else if (mainWindow.filterBy == "all" && addPerson) {
				for (var j=0;j<mainWindow.filterFunds.length;j++) {
						if (mainWindow.collaborateeFunds[i].indexOf(mainWindow.filterFunds[j]) < 0) {
						addPerson = false;
						break;
					}
				}
			}
		}
		
		// add partner only if tag, track, data item, and fund filters say we should
		if (addPerson) {
			reloadCollaboratee(i);
		}
	}
	
	// if no collaboratees, display "no results"
	if (kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML == "") {
		kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '<label class="bold-text" value="No results found."/>';
	}
}

// sort collaboratees
function sortCollaboratees(addButtons) {
	// sort by the criteria the user has selected
	var firstIndex;
	var firstItem;
	for (var i=0;i<mainWindow.collaborateeNames.length;i++) {
		firstIndex = i;
		if (mainWindow.sortCollaborateesBy == "name") {
			// sort by first name
			firstItem = mainWindow.collaborateeNames[i];
			for (var j=i+1;j<mainWindow.collaborateeNames.length;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem > mainWindow.collaborateeNames[j])) || (!mainWindow.sortCollaborateesDescending && (firstItem < mainWindow.collaborateeNames[j]))) {
					firstIndex = j;
					firstItem = mainWindow.collaborateeNames[j];
				}
			}
		}
		else if (mainWindow.sortCollaborateesBy == "id") {
			// sort by id
			firstItem = mainWindow.collaborateeIds[i];
			for (var j=i+1;j<mainWindow.collaborateeIds.length;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem > mainWindow.collaborateeIds[j])) || (!mainWindow.sortCollaborateesDescending && (firstItem < mainWindow.collaborateeIds[j]))) {
					firstIndex = j;
					firstItem = mainWindow.collaborateeIds[j];
				}
			}
		}
		else {
			// sort by date
			firstItem = datetimeToDate(mainWindow.collaborateeActivity[i][2]);
			for (var j=i+1;j<mainWindow.collaborateeActivity.length;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem < datetimeToDate(mainWindow.collaborateeActivity[j][2]))) || (!mainWindow.sortCollaborateesDescending && (firstItem > datetimeToDate(mainWindow.collaborateeActivity[j][2])))) {
					firstIndex = j;
					firstItem = datetimeToDate(mainWindow.collaborateeActivity[j][2]);
				}
			}
		}
		
		// move all items around based on how we sorted the names/ids/whatever
		var arraysToMove = [mainWindow.collaborateeNames, mainWindow.collaborateeIds, mainWindow.collaborateeTracks, mainWindow.collaborateeTags, mainWindow.collaborateeActivity, mainWindow.collaborateeData, mainWindow.collaborateeGifts, mainWindow.collaborateeFunds];
			
		for (var j=0;j<arraysToMove.length;j++) {
			firstItem = arraysToMove[j][firstIndex];
			arraysToMove[j][firstIndex] = arraysToMove[j][i];
			arraysToMove[j][i] = firstItem;
		}
	}
	
	// if no collaboratees, display "no results"
	if (mainWindow.collaborateeIds.length <= 0) {
		kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '<label class="bold-text" value="No results found."/>';
	}
	else {
		// make list of collaboratees blank
		kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '';
		// add collaboratees
		for (var i=0;i<mainWindow.collaborateeIds.length;i++) {	
			reloadCollaboratee(i);
		}
	}
	
	// if filter buttons don't exist...
	if (kardiaTab.document.getElementById("filter-by-tracks").innerHTML == '<label xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul" value="Track:"/>' || addButtons) {
		// add engagement track filter buttons
		kardiaTab.document.getElementById("filter-by-tracks").innerHTML = "<label value='Track:'/>";
		for (var k in kardiacrm.data.trackList) {
			var onetrack = kardiacrm.data.trackList[k];
			kardiaTab.document.getElementById("filter-by-tracks").innerHTML += '<button id="filter-by-e-' + parseInt(onetrack.track_id) + '" class="tab-filter-checkbox"  tooltiptext="Click to filter by this engagement track" type="checkbox" checkState="0" label="' + mainWindow.htmlEscape(onetrack.track_name) + '" oncommand="addFilter(\'e\', ' + parseInt(onetrack.track_id) + ', false)"/>';
		}
		
		// add tag filter buttons
		kardiaTab.document.getElementById("filter-by-tags").innerHTML = "<label value='Tag:'/>";
		for (var k in kardiacrm.data.tagList) {
			var onetag = kardiacrm.data.tagList[k];
			kardiaTab.document.getElementById("filter-by-tags").innerHTML += '<button id="filter-by-t-' + parseInt(onetag.tag_id) + '" class="tab-filter-checkbox"  tooltiptext="Click to filter by this tag" type="checkbox" checkState="0" label="' + mainWindow.htmlEscape(onetag.tag_label) + '" oncommand="addFilter(\'t\', ' + parseInt(onetag.tag_id) + ', false)"/>';
		}
	}
}

//TEST
// sort collaboratees
function sortSomeCollaboratees(maxIndex) {
	// sort by the criteria the user has selected
	var firstIndex;
	var firstItem;
	for (var i=0;i<maxIndex;i++) {
		firstIndex = i;
		if (mainWindow.sortCollaborateesBy == "name") {
			// sort by first name
			firstItem = mainWindow.collaborateeNames[i];
			for (var j=i+1;j<maxIndex;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem > mainWindow.collaborateeNames[j])) || (!mainWindow.sortCollaborateesDescending && (firstItem < mainWindow.collaborateeNames[j]))) {
					firstIndex = j;
					firstItem = mainWindow.collaborateeNames[j];
				}
			}
		}
		else if (mainWindow.sortCollaborateesBy == "id") {
			// sort by id
			firstItem = mainWindow.collaborateeIds[i];
			for (var j=i+1;j<maxIndex;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem > mainWindow.collaborateeIds[j])) || (!mainWindow.sortCollaborateesDescending && (firstItem < mainWindow.collaborateeIds[j]))) {
					firstIndex = j;
					firstItem = mainWindow.collaborateeIds[j];
				}
			}
		}
		else {
			// sort by date
			firstItem = datetimeToDate(mainWindow.collaborateeActivity[i][2]);
			for (var j=i+1;j<maxIndex;j++) {
				if ((mainWindow.sortCollaborateesDescending && (firstItem < datetimeToDate(mainWindow.collaborateeActivity[j][2]))) || (!mainWindow.sortCollaborateesDescending && (firstItem > datetimeToDate(mainWindow.collaborateeActivity[j][2])))) {
					firstIndex = j;
					firstItem = datetimeToDate(mainWindow.collaborateeActivity[j][2]);
				}
			}
		}
		
		// move all items around based on how we sorted the names/ids/whatever
		var arraysToMove = [mainWindow.collaborateeNames, mainWindow.collaborateeIds, mainWindow.collaborateeTracks, mainWindow.collaborateeTags, mainWindow.collaborateeActivity, mainWindow.collaborateeData, mainWindow.collaborateeGifts, mainWindow.collaborateeFunds];
			
		for (var j=0;j<arraysToMove.length;j++) {
			firstItem = arraysToMove[j][firstIndex];
			arraysToMove[j][firstIndex] = arraysToMove[j][i];
			arraysToMove[j][i] = firstItem;
		}
	}
	
	// if no collaboratees, display "no results"
	if (maxIndex <= 0) {
		kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '<label class="bold-text" value="No results found."/>';
	}
	else {
		// make list of collaboratees blank
		kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML = '';
		// add collaboratees
		for (var i=0;i<maxIndex;i++) {	
			reloadCollaboratee(i);
		}
	}
}
// END TEST

   var prevString;
// reload collaboratee at position "index"
function reloadCollaboratee(index) {
	// add basic info
	var addString = '<hbox class="tab-collaborator" tooltiptext="Click to view this partner" onclick="addCollaborator(' + mainWindow.collaborateeIds[index] + ')">\n\t<vbox class="tab-collaborator-name">\n\t\t<label class="bold-text" value="' + mainWindow.htmlEscape(mainWindow.collaborateeNames[index]) + '"/>\n\t\t<label value="ID# ' + mainWindow.htmlEscape(mainWindow.collaborateeIds[index]) + '"/>\n\t</vbox>\n';
	// add tracks if the partner has them
	if (mainWindow.collaborateeTracks[index].length > 1) {
		addString += '\t<vbox>\n';
		for (var j=0;j<mainWindow.collaborateeTracks[index].length;j+=2) {
			if (mainWindow.collaborateeTracks[index][j] != "" && mainWindow.collaborateeTracks[index][j+1] != "") { 
				var onetrack = find_item(kardiacrm.data.trackList, "track_name", mainWindow.collaborateeTracks[index][j]);
				addString += '\t\t<vbox class="tab-engagement-track-color-box" tooltiptext="Click to filter by this engagement track" onclick="addFilter(\'e\', ' + mainWindow.htmlEscape(onetrack.track_id) + ', true)" style="background-color:' + mainWindow.htmlEscape(onetrack.track_color) + '">\n\t\t\t<label class="bold-text">\n\t\t\t\t' + mainWindow.htmlEscape(mainWindow.collaborateeTracks[index][j]) + '\n\t\t\t</label>\n\t\t\t<label>\n\t\t\t\tEngagement Step: ' + mainWindow.htmlEscape(mainWindow.collaborateeTracks[index][j+1]) + '\n\t\t\t</label>\n\t\t</vbox>\n';
			}
		}
		addString += '\t</vbox>\n';
	}

	if (mainWindow.collaborateeActivity[index] != null && mainWindow.collaborateeActivity[index].length > 0) {
		addString += '\t<vbox id="collaboratee-activity-' + mainWindow.htmlEscape(mainWindow.collaborateeIds[index]) + '" flex="1">\n';
		// add recent activity
		for (var j=1;j<mainWindow.collaborateeActivity[index].length;j+=3) {
			addString += '\t\t<label flex="1">\n\t\t\t' + mainWindow.htmlEscape(mainWindow.collaborateeActivity[index][j]) + '\n\t\t</label>\n';
		}
		addString += '\t</vbox>\n';
	}
					
	// add highlighted data items
	if (mainWindow.collaborateeData[index].length > 1) {
		addString += '\t<vbox>\n';
		for (var j=0;j<mainWindow.collaborateeData[index].length;j+=3) {
			if (mainWindow.collaborateeData[index][j+1] == "1") { 
				addString += '\t\t<button tooltiptext="Click to filter by this data item" oncommand="addFilter(\'d\',\'' + mainWindow.htmlEscape(mainWindow.collaborateeData[index][j]) + '\', false);" class="highlighted" label="' + mainWindow.htmlEscape(mainWindow.collaborateeData[index][j]) + '"/>\n';
			}
		}
		addString += '\t</vbox>\n';
	}
	
	addString += '\t<spacer flex="2"/>\n\t<vbox>\n\t\t<spacer flex="1"/>\n\t\t<image class="tab-select-partner"/>\n\t\t<spacer flex="1"/>\n\t</vbox>\n</hbox>\n';
	// display the partner
   kardiaTab.document.getElementById("tab-collaborators-inner").innerHTML += addString;
}

// does quick filter from this tab
function quickFilter() {
	mainWindow.beginQuickFilter("E: " + document.getElementById("tab-filter-select").selectedItem.label);
}

// set map link
function setMapLink() {
	kardiaTab.document.getElementById("tab-map-link").href = "http://www.google.com/maps/place/" + encodeURIComponent(kardiaTab.document.getElementById("tab-address-select").selectedItem.label.substring(3,kardiaTab.document.getElementById("tab-address-select").selectedItem.label.length));
}
