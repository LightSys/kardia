$Version=2$
perms "widget/page"
    {
    title = "Security Permissions Report";
    width=400;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=336;height=466;
	    spacing=8;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Security Permissions Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    sep_top "widget/autolayoutspacer" { height=16; }

	    ctx "widget/component" { path="/sys/cmp/smart_field.cmp"; height=20; label_width=120; text="Context:"; ctl_type=dropdown; sql = "select :s_context_desc, :s_context from /apps/kardia/data/Kardia_DB/s_sec_endorsement_context/rows"; field=ctx; numdisplay=12; }
	    users "widget/component" { path="/sys/cmp/smart_field.cmp"; height=20; label_width=120; text="Include Users:"; ctl_type=editbox; field=users; }
	    perm "widget/component" { path="/sys/cmp/smart_field.cmp"; height=20; label_width=120; text="Permission:"; ctl_type=dropdown; field=perm; sql = "select :s_endorsement_desc, :s_endorsement from /apps/kardia/data/Kardia_DB/s_sec_endorsement_type/rows"; numdisplay=12; }

	    sep_out "widget/autolayoutspacer" { height=32; }

	    lbl2a "widget/label" { x=120; height=18; text="Report Output Options:"; style=bold; }

	    f_docfmt "widget/component"
		{ 
		height=24; 
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
			Target=runclient("perms");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/system/security_permissions.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="perms"; action="Close"; }
		    }

		sep3 "widget/autolayoutspacer" { width=120; }

		}
	    }
	}
    }
