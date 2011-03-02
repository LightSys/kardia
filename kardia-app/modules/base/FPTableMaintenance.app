$Version=2$
FPTableMaintenance "widget/page"
    {
    height=600; width=800;
    title = "Organization FP Data - Table Maintenance";
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl";
    bgcolor = "#e0e0e0";

    mnMain "widget/menu"
	{
	widget_class = "bar";
	x=0; y=0; width=800; 

	type_rpt "widget/repeat"
	    {
	    sql = "select count(1), :p:description, prefix=substring(:t:name, 1, 2) from /apps/kardia/data/organizationdata/organization.fp t, /apps/kardia/data/TablePrefixes.csv/rows p where substring(:t:name, 1, 2) = :p:prefix group by substring(:t:name, 1, 2)";

	    mnKardia "widget/menu"
		{
		condition=runserver(char_length(:type_rpt:prefix) > 0);
		label = runserver(:type_rpt:description + ' Tables');
		widget_class = "popup";

		tbl_rpt "widget/repeat"
		    {
		    sql = runserver("select :name from /apps/kardia/data/organizationdata/organization.fp where substring(:name, 1, 2) = " + quote(:type_rpt:prefix));

		    mnItem "widget/menuitem"
			{
			label = runserver(:tbl_rpt:name);

			mnLink "widget/connector"
			    {
			    event = Select;
			    target = cmp;
			    action = "Instantiate";
			    table=runclient(runserver('/apps/kardia/data/organizationdata/organization.fp/' + :tbl_rpt:name));
			    title=runclient(runserver('/apps/kardia/data/organizationdata/organization.fp/' + :tbl_rpt:name));
			    }
			}
		    }
		}
	    }
	}

    ebLaunch "widget/editbox"
	{
	x=10;y=30;width=80;height=18;
	bgcolor=white;

	cnLaunch "widget/connector"
	    {
	    event = "ReturnPressed";
	    target = cmp;
	    action = "Instantiate";
	    table = runclient('/apps/kardia/data/organizationdata/organization.fp/' + :ebLaunch:content);
	    title = runclient('/apps/kardia/data/organizationdata/organization.fp/' + :ebLaunch:content);
	    }
	}

    cmp "widget/component"
	{
	//table = "/samples/files.csv";
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/generic_form.cmp";
	mode = dynamic;
	width=798; height=476; h=476;
	multiple_instantiation = yes;
	icon = "/sys/images/ico26a.gif";
	}
    }
