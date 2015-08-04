$Version=2$
cd_batches "widget/page"
    {
    title = "Disbursements Batches";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement = "kardia:disb_manage","kardia:disb_entry","kardia:disb";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    cdbatches_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/generic_byperiod.cmp";
	title = "Cash Disbursements";
	embed = "/apps/kardia/modules/disb/cd_batches.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
