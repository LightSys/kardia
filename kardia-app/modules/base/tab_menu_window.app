$Version=2$
tab_menu_window "widget/page"
    {
    width = 546;
    height = 591;
    title = "Kardia Menu";
    background="/apps/kardia/images/bg/light_bgnd2.jpg";

    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    pnHeader "widget/pane"
	{
	x=0;y=0;width=546;height=37;
	style=flat;
	//bgcolor=white;
	background="/apps/kardia/images/bg/splash3.png";
	}

    tab_menu_cmp "widget/component"
	{
	x=8;y=45;width=530;height=538;
	path = "/apps/kardia/modules/base/tab_menu.cmp";
	}
    }
