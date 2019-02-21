$Version=2$
index "widget/page"
    {
    // This is the global dashboard.  It lists all projects that the user
    // is a participant in, or if the user has system admin rights, this
    // shows all projects in the system.  Projects are listed by recent
    // activity, so the most recently updated projects bubble to the top
    //
    title="Kardia Project Dashboard";
    width=1000;
    height=800;
    background=null;
    bgcolor=black;
    require_endorsement="kardia:task";
    endorsement_context="kardia";
    max_requests = 7;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";

    // Here we insert the list of projects.
    proj_list "widget/component"
	{
	x=10; y=10;
	width=980; height=780;
	path="dashboard.cmp";
	}
    }
