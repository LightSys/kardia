$Version=2$
TableMaintenance "widget/page"
    {
    height=680; width=1080;
    title = "Kardia - Table Maintenance";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    bgcolor = "#e0e0e0";
    background = "/apps/kardia/images/bg/light_bgnd3.jpg";
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    mnMain "widget/menu"
	{
	widget_class = "bar";
	x=0; y=0; width=1080;

	type_rpt "widget/repeat"
	    {
	    sql = "select cnt = count(1), :p:description, prefix=:p:prefix from /apps/kardia/data/Kardia_DB t, /apps/kardia/data/TablePrefixes.csv/rows p where substring(:t:name, 1, char_length(:p:prefix)) = :p:prefix group by :p:prefix";

	    mnKardia "widget/menu"
		{
		condition=runserver(char_length(:type_rpt:prefix) > 0);
		label = runserver(:type_rpt:description + ' (' + :type_rpt:cnt + ')');
		//label = runserver(:type_rpt:description + ' Tables');
		widget_class = "popup";

		tbl_rpt "widget/repeat"
		    {
		    sql = runserver("select :name from /apps/kardia/data/Kardia_DB where substring(:name, 1, " + (char_length(:type_rpt:prefix)) + ") = " + quote(:type_rpt:prefix) + " and :name != 'ra' limit 32");

		    mnItem "widget/menuitem"
			{
			label = runserver(:tbl_rpt:name);

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

		mnMore "widget/menu"
		    {
		    condition = runserver(:type_rpt:cnt > 32);
		    label = runserver("More " + :type_rpt:description + " Tables");
		    widget_class = "popup";

		    tbl_rpt2 "widget/repeat"
			{
			sql = runserver("select :name from /apps/kardia/data/Kardia_DB where substring(:name, 1, " + (char_length(:type_rpt:prefix)) + ") = " + quote(:type_rpt:prefix) + " and :name != 'ra' limit 32,32");

			mnItem2 "widget/menuitem"
			    {
			    label = runserver(:tbl_rpt2:name);

			    mnLink2 "widget/connector"
				{
				event = Select;
				target = cmp;
				action = "Instantiate";
				table=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt2:name));
				title=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt2:name));
				}
			    }
			}

		    mnMore2 "widget/menu"
			{
			condition = runserver(:type_rpt:cnt > 64);
			label = runserver("More " + :type_rpt:description + " Tables");
			widget_class = "popup";

			tbl_rpt3 "widget/repeat"
			    {
			    sql = runserver("select :name from /apps/kardia/data/Kardia_DB where substring(:name, 1, " + (char_length(:type_rpt:prefix)) + ") = " + quote(:type_rpt:prefix) + " and :name != 'ra' limit 64,32");

			    mnItem3 "widget/menuitem"
				{
				label = runserver(:tbl_rpt3:name);

				mnLink3 "widget/connector"
				    {
				    event = Select;
				    target = cmp;
				    action = "Instantiate";
				    table=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt3:name));
				    title=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt3:name));
				    }
				}
			    }
			}
		    }
		}
	    }

	mnOptions "widget/menu"
	    {
	    widget_class = "popup";
	    label = "Options";

	    mnItemCloseAll "widget/menuitem"
		{
		label = "Close All Windows";
		close_cn "widget/connector" { event=Select; target=cmp; action=Destroy; }
		}

	    mnItemShadeAll "widget/menuitem"
		{
		label = "Shade All Windows";
		shade_cn "widget/connector" { event=Select; target=cmp; action=Shade; }
		}
	    }
	}

    cmp "widget/component"
	{
	//table = "/samples/files.csv";
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/generic_form.cmp";
	mode = dynamic;
	width=998; height=700; h=600; w=898;
	cols=4;
	x=0; y=0;
	multiple_instantiation = yes;
	icon = "/sys/images/ico26a.gif";
	toplevel = yes;
	}
    }
