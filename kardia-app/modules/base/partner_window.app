$Version=2$
partner_window "widget/page"
    {
    visual = yes;
//    width=850;
//    height=602;
    width = 846 - 2; height=598 - 25;
    show_diagnostics = yes;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    background="/apps/kardia/images/bg/light_bgnd.jpg";

//    dbgwin "widget/component"
//	{
//	mode=static;
//	x=0;y=0;width=640;height=480;
//	multiple_instantiation=no;
//	path="/sys/cmp/debugger.cmp";
//	}

//    mainwin "widget/childwindow"
//	{
//	x=0;y=0;width=846;height=598;
//	icon = "/apps/kardia/images/icons/person.gif";
	//hdr_background='/sys/images/window_hdr.png';
        //bgcolor = "#e0e0e0";

       // active_bgcolor = "#dee2ee";
	//bgcolor = "#4f5f9f";
//	title=runserver("Partner Edit Screen");
//	visible=true;
//	style=dialog;
	//p_partner_form_cmp "widget/component" { path="/lightsys/p_partner.cmp"; }
	//p_budget_form_cmp "widget/component" { path="/lightsys/a_budget.cmp"; }
	this_form_cmp "widget/component" 
	    { 
	    path="/apps/kardia/modules/base/partner_edit.cmp"; 
	    x=0; y=0;
	    width=846 - 2;
	    height=598 - 25;
	    }
//	}

    }
