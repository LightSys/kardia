$Version=2$
annual_statement "widget/page"
    {
    title = "Annual Giving Statement for Donor";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=496;
	    spacing=4;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Annual Giving Statement Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    f_donorid "widget/component"
		{
		height=24;
		width=350;
		path="/apps/kardia/modules/base/editbox_table.cmp";
		field='donor_id';
		text='Donor ID:';
		label_width=120;
		popup_width=380;
		popup_sql="select value = :p:p_partner_key, label = condition(char_length(rtrim(:p:p_org_name)) > 0, :p:p_org_name, :p:p_given_name + ' ' + :p:p_surname) + isnull(' [' + :pl:p_city + ', ' + :pl:p_state_province + ' ' + :pl:p_postal_code + '] #' + :p:p_partner_key, '') from /apps/kardia/data/Kardia_DB/p_partner/rows p, /apps/kardia/data/Kardia_DB/p_location/rows pl where :p:p_partner_key *= :pl:p_partner_key";
		//search_field_list="p_partner_key,*p_given_name*,p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*,*p_comments";
		search_field_list="p_partner_key,*p_given_name*,p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*";
		key_name="p_partner_key";
		object_name="Donor";
		popup_text="Select a Donor:";
		//attach_point=editbox;

		donor_hints "widget/hints" { style=applyonchange; }
		}

	    f_period "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="year_period"; text="Year:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_parent_period is null and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }

	    sep1 "widget/autolayoutspacer" { height=4; }

	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='document_format'; 
		ctl_type=dropdown; 
		text='Format:'; 
		sql = runserver("select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
		form=rpt_form;
		label_width=120;
		}
	    }

	vb3 "widget/vbox"
	    {
	    x=32;y=512;width=514;height=40;
	    align=bottom;

	    spacing=4;

	    pn_sep2 "widget/pane" { height=2; style=lowered; }

	    ctls_hbox "widget/hbox"
		{
		height=32;
		spacing=4;
		rpt_print "widget/textbutton"
		    {
		    width=90;
		    text="Print";
		    //enabled = runclient(char_length(:f_year:content) > 0);
		    rpt_print_cn "widget/connector"
			{
			event="Click";
			target="rpt_form";
			action="Submit";
			Target=runclient("annual_statement");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/annual_statement.rpt");
			Width=800;
			Height=600;
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="annual_statement"; action="Close"; }
		    }
		}
	    }
	}
    }
