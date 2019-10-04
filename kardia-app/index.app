$Version=2$
index "widget/page"
    {
    width=1200;
    height=700;
    title = "Kardia";
    max_requests = 7;
    background = null;
    bgcolor = white;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", "/apps/kardia/modules/crm/crm.tpl";

    sysattrs_osrc "widget/osrc"
	{
	scope = session;
	scope_name = "kardia_sysattrs_osrc";
	replicasize = 2;
	readahead = 2;
	send_updates = no;
	autoquery = onload;

	sql = "	select
			Ledger = (select first(:a_ledger_number) from /apps/kardia/data/Kardia_DB/a_ledger/rows order by :s_date_modified desc),
			YearPeriod = isnull( (select :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where :a_parent_period is null and :a_start_date <= getdate() and :a_end_date >= getdate()), (select first(:a_period) from /apps/kardia/data/Kardia_DB/a_period/rows where :a_parent_period is null order by :a_start_date desc) ),
			CurrentPeriod = isnull( (select :a_period from /apps/kardia/data/Kardia_DB/a_period/rows where not (:a_parent_period is null) and :a_start_date <= getdate() and :a_end_date >= getdate()), (select first(:a_period) from /apps/kardia/data/Kardia_DB/a_period/rows where not (:a_parent_period is null) order by :a_start_date desc) )
		";

	}

    hbox "widget/hbox"
	{
	x=0; y=0;
	width=1200;
	height=700;
	spacing=0;

	// 
	lh_pane "widget/pane"
	    {
	    width=256;
	    fl_width=0;
	    style=flat;
	    bgcolor="#496293";
	    shadow_radius=8;
	    shadow_color="#000000";
	    shadow_angle=90;
	    shadow_offset=2;

	    lh_vbox "widget/vbox"
		{
		x=0; y=0;
		width=256; height=700;
		spacing=10;

		lh_logo_pane "widget/pane"
		    {
		    height=59;
		    fl_height=0;
		    bgcolor="#334466";
		    style=flat;
		    shadow_radius=8;
		    shadow_color="#202020";
		    shadow_angle=180;
		    shadow_offset=2;

		    logo_container_hbox "widget/hbox"
			{
			x=0; y=0;
			width=256;
			height=60;
			align=center;

			logo_image "widget/image"
			    {
			    y=12;
			    width=180;
			    height=36;
			    source = "/apps/kardia/images/artwork/Kardia2011_whitetext_216x44.png";
			    }
			}
		    }

		menu_osrc "widget/osrc"
		    {
		    searchcnt "widget/parameter" { type=integer; }
		    sql = runserver("
			    declare collection activity scope application;

			    delete from collection activity;
		   
			    insert into
				collection activity
			    select
				menuname = 'Search',
				menuicon = '/apps/kardia/images/icons/ionicons-search-w.svg',
				menutitle = 'Search',
				menudesc = 'Search for anything within Kardia',
				activitydate = getdate(),
				cnt = :parameters:searchcnt
			    ;

			    insert into
				collection activity
			    select
				menuname = 'Tasks',
				menuicon = '/apps/kardia/images/icons/ionicons-gear-w.svg',
				menutitle = 'Tasks',
				menudesc = 'My list of tasks for today',
				activitydate = getdate(),
				cnt = 99
			    where
				1 = 0
			    ;

			    insert into
				collection activity
			    select
				menuname = 'Settings',
				menuicon = '/apps/kardia/images/icons/ionicons-gear-w.svg',
				menutitle = 'Settings',
				menudesc = 'Ledger:  X\nPeriod:  2018.11\nYear:  2018YEAR',
				activitydate = getdate(),
				cnt = null
			    ;

			    " + isnull((select sum(:sql + ';\n') from object wildcard '/apps/kardia/modules/*/plugin_menu_act_*.cmp'), '') + "

			    select
				:menuname,
				:menuicon,
				:menutitle,
				:menudesc,
				:cnt,
				:e_reference_info,
				name = :e_reference_info
			    from
				collection activity
			    order by
				0 - charindex(:menuname, 'Settings Tasks Search'),
				:activitydate desc,
				:name asc
			    ");
		    replicasize=100;
		    readahead=100;
		    refresh_interval=60000;
		    indicates_activity=no;

		    menu_table "widget/table"
			{
			x=10;
			height=619;
			fl_height=10;
			width=236;
			min_rowheight=16;
			max_rowheight=128;
			mode=dynamicrow;
			show_mouse_focus = no;
			allow_selection = yes;
			show_selection = yes;
			initial_selection = yes;
			demand_scrollbar = yes;
			overlap_scrollbar = yes;
			colsep = 0;
			titlebar = no;
			row_border_radius=4;
			rowhighlight_bgcolor = "#6080c0";
			rowhighlight_shadow_angle=180;
			rowhighlight_shadow_radius=4;
			rowhighlight_shadow_offset=1;
			rowhighlight_shadow_color="#202020";
			textcolorhighlight = "#000000";
			inner_padding = 2;
			cellvspacing = 4;
			row1_bgcolor = "#496293";
			row2_bgcolor = "#496293";
			nodata_message = "one moment please...";

			mt_img "widget/table-column" { title=""; fieldname="menuicon"; width=38; type=image; image_maxwidth=32; image_maxheight=32; align=center; textcolor=white; }

			mt_name "widget/table-column" { title=""; fieldname="menutitle"; caption_value=runclient(condition(:menu_osrc:menutitle = 'Settings', 'Ledger: ' + :kardia_sysattrs_osrc:Ledger + '\nPeriod: ' + :kardia_sysattrs_osrc:CurrentPeriod + '\nYear: ' + :kardia_sysattrs_osrc:YearPeriod, :menu_osrc:menudesc)); width=166; textcolor=white; caption_textcolor="#f0f0f0"; style=bold; font_size=15; caption_style=italic; wrap=yes; }

			mt_cnt "widget/table-column" { fieldname=cnt; font_size=15; style=bold; padding=3; bgcolor=runclient(condition(:menu_osrc:cnt is null, '', 'black')); border_radius=15; width=32; align=center; textcolor=white; }

			search_detail "widget/table-row-detail"
			    {
			    display_for=runclient(:menu_osrc:menuname == 'Search');
			    height=44;
			    width=236;

			    search_hbox "widget/hbox"
				{
				x=10; y=15; width=214; height=24;
				spacing=4;

				search_box "widget/editbox"
				    {
				    width=186; height=24;
				    empty_description="type search, press ENTER";

				    enter_pressed_do_search1 "widget/connector"
					{
					event=BeforeKeyPress;
					event_condition=runclient(:Name == 'enter' and char_length(:search_box:content) > 1);
					target=search_osrc;
					action=Clear;
					}
				    enter_pressed_do_search2 "widget/connector"
					{
					event=BeforeKeyPress;
					event_condition=runclient(:Name == 'enter' and char_length(:search_box:content) > 1);
					event_cancel=runclient(:Name == 'enter');
					target=search_osrc;
					action=QueryParam;
					string=runclient(:search_box:content);
					}
				    }
				search_btn "widget/imagebutton"
				    {
				    width=24; height=24;
				    image="/apps/kardia/images/icons/ionicons-search-w.svg";

				    btn_clicked_do_search1 "widget/connector"
					{
					event=Click;
					event_condition=runclient(char_length(:search_box:content) > 1);
					target=search_osrc;
					action=Clear;
					}
				    btn_clicked_do_search2 "widget/connector"
					{
					event=Click;
					event_condition=runclient(char_length(:search_box:content) > 1);
					target=search_osrc;
					action=QueryParam;
					string=runclient(:search_box:content);
					}
				    }
				}
			    }

			menutypes "widget/repeat"
			    {
			    sql = "select path = :cmp:cx__pathname, :cmp:type, :cmp:width, :cmp:height from object wildcard '/apps/kardia/modules/*/plugin_menu_act_*.cmp' cmp";

			    menu_type_detail "widget/table-row-detail"
				{
				display_for=runclient(runserver(:menutypes:type) == :menu_osrc:menuname);
				width=236;
				height=runserver(:menutypes:height + 20);

				menu_type_cmp "widget/component"
				    {
				    x=10;
				    y=15;
				    width=216;
				    height=runserver(:menutypes:height);
				    path=runserver(:menutypes:path);
				    }
				}
			    }
			}
		    }
		}
	    }

	main_vbox "widget/vbox"
	    {
	    width = 944;

	    action_bar "widget/pane"
		{
		height=60;
		//background="/apps/kardia/images/bg/charcoal_gradient.png";
		background="/apps/kardia/images/bg/horiz-bar-world-dark-96.png";
		style=flat;
		widget_class = crm_iconbar;
		fl_height=0;

		action_bar_hbox "widget/hbox"
		    {
		    x=10; y=0;
		    width=924; height=60;
		    spacing=10;
		    align=right;

		    action_bar_buttons "widget/repeat"
			{
			sql = "select modname = :cx__pathpart4, :module_name, :module_abbrev, :module_description, :cx__rowid, icon = '/apps/kardia/images/icons/ionicons-gear-w.svg', :module_ui, permission = condition(:mi:module_endorsement is not null, condition(:mi:module_context = 'kardia', has_endorsement(:mi:module_endorsement, 'kardia'), (select max(has_endorsement(:mi:module_endorsement, :mi:module_context + ':' + rtrim(:l:a_ledger_number))) from /apps/kardia/data/Kardia_DB/a_ledger/rows l )), 1) from object wildcard '/apps/kardia/modules/*/kardia_modinfo.struct' mi where :module_sequence is not null and :module_ui is null order by :module_sequence asc having :permission = 1";

			one_button "widget/component"
			    {
			    fl_width=0;
			    fl_height=0;
			    width=76;
			    active=runclient(condition(:tab_menu:selected_index == runserver(:action_bar_buttons:cx__rowid + 1), 1, 0));
			    path="/apps/kardia/lib/button_tab.cmp";
			    text=runserver(:action_bar_buttons:module_abbrev);
			    image=runserver(:action_bar_buttons:icon);

			    select_on_click "widget/connector"
				{
				event=Click;
				target=tab_menu;
				action=SetTab;
				TabIndex=runclient(runserver(:action_bar_buttons:cx__rowid + 1));
				}
			    }
			}
		    }
		}

	    tab_menu "widget/tab"
		{
		height=630;
		fl_height=10;
		fl_width=100;
		tab_location=none;
		border_style=none;
		background=null;
		bgcolor=null;

		tabpages "widget/repeat"
		    {
		    sql = " select
				modname = :cx__pathpart4,
				:module_name,
				:module_abbrev,
				:module_description,
				icon = '/apps/kardia/images/icons/ionicons-gear-w.svg',
				:module_ui,
				h_adj = (select isnull(sum(:height + 10), 0) from object wildcard expression ('/apps/kardia/modules/' + :m:cx__pathpart4 + '/plugin_menu_subui_*.cmp') m2),
				permission = condition(:m:module_endorsement is not null, condition(:m:module_context = 'kardia', has_endorsement(:m:module_endorsement, 'kardia'), (select max(has_endorsement(:m:module_endorsement, :m:module_context + ':' + rtrim(:l:a_ledger_number))) from /apps/kardia/data/Kardia_DB/a_ledger/rows l )), 1)
			    from
				object wildcard '/apps/kardia/modules/*/kardia_modinfo.struct' m
			    where
				:module_sequence is not null and
				:module_ui is null
			    order by
				:module_sequence asc
			    having
				:permission = 1
			    ";

		    one_tabpage "widget/tabpage"
			{
			title=runserver(:tabpages:module_name);

			tabpage_vbox "widget/vbox"
			    {
			    x=20; y=20; width=904; height=600;
			    spacing=10;

			    tabpage_hbox "widget/hbox"
				{
				height=runserver(600 - :tabpages:h_adj);
				spacing=10;

				apps_list_vbox "widget/vbox"
				    {
				    width=447;
				    spacing=10;

				    apps_list_title "widget/label" { height=18; font_size=15; style=bold; align=center; text=runserver("Applications for " + :tabpages:module_abbrev); fl_width=100; }

				    apps_sep "widget/image" { height=1; fl_width=100; fl_height=0; source="/apps/kardia/images/bg/lsblue_horizsep.png"; }

				    apps_list_osrc "widget/osrc"
					{
					sql = runserver("
						    declare collection funclist;

						    -- Applications from this module
						    insert
							collection funclist
						    select
							:f:func_name,
							:f:func_description,
							icon = isnull(:a:icon, '/apps/kardia/images/icons/ionicons-gear.svg'),
							:a:height,
							:a:width,
							fullpath = '/apps/kardia/modules/" + :tabpages:modname + "/' + :f:func_file
						    from
							/apps/kardia/modules/" + :tabpages:modname + "/kardia_functions.csv/rows f,
							object expression ('/apps/kardia/modules/" + :tabpages:modname + "/' + :f:func_file) a
						    where
							:f:func_type = 'APP'
						    ;

						    -- Applications from other modules
						    insert
							collection funclist
						    select
							:func_name,
							:func_description,
							icon = isnull(:icon, '/apps/kardia/images/icons/ionicons-gear.svg'),
							:height,
							:width,
							fullpath = :cx__pathname
						    from
							object wildcard '/apps/kardia/modules/*/plugin_" + :tabpages:modname + "_app_*.app' a
						    having
							eval(isnull(:a:func_enable, '1')) != 0
						    ;

						    -- Return the list to the user
						    select
							*
						    from
							collection funclist
						    order by
							:func_name
						    ");
					replicasize=30;
					readahead=30;

					apps_list_table "widget/table"
					    {
					    height=runserver(561 - :tabpages:h_adj);
					    min_rowheight=16;
					    max_rowheight=128;
					    mode=dynamicrow;
					    show_mouse_focus = no;
					    allow_selection = yes;
					    allow_deselection = no;
					    show_selection = yes;
					    initial_selection = no;
					    demand_scrollbar = yes;
					    overlap_scrollbar = yes;
					    colsep = 0;
					    titlebar = no;
					    row_border_radius=4;
					    //rowhighlight_bgcolor = "#f0f0f0";
					    //rowhighlight_shadow_color = "#6080c0";
					    //rowhighlight_shadow_location = 'inside';
					    //rowhighlight_shadow_radius = 10;
					    rowhighlight_bgcolor = "#f0f0f0";
					    rowhighlight_shadow_angle=180;
					    rowhighlight_shadow_radius=4;
					    rowhighlight_shadow_offset=1;
					    rowhighlight_shadow_color="#808080";
					    rowhighlight_border_color="#b8b8b8";
					    //rowhighlight_bgcolor = "#6080c0";
					    //rowhighlight_shadow_angle=180;
					    //rowhighlight_shadow_radius=4;
					    //rowhighlight_shadow_offset=1;
					    //rowhighlight_shadow_color="#202020";
					    //textcolorhighlight = "#ffffff";
					    textcolorhighlight = "#000000";
					    inner_padding = 4;
					    cellvspacing = 2;
					    //row1_bgcolor = "#496293";
					    //row2_bgcolor = "#496293";
					    row1_bgcolor = '';
					    row2_bgcolor = '';
					    nodata_message = runclient(condition(:apps_list_osrc:cx__pending, "", "one moment..."));

					    alt_icon "widget/table-column" { width=40; fieldname=icon; type=image; align=right; }
					    alt_title "widget/table-column" { width=400; fieldname=func_name; font_size=15; style=bold; caption_fieldname=func_description; }

					    launchapp "widget/connector"
						{
						event = Click;
						target = index;
						action = Launch;
						event_delay = 0.20;
						Multi = 1;
						Source = runclient(:apps_list_osrc:fullpath + "?ledger=" + :kardia_sysattrs_osrc:Ledger + "&period=" + :kardia_sysattrs_osrc:CurrentPeriod + "&year_period=" + :kardia_sysattrs_osrc:YearPeriod);
						Width = runclient(:apps_list_osrc:width);
						Height = runclient(:apps_list_osrc:height);
						}
					    }
					}
				    }

				rpts_list_vbox "widget/vbox"
				    {
				    width=447;
				    spacing=10;

				    rpts_list_title "widget/label" { height=18; font_size=15; style=bold; align=center; text=runserver("Reports for " + :tabpages:module_abbrev); fl_width=100; }

				    rpts_sep "widget/image" { height=1; fl_width=100; fl_height=0; source="/apps/kardia/images/bg/lsblue_horizsep.png"; }

				    rpts_list_osrc "widget/osrc"
					{
					sql = runserver("
						    declare collection funclist;

						    insert
							collection funclist
						    select
							:f:func_name,
							:f:func_description,
							icon = isnull(:a:icon, '/apps/kardia/images/icons/tumblicons-file.svg'),
							:a:height,
							:a:width,
							fullpath = '/apps/kardia/modules/" + :tabpages:modname + "/' + :f:func_file
						    from
							/apps/kardia/modules/" + :tabpages:modname + "/kardia_functions.csv/rows f,
							object expression ('/apps/kardia/modules/" + :tabpages:modname + "/' + :f:func_file) a
						    where
							:f:func_type = 'RPT'
						    ;

						    -- Reports from other modules
						    insert
							collection funclist
						    select
							:func_name,
							:func_description,
							icon = isnull(:icon, '/apps/kardia/images/icons/tumblicons-file.svg'),
							:height,
							:width,
							fullpath = :cx__pathname
						    from
							object wildcard '/apps/kardia/modules/*/plugin_" + :tabpages:modname + "_report_*.app' r
						    having
							eval(isnull(:r:func_enable, '1')) != 0
						    ;

						    -- Return the list to the user
						    select
							*
						    from
							collection funclist
						    order by
							:func_name
						    ");
					replicasize=30;
					readahead=30;

					rpts_list_table "widget/table"
					    {
					    height=runserver(561 - :tabpages:h_adj);
					    min_rowheight=16;
					    max_rowheight=128;
					    mode=dynamicrow;
					    show_mouse_focus = no;
					    allow_selection = yes;
					    allow_deselection = no;
					    show_selection = yes;
					    initial_selection = no;
					    demand_scrollbar = yes;
					    overlap_scrollbar = yes;
					    colsep = 0;
					    titlebar = no;
					    row_border_radius=4;
					    //rowhighlight_bgcolor = "#f0f0f0";
					    //rowhighlight_shadow_color = "#6080c0";
					    //rowhighlight_shadow_location = 'inside';
					    //rowhighlight_shadow_radius = 10;
					    rowhighlight_bgcolor = "#f0f0f0";
					    rowhighlight_shadow_angle=180;
					    rowhighlight_shadow_radius=4;
					    rowhighlight_shadow_offset=1;
					    rowhighlight_shadow_color="#808080";
					    rowhighlight_border_color="#b8b8b8";
					    //rowhighlight_bgcolor = "#6080c0";
					    //rowhighlight_shadow_angle=180;
					    //rowhighlight_shadow_radius=4;
					    //rowhighlight_shadow_offset=1;
					    //rowhighlight_shadow_color="#202020";
					    //textcolorhighlight = "#ffffff";
					    textcolorhighlight = "#000000";
					    inner_padding = 4;
					    cellvspacing = 2;
					    //row1_bgcolor = "#496293";
					    //row2_bgcolor = "#496293";
					    row1_bgcolor = '';
					    row2_bgcolor = '';
					    nodata_message = runclient(condition(:rpts_list_osrc:cx__pending, "", "one moment..."));

					    rlt_icon "widget/table-column" { width=40; fieldname=icon; type=image; align=right; }
					    rlt_title "widget/table-column" { width=400; fieldname=func_name; font_size=15; style=bold; caption_fieldname=func_description; }

					    launchrpt "widget/connector"
						{
						event = Click;
						target = index;
						action = Launch;
						event_delay = 0.20;
						Multi = 1;
						Source = runclient(:rpts_list_osrc:fullpath + "?ledger=" + :kardia_sysattrs_osrc:Ledger + "&period=" + :kardia_sysattrs_osrc:CurrentPeriod + "&year_period=" + :kardia_sysattrs_osrc:YearPeriod);
						Width = runclient(:rpts_list_osrc:width);
						Height = runclient(:rpts_list_osrc:height);
						}
					    }
					}
				    }
				}

			    tab_cmps "widget/repeat"
				{
				sql = runserver("
					select
					    path = :cx__pathname,
					    :height
					from
					    object wildcard '/apps/kardia/modules/" + :tabpages:modname + "/plugin_menu_subui_*.cmp'
					");

				one_tab_cmp "widget/component"
				    {
				    path=runserver(:tab_cmps:path);
				    width=904;
				    height=runserver(:tab_cmps:height);
				    }
				}
			    }
			}
		    }

		search_page "widget/tabpage"
		    {
		    title="Search";

		    search_results_vbox "widget/vbox"
			{
			x=20; y=20; width=904; height=600;
			spacing=10;

			search_res_title "widget/label" { height=18; font_size=15; style=bold; align=center; text=runserver("Search Results..."); fl_width=100; }

			search_sep "widget/image" { height=1; fl_width=100; fl_height=0; source="/apps/kardia/images/bg/lsblue_horizsep.png"; }

			search_osrc "widget/osrc"
			    {
			    string "widget/parameter" { type=string; }
			    sql = runserver("
				    declare object info;
				    declare collection global_search scope application;

				    -- Clean up our temporary sort lists
				    delete
					collection global_search
				    ;

				    -- Break out the search criteria: we support up to 5 criteria
				    select
					:info:string = replace(replace(replace(:parameters:string, '  ', ' '), '  ', ' '), ' ', ',')
				    ;
				    select
					:info:len = char_length(:info:string), :info:pos1 = charindex(',', :info:string + ',');
				    select
					:info:pos2 = :info:pos1 + 1 + charindex(',', substring(:info:string + ',', :info:pos1 + 1)) - 1;
				    select
					:info:pos3 = :info:pos2 + 1 + charindex(',', substring(:info:string + ',', :info:pos2 + 1)) - 1;
				    select
					:info:pos4 = :info:pos3 + 1 + charindex(',', substring(:info:string + ',', :info:pos3 + 1)) - 1;
				    select
					:info:pos5 = :info:pos4 + 1 + charindex(',', substring(:info:string + ',', :info:pos4 + 1)) - 1;
				    select
					:info:cri1 = substring(:info:string, 1, condition(:info:pos1 > 0, :info:pos1 - 1, :info:len)),
					:info:cri2 = substring(:info:string, :info:pos1 + 1, condition(:info:pos2 > 0, :info:pos2 - :info:pos1 - 1, :info:len)),
					:info:cri3 = substring(:info:string, :info:pos2 + 1, condition(:info:pos3 > 0, :info:pos3 - :info:pos2 - 1, :info:len)),
					:info:cri4 = substring(:info:string, :info:pos3 + 1, condition(:info:pos4 > 0, :info:pos4 - :info:pos3 - 1, :info:len)),
					:info:cri5 = substring(:info:string, :info:pos4 + 1, condition(:info:pos5 > 0, :info:pos5 - :info:pos4 - 1, :info:len))
				    ;
				    select
					:info:lower1 = condition(:info:cri1 == lower(:info:cri1), 1, 0),
					:info:lower2 = condition(:info:cri2 == lower(:info:cri2), 1, 0),
					:info:lower3 = condition(:info:cri3 == lower(:info:cri3), 1, 0),
					:info:lower4 = condition(:info:cri4 == lower(:info:cri4), 1, 0),
					:info:lower5 = condition(:info:cri5 == lower(:info:cri5), 1, 0)
				    ;
				    select
					:info:cricnt = condition(isnull(:info:cri1,'') = '', 0, 1) + condition(isnull(:info:cri2,'') = '', 0, 1) + condition(isnull(:info:cri3,'') = '', 0, 1) + condition(isnull(:info:cri4,'') = '', 0, 1) + condition(isnull(:info:cri5,'') = '', 0, 1)
				    ;

				    -- Here are the queries from the plug-ins
				    " + isnull((select sum(:sql + ';\n') from object wildcard '/apps/kardia/modules/*/plugin_gsearch_src_*.cmp' ), '') + "

				    -- Return the results to the user
				    select
					:gs:s_label,
					:gs:s_desc,
					:gs:s_type,
					:gs:s_key,
					:cm:icon" +
					isnull((select sum(',\n ' + :cmp:field + ' = (' + :cmp:sql + ')') from object wildcard '/apps/kardia/modules/*/plugin_gsearch_tag_*.cmp' cmp), '') + "
				    from
					collection global_search gs,
					--/apps/kardia/data/Kardia_DB/s_global_search/rows gs,
					object wildcard '/apps/kardia/modules/*/plugin_gsearch_src_*.cmp' cm
				    where
					(:gs:s_cri1 > 0 or isnull(:info:cri1,'') = '') and
					(:gs:s_cri2 > 0 or isnull(:info:cri2,'') = '') and
					(:gs:s_cri3 > 0 or isnull(:info:cri3,'') = '') and
					(:gs:s_cri4 > 0 or isnull(:info:cri4,'') = '') and
					(:gs:s_cri5 > 0 or isnull(:info:cri5,'') = '') and
					:cm:type = :gs:s_type
				    order by
					:gs:s_score desc,
					:gs:s_label asc
				    ");
			    replicasize=500;
			    readahead=500;
			    autoquery=never;

			    on_query_show_tab "widget/connector"
				{
				event=BeginQuery;
				target=tab_menu;
				action=SetTab;
				Tab=runclient('search_page');
				}

			    search_results "widget/table"
				{
				height=561;
				min_rowheight=16;
				max_rowheight=128;
				mode=dynamicrow;
				show_mouse_focus = no;
				allow_selection = yes;
				show_selection = yes;
				initial_selection = no;
				demand_scrollbar = yes;
				overlap_scrollbar = yes;
				colsep = 0;
				titlebar = no;
				row_border_radius=4;
				//rowhighlight_bgcolor = "#f0f0f0";
				//rowhighlight_shadow_color = "#6080c0";
				//rowhighlight_shadow_location = 'inside';
				//rowhighlight_shadow_radius = 10;
				rowhighlight_bgcolor = "#f0f0f0";
				rowhighlight_shadow_angle=180;
				rowhighlight_shadow_radius=4;
				rowhighlight_shadow_offset=1;
				rowhighlight_shadow_color="#808080";
				rowhighlight_border_color="#b8b8b8";
				//rowhighlight_bgcolor = "#6080c0";
				//rowhighlight_shadow_angle=180;
				//rowhighlight_shadow_radius=4;
				//rowhighlight_shadow_offset=1;
				//rowhighlight_shadow_color="#202020";
				//textcolorhighlight = "#ffffff";
				textcolorhighlight = "#000000";
				inner_padding = 4;
				cellvspacing = 2;
				//row1_bgcolor = "#496293";
				//row2_bgcolor = "#496293";
				row1_bgcolor = '';
				row2_bgcolor = '';
				nodata_message = runclient(condition(:search_osrc:cx__pending, "no matching results", "one moment..."));

				search_icon "widget/table-column" { width=40; fieldname=icon; type=image; align=right; }
				search_title "widget/table-column" { width=820; fieldname=s_label; font_size=15; style=bold; caption_fieldname=s_desc; }

				search_tags "widget/repeat"
				    {
				    sql = "select :cmp:field, :cmp:text, :cmp:tag_bgcolor, :cmp:tag_textcolor from object wildcard '/apps/kardia/modules/*/plugin_gsearch_tag_*.cmp' cmp";

				    one_tag "widget/table-column" { width=80; fieldname=runserver(:search_tags:field); align=center; font_size=15; style=bold; padding=3; bgcolor=runserver(:search_tags:tag_bgcolor); textcolor=runserver(:search_tags:tag_textcolor); border_radius=4; }
				    }

				search_details "widget/repeat"
				    {
				    sql = "select :type, height = max(:height), count(1) from object wildcard '/apps/kardia/modules/*/plugin_gsearch_mod_*.cmp' where (:endorsement is null or has_endorsement(:endorsement, :endorsement_context)) group by :type having count(1) > 0";

				    one_detail "widget/table-row-detail"
					{
					width=924;
					height=runserver(:search_details:height + 20);
					display_for=runclient(:search_osrc:s_type == runserver(:search_details:type));

					detail_vbox "widget/vbox"
					    {
					    x=10; y=15;
					    width=904;
					    height=runserver(:search_details:height + 5);
					    spacing=4;

					    detail_hbox "widget/hbox"
						{
						x=32;
						height=runserver(:search_details:height);
						spacing=10;

						search_detail_items "widget/repeat"
						    {
						    sql = runserver("select :height, :width, path = :cx__pathname from object wildcard '/apps/kardia/modules/*/plugin_gsearch_mod_*.cmp' where (:endorsement is null or has_endorsement(:endorsement, :endorsement_context)) and :type = " + quote(:search_details:type) + " order by :sequence asc");

						    one_item_cmp "widget/component"
							{
							width=runserver(:search_detail_items:width);
							height=runserver(:search_detail_items:height);
							path=runserver(:search_detail_items:path);
							}
						    }
						}

					    detail_sep "widget/image"
						{
						x=0;
						height=1;
						fl_height=0;
						fl_width=100;
						source="/apps/kardia/images/bg/lsblue_horizsep.png";
						}
					    }
					}
				    }

				search_details_ctls "widget/repeat"
				    {
				    sql = "select :height, :type, path = :cx__pathname from object wildcard '/apps/kardia/modules/*/plugin_gsearch_src_*.cmp'";

				    one_detail_ctl "widget/table-row-detail"
					{
					height=runserver(:search_details_ctls:height + 20);
					width=924;
					display_for=runclient(:search_osrc:s_type == runserver(:search_details_ctls:type));

					one_detail_ctl_cmp "widget/component"
					    {
					    x=10; y=15; 
					    width=904;
					    height=runserver(:search_details_ctls:height);
					    path=runserver(:search_details_ctls:path);
					    }
					}
				    }
				}
			    }
			}
		    }
		}
	    }
	}

    motd_cmp "widget/component"
	{
	x=0; y=0; width=1200; height=700;
	path="/apps/kardia/modules/base/motd.cmp";
	}
    }
