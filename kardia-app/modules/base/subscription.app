$Version=2$
subscription "widget/page"
    {
    title = "Subscription Details";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    partner "widget/parameter" { type=string; default=null; }
    list "widget/parameter" { type=string; default=null; }
    hist_id "widget/parameter" { type=integer; default=null; }
    send_update "widget/parameter" { type=integer; default=0; }
    mlist_parent_osrc "widget/parameter" { type=object; }

    subscription_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	path = "/apps/kardia/modules/base/subscription.cmp";
	partner = runserver(:this:partner);
	list = runserver(:this:list);
	hist_id = runserver(:this:hist_id);
	send_update = runserver(:this:send_update);
	mlist_parent_osrc = mlist_parent_osrc;
	}
    }
