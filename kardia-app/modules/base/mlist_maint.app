$Version=2$
mlist_maint "widget/page"
    {
    title = "Mailing Lists Maintenance";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    list "widget/parameter" { type=string; default=null; }

    mlist_maint_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	path = "/apps/kardia/modules/base/mlist_maint.cmp";
	ledger = runserver(:this:ledger);
	list = runserver(:this:list);
	}
    }
