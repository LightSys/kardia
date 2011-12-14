$Version=2$
country_maint "widget/page"
    {
    title = "Country Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    country_maint_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	path = "/apps/kardia/modules/base/country_maint.cmp";
	ledger = runserver(:this:ledger);
	}
    }
