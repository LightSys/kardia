$Version=2$
fundmgr_report "widget/page"
    {
    width=580;
    height=550;

    title = runserver("Fund Manager's Report - " + :this:ledger);
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_one_endorsement="kardia:gl_manage","kardia:gl";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=534;
	    spacing=4;
	    lbl_bs "widget/label" { height=30; font_size=16; text="Fund Manager's Report - Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_incpartners "widget/component"
		{
		width=350;
		height=24;
		label_width=120;
		popup_width=350;
		popup_height=210;
		path="/apps/kardia/modules/base/editbox_table.cmp";
		field='manager_id';
		text='Fund Manager:';
		popup_sql=runserver("select value = :p:p_partner_key, label = :p:p_partner_key + ' ' + condition(char_length(rtrim(:p:p_org_name)) > 0, :p:p_org_name, :p:p_given_name + ' ' + :p:p_surname) + ' (' + count(1) + ' fund' + condition(count(1) == 1, '', 's') + ')', fundcnt=count(1) from /apps/kardia/data/Kardia_DB/p_partner/rows p, /apps/kardia/data/Kardia_DB/p_staff/rows ps, /apps/kardia/data/Kardia_DB/a_cc_staff/rows cs, /apps/kardia/data/Kardia_DB/a_cost_center/rows c where :p:p_partner_key = :ps:p_partner_key and :ps:p_is_staff = 1 and :cs:a_ledger_number = " + quote(:this:ledger) + " and :cs:p_staff_partner_key = :ps:p_partner_key and :c:a_ledger_number = :cs:a_ledger_number and :c:a_cost_center = :cs:a_cost_center and :c:a_cost_center_class != 'MIS' group by :p:p_partner_key having :fundcnt > 0");
		//popup_sql=runserver("select value = :p:p_partner_key, label = condition(char_length(rtrim(:p:p_org_name)) > 0, :p:p_org_name, :p:p_given_name + ' ' + :p:p_surname) + ' #' + :p:p_partner_key, fundcnt=(select count(1) from /apps/kardia/data/Kardia_DB/a_cc_staff/rows cs, /apps/kardia/data/Kardia_DB/a_cost_center/rows c where :cs:a_ledger_number = " + quote(:this:ledger) + " and :cs:p_staff_partner_key = :p:p_partner_key and :c:a_ledger_number = :cs:a_ledger_number and :c:a_cost_center = :cs:a_cost_center and :c:a_cost_center_class != 'MIS')  from /apps/kardia/data/Kardia_DB/p_partner/rows p, /apps/kardia/data/Kardia_DB/p_staff/rows ps where :p:p_partner_key = :ps:p_partner_key and :ps:p_is_staff = 1 having :fundcnt > 0");
		search_field_list="p_partner_key,*p_given_name*,*p_surname*,*p_org_name*,p_legacy_key_1,*p_legacy_key_2*";
		key_name="p_partner_key";
		object_name="Partner";
		popup_text="Choose Manager:";
		empty_desc = "required";
		attach_point=editbox;
		form=rpt_form;
		}
	    f_period "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='period';
		ctl_type=dropdown;
		text='Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period desc");
		}
	    sep "widget/autolayoutspacer" { height=4; }
	    f_unposted "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="unposted"; ctl_type='checkboxleft'; text="Include unposted transactions"; form=rpt_form; label_width=120; }
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

	    sep2 "widget/autolayoutspacer" { height=284; }
	    pn_sep2 "widget/pane" { height=2; style=lowered; }

	    ctls_hbox "widget/hbox"
		{
		height=32;
		spacing=4;
		rpt_print "widget/textbutton"
		    {
		    width=90;
		    text="Print";
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("fundmgr_report"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/fundmgr_report.rpt"); Width=runclient(800); Height=runclient(600); excl_fund_class=runclient('MIS'); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="fundmgr_report"; action="Close"; }
		    }
		}
	    }
	}
    }
