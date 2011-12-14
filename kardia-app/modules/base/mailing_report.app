$Version=2$
mailing_report "widget/page"
    {
    title = "Mailing Report";
    width=770;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

//// These are the parameters from the report itself:
//    ledger "report/parameter" { type=string; }
//    include_states "report/parameter" { type=string; badchars=" "; }
//    exclude_states "report/parameter" { type=string; badchars=" "; }
//    include_lists "report/parameter" { type=string; badchars=" "; }
//    include_zips "report/parameter" { type=string; }
//    exclude_zips "report/parameter" { type=string; }
//    only_donors "report/parameter" { type=integer; default=0; }
//    only_payees "report/parameter" { type=integer; default=0; }
//    only_postal "report/parameter" { type=integer; default=0; }
//    only_okmail "report/parameter" { type=integer; default=1; }
//    only_oksolicit "report/parameter" { type=integer; default=1; }
//    list_code "report/parameter" { type=string; }
//    list_desc "report/parameter" { type=string; default=runserver("Donor List on " + getdate()); }
//    list_type "report/parameter" { type=string; default="S"; }

    rpt_form "widget/form"
	{
	allow_nodata = no;
	allow_new = no;
	auto_focus = no;

	vb2 "widget/vbox"
	    {
	    x=32;y=8;width=704;height=466;
	    spacing=3;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Mailings Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=20; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    cols_hbox "widget/hbox"
		{
		spacing=24;
		height=393;

		col1_vbox "widget/vbox"
		    {
		    width=340;
		    spacing=3;

		    f_inclists "widget/component"
			{
			height=24;
			path="/apps/kardia/modules/base/editbox_table.cmp";
			field='include_lists';
			text='Only List(s):';
			popup_width=300;
			popup_height=210;
			popup_sql="select value = :m:m_list_code, label = :m:m_list_description + ' (' + :m:m_list_code + ')' from /apps/kardia/data/Kardia_DB/m_list/rows m where (:m:m_list_type = 'P' or :m:m_list_type = 'S')";
			search_field_list="m_list_code,*m_list_description*";
			key_name="m_list_code";
			object_name="Mailing List";
			popup_text="Choose List:";
			empty_desc = "required; comma-separated";
			label_width=120;
			attach_point=editbox;

			listcode_hints "widget/hints" { style=applyonchange; }
			//height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="include_lists"; popup_source=runserver("/apps/kardia/modules/base/mlists.qyt/"); popup_text="Choose List:"; text="Only List(s):"; attach_point=editbox; empty_desc = "required; comma-separated"; label_width=120; lists_hints "widget/hints" { badchars=" "; } 

			no_spaces "widget/connector" { event=BeforeKeyPress; event_condition=runclient(:Code = 32); event_cancel=runclient(:Code = 32); target=f_inclists; action=SetFocus; }
			}
		    f_incctrys "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="include_cntrys"; text="Only Countries:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; ic_hints "widget/hints" { style=uppercase; } }
		    f_excctrys "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="exclude_cntrys"; text="Exc. Countries:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; ec_hints "widget/hints" { style=uppercase; } }
		    f_incstates "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="include_states"; text="Only States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; is_hints "widget/hints" { style=uppercase; } }
		    f_excstates "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="exclude_states"; text="Exclude States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; es_hints "widget/hints" { style=uppercase; } }
		    f_inczips "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="include_zips"; text="Only Postal Codes:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_exczips "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="exclude_zips"; text="Exc. Postal Codes:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_mincopy "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="mincopies"; text="Minimum Copies:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; width=220; tooltip="Only include subscribers who are receiving at least this number of copies of the publication."; }
		    f_maxcopy "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="maxcopies"; text="Maximum Copies:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; width=220; tooltip="Only include subscribers who are receiving this number or fewer copies of the publication."; }

		    //sep1 "widget/pane" { height=2; style=lowered; width=250; x=110; }
		    sep1a "widget/autolayoutspacer" { height=10; }

		    lbl1a "widget/label" { x=120; height=18; text="Create or add to a mailing list:"; style=bold; }

		    f_list_code "widget/component" { height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="list_code"; popup_source=runserver("/apps/kardia/modules/base/mlists.qyt/"); popup_text="Choose List to Add To:"; text="List Code:"; attach_point=editbox; empty_desc = "list to create or add to"; label_width=120; popup_height=250; lists_hints2 "widget/hints" { badchars=" ,"; } }
		    //f_list_code "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="list_code"; text="List Code:"; empty_desc = "to create or add, type list code"; ctl_type=editbox; label_width=120; }
		    f_list_desc "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="list_desc"; text="List Description:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_list_type "widget/component" { height=24; path="/sys/cmp/smart_field.cmp"; field="list_type"; text="List Type:"; ctl_type=dropdown; label_width=120; sql = "select :text, :tag from /apps/kardia/data/Kardia_DB/_m_list_type/rows where :tag != 'I'"; }

		    //sep2 "widget/pane" { height=2; style=lowered; width=250; x=110; }
		    sep2a "widget/autolayoutspacer" { height=10; }
		    }

		col2_vbox "widget/vbox"
		    {
		    width=340;
		    spacing=3;

		    f_obs "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="include_obs"; ctl_type='checkboxleft'; text="Include obsolete partners"; label_width=120; }
		    f_postal "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_postal"; ctl_type='checkboxleft'; text="Exclude list members with email delivery"; label_width=120; }
		    f_okmail "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_okmail"; ctl_type='checkboxleft'; text="Exclude 'no mail' partners"; label_width=120; }
		    f_oksolicit "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_oksolicit"; ctl_type='checkboxleft'; text="Exclude 'no solicitations' partners"; label_width=120; }
		    f_donors "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_donors"; ctl_type='checkboxleft'; text="Donors"; label_width=120; }
		    f_payees "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_payees"; ctl_type='checkboxleft'; text="Payees/Vendors"; label_width=120; }
		    f_staff "widget/component" { x=10; height=24; path="/sys/cmp/smart_field.cmp"; field="only_staff"; ctl_type='checkboxleft'; text="Staff Members"; label_width=120; }

		    sep_out "widget/autolayoutspacer" { height=64; }

		    lbl2a "widget/label" { x=120; height=18; text="Report Output Options:"; style=bold; }

		    f_docfmt "widget/component"
			{ 
			height=24; 
			path="/sys/cmp/smart_field.cmp"; 
			field='user_document_format'; 
			ctl_type=dropdown; 
			text='Format:'; 
			//sql = runserver("select 'TntMPD Format','tntmpd'; select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
			sql = runserver("select 'Separate Fields CSV','sep_csv'; select :t:type_description + ' (' + :t:type_name + ')', :t:type_name from /sys/cx.sysinfo/osml/types t, /sys/cx.sysinfo/prtmgmt/output_types ot where :t:type_name = :ot:type order by :t:type_description");
			form=rpt_form;
			label_width=120;
			}

		    cntry_hbox "widget/hbox"
			{
			height=24;
			spacing=4;

			cntry_label "widget/label" { width=116; text="Country Names:"; align=right; }
			f_cntry_dd "widget/dropdown"
			    {
			    width=220;
			    fl_width=40; 
			    bgcolor=white; 
			    fieldname="cntry_fmt";
			    mode=static;
			    hilight="#d0d0d0";
			    numdisplay=6;

			    f_cntry_opt1 "widget/dropdownitem" { label="Full Country Name (default)"; value="full"; selected=yes; }
			    f_cntry_opt2 "widget/dropdownitem" { label="Kardia / ccTLD"; value="kardia"; }
			    f_cntry_opt3 "widget/dropdownitem" { label="ISO3166-1 Alpha-2"; value="iso_alpha2"; }
			    f_cntry_opt4 "widget/dropdownitem" { label="ISO3166-1 Alpha-3"; value="iso_alpha3"; }
			    f_cntry_opt5 "widget/dropdownitem" { label="FIPS 10-4"; value="fips10"; }
			    f_cntry_opt6 "widget/dropdownitem" { label="Blank"; value="none"; }
			    }
			}
		    }
		}
	    }

	vb3 "widget/vbox"
	    {
	    x=32;y=482;width=704;height=70;
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
		    enabled = runclient(char_length(:f_inclists:content) > 0);
		    rpt_print_cn "widget/connector"
			{
			event="Click";
			event_condition=runclient(not (:f_docfmt:value = 'sep_csv'));
			target="rpt_form";
			action="Submit";
			Target=runclient("mailing_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/base/mailing_report.rpt");
			Width=800;
			Height=600;
			document_format=runclient(isnull(:f_docfmt:value, 'application/pdf'));
			}
		    rpt_print_cn2 "widget/connector"
			{
			event="Click";
			event_condition=runclient(:f_docfmt:value = 'sep_csv');
			target="rpt_form";
			action="Submit";
			Target=runclient("mailing_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/base/mailing_report_fields.rpt");
			Width=800;
			Height=600;
			document_format=runclient('text/csv');
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="mailing_report"; action="Close"; }
		    }

		sep3 "widget/autolayoutspacer" { width=120; }

		rpt_count "widget/textbutton"
		    {
		    width=120;
		    text="Get Count:";
		    enabled = runclient(char_length(:f_inclists:content) > 0);
		    rpt_count_cn "widget/connector"
			{
			event="Click";
			target="rpt_form";
			action="Submit";
			Target=runclient("rpt_count_html");
			Source=runclient("/apps/kardia/modules/base/num_addrs.rpt");
			}
		    }

		rpt_count_box "widget/pane"
		    {
		    width=120;
		    height=24;
		    style=raised;
		    bgcolor=white;

		    rpt_count_html_container "widget/pane"
			{
			x=4; y=-8;
			width=114;
			height=22;
			style=flat;
			rpt_count_html "widget/html"
			    {
			    x=0; y=0; width=120; height=24;
			    mode=dynamic;
			    }
			}
		    }
		}
	    }
	}
    }
