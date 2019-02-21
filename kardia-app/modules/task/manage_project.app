$Version=2$
manage_project "widget/page"
    {
    // This is the project admin page.
    //
    title="Kardia Project Admin";
    width=1000;
    height=800;
    background=null;
    bgcolor=black;
    require_endorsement = "kardia:task";
    endorsement_context = "kardia";
    max_requests = 7;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";

    project "widget/parameter" { type=integer; }

    // Here we insert the list of projects.
    proj_list "widget/component"
	{
	x=10; y=10;
	width=980; height=780;
	path="manage_project.cmp";
	project=runserver(:this:project);
	}
    }
