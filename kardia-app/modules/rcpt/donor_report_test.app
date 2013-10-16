$Version=2$
donor_report "widget/page"
    {
    title = "Donor Report";
    width=770;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }

    generic_report_cmp "widget/component"
	{
	x=10; y=10; width=750; height=533;
	path = "/apps/kardia/modules/base/generic_report.cmp";

	report_title = "Donor Report";
	report_path = "/apps/kardia/modules/rcpt/donor_report.rpt";
	report_path_sep_csv = "/apps/kardia/modules/rcpt/donor_report_fields.rpt";
	ledger = runserver(:this:ledger);
	mlist_tab=1;
	}
    }
