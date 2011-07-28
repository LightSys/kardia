$Version=2$
batches "widget/page"
    {
    title = "i18n:GL Batches";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    year_period "widget/parameter" { type=string; default=null; }
    period "widget/parameter" { type=string; default=null; }

    batches_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver((not (:this:ledger is null)));
	path = "/apps/kardia/modules/gl/generic_byperiod.cmp";
	title = "i18n:GL Batches";
	embed = "/apps/kardia/modules/gl/batches.cmp";
	ledger = runserver(:this:ledger);
	year_period = runserver(:this:year_period);
	period = runserver(:this:period);
	}
    }
