$Version=2$
partner_window "widget/page"
    {
    width = 844;
    height=600;
    title = "Kardia - Partners";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    // If needing to pre-load a particular partner record, use this parameter.
    id "widget/parameter" { type=string; default=null; }
    search "widget/parameter" { type=string; default=null; }
    ledger "widget/parameter" { type=string; default=null; }
    send_refresh "widget/parameter" { type=integer; default=0; }
    send_refresh_to "widget/parameter" { type=object; }
    partner_only "widget/parameter" { type=integer; default=0; }

    this_form_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/partner_edit.cmp"; 
	id = runserver(:this:id);
	ledger = runserver(:this:ledger);
	search = runserver(:this:search);
	send_refresh = runserver(:this:send_refresh);
	send_refresh_to = send_refresh_to;
	partner_only = partner_only;
	}
    }
