// on load, center window on screen and load person options
function onLoad() {
	centerWindowOnScreen();

	setTimeout(function() {
	  
	  // load collaborator options
	  document.getElementById("select-collaborator").innerHTML = "";
	  for (var i=0;i<window.arguments[1].length;i+=2) {
		  document.getElementById("select-collaborator").innerHTML += '<menuitem label="' + window.arguments[1][i] + ", #" + window.arguments[1][i+1] + '" value="' + window.arguments[1][i+1] + '"/>';
	  }
	  document.getElementById("outer-select-collaborator").selectedIndex = 0;

	  // load collaborator type options
	  document.getElementById("select-collab-type").innerHTML = "";
	  for (var i=0;i<window.arguments[2].length;i+=2) {
		  document.getElementById("select-collab-type").innerHTML += '<menuitem label="' + window.arguments[2][i] + '" value="' + window.arguments[2][i+1] + '"/>';
	  }
	  document.getElementById("outer-select-collab-type").selectedIndex = 0;
	
	}, 1000);
}

//when you click "OK" on the Add Note/Prayer dialog, send textbox values to main script
function saveCollab(){
	window.arguments[0].id = document.getElementById("outer-select-collaborator").selectedItem.value;
	window.arguments[0].name = window.arguments[1][window.arguments[1].indexOf(document.getElementById("outer-select-collaborator").selectedItem.value)-1];
	window.arguments[0].type = document.getElementById("outer-select-collab-type").selectedItem.value;
	
	return true;
}

// when you click "Cancel," nothing happens
function cancelCollab(){
	window.arguments[0].id = null;
	return true;
}

