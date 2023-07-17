$Version=2$
taskstpl "widget/template"
    {
    label "widget/label" { fgcolor=white; }

    editbox "widget/editbox" { fgcolor=white; }

    button "widget/textbutton"
	{
	widget_class=iconbutton;
	tristate=no;
	border_color="#6080c0";
	border_radius=8;
	border_style=none;
	//border_style=solid;
	image_width=24;
	image_height=24;
	}
    textbutton "widget/textbutton"
	{
	background="/apps/kardia/images/bg/lsblue_btngradient.png";
	fgcolor1=white;
	fgcolor2=black;
	disable_color="#333333";
	}
    table "widget/table"
	{
	nodata_message_textcolor = "#808080";
	allow_selection = yes;
	allow_deselection = yes;
	show_selection = yes;
	initial_selection = noexpand;
	demand_scrollbar = yes;
	overlap_scrollbar = yes;
	colsep = 0;
	//titlebar = no;
	row_border_radius=6;
	inner_padding = 2;
	cellvspacing = 2;
	row1_bgcolor = "#101010";
	row2_bgcolor = "#181818";
	textcolor = white;
	rowhighlight_bgcolor = "#282828";
	rowhighlight_shadow_color = '#6080c0';
	rowhighlight_shadow_location = 'inside';
	rowhighlight_shadow_radius = 6;
	textcolorhighlight = white;
	row_minheight=16;
	row_maxheight=128;
	rowheight = null;
	hdr_background = "/apps/kardia/images/bg/lsblue_gradient.png";
	type_to_find = yes;
	}
    pane "widget/pane"
	{
	border_radius=8;
	border_color="#334466";
	style=bordered;
	}

    window "widget/childwindow"
	{
	titlebar=no;
	visible=no;
	border_radius=8;
	border_style=solid;
	border_color="#6080c0";
	shadow_radius=8;
	shadow_color="#6080c0";
	shadow_offset=0;
	background=null;
	bgcolor="#f8f8f8";
	}

    osrc "widget/osrc"
	{
	replicasize=100;
	readahead=100;
	}
    }
