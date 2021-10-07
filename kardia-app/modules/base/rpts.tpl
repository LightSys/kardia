$Version=2$
rpts_new "widget/template"
    {
    hdrlabelpane "widget/component"
	{
	widget_class = "batchlisthdr";
	background = "/apps/kardia/images/bg/ls_blue_gradient_dark.png";
	}
    table "widget/table"
	{
	titlebar=no;
	overlap_scrollbar=yes;
	demand_scrollbar=yes;
	rowheight=null;
	cellvspacing=4;
	inner_padding=2;
	colsep=0;
	row_border_radius=6;
	row_shadow_radius=2;
	row_shadow_offset=1;
	row_shadow_color="#a0a0a0";
	row_shadow_angle=135;
	}
    pane "widget/pane"
	{
	style=flat;
	bgcolor="#f8f8f8";
	border_radius=12;
	shadow_radius=4;
	shadow_offset=2;
	shadow_color="#808080";
	shadow_angle=135;
	}
    rptslbl "widget/component"
	{
	path="/apps/kardia/modules/base/section_label.cmp";
	height=26;
	fl_height=0;
	}
    }
