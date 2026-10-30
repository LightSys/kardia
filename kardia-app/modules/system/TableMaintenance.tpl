$Version=2$
TableMaintenance "widget/template"
    {
    tplTable "widget/table"
	{
	rowheight = 20;
	mode = dynamicrow;
	//row1_bgcolor = "#ffffff";
	//row2_bgcolor = "#f0f0f0";
	//rowhighlight_bgcolor = "#153f5f";
	//hdr_background="/apps/kardia/images/bg/blue_gradient.png";
	//textcolorhighlight = "#ffffff";
	//textcolor = "#000000";
	//newrow_bgcolor = "#ffff80";
	//textcolornew = "black";
	//colsep = 1;
	//dragcols = 1;
	colsep_bgcolor = "#7393ac";
	colsep_mode = "full";
	//overlap_scrollbar=yes;
	//demand_scrollbar=yes;
	//initial_selection = no;
	//rowheight=null;
	cellvspacing=1;
	inner_padding=2;
	row_border_radius=2;
	row_shadow_radius=0;
	row_shadow_offset=0;
	row_shadow_color=null;
	//row_shadow_angle=135;
	}
    tplTablePane "widget/pane"
	{
	widget_class = "table_bgnd";
	}
    tplOsrc "widget/osrc"
	{
	}
    }
