$Version=2$
partner_window "widget/page"
    {
    width = 844;
    height=600;
    title = "i18n:Kardia - Partners";
    show_diagnostics = yes;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    // If needing to pre-load a particular partner record, use this parameter.
    id "widget/parameter" { type=string; default=null; }

    ledger "widget/parameter" { type=string; default=null; }

    this_form_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/partner_edit.cmp"; 
	id = runserver(:this:id);
	ledger = runserver(:this:ledger);
	}
    }
