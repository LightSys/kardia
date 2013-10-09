$Version=2$
annual_statement "widget/page"
    {
    title = "Periodic Giving Statement for Donor";
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
	    lbl_opt "widget/label" { height=30; font_size=16; text="Periodic Giving Statement Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    sep "widget/autolayoutspacer" { height=4; }
	    donor_txt "widget/label" { height=16; x=120; text="Donor Selection:"; style=bold; }
	    f_donorid "widget/component"
		{
		height=24;
		width=350;
		path="/apps/kardia/modules/base/editbox_table.cmp";
		field='donor_id';
		text='Donor ID:';
		label_width=120;
		popup_width=380;
		popup_sql="select value = :p:p_partner_key, label = condition(char_length(rtrim(:p:p_org_name)) > 0, :p:p_org_name, :p:p_given_name + ' ' + :p:p_surname) + isnull(' [' + :pl:p_city + ', ' + :pl:p_state_province + ' ' + :pl:p_postal_code + ']', '') + ' #' + :p:p_partner_key from /apps/kardia/data/Kardia_DB/p_partner/rows p, /apps/kardia/data/Kardia_DB/p_location/rows pl where :p:p_partner_key *= :pl:p_partner_key and :pl:p_revision_id = 0";
		//search_field_list="p_partner_key,*p_given_name*,p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*,*p_comments";
		search_field_list="p_partner_key,*p_given_name*,*p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*";
		key_name="p_partner_key";
		object_name="Donor";
		popup_text="Select a Donor:";
		//attach_point=editbox;

		donor_hints "widget/hints" { style=applyonchange; }
		}
	    donor2_txt "widget/label" { height=16; x=120; text="- or -"; }
	    f_rcpttype "widget/component"
		{
		height=24;
		width=350;
		path="/sys/cmp/smart_field.cmp";
		field="rcpt_type";
		text="All Requesting:";
		ctl_type=dropdown;
		label_width=120;
		sql = "select :a_receipt_type_desc, :a_receipt_type from /apps/kardia/data/Kardia_DB/a_receipt_type/rows where :a_receipt_type != 'I' and :a_receipt_type != 'N' and :a_is_enabled = 1"; 
		}

	    sep0 "widget/autolayoutspacer" { height=4; }
	    period_txt "widget/label" { height=16; x=120; text="Statement Period:"; style=bold; }
	    f_year "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field="year_period";
		text="Year:";
		empty_desc = "required";
		ctl_type=dropdown;
		sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_parent_period is null and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc");
		label_width=120;

		year_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:Value) > 0);
		    target=f_start;
		    action=SetGroup;
		    Group = runclient(:Value);
		    }
		}
	    f_start "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='stmt_start_period';
		ctl_type=dropdown;
		text='Starting Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc");

		ref_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:stmt_start_period) > 0 and char_length(:rpt_form:year_period) > 0);
		    target=f_end;
		    action=SetGroup;
		    Group = runclient(:f_year:value);
		    Min = runclient(:Value);
		    //action=SetSQL;
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :trial_balance:ledger + "/" + :rpt_form:year_period + "|" + :trial_balance:ledger + " order by :a_period asc having :a_summary_only = 0 and :a_period >= " + quote(:rpt_form:ref_period));
		    }
		}
	    f_end "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='stmt_end_period'; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc"); }

	    sep1 "widget/autolayoutspacer" { height=4; }
	    fmt_txt "widget/label" { height=16; x=120; text="Format Options:"; style=bold; }

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
