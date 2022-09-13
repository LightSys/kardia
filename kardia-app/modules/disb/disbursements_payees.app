$Version=2$
disbursements_payees "widget/page"
    {
    title = "Disbursements Payees";
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

	qy_cn "widget/connector" { event=Query; target=f_yearperiod; action=SetValue; Value=runclient(:disbursements_payees:year_period); }

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=468;
	    spacing=4;
	    lbl_tb "widget/label" { height=30; font_size=16; text="Disbursements Payees - Report Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_yearperiod "widget/component"
		{
		width=350;
		height=24;
		path="/sys/cmp/smart_field.cmp";
		field='year_period';
		ctl_type=dropdown;
		text='Year:';
		label_width=120;
		form=rpt_form;

		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, (:a_period == " + quote(:this:year_period) + ") from /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_parent_period is null order by :a_period desc");

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
		field='startperiod';
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
		    Group = runclient(:f_yearperiod:value);
		    Min = runclient(:Value);
		    //action=SetSQL;
		    //sql = runclient("select :a_period + ' - ' + :a_period_desc, :a_period, :a_summary_only from subtree /apps/kardia/modules/gl/periods.qyt/" + :disbursements_detail:ledger + "/" + :rpt_form:year_period + "|" + :disbursements_detail:ledger + " order by :a_period asc having :a_summary_only = 0 and :a_period >= " + quote(:rpt_form:start_period));
		    }
		}
	    f_end "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='endperiod'; ctl_type=dropdown; text='Ending Period:';  form=rpt_form; label_width=120; sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period, 0, :a_parent_period from  /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_summary_only = 0 order by :a_period asc"); }
	    f_fund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="fund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Fund:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    sep "widget/autolayoutspacer" { height=4; }
	    f_showacct "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="showacct"; ctl_type='checkboxleft'; text="List GL Accounts Separately"; form=rpt_form; label_width=120; }
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
	    }

	vb3 "widget/vbox"
	    {
	    x=32;y=484;width=514;height=40;
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
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("disbursements_payees"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/disb/disbursements_payees.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="disbursements_payees"; action="Close"; }
		    }
		}
	    }
	}
    }
