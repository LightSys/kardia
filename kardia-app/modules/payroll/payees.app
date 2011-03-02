$Version=2$
payees "widget/page"
    {
    title = "Payees (for Payroll)";
    width=778; height=525;
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
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
	path = "/apps/kardia/modules/payroll/payees.cmp";
	ledger = runserver(:this:ledger);
	paydet = paydet;
	}
    }
