$Version=2$
labels "widget/page"
    {
    title = "Labels";
    width=770;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }

    generic_report_cmp "widget/component"
	{
	x=10; y=10; width=750; height=533;
	path = "generic_report.cmp";

	report_title = "Print Labels";
	report_path = "/apps/kardia/modules/base/labels.rpt";
	ledger = runserver(:this:ledger);
	show_preview = 1;
	combine_criteria_format = 1;
	}
    }
