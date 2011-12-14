$Version=2$
new_partner "widget/page"
    {
    width = 844;
    height=600;
    title = "Kardia - Add a Partner";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; }
    return_to "widget/parameter" { type=object; default=null; deploy_to_client=yes; }
    set_donor "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_payee "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_staff "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }

    new_partner_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/new_partner.cmp"; 
	ledger = runserver(:this:ledger);
	return_to = return_to;
	set_donor=runserver(:this:set_donor);
	set_payee=runserver(:this:set_payee);
	set_staff=runserver(:this:set_staff);
	}
    }
