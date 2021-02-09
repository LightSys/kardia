$Version=2$
dashboard "widget/page"
    {
    // This is the global dashboard.  It lists all projects that the user
    // is a participant in, or if the user has system admin rights, this
    // shows all projects in the system.  Projects are listed by recent
    // activity, so the most recently updated projects bubble to the top
    //
    title="Kardia Project Management Dashboard";
    width=1000;
    height=800;
    background=null;
    bgcolor=black;
    require_endorsement="kardia:task";
    endorsement_context="kardia";
    max_requests = 10;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    kbdfocus1="#6080c0";
    kbdfocus2="#6080c0";

    // Here we insert the list of projects.
    proj_list "widget/component"
	{
	x=0; y=0;
	width=1000; height=800;
	path="myprojects.cmp";
	dashboard=1;
	refresh=60000;
	}
    }
