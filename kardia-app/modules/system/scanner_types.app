$Version=2$
scanner_types "widget/page"
    {
    title = "Configure Document Scanners";
    width=800;
    height=500;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    //func_name = "Configure Document Scanners";
    //func_description = "Configure Document Scanners, such as Check Scanners";
    //func_enable = "has_endorsement('kardia:sys_admin', 'kardia')";
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    st_cmp "widget/component"
	{
	x=10; y=10; width=780; height=480;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/system/scanner_types.cmp";
	ledger = runserver(:this:ledger);
	}
    }
