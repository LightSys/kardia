$Version=2$
fundmaint "widget/page"
    {
    title = "Fund Maintenance";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gl_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 5;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    fund "widget/parameter" { type=string; default=null; }

    fundmaint_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/gl/fundmaint.cmp";
	ledger = runserver(:this:ledger);
	mainfund = runserver((select :a_bal_fund from /apps/kardia/data/Kardia_DB/a_fund/rows cc where :cc:a_ledger_number = :this:ledger and :cc:a_fund = :this:fund));
	fund = runserver(:this:fund);
	}
    }
