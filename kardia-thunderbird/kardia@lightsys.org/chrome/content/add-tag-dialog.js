//when the dialog opens, generate dialog list and center dialog
function startDialog() {
	// generate list
	document.getElementById("select-tag-type").innerHTML = "";
	for (var i=1;i<window.arguments[0].length;i+=2) {
		document.getElementById("select-tag-type").innerHTML += '<menuitem label="' + window.arguments[0][i] + '"/>';
	}
	document.getElementById("outer-select-tag").selectedIndex = 0;

	// move to center of parent window
	centerWindowOnScreen();
}

// when you click "OK" on the Add Tag dialog, send results to main script
function saveTag(){
	window.arguments[1].tag = document.getElementById("outer-select-tag").selectedItem.label;
	window.arguments[1].magnitude = document.getElementById("tag-magnitude").value/100;
	window.arguments[1].certainty = document.getElementById("tag-certainty").value/100;
	return true;
}

// when you click cancel, nothing happens
function cancelTag(){
  return true;
}

/*** add number boxes */