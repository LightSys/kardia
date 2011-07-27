$Version=2$
gift_entry "widget/page"
    {
    title = "i18n:Gift Entry";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }
    by_donor "widget/parameter" { type=integer; default=0; }

    ge_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/gift_entry.cmp";
	ledger = runserver(:this:ledger);
	batch = runserver(:this:batch);
	by_donor = runserver(:this:by_donor);
	}
    }
