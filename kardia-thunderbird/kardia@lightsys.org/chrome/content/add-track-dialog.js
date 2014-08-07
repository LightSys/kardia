// array of engagement steps so we don't have to do a new http request every time
var steps = new Array();

// server address, needed to find list of available tracks
var server = "";

//when the dialog opens, generate dialog list and center dialog
function startDialog() {
	// generate list
	document.getElementById("select-track-type").innerHTML = "";
	for (var i=0;i<window.arguments[0].length;i++) {
		document.getElementById("select-track-type").innerHTML += '<menuitem label="' + window.arguments[1][i] + '" value="' + window.arguments[0][i] + '"/>';
	}
	document.getElementById("outer-select-track").selectedIndex = 0;
	
	// set server to appropriate value
	server = window.arguments[2];
	
	// generate step list
	setSteps();
	
	// move to center of parent window
	centerWindowOnScreen();
}

// when you click "OK" on the Add Engagement Track dialog, send results to main script
function saveTrack(){
	window.arguments[3].track = document.getElementById("outer-select-track").selectedItem.label;
	window.arguments[3].trackNum = document.getElementById("outer-select-track").selectedItem.value;
	window.arguments[3].step = document.getElementById("outer-select-step").selectedItem.label;
	window.arguments[3].stepNum = document.getElementById("outer-select-step").selectedItem.value;
	return true;
}

// when you click cancel, nothing happens
function cancelTrack(){
  return true;
}

// when you choose a dialog item, set list of available steps
function setSteps() {
	var index = document.getElementById("outer-select-track").selectedIndex;
	if (steps[index] == null) {
		// get list of steps for this track
		// create HTTP request to get steps
		var stepRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var stepUrl = server + "apps/kardia/api/crm_config/Tracks/" + document.getElementById("outer-select-track").selectedItem.label + "/Steps?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
		var stepResp;
		
		stepRequest.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(stepRequest.readyState == 4 && stepRequest.status == 200) {
				// parse the JSON returned from the request
				stepResp = JSON.parse(stepRequest.responseText);
				
				// get all the keys from the JSON file
				var keys = [];
				for(var k in stepResp) keys.push(k);

				
				// the key "@id" doesn't correspond to a track, so use all other keys to save tracks
				var stepList = new Array();
				for (var i=0;i<keys.length;i++) {
					if (keys[i] != "@id") {
						stepList.push(stepResp[keys[i]]['step_name']);
						stepList.push(stepResp[keys[i]]['step_id']);
					}
				}
				steps[index] = stepList;
		
				// set the steps in the list
				document.getElementById("select-step-type").innerHTML = "";
				for (var i=0;i<steps[index].length;i+=2) {
					document.getElementById("select-step-type").innerHTML += '<menuitem label="' + steps[index][i] + '" value="' + steps[index][i+1] + '"/>';
				}
				document.getElementById("outer-select-step").selectedIndex = 0;
			}
		};
		// do nothing if the step request errors
		stepRequest.onerror = function(aEvent) {};
		
		// send step HTTP request
		stepRequest.open("GET", stepUrl, true);
		stepRequest.send(null);
	}
	else {
		// set steps from stored info
		document.getElementById("select-step-type").innerHTML = "";
		for (var i=0;i<steps[index].length;i+=2) {
			document.getElementById("select-step-type").innerHTML += '<menuitem label="' + steps[index][i] + '" value="' + steps[index][i+1] + '"/>';
		}
		document.getElementById("outer-select-step").selectedIndex = 0;
	}
}
