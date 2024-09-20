$Version=2$
runpayroll "widget/page"
    {
    title = "Bank Reconciliation - Kardia";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:recon";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 7;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    rec_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	path = "/apps/kardia/modules/bank_rec/bank_rec.cmp";
	title = "Bank Reconciliation";
	embed = "/apps/kardia/modules/bank_rec/bank_rec.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
