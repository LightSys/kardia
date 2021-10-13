// array of engagement steps so we don't have to do a new http request every time
var steps = new Array();

// server address, needed to find list of available tracks
var server = "";

//when the dialog opens, generate dialog list and center dialog
function startDialog() {
	// set server to appropriate value
	server = window.arguments[0];
	
	// generate step list
	setSteps();
	
	// move to center of parent window
	centerWindowOnScreen();
}

// when you click "OK" on the Edit Engagement Track dialog, send results to main script
function saveTrack(){
	if (document.getElementById("edit-track-action").selectedItem.value == "c") {
		window.arguments[1].action="c";
	}
	else if (document.getElementById("edit-track-action").selectedItem.value == "e") {
		window.arguments[1].action="e";
	}
	else if (document.getElementById("edit-track-action").selectedItem.value == "n") {
		window.arguments[1].action="n";
		window.arguments[1].step = document.getElementById("outer-select-step").selectedItem.label
		window.arguments[1].stepNum = parseInt(document.getElementById("outer-select-step").selectedItem.value);
	}
	return true;
}

// when you click cancel, tell the main pane we cancelled
function cancelTrack(){
  window.arguments[1].action = "q";
  return true;
}

// when you choose a dialog item, set list of available steps
function setSteps() {
	// get list of steps for this track
	// create HTTP request to get steps
	var stepRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
	
	var stepUrl = server + "apps/kardia/api/crm_config/Tracks/" + window.arguments[2] + "/Steps?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
	
	stepRequest.onreadystatechange  = function(aEvent) {
		// if the request went through and we got success status
		
		if(stepRequest.readyState == 4 && stepRequest.status == 200) {
			// parse the JSON returned from the request
			stepResp = JSON.parse(stepRequest.responseText);
			
			// get all the keys from the JSON file
			var keys = [];
			for(var k in stepResp) keys.push(k);

			
			// the key "@id" doesn't correspond to a track, so use all other keys to save tracks
			for (var i=0;i<keys.length;i++) {
				if (keys[i] != "@id") {
					steps.push(stepResp[keys[i]]['step_name']);
					steps.push(stepResp[keys[i]]['step_id']);
				}
			}
	
			// set the steps in the list
			document.getElementById("select-step-type").innerHTML = "";
			for (var i=0;i<steps.length;i+=2) {
				document.getElementById("select-step-type").innerHTML += '<menuitem label="' + steps[i] + '" value="' + steps[i+1] + '"/>';
			}
			
			if (steps.indexOf(window.arguments[3])+2 >= steps.length) {
				document.getElementById("outer-select-step").selectedIndex = 0;
				document.getElementById("edit-track-action").selectedIndex = 0;
			}
			else {
				document.getElementById("outer-select-step").selectedIndex = steps.indexOf(window.arguments[3])/2+1;
			}
		}
	};
	// do nothing if the step request errors
	stepRequest.onerror = function(aEvent) {};
	
	// send step HTTP request
	stepRequest.open("GET", stepUrl, true);
	stepRequest.send(null);
}
