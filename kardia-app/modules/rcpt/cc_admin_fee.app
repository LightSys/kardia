$Version=2$
cc_admin_fee "widget/page"
    {
    title = "Admin Fees for Funds Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    af_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	path = "/apps/kardia/modules/rcpt/cc_admin_fee.cmp";
	ledger = runserver(:this:ledger);
	}
    }
