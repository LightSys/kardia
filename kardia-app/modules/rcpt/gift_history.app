$Version=2$
gift_history "widget/page"
    {
    title = "Gift History Search";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:gift","kardia:gift_entry","kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    by_donor "widget/parameter" { type=integer; default=1; }

    ge_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/gift_entry.cmp";
	ledger = runserver(:this:ledger);
	by_donor = runserver(:this:by_donor);
	}
    }
