$Version=2$
dup_check "widget/page"
    {
    width=806;
    height=562;
    title = "Duplicate Scan";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    partner_key "widget/parameter" { type=string; deploy_to_client=yes; }
    location_id "widget/parameter" { type=string; deploy_to_client=yes; }
    given_name "widget/parameter" { type=string; deploy_to_client=yes; }
    surname "widget/parameter" { type=string; deploy_to_client=yes; }
    org_name "widget/parameter" { type=string; deploy_to_client=yes; }
    address_1 "widget/parameter" { type=string; deploy_to_client=yes; }
    city "widget/parameter" { type=string; deploy_to_client=yes; }
    state_province "widget/parameter" { type=string; deploy_to_client=yes; }
    postal_code "widget/parameter" { type=string; deploy_to_client=yes; }

    email_phone_osrc "widget/osrc"
	{
	epo_partner_key "widget/parameter" { param_name=partner_key; type=string; default=runclient(:partner_key:value); }
	sql = runserver("
		SELECT
			email1 = (select :p_contact_data from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and :p_contact_type = 'E' and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 0,1),
			email2 = (select :p_contact_data from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and :p_contact_type = 'E' and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 1,1),
			phone1_area = (select :p_phone_area_city from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and (:p_contact_type = 'P' or :p_contact_type = 'C' or :p_contact_type = 'F') and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 0,1),
			phone1_number = (select :p_contact_data from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and (:p_contact_type = 'P' or :p_contact_type = 'C' or :p_contact_type = 'F') and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 0,1),
			phone2_area = (select :p_phone_area_city from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and (:p_contact_type = 'P' or :p_contact_type = 'C' or :p_contact_type = 'F') and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 1,1),
			phone2_number = (select :p_contact_data from /apps/kardia/data/Kardia_DB/p_contact_info/rows where :p_partner_key = :parameters:partner_key and (:p_contact_type = 'P' or :p_contact_type = 'C' or :p_contact_type = 'F') and :p_record_status_code = 'A' ORDER BY :p_contact_id LIMIT 1,1)
		");
	autoquery = onload;
	readahead = 2;
	replicasize = 2;

	trigger_dup_check "widget/connector"
	    {
	    event=EndQuery;
	    target=dup_check_cmp;
	    action=ScanForDups;
	    given_name = runclient(:dup_check:given_name);
	    surname = runclient(:dup_check:surname);
	    org_name = runclient(:dup_check:org_name);
	    address_1 = runclient(:dup_check:address_1);
	    city = runclient(:dup_check:city);
	    state_province = runclient(:dup_check:state_province);
	    postal_code = runclient(:dup_check:postal_code);
	    exclude_partner_key = runclient(:dup_check:partner_key);
	    email1 = runclient(:email_phone_osrc:email1);
	    email2 = runclient(:email_phone_osrc:email2);
	    phone1_area = runclient(:email_phone_osrc:phone1_area);
	    phone2_area = runclient(:email_phone_osrc:phone2_area);
	    phone1_number = runclient(:email_phone_osrc:phone1_number);
	    phone2_number = runclient(:email_phone_osrc:phone2_number);
	    }
	}

    dup_check_cmp "widget/component"
	{
	x=10; y=10;
	width=786;
	height=542;
	path="dup_check.cmp";

	close_cn "widget/connector" { event=ClosePressed; target=dup_check; action=Close; }
	}
    }
