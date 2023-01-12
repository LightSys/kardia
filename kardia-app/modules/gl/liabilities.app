$Version=2$
liabilities "widget/page"
    {
    width=580;
    height=550;

    title = runserver("Liabilities Report - " + :this:ledger);
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
	    x=32;y=8;width=514;height=508;
	    spacing=4;
	    lbl_bs "widget/label" { height=30; font_size=16; text="GL Liabilities - Report Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_fund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="fund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Fund:"; attach_point=editbox; label_width=120; empty_desc="optional"; }
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
		    event_condition=runclient(char_length(:rpt_form:year_period) > 0);
		    target=f_start;
		    action=SetSQL;
		    sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :liabilities:ledger + "/" + :rpt_form:year_period + "|" + :liabilities:ledger + " order by :a_period asc having :a_summary_only = 0");
		    }
		}
	    f_start "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='ref_period';
		ctl_type=dynamicdropdown;
		text='Reference Period:';
		label_width=120;
		form=rpt_form;

		ref_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:ref_period) > 0 and char_length(:rpt_form:year_period) > 0);
		    target=f_end;
		    action=SetSQL;
		    sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :liabilities:ledger + "/" + :rpt_form:year_period + "|" + :liabilities:ledger + " order by :a_period asc having :a_summary_only = 0 and :a_period >= " + quote(:rpt_form:ref_period));
		    }
		}
	    f_end "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='end_period'; ctl_type=dynamicdropdown; text='Ending Period:';  form=rpt_form; label_width=120; }
	    sep "widget/autolayoutspacer" { height=4; }
	    f_byperiod "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="byperiod"; ctl_type='checkboxleft'; text="Break out accruals/payments by period"; form=rpt_form; label_width=120; }
	    f_zero "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="zero"; ctl_type='checkboxleft'; text="Show accounts with zero balances"; form=rpt_form; label_width=120; }
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

	    sep2 "widget/autolayoutspacer" { height=168; }
	    pn_sep2 "widget/pane" { height=2; style=lowered; }

	    ctls_hbox "widget/hbox"
		{
		height=32;
		spacing=4;
		rpt_print "widget/textbutton"
		    {
		    width=90;
		    text="Print";
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("liabilities"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/liabilities.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="liabilities"; action="Close"; }
		    }
		}
	    }
	}
    }
