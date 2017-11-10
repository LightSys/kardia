// keep track of this window and Kardia tab
var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIWebNavigation)
	   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
	   .rootTreeItem
	   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIDOMWindow);	   
	   
window.addEventListener("load", function() {
  addKardiaButton();
}, false);

gMessageListeners.push({
	onEndHeaders: function () {},
	onStartHeaders: function() {if (loginValid) {findEmails();
	}}
	});

function addKardiaButton(){
 	
  	if(gExpandedHeaderView == null || gExpandedHeaderView.from == null || gExpandedHeaderView.from.textNode == null || gExpandedHeaderView.from.textNode.childNodes == null) {
	  setTimeout(function() {
	    addKardiaButton();
	  }, 1000);
	  return;
	}
	  
	// save list of header views we need to check
	var headersArray = [gExpandedHeaderView.from.textNode.childNodes, gExpandedHeaderView.to.textNode.childNodes, gExpandedHeaderView.cc.textNode.childNodes, gExpandedHeaderView.bcc.textNode.childNodes];
	// iterate through header views
	for (var j=0;j<headersArray.length;j++) {
		var nodeArray = headersArray[j];
		document.getElementById("hellobutton").label += "line30 " + j + " size: " + nodeArray.length;
		
		// iterate through children in the header view
		for (var i=0;i<nodeArray.length;i++) {
			// check if this node's email address is in the list from Kardia
			var email = nodeArray[i].getAttribute('emailAddress').toLowerCase();
			document.getElementById("hellobutton").label = "*" + email + "*" + mainWindow.emailAddresses;//.indexOf(email);
			
			if (email != null && email != "" &&  mainWindow.emailAddresses !== null && mainWindow.emailAddresses.length > 0 && mainWindow.emailAddresses.indexOf(email) >= 0) {
				// if so, make the button visible
				nodeArray[i].setAttribute("kardiaShowing","");
						  
				// make button select the right person on click
				nodeArray[i].setAttribute("kardiaOnclick","mainWindow.selected = mainWindow.emailAddresses.indexOf('" + email + "'); if (document.getElementById('main-box').collapsed) {toggleKardiaVisibility(3);} reload(false);");
			}
			
			else {
				// the person isn't from Kardia, so hide the button
				nodeArray[i].setAttribute("kardiaShowing","display:none");
			}
		}
	}
}