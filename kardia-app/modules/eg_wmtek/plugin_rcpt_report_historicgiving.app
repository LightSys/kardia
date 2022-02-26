$Version=2$
plugin_rcpt_report_historicgiving "widget/page"
    {
    title = "Historic Giving Export to SiteStacker";
    width=770;
    height=553;
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    func_name = "Historic Giving Export to SiteStacker";
    func_description = "Export historic and offline gift data to SiteStacker";
    func_enable = "has_endorsement('kardia:gift_amt', 'kardia:ledger:*') and (select count(1) from /apps/kardia/data/Kardia_DB/a_config/rows where :a_config_name = 'GiftImport_SS' and convert(integer, :a_config_value) > 0) > 0";
    require_one_endorsement="kardia:gift_manage","kardia:gift_amt";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; deploy_to_client=yes; }

    generic_report_cmp "widget/component"
	{
	x=10; y=10; width=750; height=533;
	path = "/apps/kardia/modules/base/generic_report.cmp";

	report_title = "Historic Giving Export to SiteStacker";
	report_path = "/apps/kardia/modules/eg_wmtek/historic_giving.rpt";
	report_path_sep_csv = "/apps/kardia/modules/eg_wmtek/historic_giving.rpt";
	ledger = runserver(:this:ledger);
	mlist_tab=0;
	default_format = "text/csv";
	}
    }
