$Version=2$
period_comparison "widget/page"
    {
    title = "GL Revenue & Expense Period Comparison";
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

	//qy1_cn "widget/connector" { event=Query; target=f_year; action=SetValue; Value=runclient(:period_comparison:year_period); }
	//qy2_cn "widget/connector" { event=Query; target=f_start; action=SetValue; Value=runclient(:donation_summary:period); }

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=508;
	    spacing=4;
	    lbl_tb "widget/label" { height=20; font_size=16; text="GL Revenue & Expense Period Comparison - Report Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    lbl_1 "widget/label" { height=16; style=bold; text="Reference Period Range:"; }
	    f_start1 "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field=start1;
		ctl_type=dropdown;
		text='Starting Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period desc");
		}
	    f_end1 "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field=end1; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period desc"); }
	    sep0 "widget/autolayoutspacer" { height=4; }

	    lbl_2 "widget/label" { height=16; style=bold; text="Analysis Period Range:"; }
	    f_start2 "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field=start2;
		ctl_type=dropdown;
		text='Starting Period:';
		label_width=120;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period desc");
		}
	    f_end2 "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field=end2; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period desc"); }
	    sep1 "widget/autolayoutspacer" { height=4; }

	    lbl_3 "widget/label" { height=16; style=bold; text="Fund and Account Filters:"; }
	    f_onlyfund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="only_funds"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Only Funds:"; attach_point=editbox; label_width=120; empty_desc="optional, comma separated"; }
	    f_exclfund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="excl_funds"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Exclude Funds:"; attach_point=editbox; label_width=120; empty_desc="optional, comma separated"; }
	    f_onlyaccts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="only_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Account:"; text="Only Accounts:"; attach_point=editbox; label_width=120; empty_desc="optional, comma separated"; }
	    f_exclaccts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="excl_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Account:"; text="Exclude Accounts:"; attach_point=editbox; label_width=120; empty_desc="optional, comma separated"; }

	    f_unposted "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="unposted"; ctl_type='checkboxleft'; text="Include unposted transactions"; form=rpt_form; label_width=120; }
	    //f_pagesep "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="sep_funds"; ctl_type='checkboxleft'; text="Summarize for Each Fund"; form=rpt_form; label_width=120; }
	    f_execfmt "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="invert"; ctl_type='checkboxleft'; text="Executive Format (invert +/- for debits and credits)"; form=rpt_form; label_width=120; }

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

	    sep2 "widget/autolayoutspacer" { height=8; }
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
		    //rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("period_comparison"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/batch_balance.rpt"); Width=runclient(800); Height=runclient(600); }
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("period_comparison"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/period_comparison.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="period_comparison"; action="Close"; }
		    }
		}
	    }
	}
    }
