$Version=2$
config "widget/page"
    {
    title = "Kardia Configuration";
    width = 1000;
    height = 600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    cmp "widget/component"
	{
	x=10; y=10; width=980; height=580;
	path = "config.cmp";
	}
    }
