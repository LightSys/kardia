$Version=2$
de_batches "widget/page"
    {
    title = "Cash Deposit Batches";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:dep","kardia:dep_entry","kardia:dep_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    debatches_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/generic_byperiod.cmp";
	title = "Deposits";
	embed = "/apps/kardia/modules/rcpt/de_batches.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
