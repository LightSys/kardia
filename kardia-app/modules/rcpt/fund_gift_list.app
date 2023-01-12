$Version=2$
fund_gift_list "widget/page"
    {
    title = "Gift/Donor List for a Fund";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    require_one_endorsement="kardia:gift_manage","kardia:gift_amt";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }
    fund "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=496;
	    spacing=4;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Gift/Donor List Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    f_fund "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="fund"; popup_source=runserver("/apps/kardia/modules/gl/funds.qyt/" + :this:ledger + "/"); popup_text="Choose Fund:"; text="Fund:"; attach_point=editbox; empty_desc = "required"; label_width=120; }

	    f_period "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="period"; text="Beginning Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
	    f_startday "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="startday"; text="Start Day:"; ctl_type=editbox; empty_desc = "optional: 1 - 31"; label_width=120; }
	    f_endperiod "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="endperiod"; text="Ending Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
	    f_endday "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="endday"; text="End Day:"; ctl_type=editbox; empty_desc = "optional: 1 - 31"; label_width=120; }

	    sep1 "widget/autolayoutspacer" { height=4; }

	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='user_document_format'; 
		ctl_type=dropdown; 
		text='Format:'; 
		sql = runserver("select 'TntMPD Format','tntmpd'; select 'Separate Fields CSV','sep_csv'; select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
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
			event_condition=runclient((not (:f_docfmt:value = 'tntmpd')) and (not (:f_docfmt:value = 'sep_csv')));
			target="rpt_form";
			action="Submit";
			Target=runclient("fund_gift_list");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/fund_gift_list.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			document_format2=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			}
		    rpt_print_cn2 "widget/connector"
			{
			event="Click";
			event_condition=runclient(:f_docfmt:value = 'tntmpd');
			target="rpt_form";
			action="Submit";
			Target=runclient("fund_gift_list");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/fund_gift_list_tntmpd.rpt");
			Width=800;
			Height=600;
			document_format=runclient('text/csv');
			}
		    rpt_print_cn3 "widget/connector"
			{
			event="Click";
			event_condition=runclient(:f_docfmt:value = 'sep_csv');
			target="rpt_form";
			action="Submit";
			Target=runclient("fund_gift_list");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/fund_gift_list_fields.rpt");
			Width=800;
			Height=600;
			document_format=runclient('text/csv');
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="fund_gift_list"; action="Close"; }
		    }
		}
	    }
	}
    }
