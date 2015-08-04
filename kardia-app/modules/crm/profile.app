$Version=2$

// profile.app for CRM module in Kardia.  This app displays just one
// person's profile, without the ability to navigate to other profiles via
// the people/tasks/activity/search/etc lists.
//
// Copyright (C) 2014-2015 LightSys Technology Services, Inc.
// Written 15-May-2015 by Greg Beeley
//
// This file is free software, licensed under the GPL version 2, or at
// your option, any later version released by the Free Software Foundation.
// See the file COPYING accompanying this source file for further details.
//
profileapp "widget/page"
    {
    width = 1000;
    height = 630;
    max_requests = 6;

    // This is the template to use -- it is much like a CSS stylesheet,
    // providing basic information about the look and feel of the 
    // application.  It also includes the template containing user
    // preferences, which also includes the template for the overall
    // theme that is in use.
    //
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", "/apps/kardia/modules/crm/crm.tpl";

    // Parameters that can be passed to this application
    partner_key "widget/parameter" { type=string; }

    // Background image for the window.
    //
    //background = "/apps/kardia/images/bg/light_bgnd.jpg";
    bgcolor="#ffffff";
    background = null;

    // Security control -- only users with the "kardia:crm" endorsement are
    // allowed to use this application.
    //
    require_endorsements = "kardia:crm";
    endorsement_context = "kardia";

    // Main CRM interface
    //
    crm "widget/component"
	{
	x=0; y=0;
	width=1000; height=630;
	path="crm.cmp";
	us = crm;
	show_profile_only=1;
	partner_key = runserver(:this:partner_key);
	}
    }

