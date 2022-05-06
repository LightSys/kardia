$Version=2$
mykardia "widget/page"
    {
    title = "My Kardia";
    width=800;
    height=600;
    //widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    bgcolor=white;

    mykardia_cmp "widget/component"
	{
	x=0; y=0; width=800; height=600;
	path="mykardia.cmp";
	}
    }
