$Version=2$
transaction_report "widget/page"
    {
    title = "i18n:Transaction Report";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }
    year_period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	qy1_cn "widget/connector" { event=Query; target=f_year; action=SetValue; Value=runclient(:transaction_report:year_period); }
	//qy_cn "widget/connector" { event=Query; target=f_period; action=SetValue; Value=runclient(:transaction_report:period); }

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=496;
	    spacing=4;
	    lbl_opt "widget/label" { height=30; font_size=16; text="i18n:Transaction Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='i18n:Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_year "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='year_period'; 
		ctl_type=dropdown; 
		text="i18n:Year (req'd):"; 
		sql = runserver("select :a_period + ' - ' + :a_period_desc, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_ledger_number = " + quote(:this:ledger) + " and :a_parent_period is null order by :a_period desc");
		form=rpt_form;
		label_width=120;

		year_sel_cn_1 "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:year_period) > 0);
		    target=f_startperiod;
		    action=SetSource;
		    Source = runclient("/apps/kardia/modules/gl/periods.qyt/" + :rpt_form:ledger + "/" + :rpt_form:year_period + "|" + :rpt_form:ledger + "/");
		    }
		year_sel_cn_2 "widget/connector"
		    {
		    event="DataChange";
		    event_condition=runclient(char_length(:rpt_form:year_period) > 0);
		    target=f_endperiod;
		    action=SetSource;
		    Source = runclient("/apps/kardia/modules/gl/periods.qyt/" + :rpt_form:ledger + "/" + :rpt_form:year_period + "|" + :rpt_form:ledger + "/");
		    }
		}

	    sep "widget/autolayoutspacer" { height=8; }

	    f_balcostctr "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="balcostctr"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="i18n:Choose Cost Center:"; text="i18n:Bal Cost Center:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; tooltip="i18n:Balancing Cost Center, including subsidiaries"; }
	    f_costctr "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="costctr"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="i18n:Choose Cost Center:"; text="i18n:Cost Center:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; }
	    f_glacct "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="account"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="i18n:Choose GL Account:"; text="i18n:Account:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; }
	    f_batch "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="batch"; popup_source=runserver("/apps/kardia/modules/gl/batches.qyt/" + :this:ledger + "/"); popup_text="i18n:Choose Batch:"; text="i18n:Batch:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; }

	    sep0 "widget/autolayoutspacer" { height=8; }

	    f_startperiod "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="startperiod"; popup_source=runserver("/apps/kardia/modules/gl/periods.qyt/" + :this:ledger + "/"); popup_text="i18n:Starting Period:"; text="i18n:Start Period:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; }
	    f_endperiod "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="endperiod"; popup_source=runserver("/apps/kardia/modules/gl/periods.qyt/" + :this:ledger + "/"); popup_text="i18n:Ending Period:"; text="i18n:End Period:"; attach_point=editbox; empty_desc = "i18n:optional"; label_width=120; }
	    f_startdate "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="startdate"; text="i18n:Start Date:"; search_by_range=0; ctl_type=datetime; label_width=120; }
	    f_enddate "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="enddate"; text="i18n:End Date:"; search_by_range=0; ctl_type=datetime; label_width=120; }
	    f_persubttl "widget/component"
		{
		x=10; width=340; height=24;
		path="/sys/cmp/smart_field.cmp";
		field="persubttl";
		ctl_type='checkboxleft';
		text="i18n:Show subtotals by period";
		label_width=120;

		set_sort_period "widget/connector"
		    {
		    event = DataChange;
		    event_condition = runclient(:Value == 1);
		    target = f_sortby_dd;
		    action = SetValue;
		    Value = runclient('pbjt');
		    }
		}
	    f_hide1900 "widget/component" { x=10; width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="hide1900"; ctl_type='checkboxleft'; text="i18n:Do not show '1900' account transactions"; label_width=120; }
	    f_onlyequity "widget/component" { x=10; width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="onlyequity"; ctl_type='checkboxleft'; text="i18n:Show only Equity, Revenue, and Expense"; label_width=120; }

	    sep1 "widget/autolayoutspacer" { height=4; }

	    f_sortby_hbx "widget/hbox"
		{
		width=350; height=24; spacing=5;
		f_sortby_lbl "widget/label" { text="i18n:Sort By:"; align=right; width=115; }
		f_sortby_dd "widget/dropdown"
		    {
		    width=230;
		    fl_width=40; 
		    bgcolor=white; 
		    fieldname="sortby";
		    mode=static;
		    hilight="#d0d0d0";

		    f_sortby_opt1 "widget/dropdownitem" { label="i18n:Period / Batch / Journal / Transaction"; value="pbjt"; }
		    f_sortby_opt2 "widget/dropdownitem" { label="i18n:Date / Batch / Journal / Transaction"; value="date"; }
		    f_sortby_opt3 "widget/dropdownitem" { label="i18n:Cost Center / Account"; value="cca"; }
		    f_sortby_opt4 "widget/dropdownitem" { label="i18n:Account / Cost Center"; value="acc"; }

		    uncheck_show_per_subttl "widget/connector"
			{
			event = DataChange;
			event_condition = runclient(:Value != 'pbjt');
			target = f_persubttl;
			action = SetValue;
			Value = runclient(0);
			}
		    }
		}

	    sep2 "widget/autolayoutspacer" { height=4; }

	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='document_format'; 
		ctl_type=dropdown; 
		text='i18n:Format:'; 
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
		    text="i18n:Print";
		    //enabled = runclient(char_length(:f_year:content) > 0);
		    rpt_print_cn "widget/connector" { event="Click"; target="rpt_form"; action="Submit"; Target=runclient("transaction_report"); NewPage=runclient(1); Source=runclient("/apps/kardia/modules/gl/transaction_report.rpt"); Width=runclient(800); Height=runclient(600); }
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="i18n:Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="transaction_report"; action="Close"; }
		    }
		}
	    }
	}
    }
