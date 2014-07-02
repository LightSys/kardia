$Version=2$
prefs "widget/page"
    {
    width=500; height=475;
    title = "Kardia Preferences";

    //background="/apps/kardia/images/bg/light_bgnd2.jpg";
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    pnHeader "widget/pane"
	{
	x=0;y=0;width=500;height=45;
	style=flat;
	//bgcolor=white;
	background="/apps/kardia/images/bg/splash3.png";
	}

    prefs_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/prefs.cmp";
	x=10;y=50;
	width=480;height=405;
	}
    }
