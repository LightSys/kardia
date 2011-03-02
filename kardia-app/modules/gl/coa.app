$Version=2$
coa "widget/page"
    {
    title = "Chart of Accounts";
    width=800; height=600;

    widget_template = "/apps/kardia/tpl/organization-kardia.tpl";

    cnLoad "widget/connector"
	{
	event = "Load";
	target=ledger_cmp;
	action=Open;
	}

    ledger_cmp "widget/component"
	{
	path = "/apps/kardia/modules/gl/coa_window.cmp";
	}
    }
