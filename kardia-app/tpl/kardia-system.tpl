$Version=2$
kardia "widget/template"
    {
    tplPage "widget/page"
	{
	//bgcolor="white";
	background="/apps/kardia/images/bg/brown_bgnd.jpg";
	linkcolor="#153f5f";
	font_name = "Arial";
	font_size = 12;
	icon = "/apps/kardia/favicon.ico";

	//cx__debug "widget/parameter"
	//    {
	//    type=integer;
	//    default=0;
	//    }
	
	//dbgwin "widget/component"
	//    {
	//    condition=runserver(:this:cx__debug);
	//    mode=static;
	//    x=0;y=0;width=640;height=480;
	//    path="/sys/cmp/debugger.cmp";
	//    }
	}
    tplMenuBar "widget/menu"
	{
	widget_class="bar";
	background = "/apps/kardia/images/bg/blue_gradient2.png";
	fgcolor="#ffffff";
	highlight_bgcolor = "#153f5f";
	active_bgcolor = "#a8c1d8";
	direction = "horizontal";
	popup = false;
	height = 25;
	}
    tplMenuPopup "widget/menu"
	{
	widget_class="popup";
	background = "/apps/kardia/images/bg/blue_gradient2_h.png";
	fgcolor="#ffffff";
	highlight_bgcolor = "#153f5f";
	active_bgcolor = "#a8c1d8";
	direction = "vertical";
	popup = true;
	shadow_offset=2;
	}
    tplClock "widget/clock"
	{
	shadowed=true;
	//fgcolor1="#465e8b";
	fgcolor1=black;
	fgcolor2="#dee2ee";
	shadowx=1;
	shadowy=1;
	size=1;
	moveable=false;
	bold=false;
	hrtype=12;
	ampm=true;
	seconds=false;
	width=74;
	height=20;
	}
    tplWinSplash "widget/childwindow"
	{
	widget_class="splash";
	style=dialog;
	titlebar=no;
	width=346;
	height=258;
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
	style=dialog;
	shadow_offset=2;
	}
    tplPopupWin "widget/childwindow"
	{
	widget_class = "popup";
	background = "/apps/kardia/images/bg/blue_gradient2_h.png";
	style = dialog;
	visible = false;
	shadow_offset=2;
	}
    tplFormWin "widget/childwindow"
	{
	widget_class = "form_overlay";
	style=dialog;
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
	rowheight = 18;
	mode = dynamicrow;
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
    tplLink "widget/label"
	{
	widget_class = "link";
	fgcolor = "#153f5f";
	point_fgcolor = "#0000ff";
	click_fgcolor = "#ffffff";
	//point_fgcolor = "#335a78";
	}
    tplLabelPaneLabel "widget/label"
	{
	widget_class = "label";
	align=center;
	style=bold;
	fgcolor=white;
	y = -2;
	}
    tplLabelPane "widget/pane"
	{
	widget_class = "label";
	width=100;
	height=18;
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
    tplButton "widget/textbutton"
	{
	background="/apps/kardia/images/bg/blue_gradient.png";
	fgcolor2="white";
	fgcolor1="black";
	tristate=no;
	width=100;
	height=24;
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
