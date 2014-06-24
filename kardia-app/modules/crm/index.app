$Version=2$

// index.app for CRM module in Kardia.
//
// Copyright (C) 2014 LightSys Technology Services, Inc.
// Written 23-May-2014 by Greg Beeley
//
// This file is free software, licensed under the GPL version 2, or at
// your option, any later version released by the Free Software Foundation.
// See the file COPYING accompanying this source file for further details.
//
// The above "$Version=2$" identifies the file format version of this
// structure file.  Below, the word "index" is the name of the app, and
// the quoted "widget/page" is the object type of "index", in other words,
// a Page widget (the main widget representing an application).
//
index "widget/page"
    {
    // Basic information about the application - title, width and height.
    // The width and height are the "design" width and height.  If the 
    // browser window is a different size, the system automatically scales
    // the application to fit.  The main menu also queries this file for
    // its width and height and uses that when launching the application
    // from the menu.
    //
    title = "Kardia CRM - Structured Engagement";
    width = 1000;
    height = 600;

    // This is the template to use -- it is much like a CSS stylesheet,
    // providing basic information about the look and feel of the 
    // application.  It also includes the template containing user
    // preferences, which also includes the template for the overall
    // theme that is in use.
    //
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";

    // Background image for the window.
    //
    //background = "/apps/kardia/images/bg/light_bgnd.jpg";
    bgcolor="#f0f0f0";
    background = null;

    // Security control -- only users with the "kardia:crm" endorsement are
    // allowed to use this application.
    //
    require_endorsements = "kardia:crm";
    endorsement_context = "kardia";

    // And here is the component containing the active collaboration list on
    // the lefthand side and the Partner profile on the righthand side.  The
    // path for the component is relative to the path of the application,
    // unless the component's path begins with a slash.
    //
    list_and_profile "widget/component"
	{
	x = 10; y = 10;
	width = 980; height = 580;
	path = "list_and_profile.cmp";
	}
    }

