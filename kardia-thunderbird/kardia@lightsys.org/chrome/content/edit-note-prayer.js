// on load, enter predefined title/description (if necessary), center window on screen
function onLoad() {
	centerWindowOnScreen();
	document.getElementById("note-title").value = window.arguments[0].title;
	document.getElementById("note-text").value = window.arguments[0].desc;
}

//when you click "OK" on the Add Note/Prayer dialog, send textbox values to main script
function saveNote(){
	window.arguments[0].title = document.getElementById("note-title").value;
	window.arguments[0].desc = document.getElementById("note-text").value;
	return true;
}

// when you click "Cancel," nothing happens
function cancelNote(){
	window.arguments[0].saveNote = false;
	return true;
}

