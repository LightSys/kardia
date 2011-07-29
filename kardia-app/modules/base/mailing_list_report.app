$Version=2$
mailing_list_report "widget/page"
    {
    title = "Mailing List Report";
    width=580;
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
	    x=32;y=8;width=514;height=496;
	    spacing=4;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Mailing List Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_listcode "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="listcode"; text="List:"; ctl_type=dropdown; sql=runserver("select :m_list_code + ' - ' + :m_list_description, :m_list_code from /apps/kardia/data/Kardia_DB/m_list/rows where :m_list_type != 'I' order by :m_list_code"); label_width=120; }
	    f_currentonly "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="currentonly"; ctl_type='checkboxleft'; text="Current Subscribers Only"; form=rpt_form; label_width=120; }
	    f_validonly "widget/component" { x=10; width=400; height=24; path="/sys/cmp/smart_field.cmp"; field="validonly"; ctl_type='checkboxleft'; text="Valid (Active) Partners Only"; form=rpt_form; label_width=120; }

	    f_fields_dd "widget/dropdown"
		{
		condition = 0;
		width=230;
		fl_width=40; 
		bgcolor=white; 
		fieldname="fields";
		mode=static;
		hilight="#d0d0d0";

		f_fields_opt1 "widget/dropdownitem" { label="Period / Batch / Journal / Transaction"; value="pbjt"; }
		f_fields_opt2 "widget/dropdownitem" { label="Date / Batch / Journal / Transaction"; value="date"; }
		f_fields_opt3 "widget/dropdownitem" { label="Cost Center / Account"; value="cca"; }
		f_fields_opt4 "widget/dropdownitem" { label="Account / Cost Center"; value="acc"; }
		}

	    sep1 "widget/autolayoutspacer" { height=4; }

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
			target="rpt_form";
			action="Submit";
			Target=runclient("mailing_list_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/mailing_list_report.rpt");
			Width=800;
			Height=600;
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="mailing_list_report"; action="Close"; }
		    }
		}
	    }
	}
    }
