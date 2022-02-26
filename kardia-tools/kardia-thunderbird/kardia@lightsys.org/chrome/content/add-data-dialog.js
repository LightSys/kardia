// on load, enter predefined title/description (if necessary), center window on screen
function onLoad() {
	centerWindowOnScreen();

	// load data item type options
	document.getElementById("select-data-type").innerHTML = "";
	for (var i=0;i<window.arguments[1].length;i+=2) {
		document.getElementById("select-data-type").innerHTML += '<menuitem label="' + window.arguments[1][i+1] + '" value="' + window.arguments[1][i] + '"/>';
	}
	document.getElementById("outer-select-data-type").selectedIndex = 0;
}

//when you click "OK" on the Add Note/Prayer dialog, send textbox values to main script
function saveData() {
	window.arguments[0].type = parseInt(document.getElementById("outer-select-data-type").selectedItem.value);
	window.arguments[0].data = document.getElementById("data").value;
	window.arguments[0].highlight = document.getElementById("highlight").checked ? 1 : 0;
	return true;
}

// when you click "Cancel," tell the main window
function cancelData(){
	window.arguments[0].saveData = false;
	return true;
}

