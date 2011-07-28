$Version=2$
coa "widget/page"
    {
    title = "i18n:Chart of Accounts";
    width=800; height=600;

    widget_template = "/apps/kardia/tpl/kardia-system.tpl";

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
