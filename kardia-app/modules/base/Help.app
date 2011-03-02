$Version=2$
help "widget/page"
    {
    title = "Kardia - Help";
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl";
    bgcolor = "#ffffff";
    x=0; y=0; width=640; height=480;

    lang_label "widget/label" { x=8;y=8;width=192;height=20; text="Language:"; }
    lang_dd "widget/dropdown" { x=8;y=28;width=192;height=20; bgcolor="#ffffff"; mode=dynamic_server; hilight="#c0c0c0"; sql="select :l:lc_description, :f:name from /apps/kardia/help f, /apps/kardia/data/Locale.csv/rows l where :f:name = :l:lc_id"; }
    
    tree_pane "widget/pane"
	{
	x=8;y=64;
	height=480 - 8 - 64;
	width=200 - 8;
	style=lowered;
	bgcolor="#ffffff";

	tree_scroll "widget/scrollpane"
	    {
	    x=0;y=0;
	    height=480 - 8 - 64 - 2;
	    width=200 - 8 - 2;
	    samples_tree "widget/treeview"
		{
		x=0;y=0;width=200 - 8 - 2 - 20;
		show_branches=yes;
		show_root=no;
		show_root_branch = yes;
		use_3d_lines=no;
		source="/apps/kardia/help/en_US/";

		tree_click "widget/connector"
		    {
		    event="ClickItem";
		    target=info_html;
		    action="LoadPage";
		    Source=runclient(:Pathname + '?ls__type=text%2fplain');
		    }
		}
	    }
	}

    info_pane "widget/pane"
	{
	x=208;y=8;
	height=480 - 16;
	width=640 - 208 - 8;
	style=lowered;
	bgcolor="#ffffff";

	info_scroll "widget/scrollpane"
	    {
	    x=0;y=0;
	    height=480 - 16 - 2;
	    width=640 - 208 - 8 - 2;
	    info_html "widget/html"
		{
		x=1;y=0;width = 640 - 208 - 8 - 2 - 20;
		mode=dynamic;
		source="/apps/kardia/help/en_US/Overview/Introduction.html";
		}
	    }
	}
    }
