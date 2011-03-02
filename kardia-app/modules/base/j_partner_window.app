$Version=2$
partner_window "widget/page"
    {
    visual = yes;
    width=850;
    height=610;
    show_diagnostics = yes;
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl";

    dbgwin "widget/component"
	{
	mode=static;
	x=0;y=0;width=640;height=480;
	multiple_instantiation=no;
	path="/sys/cmp/debugger.cmp";
	}

    mainwin "widget/childwindow"
	{
	x=0;y=0;width=846;height=606;
	icon = "/apps/kardia/images/icons/person.gif";
	//hdr_background='/sys/images/window_hdr.png';
        //bgcolor = "#e0e0e0";

       // active_bgcolor = "#dee2ee";
	//bgcolor = "#4f5f9f";
	title=runserver("Partner Edit Screen");
	visible=true;
	style=dialog;
	//p_partner_form_cmp "widget/component" { path="/lightsys/p_partner.cmp"; }
	//p_budget_form_cmp "widget/component" { path="/lightsys/a_budget.cmp"; }
	this_form_cmp "widget/component" 
	    { 
	    path="/apps/kardia/modules/base/j_partner_edit.cmp"; 
	    x=0; y=0;
	    width=846;
	    height=606;
	    }
	}

    }
