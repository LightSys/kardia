//when the dialog opens, center dialog
function startDialog() {
	// move to center of parent window
	centerWindowOnScreen();

	// add countries
		document.getElementById("inner-country").innerHTML = mainWindow.htmlEscape(window.arguments[1]);
		document.getElementById("country").selectedIndex = mainWindow.htmlEscape(window.arguments[2]);
}

// when you click "OK" on the Add Contact Item dialog, send results to main script
function saveTrack(){
	var type = document.getElementById("outer-select-type").selectedItem.value;
	
	window.arguments[0].type = type;
	window.arguments[0].locationId = document.getElementById("outer-select-location").selectedItem.value;
	if (type == "A") {
		window.arguments[0].info = {address1:document.getElementById("address1").value, address2:document.getElementById("address2").value, address3:document.getElementById("address3").value, city:document.getElementById("city").value, state:document.getElementById("state").value, zip:document.getElementById("zip").value, country:document.getElementById("country").selectedItem.value};
	}
	else if (type == "E" || type == "B" || type == "W") {
		window.arguments[0].info = document.getElementById("web-address").value;
	}
	else {
		window.arguments[0].info = {areaCode:document.getElementById("area-code").value, number:document.getElementById("phone-number").value};
	}
	return true;
}

// when you click cancel, tell the main script
function cancelTrack(){
	window.arguments[0].type = "q";
	return true;
}

// when you choose a contact type, set visibility of fields
function setFields() {
	var type = document.getElementById("outer-select-type").selectedItem.value;
	if (type == "A") {
		document.getElementById("address-fields").style.visibility = "visible";
		document.getElementById("phone-fields").style.visibility = "collapse";
		document.getElementById("email-web-fields").style.visibility = "collapse";
		document.getElementById("choose-location").style.visibility = "visible";
	}
	else if (type == "E" || type == "W" || type == "B") {
		document.getElementById("address-fields").style.visibility = "collapse";
		document.getElementById("phone-fields").style.visibility = "collapse";
		document.getElementById("email-web-fields").style.visibility = "visible";
		document.getElementById("choose-location").style.visibility = "collapse";
	}
	else {
		document.getElementById("address-fields").style.visibility = "collapse";
		document.getElementById("phone-fields").style.visibility = "visible";
		document.getElementById("email-web-fields").style.visibility = "collapse";
		document.getElementById("choose-location").style.visibility = "collapse";
	}
}


