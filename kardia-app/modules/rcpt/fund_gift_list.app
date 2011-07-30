$Version=2$
fund_gift_list "widget/page"
    {
    title = "i18n:Gift/Donor List for a Fund";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }
    costctr "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=514;height=496;
	    spacing=4;
	    lbl_opt "widget/label" { height=30; font_size=16; text="i18n:Gift/Donor List Options:"; align=center; }
	    pn_sep1 "widget/pane" { height=2; style=lowered; }
	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='i18n:Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }
	    f_costctr "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="costctr"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="i18n:Choose Cost Center:"; text="i18n:Cost Center:"; attach_point=editbox; empty_desc = "i18n:required"; label_width=120; }
	    f_period "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="period"; text="i18n:Period:"; empty_desc = "i18n:required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
	    f_startday "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="startdate"; text="i18n:Start Day:"; ctl_type=editbox; empty_desc = "i18n:optional: 1 - 31"; label_width=120; }
	    f_endday "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="enddate"; text="i18n:End Day:"; ctl_type=editbox; empty_desc = "i18n:optional: 1 - 31"; label_width=120; }

	    sep1 "widget/autolayoutspacer" { height=4; }

	    f_docfmt "widget/component"
		{ 
		width=350; height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='user_document_format'; 
		ctl_type=dropdown; 
		text='i18n:Format:'; 
		sql = runserver("select 'TntMPD Format','tntmpd'; select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
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
		    rpt_print_cn "widget/connector"
			{
			event="Click";
			event_condition=runclient(not (:f_docfmt:value = 'tntmpd'));
			target="rpt_form";
			action="Submit";
			Target=runclient("fund_gift_list");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/fund_gift_list.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
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
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="i18n:Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="fund_gift_list"; action="Close"; }
		    }
		}
	    }
	}
    }
