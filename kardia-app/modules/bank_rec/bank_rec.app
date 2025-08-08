$Version=2$
runpayroll "widget/page"
    {
    title = "Bank Reconciliation - Kardia";
    width=1400;
    height=650;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:recon";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 7;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    rec_cmp "widget/component"
	{
	x=10; y=10; width=1380; height=580;
	path = "/apps/kardia/modules/bank_rec/bank_rec.cmp";
	title = "Bank Reconciliation";
	ledger = runserver(:this:ledger);
	}
    }
