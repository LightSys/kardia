$Version=2$
item_types "widget/page"
    {
    width=800; height=600;
    title = "Payroll Line Item Types";
    background="/apps/kardia/images/bg/light_bgnd2.jpg";
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    tax_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/tax_table_window.cmp";
	ledger = runserver(:this:ledger);
	ttwin = tax_cmp;
	}

    it_cmp "widget/component"
	{
	path = "/apps/kardia/modules/payroll/item_types.cmp";
	ledger = runserver(:this:ledger);
	ttwin = tax_cmp;
	}
    }
