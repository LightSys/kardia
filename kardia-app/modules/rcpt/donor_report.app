$Version=2$
donor_report "widget/page"
    {
    title = "Donor Report";
    width=580;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

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
	    x=32;y=8;width=514;height=466;
	    spacing=3;
	    lbl_opt "widget/label" { height=30; font_size=16; text="Donor Report Options:"; align=center; }

	    pn_sep1 "widget/pane" { height=2; style=lowered; }

	    f_ledger "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field='ledger'; ctl_type=label; text='Ledger:'; value=runserver(:this:ledger); form=rpt_form; label_width=120; }

	    f_speriod "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="start_period"; text="Start Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
	    f_eperiod "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="end_period"; text="End Period:"; empty_desc = "required"; ctl_type=dropdown; sql=runserver("select :a_period_desc + ' - ' + :a_period, :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_summary_only = 0 and :a_ledger_number = " + quote(:this:ledger) + " order by :a_start_date desc"); label_width=120; }
	    f_incfunds "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="include_funds"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="Choose Cost Center:"; text="Only Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_excfunds "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_funds"; popup_source=runserver("/apps/kardia/modules/gl/costctrs.qyt/" + :this:ledger + "/"); popup_text="Choose Cost Center:"; text="Exclude Funds:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_incaccts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="include_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose GL Account:"; text="Only Accts:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_excaccts "widget/component" { width=350; height=24; path="/apps/kardia/modules/base/editbox_tree.cmp"; field="exclude_accts"; popup_source=runserver("/apps/kardia/modules/gl/accounts.qyt/" + :this:ledger + "/"); popup_text="Choose GL Account:"; text="Exclude Accts:"; attach_point=editbox; empty_desc = "optional"; label_width=120; }
	    f_min "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="min_total"; text="Min. Total Gift:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
	    f_max "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="max_total"; text="Max. Total Gift:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
	    f_incstates "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="include_states"; text="Only States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
	    f_excstates "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="exclude_states"; text="Exclude States:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }

	    sep1 "widget/pane" { height=2; style=lowered; width=250; x=110; }
	    sep1a "widget/autolayoutspacer" { height=1; }

	    f_list_code "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="list_code"; text="Create a List:"; empty_desc = "to create, type new list code"; ctl_type=editbox; label_width=120; }
	    f_list_desc "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="list_desc"; text="List Description:"; empty_desc = "optional"; ctl_type=editbox; label_width=120; }
	    f_list_type "widget/component" { width=350; height=24; path="/sys/cmp/smart_field.cmp"; field="list_type"; text="List Type:"; ctl_type=dropdown; label_width=120; sql = "select :text, :tag from /apps/kardia/data/Kardia_DB/_m_list_type/rows where :tag != 'I'"; }

	    sep2 "widget/pane" { height=2; style=lowered; width=250; x=110; }
	    sep2a "widget/autolayoutspacer" { height=1; }

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
	    x=32;y=482;width=514;height=70;
	    align=bottom;

	    spacing=4;

	    info_label "widget/label" { height=30; text="This report takes some time to run; please avoid running this report while Gift Entry is occurring."; }

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
			Target=runclient("donor_report");
			NewPage=1;
			Source=runclient("/apps/kardia/modules/rcpt/donor_report.rpt");
			Width=800;
			Height=600;
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
