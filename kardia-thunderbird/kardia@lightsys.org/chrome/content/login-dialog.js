// on opening dialog, if this was result of a failed login, set the "failed login label" visible
function doOnLoginLoad () { 
	if (window.arguments[0].showFailMessage) {
		document.getElementById("login-failed-label").innerHTML = "Invalid username or password.  Please try again.";
	}
}

// function that is called when you click "OK" on the Add Note/Prayer dialog
function login(){
	var username = document.getElementById("username-text").value;
	var password = document.getElementById("password-text").value;
	
	if (document.getElementById("save-password").checked) {
		// save username/password
		var passwordManager = Components.classes["@mozilla.org/login-manager;1"].getService(
			Components.interfaces.nsILoginManager
		);
		var nsLoginInfo = new Components.Constructor(
			"@mozilla.org/login-manager/loginInfo;1",
			Components.interfaces.nsILoginInfo,
			"init"
		);
		var formLoginInfo = new nsLoginInfo(
			"chrome://kardia",
			null,
			"Kardia Login",
			username,
			password,
			"",
			""
		);
		passwordManager.addLogin(formLoginInfo);
	}

	window.arguments[0].username = username;
	window.arguments[0].password = password;
	window.arguments[0].cancel = false;
	return true;
}

// function that is called when you click "Cancel"
function cancel(){
  // tell program you cancelled it
  window.arguments[0].cancel = true;
  return true;
}