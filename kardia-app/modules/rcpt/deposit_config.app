$Version=2$
deposit_config "widget/page"
    {
    title = "Online Giving Deposits/Fees";
    width=960;
    height=640;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    dc_cmp "widget/component"
	{
	x=10; y=10; width=940; height=620;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/deposit_config.cmp";
	ledger = runserver(:this:ledger);
	}
    }
