$Version=2$
motd_edit "widget/page"
    {
    width=800;
    height=600;
    title = "Message of the Day Editor";
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    motd_cmp "widget/component"
	{
	x=10; y=10;
	width=780; height=580;
	path = "/apps/kardia/modules/base/motd_edit.cmp";
	}
    }
