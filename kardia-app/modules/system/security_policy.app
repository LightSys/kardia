$Version=2$
security_policy "widget/page"
    {
    title = "Kardia - Security Policy";
    width = 844;
    height = 600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    cmp "widget/component"
	{
	x=10; y=10; width=824; height=580;
	path = "security_policy.cmp";
	}
    }
