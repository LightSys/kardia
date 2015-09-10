var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIWebNavigation)
	   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
	   .rootTreeItem
	   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
	   .getInterface(Components.interfaces.nsIDOMWindow);
mainWindow.dataTab = this;
var kardiaTab = mainWindow.kardiaTab;
var kardiacrm = mainWindow.kardiacrm;

function loadData() {
	// get arguments passed from main page
	var getArgs = decodeURIComponent(document.location.href);
	getArgs = getArgs.substring(getArgs.indexOf('?')+1,getArgs.length);
	var fullArgs = getArgs.split('&');

	var args = new Array();
	for (var i=0;i<fullArgs.length;i++) {
		args.push(fullArgs[i].split('='));
	}

	// set title and name
	document.title = args[0][1];
	document.getElementById("data-item-name").value = args[0][1];

	// add data items
	for (var i=1;i<args.length;i+=2) {
		if (args[i+1][1] == "0") {
			// not highlighted, so don't highlight the data item
			document.getElementById("main-data").innerHTML += '<vbox tooltiptext="Click to filter by this data item" onclick="filterAndShowTab(\'' + args[i][1] + '\');"><label>' + args[i][1] + '</label></vbox>';
		}
		else {
			// highlight it
			document.getElementById("main-data").innerHTML += '<vbox tooltiptext="Click to filter by this data item" class="highlighted" onclick="filterAndShowTab(\'' + args[i][1] + '\');"><label>' + args[i][1] + '</label></vbox>';
		}
	}
}

// add filter and show Kardia tab
function filterAndShowTab(filter) {
	kardiaTab.addFilter("d", filter, false);
	mainWindow.showKardiaTab();
}
