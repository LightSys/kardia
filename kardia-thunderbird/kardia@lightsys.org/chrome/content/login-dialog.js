// on opening dialog, if this was result of a failed login, set the "failed login label" visible
function doOnLoginLoad () { 
	if (window.arguments[0].prevFail) {
		if (window.arguments[0].prevSaved) {
			document.getElementById("login-failed-label").innerHTML = "There was a problem with your saved login information.  Please login now.";		  
		}
		else {
			document.getElementById("login-failed-label").innerHTML = "Invalid username, password, or server.  Please try again.";
		}
	}

	document.getElementById("username-text").value = window.arguments[0].username;
	document.getElementById("password-text").value = window.arguments[0].password;
	if (window.arguments[0].server != "") {
		document.getElementById("server-text").value = window.arguments[0].server.substring(0,window.arguments[0].server.indexOf(":",6));
		document.getElementById("port-text").value = window.arguments[0].server.substring(window.arguments[0].server.indexOf(":",6)+1, window.arguments[0].server.length-1);
	}
}

// function that is called when you click "OK" on the login dialog
function login(){
	window.arguments[0].username = document.getElementById("username-text").value;
	window.arguments[0].password = document.getElementById("password-text").value;
	window.arguments[0].server = document.getElementById("server-text").value + ":" + document.getElementById("port-text").value + "/";
	window.arguments[0].cancel = false;
	window.arguments[0].save = document.getElementById("save-password").checked;
	return true;
}

// function that is called when you click "Cancel"
function cancel(){
  // tell program you cancelled it
  window.arguments[0].cancel = true;
  return true;
}
