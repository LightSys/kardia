var XUL_NS = "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";

// on load, enter predefined title/description (if necessary), center window on screen
function onLoad() {
	centerWindowOnScreen();
	document.getElementById("note-title").value = window.arguments[0].title;
	document.getElementById("note-text").value = window.arguments[0].desc;

	// load note type options
	var notelist = $("#select-note-type");
	notelist.find("menuitem").remove();
	for (var k in window.arguments[1]) {
		var onenotetype = window.arguments[1][k];
		var onemenuitem = document.createElementNS(XUL_NS,"menuitem");
		$(onemenuitem).attr("value", onenotetype.id);
		$(onemenuitem).attr("label", onenotetype.label);
		notelist.append(onemenuitem);
	}
	$("#outer-select-note-type")[0].selectedIndex = 0;
}

//when you click "OK" on the Add Note/Prayer dialog, send textbox values to main script
function saveNote(){
	window.arguments[0].title = document.getElementById("note-title").value;
	window.arguments[0].desc = document.getElementById("note-text").value;
	window.arguments[0].type = parseInt(document.getElementById("outer-select-note-type").selectedItem.value);
	return true;
}

// when you click "Cancel," nothing happens
function cancelNote(){
	window.arguments[0].saveNote = false;
	return true;
}
