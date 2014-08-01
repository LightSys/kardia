// on opening dialog, if this was result of a failed login, set the "failed login label" visible
function doOnLoginLoad () { 
	var temp;
	for (var a in window.arguments[0]) {
		temp += a + "\n";
	}
	
	if (window.arguments[0].prevFail) {
		if (window.arguments[0].prevSaved) {
			document.getElementById("login-failed-label").innerHTML = "There was a problem with your saved login information.  Please login now.";		  
		}
		else {
			document.getElementById("login-failed-label").innerHTML = "Invalid username or password.  Please try again.";
		}
	}
}

// function that is called when you click "OK" on the login dialog
function login(){
	var username = document.getElementById("username-text").value;
	var password = document.getElementById("password-text").value;

	window.arguments[0].username = username;
	window.arguments[0].password = password;
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
