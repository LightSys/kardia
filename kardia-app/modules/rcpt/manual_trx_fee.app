$Version=2$
manual_trx_fee "widget/page"
    {
    title = "Manual Gift Transaction Fees";
    width=844;
    height=640;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    manual_trx_fee_cmp "widget/component"
	{
	x=10; y=10; width=824; height=620;
	path = "/apps/kardia/modules/rcpt/manual_trx_fee.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
