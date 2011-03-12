$Version=2$
financial_statement "widget/page"
    {
    title = "Missionary Financial Statement";
    width=780; height=550;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    mfs_cmp "widget/component"
	{
	path = "/apps/kardia/modules/payroll/financial_statement.cmp";
	ledger = runserver(:this:ledger);
	page = financial_statement;
	}
    }
