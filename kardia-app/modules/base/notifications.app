$Version=2$
notifications "widget/page"
    {
    width = 844;
    height = 600;
    title = "Kardia - Notification Queue";
    show_diagnostics = yes;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background = "/apps/kardia/images/bg/light_bgnd.jpg";

    // If needing to view the queue for just one recipient, pass the partner key here.
    partner "widget/parameter" { type=string; default=null; }

    notifications_cmp "widget/component"
	{
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/notifications.cmp";
	partner = runserver(:this:partner);
	}
    }
