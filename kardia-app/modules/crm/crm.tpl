$Version=2$
crm_tpl "widget/template"
    {
    pane "widget/pane"
	{
	widget_class=crm_iconbar;
	style=flat;
	border_color="#6080c0";
	shadow_color="#496293";
	shadow_radius=12;
	shadow_offset=2;
	//border_radius=8;
	//bgcolor="black";
	background="/apps/kardia/images/bg/charcoal_gradient.png";
	}
    button "widget/textbutton"
	{
	widget_class=crm_iconbutton;
	tristate=no;
	border_color="#6080c0";
	border_radius=8;
	border_style=none;
	//border_style=solid;
	image_width=24;
	image_height=24;
	}
    }
