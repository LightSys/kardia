$Version=2$
payees "widget/page"
    {
    title = "Payees (for Payroll)";
    width=778; height=525;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    // Payroll detail screen
    paydet "widget/component" 
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_detail_window.cmp";
	ledger = runserver(:this:ledger);
	}

    payee_cmp "widget/component"
	{
	condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/payroll/payees.cmp";
	ledger = runserver(:this:ledger);
	paydet = paydet;
	}
    }
