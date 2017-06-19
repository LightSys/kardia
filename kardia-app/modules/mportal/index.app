$Version=2$

// index.app for Missionary Portal in Kardia.
//
// Copyright (C) 2016 LightSys Technology Services, Inc.
// Written 18-Nov-2016 by Greg Beeley
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
    title = "Kardia Missionary Portal";
    width = 1200;
    height = 700;
    max_requests = 6;

    // This is the template to use -- it is much like a CSS stylesheet,
    // providing basic information about the look and feel of the 
    // application.  It also includes the template containing user
    // preferences, which also includes the template for the overall
    // theme that is in use.
    //
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", "/apps/kardia/modules/crm/crm.tpl";

    // Background image for the window.
    //
    //background = "/apps/kardia/images/bg/light_bgnd.jpg";
    bgcolor="#ffffff";
    background = null;

    // Security control -- only users with the "kardia:crm" endorsement are
    // allowed to use this application.
    //
    //require_endorsements = "kardia:crm";
    //endorsement_context = "kardia";

    // Main interface
    //
    mportal "widget/component"
	{
	x=0; y=0;
	width=1200; height=700;
	path="mportal.cmp";
	us = mportal;
	}
    }

