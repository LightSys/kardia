$Version=2$
new_partner "widget/page"
    {
    width = 844;
    height=600;
    title = "Kardia - Add a Partner";
    icon = "/apps/kardia/images/icons/ionicons-person-add.svg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; }
    return_to "widget/parameter" { type=object; default=null; deploy_to_client=yes; }
    set_return "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_donor "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_payee "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_staff "widget/parameter" { type=integer; default=0; deploy_to_client=yes; }
    set_given_name "widget/parameter" { type=string; }
    set_surname "widget/parameter" { type=string; }
    set_salutation "widget/parameter" { type=string; }
    set_addr1 "widget/parameter" { type=string; }
    set_addr2 "widget/parameter" { type=string; }
    set_city "widget/parameter" { type=string; }
    set_state_province "widget/parameter" { type=string; }
    set_postal "widget/parameter" { type=string; }
    set_country_code "widget/parameter" { type=string; }
    set_email "widget/parameter" { type=string; }
    set_phone "widget/parameter" { type=string; }
    set_comment "widget/parameter" { type=string; }

    new_partner_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/new_partner.cmp"; 
	ledger = runserver(:this:ledger);
	return_to = return_to;
	set_return=runserver(:this:set_return);
	set_donor=runserver(:this:set_donor);
	set_payee=runserver(:this:set_payee);
	set_staff=runserver(:this:set_staff);
	set_given_name=runserver(:this:set_given_name);
	set_surname=runserver(:this:set_surname);
	set_salutation=runserver(:this:set_salutation);
	set_addr1=runserver(:this:set_addr1);
	set_addr2=runserver(:this:set_addr2);
	set_city=runserver(:this:set_city);
	set_state_province=runserver(:this:set_state_province);
	set_postal=runserver(:this:set_postal);
	set_country_code=runserver(:this:set_country_code);
	set_email=runserver(:this:set_email);
	set_phone=runserver(:this:set_phone);
	set_comment=runserver(:this:set_comment);
	}
    }
