$Version=2$
coamaint "widget/page"
    {
    title = "i18n:Chart of Accounts Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    coamaint_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver((not (:this:ledger is null)));
	path = "/apps/kardia/modules/gl/coamaint.cmp";
	ledger = runserver(:this:ledger);
	}
    }
