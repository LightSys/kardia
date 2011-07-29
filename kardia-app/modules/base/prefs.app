$Version=2$
prefs "widget/page"
    {
    width=500; height=475;
    title = "Kardia Preferences";

    background="/apps/kardia/images/bg/light_bgnd2.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    prefs_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/prefs.cmp";
	width=500;height=475;
	}
    }
