$Version=2$
gift_import "widget/page"
    {
    title = "Gift Import";
    width=844;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:gift_entry";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests=9;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    gift_imp_cmp "widget/component"
	{
	x=10; y=10; width=824; height=580;
	path = "/apps/kardia/modules/rcpt/gift_import.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
