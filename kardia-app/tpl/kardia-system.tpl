$Version=2$
kardia "widget/template"
    {
    tplPage "widget/page"
	{
	icon = "/apps/kardia/favicon.ico";
	widget_template = runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
	add_endorsements_sql = "select endorsement = :s_endorsement, context = :s_context from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_subject = 'u:' + user_name()";
	}
    tplMenuBar "widget/menu"
	{
	widget_class="bar";
	direction = "horizontal";
	popup = false;
	height = 25;
	}
    tplMenuPopup "widget/menu"
	{
	widget_class="popup";
	direction = "vertical";
	popup = true;
	}
    tplClock "widget/clock"
	{
	moveable=false;
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
	}
    tplWin "widget/childwindow"
	{
	style=dialog;
	}
    tplPopupWin "widget/childwindow"
	{
	widget_class = "popup";
	style = dialog;
	visible = false;
	}
    tplFormWin "widget/childwindow"
	{
	widget_class = "form_overlay";
	style=dialog;
	}
    tpEb "widget/editbox"
	{
	}
    tplDt "widget/datetime"
	{
	}
    tplTab "widget/tab"
	{
	}
    tplTable "widget/table"
	{
	rowheight = 20;
	mode = dynamicrow;
	}
    tplTablePane "widget/pane"
	{
	widget_class = "table_bgnd";
	}
    tplNonLink "widget/label"
	{
	widget_class = "nonlink";
	}
    tplLink "widget/label"
	{
	widget_class = "link";
	}
    tplLabelPaneLabel "widget/label"
	{
	widget_class = "label";
	y = -2;
	}
    tplLabelPane "widget/pane"
	{
	widget_class = "label";
	width=100;
	height=18;
	}
    tplGroupPane "widget/pane"
	{
	widget_class = "group";
	}
    tplButton "widget/textbutton"
	{
	tristate=no;
	width=100;
	height=24;
	}
    tplDropDown "widget/dropdown"
	{
	}
    tplFormControls "widget/component"
	{
	path = "/sys/cmp/form_controls.cmp";
	}
    tplRadiobuttonpanel "widget/radiobuttonpanel"
	{
	}
    tplOsrc "widget/osrc"
	{
	}
    tplForm "widget/form"
	{
	}
    }
