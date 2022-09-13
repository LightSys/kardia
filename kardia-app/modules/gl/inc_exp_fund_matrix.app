$Version=2$
inc_exp_fund_matrix "widget/page"
    {
    title = "Revenue & Expense by Fund";
    width=580;
    height=525;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_one_endorsement = "kardia:gl_manage","kardia:gl_entry";
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
	    lbl_tb "widget/label" { height=30; font_size=16; text="Revenue & Expense by Fund Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=150; }
	    f_year "widget/component"
		{
		width=350; height=24;
		path="/sys/cmp/smart_field.cmp";
		field='year_period';
		ctl_type=dropdown;
		text='Year:';
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_parent_period is null order by :a_period desc");
		label_width=150;
		form=rpt_form;

		year_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:Value) > 0);
		    target=f_start;
		    action=SetGroup;
		    Group = runclient(:Value);
		    }
		year_sel_cn2 "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:Value) > 0);
		    target=f_end;
		    action=SetGroup;
		    Group = runclient(:Value);
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
		label_width=150;
		form=rpt_form;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc");

		ref_sel_cn "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:end_period) > 0 and char_length(:rpt_form:year_period) > 0);
		    target=f_end;
		    action=SetGroup;
		    Group = runclient(:f_year:value);
		    Min = runclient(:Value);
		    }
		}
	    f_end "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='end_period'; 
		ctl_type=dropdown;
		text='Ending Period:'; 
		form=rpt_form;
		label_width=150;
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc"); 
		}
	    f_fund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="balfund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=150; }
	    f_exfund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_balfund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Exclude Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=150; }
	    f_accttype "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="accttype"; text="Account Types:"; ctl_type=dropdown; label_width=150; sql="select 'Revenue & Expense', 'RE'; select 'Revenue Only', 'R'; select 'Expense Only', 'E'"; }
	    f_ctltype "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="ctltype"; text="Transaction Types:"; ctl_type=dropdown; label_width=150; sql="select 'External, Interfund, and Within-Fund', '012'; select 'External and Interfund Only', '02'; select 'External Only', '0'"; }
	    f_accts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Accounts:"; text="Accounts:"; attach_point=editbox; empty_desc = "optional"; label_width=150; }
	    f_exaccts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose Accounts:"; text="Exclude Accounts:"; attach_point=editbox; empty_desc = "optional"; label_width=150; }
	    sep "widget/autolayoutspacer" { height=4; }
	    f_other "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="other"; ctl_type='checkboxleft'; text="Include other GL accounts in 'Other' column"; form=rpt_form; label_width=150; }
	    f_unposted "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="unposted"; ctl_type='checkboxleft'; text="Include unposted transactions"; form=rpt_form; label_width=150; }
	    f_invert "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="invert"; ctl_type='checkboxleft'; text="Invert Debits/Credits (Executive Format)"; form=rpt_form; label_width=150; }
	    //f_level "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='report_level'; ctl_type=dropdown; text='Detail Level:'; sql=runserver("select '' + :a_reporting_level + ' - ' + :a_level_rpt_desc, :a_reporting_level from /apps/kardia/data/Kardia_DB/a_reporting_level/rows where :a_ledger_number = " + quote(:this:ledger)); form=rpt_form; label_width=120; }
	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='document_format'; 
		ctl_type=dropdown; 
		text='Format:'; 
		sql = runserver("select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
		form=rpt_form;
		label_width=150;
		}

	    sep2 "widget/autolayoutspacer" { height=32; }
	    pn_sep2 "widget/pane" { height=2; style=lowered; }

	    ctls_hbox "widget/hbox"
		{
		height=32;
		spacing=4;
		rpt_print "widget/textbutton"
		    {
		    width=90;
		    text="Print";
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("inc_exp_fund_matrix"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/inc_exp_fund_matrix.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="inc_exp_fund_matrix"; action="Close"; }
		    }
		}
	    }
	}
    }
