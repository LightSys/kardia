//when the dialog opens, center dialog
function startDialog() {
	// move to center of parent window
	centerWindowOnScreen();

	// if address, add countries
	if (window.arguments[0].type == "A") {
		document.getElementById("inner-country").innerHTML = mainWindow.htmlEscape(window.arguments[1]);
	}
	
	// choose correct type
	setFields();
}

// when you click "OK" on the Edit Contact Item dialog, send results to main script
function saveTrack(){
	var type = window.arguments[0].type;
	window.arguments[0].setInactive = document.getElementById("delete").checked;
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
  	window.arguments[0].type = "Q";
	return true;
}

// when you choose a contact type, set visibility of fields
function setFields() {
	var type = window.arguments[0].type;
	if (type == "A") {
		document.getElementById("address-fields").style.visibility = "visible";
		document.getElementById("phone-fields").style.visibility = "collapse";
		document.getElementById("email-web-fields").style.visibility = "collapse";
		document.getElementById("choose-location").style.visibility = "visible";

		var contactRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var contactUrl = window.arguments[2] + "apps/kardia/api/partner/Partners/" + window.arguments[3] + "/Addresses" + "?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
		var contactResp;
		
		contactRequest.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(contactRequest.readyState == 4 && contactRequest.status == 200) {
						  
				// parse the JSON returned from the request
				contactResp = JSON.parse(contactRequest.responseText);
				
				// get all the keys from the JSON file
				for(var k in contactResp) {
					if (k == window.arguments[3] + "|" + window.arguments[4] + "|" + 0) {
						document.getElementById("address1").value = contactResp[k]['address_1'];
						document.getElementById("address2").value = contactResp[k]['address_2'];
						document.getElementById("address3").value = contactResp[k]['address_3'];
						document.getElementById("city").value = contactResp[k]['city'];
						document.getElementById("state").value = contactResp[k]['state_province'];
						document.getElementById("zip").value = contactResp[k]['postal_code'];
					
						var numCountries = document.getElementById("inner-country").childElementCount;
						
						// select country
						if (contactResp[k]['country_code'] != null) {
							document.getElementById("country").selectedIndex = window.arguments[5].indexOf(contactResp[k]['country_code']);
							if (document.getElementById("country").selectedIndex < 0) {
								//document.getElementById("country").selectedIndex = 0;
							}
						}

						// select location type
						document.getElementById("outer-select-location").selectedIndex = 0;
						while (document.getElementById("outer-select-location").selectedItem.value != contactResp[k]['location_type_code']) {
							document.getElementById("outer-select-location").selectedIndex++;
						}

						break;
					}
				}
			}
		};
		// do nothing if the contact request errors
		contactRequest.onerror = function(aEvent) {};
		
		// send contact info HTTP request
		contactRequest.open("GET", contactUrl, true);
		contactRequest.send(null);
	}
	else if (type == "E" || type == "W") {
		document.getElementById("address-fields").style.visibility = "collapse";
		document.getElementById("phone-fields").style.visibility = "collapse";
		document.getElementById("email-web-fields").style.visibility = "visible";
		document.getElementById("choose-location").style.visibility = "collapse";

		var contactRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var contactUrl = window.arguments[2] + "apps/kardia/api/partner/Partners/" + window.arguments[3] + "/ContactInfo" + "?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
		var contactResp;

		contactRequest.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(contactRequest.readyState == 4 && contactRequest.status == 200) {
						  
				// parse the JSON returned from the request
				contactResp = JSON.parse(contactRequest.responseText);
				
				// get all the keys from the JSON file
				for(var k in contactResp) {
					if (k == window.arguments[3] + "|" + window.arguments[4]) {
						document.getElementById("web-address").value = contactResp[k]['contact_data'];
						break;
					}
				}
			}
		};
		// do nothing if the contact request errors
		contactRequest.onerror = function(aEvent) {};
		
		// send contact info HTTP request
		contactRequest.open("GET", contactUrl, true);
		contactRequest.send(null);
	}
	else {
		document.getElementById("address-fields").style.visibility = "collapse";
		document.getElementById("phone-fields").style.visibility = "visible";
		document.getElementById("email-web-fields").style.visibility = "collapse";
		document.getElementById("choose-location").style.visibility = "collapse";

		var contactRequest = Components.classes["@mozilla.org/xmlextras/xmlhttprequest;1"].createInstance(Components.interfaces.nsIXMLHttpRequest);
		var contactUrl = window.arguments[2] + "apps/kardia/api/partner/Partners/" + window.arguments[3] + "/ContactInfo" + "?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
		var contactResp;
		
		contactRequest.onreadystatechange  = function(aEvent) {
			// if the request went through and we got success status
			if(contactRequest.readyState == 4 && contactRequest.status == 200) {
						  
				// parse the JSON returned from the request
				contactResp = JSON.parse(contactRequest.responseText);
				
				// get all the keys from the JSON file
				for(var k in contactResp) {
					if (k == window.arguments[3] + "|" + window.arguments[4]) {
						document.getElementById("area-code").value = contactResp[k]['phone_area_city'];
						document.getElementById("phone-number").value = contactResp[k]['contact_data'];
						break;
					}
				}
			}
		};
		// do nothing if the contact request errors
		contactRequest.onerror = function(aEvent) {};
		
		// send contact info HTTP request
		contactRequest.open("GET", contactUrl, true);
		contactRequest.send(null);
	}
}

