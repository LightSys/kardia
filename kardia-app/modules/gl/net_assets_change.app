$Version=2$
net_assets_change "widget/page"
    {
    title = "GL Change in Net Assets Report";
    width=580;
    height=525;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_one_endorsement="kardia:gl_manage","kardia:gl";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }
    year_period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	//qy1_cn "widget/connector" { event=Query; target=f_year; action=SetValue; Value=runclient(:net_assets_change:year_period); }
	//qy2_cn "widget/connector" { event=Query; target=f_start; action=SetValue; Value=runclient(:donation_summary:period); }

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=508;
	    spacing=4;
	    lbl_tb "widget/label" { height=30; font_size=16; text="GL Change in Net Assets Options:"; align=center; }
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
		    //event_confirm=runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :net_assets_change:ledger + "/" + :Value + "|" + :net_assets_change:ledger + " order by :a_period asc having :a_summary_only = 0");
		    target=f_start;
		    //action=SetSQL;
		    action=SetGroup;
		    Group = runclient(:Value);
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :net_assets_change:ledger + "/" + :Value + "|" + :net_assets_change:ledger + " order by :a_period asc having :a_summary_only = 0");
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :net_assets_change:ledger + "/" + :rpt_form:year_period + "|" + :net_assets_change:ledger + " order by :a_period asc having :a_summary_only = 0");
		    }
		}
	    f_start "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='ref_period';
		ctl_type=dropdown;
		text='Reference Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc");

		ref_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:ref_period) > 0 and char_length(:rpt_form:year_period) > 0);
		    target=f_end;
		    action=SetGroup;
		    Group = runclient(:f_year:value);
		    Min = runclient(:Value);
		    //action=SetSQL;
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :net_assets_change:ledger + "/" + :rpt_form:year_period + "|" + :net_assets_change:ledger + " order by :a_period asc having :a_summary_only = 0 and :a_period >= " + quote(:rpt_form:ref_period));
		    }
		}
	    f_end "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='end_period'; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc"); }
	    sep "widget/autolayoutspacer" { height=4; }
	    f_bybatch "widget/component" { x=10; width=400; height=20; path="/sys/cmp/smart_field.cmp"; field="bybatch"; ctl_type='checkboxleft'; text="Show Totals by Batch (instead of by Fund)"; form=rpt_form; label_width=120; checked=0; bybatch_hints "widget/hints" { style=notnull; default=0; } }
	    byfund_pane "widget/pane"
		{
		enabled=runclient(isnull(:f_bybatch:value, 0) == 0);
		height=52;
		width=514;
		style=flat;

		byfund_vbox "widget/vbox"
		    {
		    x=0; y=0;
		    width=514;
		    height=52;
		    spacing=4;

		    f_fund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="fund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Fund:"; attach_point=editbox; label_width=120; empty_desc="optional"; }
		    f_class "widget/component"
			{ 
			width=350; height=24; 
			path="/sys/cmp/smart_field.cmp"; 
			field='cc_class'; 
			ctl_type=dropdown; 
			text='Fund Class:'; 
			sql = runserver("select :a_fund_class + ' - ' + :a_fund_class_desc, :a_fund_class from /apps/kardia/data/Kardia_DB/a_fund_class/rows where :a_ledger_number = " + quote(:this:ledger) + " order by :a_fund_class");
			label_width=120;
			form=rpt_form;
			}
		    }
		}
	    bybatch_pane "widget/pane"
		{
		enabled=runclient(isnull(:f_bybatch:value, 0) == 1);
		height=24;
		width=514;
		style=flat;

		bybatch_vbox "widget/vbox"
		    {
		    x=0; y=0;
		    width=514;
		    height=24;
		    spacing=4;

		    f_type "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='origin'; ctl_type=dropdown; text='Batch Type:';  form=rpt_form; label_width=120; sql = runserver("select 'CD - Cash Disbursements', 'CD'; select 'CR - Cash Receipts', 'CR'; select 'DE - Deposits', 'DE'; select 'EG - Electronic Giving', 'EG'; select 'GL - Manual GL Journal', 'GL'; select 'OB - Opening Balances', 'OB'; select 'PP - Payroll', 'PP'"); }
		    }
		}
	    sep0 "widget/autolayoutspacer" { height=4; }
	    f_unposted "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="unposted"; ctl_type='checkboxleft'; text="Include unposted transactions"; form=rpt_form; label_width=120; }
	    f_subsid "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="showsubsid"; ctl_type='checkboxleft'; text="Break out subsidiary funds"; form=rpt_form; label_width=120; }
	    f_invert "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="invert"; ctl_type='checkboxleft'; text="Invert Debits/Credits (Executive Format)"; form=rpt_form; label_width=150; }
	    f_showzero "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="showzero"; ctl_type='checkboxleft'; text="Show funds with a zero balance and no transactions"; form=rpt_form; label_width=120; }
	    sep1 "widget/autolayoutspacer" { height=4; }
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

	    sep2 "widget/autolayoutspacer" { height=20; }
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
		    rpt_print_cn1 "widget/connector" { event="Click"; event_condition=runclient(not (:f_bybatch:is_checked == 1)); target="rpt_form"; action="Submit"; Target=runclient("net_assets_change"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/net_assets_change.rpt"); Width=runclient(800); Height=runclient(600); }
		    rpt_print_cn2 "widget/connector" { event="Click"; event_condition=runclient(:f_bybatch:is_checked == 1); target="rpt_form"; action="Submit"; Target=runclient("net_assets_change"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/net_assets_change_bybatch.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="net_assets_change"; action="Close"; }
		    }
		}
	    }
	}
    }
