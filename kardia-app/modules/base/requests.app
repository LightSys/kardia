$Version=2$
requests "widget/page"
    {
    width = 844;
    height=600;
    title = "Kardia - Requests";
    show_diagnostics = yes;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    // If needing to pre-load a particular partner record, use this parameter.
    ledger "widget/parameter" { type=string; default=null; }

    requests_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/requests.cmp"; 
	ledger = runserver(:this:ledger);
	}
    }
