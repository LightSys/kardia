$Version=2$
index "widget/page"
    {
    title = "Kardia";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    widget_class = "dark";

    pnHeader "widget/pane"
	{
	x=0;y=0;width=800;height=45;
	style=flat;
	//bgcolor=white;
	widget_class="splash";

	lblUsername "widget/label"
	    {
	    x=500;y=2;height=16;width=298;
	    align=right;
	    //style=bold;
	    font_size=11;
	    text = runserver( "Logged In As: " + (select :u:description from /apps/kardia/data/Users.uxu u where :u:name = user_name() ) );
	    }
	lblSite "widget/label"
	    {
	    x=500;y=18;height=27;width=298;
	    align=right;
	    //style=bold;
	    font_size=11;
	    text = runserver( "Site: " + /apps/kardia/data/Site.struct:site_description );
	    }
	}

    pnSeparator "widget/pane"
	{
	x=0;y=45;width=800;
	fl_height = 0;
	style=flat;
	widget_class = "separator";
	}

    menu_cmp "widget/component"
	{
	x=8;y=63;height=530;width=784;
	//If there are any records in p_partner_key_cnt, we want to go
	//to the main menu.  Otherwise, we need to go to the setup-wizard.
//	path=runserver(
//	    condition(
//		( select count(1) from /apps/kardia/data/Kardia_DB/p_partner_key_cnt/rows ),
//		"/apps/kardia/modules/base/whoson_and_tab_menu.cmp",
//		"/apps/kardia/modules/base/initial_setup_wizard.cmp"
//		)
//	    );
	path= "/apps/kardia/modules/base/initial_setup_wizard.cmp";
	mode=dynamic;
	multiple_instantiation=no;
	auto_destroy=yes;

	instantiate_cn "widget/connector" { source = index; event="Load"; action="Instantiate"; }
	}

    motd_cmp "widget/component"
	{
	x=0; y=0; width=800; height=600;
	path="/apps/kardia/modules/base/motd.cmp";
	}
    }
