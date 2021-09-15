$Version=2$
pledges "widget/page"
    {
    title = "Manage Donor Pledges and Intents";
    width=820;
    height=650;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    pl_cmp "widget/component"
	{
	x=10; y=10; width=800; height=630;
	path = "/apps/kardia/modules/rcpt/pledges.cmp";
	ledger = runserver(:this:ledger);
	}
    }
