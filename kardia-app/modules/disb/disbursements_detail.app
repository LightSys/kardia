$Version=2$
disbursements_detail "widget/page"
    {
    title = "Cash Disbursements Detail";
    width=580;
    height=525;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_one_endorsement = "kardia:disb_manage","kardia:disb_entry","kardia:disb";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }
    year_period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=508;
	    spacing=4;
	    lbl_tb "widget/label" { height=30; font_size=16; text="Disbursements Detail Report Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_year "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='year_period'; 
		ctl_type=dropdown; 
		text='Year:'; 
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_parent_period is null order by :a_period desc");
		label_width=120;
		form=rpt_form;

		year_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    //event_condition=runclient(char_length(:rpt_form:year_period) > 0);
		    event_condition=runclient(char_length(:Value) > 0);
		    //event_confirm=runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :disbursements_detail:ledger + "/" + :Value + "|" + :disbursements_detail:ledger + " order by :a_period asc having :a_summary_only = 0");
		    target=f_start;
		    //action=SetSQL;
		    action=SetGroup;
		    Group = runclient(:Value);
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :disbursements_detail:ledger + "/" + :Value + "|" + :disbursements_detail:ledger + " order by :a_period asc having :a_summary_only = 0");
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :disbursements_detail:ledger + "/" + :rpt_form:year_period + "|" + :disbursements_detail:ledger + " order by :a_period asc having :a_summary_only = 0");
		    }
		}
	    f_start "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='start_period';
		ctl_type=dropdown;
		text='Starting Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc");

		ref_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:start_period) > 0 and char_length(:rpt_form:year_period) > 0);
		    target=f_end;
		    action=SetGroup;
		    Group = runclient(:f_year:value);
		    Min = runclient(:Value);
		    //action=SetSQL;
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :disbursements_detail:ledger + "/" + :rpt_form:year_period + "|" + :disbursements_detail:ledger + " order by :a_period asc having :a_summary_only = 0 and :a_period >= " + quote(:rpt_form:start_period));
		    }
		}
	    f_end "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='end_period'; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc"); }
	    f_costctr "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="costctr"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="Choose Cost Center:"; text="Fund:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_acct "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="acct"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Account:"; text="Account:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_cashacct "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="cashacct"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Account:"; text="Cash Account:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_payeeid "widget/component"
		{
		height=24;
		width=350;
		path="/apps/kardia/modules/base/editbox_table.cmp";
		field='payee';
		text='Payee ID:';
		label_width=120;
		popup_width=380;
		popup_sql="select value = :p:p_partner_key, label = condition(char_length(rtrim(:p:p_org_name)) > 0, :p:p_org_name, :p:p_given_name + ' ' + :p:p_surname) + isnull(' [' + :pl:p_city + ', ' + :pl:p_state_province + ' ' + :pl:p_postal_code + ']', '') + ' #' + :p:p_partner_key from /apps/kardia/data/Kardia_DB/p_partner/rows p, /apps/kardia/data/Kardia_DB/p_location/rows pl where :p:p_partner_key *= :pl:p_partner_key and :pl:p_revision_id = 0";
		//search_field_list="p_partner_key,*p_given_name*,p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*,*p_comments";
		search_field_list="p_partner_key,*p_given_name*,*p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*";
		key_name="p_partner_key";
		object_name="Payee";
		popup_text="Select a Payee:";
		//attach_point=editbox;

		payee_hints "widget/hints" { style=applyonchange; }
		}
	    sep "widget/autolayoutspacer" { height=4; }
	    f_unposted "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="unposted"; ctl_type='checkboxleft'; text="Include unposted transactions"; form=rpt_form; label_width=120; }
	    f_line "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="show_line_items"; ctl_type='checkboxleft'; text="Show Check Line Items"; form=rpt_form; label_width=120; }
	    f_level "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='report_level'; ctl_type=dropdown; text='Detail Level:'; sql=runserver("select '' + :a_reporting_level + ' - ' + :a_level_rpt_desc, :a_reporting_level from /apps/kardia/data/Kardia_DB/a_reporting_level/rows where :a_ledger_number = " + quote(:this:ledger)); form=rpt_form; label_width=120; }
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

	    sep2 "widget/autolayoutspacer" { height=88; }
	    pn_sep2 "widget/pane" { height=2; style=lowered; }

	    ctls_hbox "widget/hbox"
		{
		height=32;
		spacing=4;
		rpt_print "widget/textbutton"
		    {
		    width=90;
		    text="Print";
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("disbursements_detail"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/disb/disbursements_detail.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="disbursements_detail"; action="Close"; }
		    }
		}
	    }
	}
    }
