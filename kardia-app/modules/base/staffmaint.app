$Version=2$
staffmaint "widget/page"
    {
    title = "Manage Staff";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    staffmaint_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	path = "/apps/kardia/modules/base/staffmaint.cmp";
	ledger = runserver(:this:ledger);
	}
    }
