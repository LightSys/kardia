$Version=2$
whoson_window "widget/page"
    {
    width = 298;
    height = 591;
    title = "i18n:Kardia - Who's Online";
    background="/apps/kardia/images/bg/light_bgnd2.jpg";

    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    pnHeader "widget/pane"
	{
	x=0;y=0;width=298;height=45;
	style=flat;
	//bgcolor=white;
	background="/apps/kardia/images/bg/splash3.png";
	}

    whoson_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/whoson.cmp";
	x=8;y=53;
	width=282;height=530;
	auto_start = 1;
	}
    }
