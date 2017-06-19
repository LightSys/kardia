$Version=2$
gift_import_report "widget/page"
    {
    title = "Gift Import Report";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    require_one_endorsement="kardia:gift_manage","kardia:gift_amt";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

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
	    lbl_opt "widget/label" { height=30; style=bold; font_size=16; text="Gift Import Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    sep0 "widget/autolayoutspacer" { height=4; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    f_period "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="period"; text="Month:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }

	    sep1 "widget/autolayoutspacer" { height=4; }

	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='user_document_format'; 
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

		    rpt_print_cn "widget/connector"
			{
			event="Click";
			target="rpt_form";
			action="Submit";
			Target=runclient("gift_import_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/gift_import_report.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			document_format2=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="gift_import_report"; action="Close"; }
		    }
		}
	    }
	}
    }
