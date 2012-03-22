$Version=2$
map "widget/page"
    {
    width=840;
    height=681;
    title = "Kardia - Map View";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    map_cmp "widget/component"
	{
	path = "map.cmp";
	x=10; y=10;
	width=820; height=680;
	}
    }
