$Version=2$
gift_entry "widget/page"
    {
    title = "Gift Entry";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl"), "/apps/kardia/modules/rcpt/gift.tpl";
    //background="/apps/kardia/images/bg/light_bgnd.jpg";
    bgcolor=white;
    background=null;
    require_one_endorsement="kardia:gift_manage","kardia:gift_entry","kardia:gift";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests=9;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }
    receipt "widget/parameter" { type=string; default=null; }
    by_donor "widget/parameter" { type=integer; default=0; }

    ge_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/rcpt/gift_entry.cmp";
	ledger = runserver(:this:ledger);
	batch = runserver(:this:batch);
	receipt = runserver(:this:receipt);
	by_donor = runserver(:this:by_donor);
	}
    }
