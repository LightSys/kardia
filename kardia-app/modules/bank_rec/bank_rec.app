$Version=2$
runpayroll "widget/page"
    {
    title = "Bank Reconciliation - Kardia";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:pay_manage"; // FIXME: needs own endorsement
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 7;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    rec_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/bank_rec/bank_byperiod.cmp";
	title = "Bank Reconciliation";
	embed = "/apps/kardia/modules/bank_rec/bank_rec.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	}
    }
