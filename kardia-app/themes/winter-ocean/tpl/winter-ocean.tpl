$Version=2$
kardia "widget/template"
    {
    title = "Winter Ocean";

    tplPage "widget/page"
	{
	background="/apps/kardia/images/bg/light_bgnd.jpg";
	//background="/apps/kardia/images/bg/brown_bgnd.jpg";
	linkcolor="#153f5f";
	//font_name = "Arial";
	//font_size = 12;
	}
    tplDarkPage "widget/page"
	{
	widget_class="dark";
	background="/apps/kardia/images/bg/light_bgnd3.jpg";
	}
    tplMenuBar "widget/menu"
	{
	widget_class="bar";
	background = "/apps/kardia/images/bg/blue_gradient2.png";
	fgcolor="#ffffff";
	highlight_bgcolor = "#153f5f";
	active_bgcolor = "#a8c1d8";
	}
    tplMenuPopup "widget/menu"
	{
	widget_class="popup";
	background = "/apps/kardia/images/bg/blue_gradient2_h.png";
	fgcolor="#ffffff";
	highlight_bgcolor = "#153f5f";
	active_bgcolor = "#a8c1d8";
	shadow_offset=2;
	}
    tplClock "widget/clock"
	{
	shadowed=true;
	fgcolor1=black;
	fgcolor2="#dee2ee";
	shadowx=1;
	shadowy=1;
	size=1;
	bold=false;
	}
    tplWinSplash "widget/childwindow"
	{
	widget_class="splash";
	background="/apps/kardia/images/bg/splash3.png";
	closetype="shrink3";
	shadow_offset=2;
	}
    tplWin "widget/childwindow"
	{
	//hdr_background = "/apps/kardia/images/bg/bar.png";
	hdr_bgcolor="#153f5f";
	textcolor="white";
	background="/apps/kardia/images/bg/light_bgnd.jpg";
	shadow_offset=2;
	}
    tplPopupWin "widget/childwindow"
	{
	widget_class = "popup";
	background = "/apps/kardia/images/bg/blue_gradient2_h.png";
	shadow_offset=2;
	}
    tplFormWin "widget/childwindow"
	{
	widget_class = "form_overlay";
	//background="/apps/kardia/images/bg/light_bgnd2.jpg";
	bgcolor="#d8d8d8";
	shadow_offset=2;
	}
    tpEb "widget/editbox"
	{
	bgcolor="white";
	description_fgcolor="#8194a6";
	}
    tplDt "widget/datetime"
	{
	bgcolor="white";
	}
    tplTab "widget/tab"
	{
	//textcolor="white";
	//bgcolor="#3b607e";
	//background="/apps/kardia/images/bg/light_bgnd2.jpg";
	bgcolor="#d8d8d8";
	inactive_bgcolor="#c0c0c0";
	}
    tplLightTab "widget/tab"
	{
	widget_class="light";
	background="/apps/kardia/images/bg/light_bgnd.jpg";
	inactive_background="/apps/kardia/images/bg/light_bgnd2.jpg";
	}
    tplTable "widget/table"
	{
	row1_bgcolor = "#ffffff";
	row2_bgcolor = "#f0f0f0";
	rowhighlight_bgcolor = "#153f5f";
	hdr_background="/apps/kardia/images/bg/blue_gradient.png";
	textcolorhighlight = "#ffffff";
	textcolor = "#000000";
	newrow_bgcolor = "#ffff80";
	textcolornew = "black";
	colsep = 1;
	colsep_bgcolor = "#d8d8d8";
	}
    tplTablePane "widget/pane"
	{
	widget_class = "table_bgnd";
	style=lowered;
	//background="/apps/kardia/images/bg/light_bgnd2.jpg";
	bgcolor="#d8d8d8";
	//background="/apps/kardia/images/bg/95pct_1x1.png";
	}
    tplNonLink "widget/label"
	{
	widget_class = "nonlink";
	fgcolor = "#153f5f";
	//point_fgcolor = "#0000ff";
	//click_fgcolor = "#ffffff";
	//point_fgcolor = "#335a78";
	}
    tplLink "widget/label"
	{
	widget_class = "link";
	fgcolor = "#153f5f";
	point_fgcolor = "#0000ff";
	click_fgcolor = "#a8c1d8";
	//point_fgcolor = "#335a78";
	}
    tplLabelPaneLabel "widget/label"
	{
	widget_class = "label";
	align=center;
	style=bold;
	fgcolor=white;
	}
    tplLabelPane "widget/pane"
	{
	widget_class = "label";
	//style=raised;
	style=bordered;
	//border_color="#5c7e9a";
	border_color="white";
	//border_color="#153f5f";
	//border_color="#335a78";
	//background="/apps/kardia/images/bg/blue_gradient.png";
	background="/apps/kardia/images/bg/blue_gradient2.png";
	//bgcolor="#ececec";
	}
    tplGroupPane "widget/pane"
	{
	widget_class = "group";
	background="/apps/kardia/images/bg/light_bgnd2.jpg";
	style=raised;
	}
    tplSplashPane "widget/pane"
	{
	widget_class = "splash";
	background="/apps/kardia/images/bg/splash3.png";
	}
    tplSepPane "widget/pane"
	{
	widget_class = "separator";
	height=8;
	background = "/apps/kardia/images/bg/blue_gradient2.png";
	}
    tplButton "widget/textbutton"
	{
	background="/apps/kardia/images/bg/blue_gradient.png";
	fgcolor2="#c0c0c0";
	fgcolor1="black";
	disable_color="#787878";
	border_radius=12;
	}
    tplDropDown "widget/dropdown"
	{
	hilight = "#a8c1d8";
	bgcolor = white;
	}
    tplFormControls "widget/component"
	{
	path = "/sys/cmp/form_controls.cmp";
	background=runserver("/apps/kardia/images/bg/blue_gradient2.png");
	fgcolor=white;
	}
    tplRadiobuttonpanel "widget/radiobuttonpanel"
	{
	bgcolor="#d8d8d8";
	outline_bgcolor="black";
	}
    tplOsrc "widget/osrc"
	{
	}
    tplForm "widget/form"
	{
	}
    }
