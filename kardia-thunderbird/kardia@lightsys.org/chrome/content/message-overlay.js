// Kardia CRM Javascript file for pop-up message display window
//

// We need to link to our CRM data that's over in the main window context.
var mainWindow = Components.classes["@mozilla.org/appshell/window-mediator;1"]
	.getService(Components.interfaces.nsIWindowMediator)
	.getMostRecentWindow("mail:3pane");
var kardiacrm = mainWindow.kardiacrm;
kardiacrm.lastMessageWindow = window;

addEventListener("load", function()
    {
    // Add the kardia icons/flags when the message is rendered.
    gMessageListeners.push
	({
	onEndHeaders: function ()
	    {
	    if (kardiacrm.logged_in)
		{
		mainWindow.addKardiaButton(window);
		}
	    },
	onStartHeaders: function() {},
	onStartAttachments: function () {},
	onEndAttachments: function () {},
	onBeforeShowHeaderPane: function () {},
	});

    }, false);

