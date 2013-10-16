$Version=2$
receipt_types "widget/page"
    {
    title = "Receipt Types";
    width=800;
    height=500;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    rt_cmp "widget/component"
	{
	x=10; y=10; width=780; height=480;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/receipt_types.cmp";
	ledger = runserver(:this:ledger);
	}
    }
