//
//  Centrallix Test Suite
//
//  "T4.app"
//  Modified by arbor70 2009 January 30
//  Originally By Luke Ehresman - August 23, 2002
//

$Version=2$
Page1 "widget/page"
    {
    title="Kardia (Web Browser Title)";
    bgcolor="#4386a8";
    x=0; y=0; width=400; height=480;
    
    Textbutton1 "widget/textbutton"
	{
	x=10; y=10; width=90; height=30;
	text="Checkboxes";
	tristate="no";
	bgcolor="#c0c0c0";
	fgcolor1="#000000";
	fgcolor2="#c0c0c0";
	Connector1 "widget/connector" { event="Click"; target="Window1"; action="ToggleVisibility"; }
	}
    Textbutton2 "widget/textbutton"
	{
	x=100; y=10; width=100; height=30;
	text="Radio Buttons";
	tristate="no";
	bgcolor="#c0c0c0";
	fgcolor1="#000000";
	fgcolor2="#c0c0c0";
	Connector2 "widget/connector" { event="Click"; target="Window2"; action="ToggleVisibility"; }
	}
    Textbutton3 "widget/textbutton"
	{
	x=200; y=10; width=70; height=30;
	text="Clocks";
	tristate="no";
	bgcolor="#c0c0c0";
	fgcolor1="#000000";
	fgcolor2="#c0c0c0";
	Connector3 "widget/connector" { event="Click"; target="Window3"; action="ToggleVisibility"; }
	}
    Textbutton4 "widget/textbutton"
	{
	x=270; y=10; width=50; height=30;
	text="D*";
	tristate="no";
	bgcolor="#c0c0c0";
	fgcolor1="#000000";
	fgcolor2="#c0c0c0";
	Connector4 "widget/connector" { event="Click"; target="Window4"; action="ToggleVisibility"; }
	}
    Textbutton5 "widget/textbutton"
	{
	x=320; y=10; width=50; height=30;
	text="Boxes";
	tristate="no";
	bgcolor="#c0c0c0";
	fgcolor1="#000000";
	fgcolor2="#c0c0c0";
	Connector5 "widget/connector" { event="Click"; target="Window5"; action="ToggleVisibility"; }
	}
	
	
	WindowCheckReceiving "widget/childwindow"
	{
	x=340; y=50; width=640; height=480;
	title="Donations - Checks / Receiving";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink1";
	gshade="true";

	mypane "widget/pane"
	{
	x=10; y=10; width=300; height=300;
	style="raised";
	bgcolor = "#c0c0c0";
	}
	
	
	// Donor Information Pane
	lblDonorPane  "widget/label"    { x=25; y=0; width=100; height=15; text="Donor Information"; }
	lblDonorID    "widget/label"    { x=15; y=15; width=100; height=15; text="Donor No:"; bgcolor="#ffffff";}
	edtDonorID "widget/editbox"
	{
	    x=45; y=25; height=15; width=120;
	    style="lowered";
	    bgcolor="#ffffff";
	}
	
	//Checkbox1 "widget/checkbox" { x=10; y=13; width=12;  height=12; }
	//Checkbox2 "widget/checkbox" { x=10; y=33; width=12;  height=12; }
	//Label2    "widget/label"    { x=25; y=30; width=100; height=15; text="2nd Checkbox"; }
	//Checkbox3 "widget/checkbox" { x=10; y=53; width=12;  height=12; }
	//Label3    "widget/label"    { x=25; y=50; width=100; height=15; text="Third Option"; }
	}

    Window1 "widget/childwindow"
	{
	x=10; y=50; width=160; height=105;
	title="Checkbox Test";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink1";
	gshade="true";

	chk1 "widget/checkbox" { x=10; y=13; width=12;  height=12; }
	lbl1    "widget/label"    { x=25; y=10; width=100; height=15; text="Checkbox #1"; }
	chk2 "widget/checkbox" { x=10; y=33; width=12;  height=12; }
	lbl2    "widget/label"    { x=25; y=30; width=100; height=15; text="2nd Checkbox"; }
	chk3 "widget/checkbox" { x=10; y=53; width=12;  height=12; }
	lbl3    "widget/label"    { x=25; y=50; width=100; height=15; text="Third Option"; }
	}

    Window2 "widget/childwindow"
	{
	x=153; y=105; width=180; height=160;
	title="RadioButton Test";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink2";
	gshade="true";

	RadioButtonPanel1 "widget/radiobuttonpanel"
	    {
	    x=0; y=0; width=175; height=130;
	    title="Radio Buttons";
	    bgcolor="#c0c0c0";

	    RadioButton1 "widget/radiobutton" { label="1st RB option"; }
	    RadioButton2 "widget/radiobutton" { label="2nd RB option"; }
	    RadioButton3 "widget/radiobutton" { label="3rd RB option"; }
	    RadioButton4 "widget/radiobutton" { label="4th RB option"; }
	    }
	}

    Window3 "widget/childwindow"
	{
	x=160; y=170; width=150; height=120;
	title="Clock Test";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink3";
	gshade="true";

	Clock1 "widget/clock"
	    {
	    x=10; y=10; width=100; height=20;
	    shadowed="false";
	    fgcolor1="#000000";
	    size=1; moveable="false"; bold="true";
	    }
	Clock2 "widget/clock"
	    {
	    x=10; y=40; width=80; height=20;
	    shadowed="true";
	    fgcolor1="#739886";
	    fgcolor2="#b0b0b0";
	    shadowx=1; shadowy=1; size=0; moveable="false"; bold="true";
	    }
	Clock3 "widget/clock"
	    {
	    x=12; y=62; width=120; height=20;
	    shadowed="true";
	    fgcolor1="#aa9900";
	    fgcolor2="#b0b0b0";
	    shadowx=1; shadowy=1; size=2; moveable="false"; bold="true";
	    }
	}

    Window4 "widget/childwindow"
	{
	x=20; y=220; width=172; height=83;
	title="D* Test";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink2";
	gshade="true";

	Dropdown1 "widget/dropdown"
	    {
	    mode="static";
	    x=5; y=5; height=20; width=160;
	    bgcolor="#c0c0c0";
	    hilight="#a0a0a0";

	    DropdownItem1 "widget/dropdownitem" { label="Movies"; value="1"; }
	    DropdownItem2 "widget/dropdownitem" { label="Speakers"; value="2"; }
	    DropdownItem3 "widget/dropdownitem" { label="Soda"; value="3"; }
	    DropdownItem4 "widget/dropdownitem" { label="Monitor"; value="4"; }
	    DropdownItem5 "widget/dropdownitem" { label="Telephone"; value="5"; }
	    DropdownItem6 "widget/dropdownitem" { label="Headphones"; value="6"; }
	    DropdownItem7 "widget/dropdownitem" { label="Cables"; value="7"; }
	    }
	Datetime1 "widget/datetime"
	    {
	    x=5; y=30; width=160; height=20;
	    bgcolor="#c0c0c0";
	    initialdate="December 25, 2001 5:30pm";
	    }
	}

    Window5 "widget/childwindow"
	{
	x=80; y=280; width=250; height=200;
	title="Boxes Test";
	hdr_bgcolor="#739886";
	bgcolor="#c0c0c0";
	style="dialog";
	closetype="shrink1";
	gshade="true";

	Editbox1 "widget/editbox"
	    {
	    x=5; y=5; height=15; width=120;
	    style="lowered";
	    bgcolor="#ffffff";
	    }
	Textarea1 "widget/textarea"
	    {
	    x=5; y=30; height=136; width=234;
	    style="lowered";
	    bgcolor="#ffffff";
	    }
	}
    }
