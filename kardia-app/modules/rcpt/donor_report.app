$Version=2$
donor_report "widget/page"
    {
    title = "Donor Report";
    width=770;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    require_one_endorsement="kardia:gift_manage","kardia:gift";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

//// These are the parameters from the report itself:
//    ledger "report/parameter" { type=string; }
//    include_accts "report/parameter" { type=string; }
//    exclude_accts "report/parameter" { type=string; }
//    include_funds "report/parameter" { type=string; }
//    exclude_funds "report/parameter" { type=string; }
//    start_period "report/parameter" { type=string; }
//    end_period "report/parameter" { type=string; }
//    min_total "report/parameter" { type=integer; }  // FIXME - money type
//    max_total "report/parameter" { type=integer; }  // FIXME - money type
//    include_states "report/parameter" { type=string; }
//    exclude_states "report/parameter" { type=string; }
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
	    lbl_opt "widget/label" { height=30; font_size=16; text="Donor Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    cols_hbox "widget/hbox"
		{
		spacing=24;
		height=393;

		col1_vbox "widget/vbox"
		    {
		    width=340;
		    spacing=3;

		    lbl1 "widget/label" { x=120; height=18; text="Donor selection criteria:"; style=bold; }

		    f_speriod "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="start_period"; text="Start Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
		    f_eperiod "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="end_period"; text="End Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
		    f_incfunds "widget/component" { width=340; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="include_funds"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="Choose Cost Center:"; text="Only Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
		    f_excfunds "widget/component" { width=340; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_funds"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="Choose Cost Center:"; text="Exclude Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
		    f_incaccts "widget/component" { width=340; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="include_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose GL Account:"; text="Only Accts:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
		    f_excaccts "widget/component" { width=340; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose GL Account:"; text="Exclude Accts:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
		    f_min "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="min_total"; text="Min. Total Gift:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_max "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="max_total"; text="Max. Total Gift:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_incstates "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="include_states"; text="Only States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_excstates "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="exclude_states"; text="Exclude States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_comm "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="comment_text"; text="Gift Comment:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    }

		col2_vbox "widget/vbox"
		    {
		    width=340;
		    spacing=3;

		    //sep_out "widget/autolayoutspacer" { height=64; }

		    lbl2a "widget/label" { x=120; height=18; text="Create or add to a mailing list:"; style=bold; }

		    f_list_code "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="list_code"; text="List Code:"; empty_desc = "list to create or add to"; ctl_type=editbox; label_width=120; }
		    f_list_desc "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="list_desc"; text="List Description:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
		    f_list_type "widget/component" { width=340; height=24; path="/sys/cmp/smart_field.cmp"; field="list_type"; text="List Type:"; ctl_type=dropdown; label_width=120; sql = "select :text, :tag from /apps/kardia/data/Kardia_DB/_m_list_type/rows where :tag != 'I'"; }

		    sep_out "widget/autolayoutspacer" { height=10; }
		    lbl2b "widget/label" { x=120; height=18; text="Report Output Options:"; style=bold; }

		    f_docfmt "widget/component"
			{ 
			width=340; height=24; 
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
			    bgcolor=white; 
			    fieldname="cntry_fmt";
			    mode=static;
			    hilight="#d0d0d0";
			    numdisplay=7;

			    f_cntry_opt1 "widget/dropdownitem" { label="Full Country Name (default for Sep. Fields)"; value="full"; }
			    f_cntry_opt2 "widget/dropdownitem" { label="Kardia / ccTLD"; value="kardia"; }
			    f_cntry_opt3 "widget/dropdownitem" { label="ISO3166-1 Alpha-2"; value="iso_alpha2"; }
			    f_cntry_opt4 "widget/dropdownitem" { label="ISO3166-1 Alpha-3"; value="iso_alpha3"; }
			    f_cntry_opt5 "widget/dropdownitem" { label="FIPS 10-4"; value="fips10"; }
			    f_cntry_opt6 "widget/dropdownitem" { label="Blank (default for PDF)"; value="none"; selected=yes; }
			    }
			}
		    f_showamt "widget/component"
			{
			require_one_endorsement="kardia:gift_manage","kardia:gift_amt";
			endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
			width=340;
			height=24;
			path="/sys/cmp/smart_field.cmp";
			field="show_amounts";
			text="Show Amounts:";
			ctl_type=checkbox;
			label_width=120;
			}
		    }
		}
	    }

	vb3 "widget/vbox"
	    {
	    x=32;y=482;width=704;height=70;
	    align=bottom;

	    spacing=4;

	    info_label "widget/label" { height=20; text="This report takes some time to run; please avoid running this report while Gift Entry is occurring."; }

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
			event_condition=runclient(not (:f_docfmt:value = 'sep_csv'));
			target="rpt_form";
			action="Submit";
			Target=runclient("donor_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/donor_report.rpt");
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
			Target=runclient("donor_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/donor_report_fields.rpt");
			Width=800;
			Height=600;
			document_format=runclient('text/csv');
			}
		    }
		rpt_cancel "widget/textbutton"
		    {
		    width=90;
		    text="Cancel";
		    rpt_cancel_cn "widget/connector" { event="Click"; target="donor_report"; action="Close"; }
		    }
		}
	    }
	}
    }
