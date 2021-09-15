$Version=2$
gift_history "widget/page"
    {
    title = "Gift History Search";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl"), "/apps/kardia/modules/rcpt/gift.tpl";
    //background="/apps/kardia/images/bg/light_bgnd.jpg";
    bgcolor=white;
    background=null;
    require_one_endorsement="kardia:gift","kardia:gift_entry","kardia:gift_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests=9;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    by_donor "widget/parameter" { type=integer; default=1; }

    ge_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/gift_entry.cmp";
	ledger = runserver(:this:ledger);
	by_donor = runserver(:this:by_donor);
	}
    }
