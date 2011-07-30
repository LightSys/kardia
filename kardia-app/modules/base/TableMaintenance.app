$Version=2$
TableMaintenance "widget/page"
    {
    height=600; width=800;
    title = "i18n:Kardia - Table Maintenance";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    bgcolor = "#e0e0e0";

    mnMain "widget/menu"
	{
	widget_class = "bar";
	x=0; y=0; width=800; 

	type_rpt "widget/repeat"
	    {
	    sql = "select count(1), :p:description, prefix=substring(:t:name, 1, charindex('_', :t:name) - 1) from /apps/kardia/data/Kardia_DB t, /apps/kardia/data/TablePrefixes.csv/rows p where substring(:t:name, 1, charindex('_', :t:name) - 1) = :p:prefix group by substring(:t:name, 1, charindex('_', :t:name) - 1)";

	    mnKardia "widget/menu"
		{
		condition=runserver(char_length(:type_rpt:prefix) > 0);
		label = runserver("i18n:" + :type_rpt:description + ' Tables');
		widget_class = "popup";

		tbl_rpt "widget/repeat"
		    {
		    sql = runserver("select :name from /apps/kardia/data/Kardia_DB where substring(:name, 1, " + (char_length(:type_rpt:prefix) + 1) + ") = " + quote(:type_rpt:prefix + '_'));

		    mnItem "widget/menuitem"
			{
			label = runserver("i18n:" + :tbl_rpt:name);

			mnLink "widget/connector"
			    {
			    event = Select;
			    target = cmp;
			    action = "Instantiate";
			    table=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt:name));
			    title=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt:name));
			    }
			}
		    }
		}
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
