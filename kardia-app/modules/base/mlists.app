$Version=2$
mlists "widget/page"
    {
    title = "Master Mailing Lists Report";
    width=400;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=336;height=466;
	    spacing=3;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Master Mailing Lists Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    sep_top "widget/autolayoutspacer" { height=16; }

	    mltype "widget/component" { path="/sys/cmp/smart_field.cmp"; height=20; label_width=120; text="List Type:"; ctl_type=dropdown; sql = "select :text, :tag from /apps/kardia/data/Kardia_DB/_m_list_type/rows"; field=listtype; }

	    sep_out "widget/autolayoutspacer" { height=32; }

	    lbl2a "widget/label" { x=120; height=18; text="Report Output Options:"; style=bold; }

	    f_docfmt "widget/component"
		{ 
		height=24; 
		path="/sys/cmp/smart_field.cmp"; 
		field='user_document_format'; 
		ctl_type=dropdown; 
		text='Format:'; 
		//sql = runserver("select 'TntMPD Format','tntmpd'; select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
		sql = runserver("select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
		form=rpt_form;
		label_width=120;
		}
	    }

	vb3 "widget/vbox"
	    {
	    x=32;y=482;width=336;height=70;
	    align=bottom;

	    spacing=4;

	    //info_label "widget/label" { height=30; text="This report can take some time to run."; }

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
			event_condition=runclient(not (:f_docfmt:value = 'sep_csv'));
			target="rpt_form";
			action="Submit";
			Target=runclient("mlists");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/base/mlists.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="mlists"; action="Close"; }
		    }

		sep3 "widget/autolayoutspacer" { width=120; }

		}
	    }
	}
    }
