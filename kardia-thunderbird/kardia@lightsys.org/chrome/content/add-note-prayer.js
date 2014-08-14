// on load, enter predefined title/description (if necessary), center window on screen
function onLoad() {
	centerWindowOnScreen();
	document.getElementById("note-title").value = window.arguments[0].title;
	document.getElementById("note-text").value = window.arguments[0].desc;

	// load note type options
	document.getElementById("select-note-type").innerHTML = "";
	for (var i=0;i<window.arguments[1].length;i+=2) {
		document.getElementById("select-note-type").innerHTML += '<menuitem label="' + window.arguments[1][i+1] + '" value="' + window.arguments[1][i] + '"/>';
	}
	document.getElementById("outer-select-note-type").selectedIndex = 0;
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
