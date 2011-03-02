$Version=2$
partner_search "widget/page"
    {
    title = "Partner Search";
//    width=800;
//    height=600;
    width=700; height=440;
    widget_template="/apps/kardia/tpl/organization-kardia.tpl";
    show_diagnostics = runserver(user_name() == 'tyoung' or user_name() == 'gbeeley');
    background="/apps/kardia/images/bg/light_bgnd.jpg";

//    partner_search_window "widget/childwindow"
//        {
//        x=0;y=0;
//        height=465; width=700;
//        visible=true;
//        toplevel = yes;
//        style = dialog;
//	bgcolor = "#e0e0e0";
//	is_modal=true;
//	title = "Partner Search";
//	icon = "/apps/kardia/images/icons/person-search.gif";
        partner_search_component "widget/component"
            {
            x=0;y=0;
            height=440; width=700;
            path="/apps/kardia/modules/base/partner_search.cmp";
            }
//        }

//    dbgwin "widget/component"
//	{
//	mode=static;
//	x=0;y=0;width=640;height=480;
//	multiple_instantiation=no;
//	path="/sys/cmp/debugger.cmp";
//	}
    }
