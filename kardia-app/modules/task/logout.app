$Version=2$
logout "widget/page"
    {
    // This is the logout app.  When the user loads this app, it will
    // display and then log them out.
    //
    title="Logged Out - Kardia Project Management";
    width=1000;
    height=800;
    background=null;
    bgcolor=black;
    //require_endorsements="system:from_application";
    max_requests = 10;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    kbdfocus1="#6080c0";
    kbdfocus2="#6080c0";
    logout = yes;

    dashboard "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }

    main_vbox "widget/vbox"
	{
	widget_template = "/apps/kardia/modules/task/tasks.tpl";
	x=0; y=0; width=1000; height=800;
	spacing=10;
	align=center;

	action_bar_ctx_hbox "widget/hbox"
	    {
	    height=88;
	    spacing=12;
	    align=center;

	    logo_icon "widget/image"
		{
		source="/apps/kardia/images/artwork/Kardia2011_transcorner.png";
		y=19;
		width=56;
		height=38;

		logoclick "widget/connector" { event=Click; target=logout; action=LoadPage; Source=runclient(condition(:dashboard:value = 0, "/apps/kardia/modules/task/", "/apps/kardia/modules/task/dashboard.app")); }
		}

	    bar_title "widget/label"
		{
		fl_width=0;
		width=runserver(condition(:this:dashboard = 0, 120, 310));
		y=20;
		font_size=32;
		style=bold;
		text=runserver(condition(:this:dashboard = 0, "Projects", "Project Dashboard"));
		fgcolor=white;
		align=right;
		}
	    }

	lbl_hbox "widget/hbox"
	    {
	    height=16;
	    align=center;

	    logged_out_label "widget/label"
		{
		width=300;
		height=16;
		font_size=16;
		align=center;
		text="You are now logged out of Kardia.";
		fgcolor=white;
		}
	    }

	note_hbox "widget/hbox"
	    {
	    height=50;
	    align=center;

	    note_label "widget/label"
		{
		width=400;
		height=50;
		font_size=12;
		align=center;
		text="To force your browser to forget your HTTP authentication credentials, either close your browser, or click the button below and then cancel out of the login dialog.";
		fgcolor=white;
		}
	    }

	btn_hbox "widget/hbox"
	    {
	    height=24;
	    align=center;

	    log_in_btn "widget/textbutton"
		{
		height=24;
		width=140;
		text = "Log In";

		btnclick "widget/connector" { event=Click; target=logout; action=LoadPage; Source=runclient(condition(:dashboard:value = 0, "/apps/kardia/modules/task/", "/apps/kardia/modules/task/dashboard.app")); }
		}
	    }
	}
    }
