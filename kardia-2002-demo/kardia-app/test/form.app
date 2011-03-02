$Version=2$
wholePage "widget/page" 
	{
	alerter "widget/alerter" {}
	title = "Form, osrc, and widget test page";
	bgcolor = "#1f1f1f";
	textcolor = black;

	_3bConfirmWindow "widget/htmlwindow"
		{
		title = "Confirm something please";
		titlebar = yes;
		bgcolor= "#c0c0c0";
		visible = false;
		x=200;y=200;width=300;height=80;

		_3bConfirmDiscard "widget/textbutton"
			{
			x=10;y=15;width=80;height=30;
			text = "Discard";
			}
		_3bConfirmSave "widget/textbutton"
			{
			x=110;y=15;width=80;height=30;
			text = "Save";
			}
		_3bConfirmCancel "widget/textbutton"
			{
			x=210;y=15;width=80;height=30;
			text = "Cancel";
			}
		}

	navWindow "widget/htmlwindow" 
		{
		title = "Left Nav Window";
		bgcolor = "#b0b0b0";
		titlebar = yes;
		style = "floating";
		x = 0; y = 0; width = 95; height = 300;

		navBtn1 "widget/textbutton" 
			{
			x = 5; y = 5; height = 60; width = 80;
			fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
			text = "Show self DOM";
			tristate = "yes";
			cn5 "widget/connector"
				{
				event="Click";
				target="alerter";
				action="ViewTreeDOM";
				param="(navBtn1)";
				}
			}
		showedit1 "widget/textbutton" 
			{
			x = 5; y = 125; height = 60; width = 80;
			fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
			text = "Display above text";
			tristate = "yes";
			cn6 "widget/connector"
				{
				event="Click";
				target="alerter";
				action="Confirm";
				param="editshow1.getvalue()";
				}
			}
		editshow1 "widget/editbox"
			{
				x=4;y=100;width=80;height=15;
			}
		}
	mainWindow "widget/htmlwindow" 
		{
		title = "Main";
		bgcolor = "#b0b0b0";
		titlebar = yes;
		style = "floating";
		x = 95; y = 0; width = 600; height = 300;
		osrc1 "widget/osrc"
		{
			form1 "widget/form"
				{
				basequery = "SELECT :annotation, firstname= :ptnr_first_name_c, familyname= :ptnr_family_name_c  FROM /kardia/kardia_DB/ptnr_person/rows";
				//ReadOnly = no;

				_3bconfirmwindow = "_3bConfirmWindow";
				//basequery = "SELECT a,b,c,d,e FROM data WHERE b=true";
				//basewhere = "a=true";
				formstatus "widget/formstatus"
					{
					x=5;y=235;
					}
				btnFirst "widget/imagebutton"
					{
					x=250;y=5;
					width=20; height=20;
					image = "/sys/images/ico16aa.gif";
					pointimage = "/sys/images/ico16ab.gif";
					clickimage = "/sys/images/ico16ac.gif";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="First";
						}
					}
				btnPrev "widget/imagebutton"
					{
					x=270;y=5;
					width=20; height=20;
					image = "/sys/images/ico16ba.gif";
					pointimage = "/sys/images/ico16bb.gif";
					clickimage = "/sys/images/ico16bc.gif";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Prev";
						}
					}
				btnNext "widget/imagebutton"
					{
					x=290;y=5;
					width=20; height=20;
					image = "/sys/images/ico16ca.gif";
					pointimage = "/sys/images/ico16cb.gif";
					clickimage = "/sys/images/ico16cc.gif";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Next";
						}
					}
				btnLast "widget/imagebutton"
					{
					x=310;y=5;
					width=20; height=20;
					image = "/sys/images/ico16da.gif";
					pointimage = "/sys/images/ico16db.gif";
					clickimage = "/sys/images/ico16dc.gif";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Last";
						}
					}


				bigTabFrame "widget/tab" 
					{
					x = 5; y = 5; width = 590; height = 200;
					bgcolor = "#c0c0c0";
				
					First "widget/tabpage"
						{
						testcheck "widget/checkbox"
							{
								x = 20; y = 20; width = 12; height = 12;
								fieldname = "fieldcheck1";
							}
						testcheck2 "widget/checkbox"
							{
								x = 20; y = 40; width = 12; height = 12;
								fieldname="fieldcheck2";
							}
						testedit1 "widget/editbox"
							{
								x=20;y=70;width=100;height=15;
								fieldname="annotation";
							}
						testedit2 "widget/editbox"
							{
								x=20;y=100;width=100;height=15;
								fieldname="firstname";
							}
						testedit3 "widget/editbox"
							{
								x=20;y=130;width=100;height=15;
								fieldname="familyname";
							}
				//		testspin "widget/spinner"
				//			{
				//				x=10;y=80;width=100;height=15;
				//				fieldname="fieldspin1";
				//			}
						formchangebtn1 "widget/textbutton" 
							{
							x = 50; y = 10; height = 30; width = 80;
							fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
							text = "Form status to query";
							cn1 "widget/connector"
								{
								event="Click";
								target="form1";
								action="Query";
								}
							}
						formchangebtn2 "widget/textbutton" 
							{
							x = 150; y = 10; height = 30; width = 80;
							fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
							text = "Execute Query";
							cn1 "widget/connector"
								{
								event="Click";
								target="form1";
								action="QueryExec";
								}
							}
						testradio "widget/radiobuttonpanel" 
							{
							x=250;
							y=20;
							width=150;
							height=180;
							title="test";
							fieldname="radiofield1";

							label1 "widget/radiobutton" 
								{
								label="basketball";
								selected="true";
								}
							label2 "widget/radiobutton" 
								{
								label="is fun";
								}
							}
						testdrop "widget/dropdown"
							{
							x=200;y=130;
							width=100;
							bgcolor="#CFCFCF";
							hilight="green";
							fieldname="full_name";
							d1 "widget/dropdownitem"
								{
								value="January";
								label="January";
								}
							d2 "widget/dropdownitem"
								{
								value="February";
								label="February";
								}
							d3 "widget/dropdownitem"
								{
								value="March";
								label="March";
								}
							d4 "widget/dropdownitem"
								{
								value="April";
								label="April";
								}
							d5 "widget/dropdownitem"
								{
								value="May";
								label="May";
								}
							d6 "widget/dropdownitem"
								{
								value="June";
								label="June";
								}
							d7 "widget/dropdownitem"
								{
								value="July";
								label="July";
								}
							d8 "widget/dropdownitem"
								{
								value="August";
								label="August";
								}
							d9 "widget/dropdownitem"
								{
								value="September";
								label="September";
								}
							d10 "widget/dropdownitem"
								{
								value="October";
								label="October";
								}
							d11 "widget/dropdownitem"
								{
								value="November";
								label="November";
								}
							d12 "widget/dropdownitem"
								{
								value="December";
								label="December";
								}
							}
//						testspin "widget/spinner"
//							{
//							x=100;y=80;
//							width=100;height=15;
//							fieldname="spin1";
//							}
						}
					Second "widget/tabpage" 
						{
						testedit3 "widget/editbox"
							{
								x=20;y=10;width=100;height=15;
								fieldname="fieldbox3";
							}
						testedit4 "widget/editbox"
							{
								x=20;y=40;width=100;height=15;
								fieldname="fieldbox4";
							}
						testradio1 "widget/radiobuttonpanel" 
							{
							x=50;
							y=100;
							width=150;
							height=180;
							title="test";
							fieldname="radiofield12";

							label12 "widget/radiobutton" 
								{
								label="etball";
								selected="true";
								}
							label13 "widget/radiobutton" 
								{
								label="etbalasdfasdfl";
								}
							label22 "widget/radiobutton" 
								{
								label="fun";
								}
							}


						}
					}
				}
			}		//end of osrc
		}
	rightNavWindow "widget/htmlwindow" 
		{
		title = "Right Nav Window";
		bgcolor = "#b0b0b0";
		titlebar = yes;
		style = "floating";
		x = 695; y = 0; width = 135; height = 300;

		rightTabFrame "widget/tab" 
			{
			x = 0; y = 0; width = 130; height = 280;
			bgcolor = "#c0c0c0";
			rFirst "widget/tabpage"
				{
				title="Buttons";
				formchangebtn10 "widget/textbutton" 
					{
					x = 5; y = 5; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Form to Query";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Query";
						}
					}
				formchangebtn11 "widget/textbutton" 
					{
					x = 5; y = 35; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Form to New";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="New";
						}
					}
				formchangebtn12 "widget/textbutton" 
					{
					x = 5; y = 65; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Form Clear";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Clear";
						}
					}
				formchangebtn13 "widget/textbutton" 
					{
					x = 5; y = 95; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Form to Edit";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Edit";
						}
					}
				formchangebtn14 "widget/textbutton" 
					{
					x = 5; y = 125; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Form Discard";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="Discard";
						}
					}
				formchangebtn15 "widget/textbutton" 
					{
					x = 5; y = 155; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "Test 3-button confirm";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="test3bconfirm";
						}
					}
				formchangebtn16 "widget/textbutton" 
					{
					x = 5; y = 185; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="";
						}
					}
				formchangebtn17 "widget/textbutton" 
					{
					x = 5; y = 215; height = 30; width = 118;
					fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
					text = "";
					cn1 "widget/connector"
						{
						event="Click";
						target="form1";
						action="";
						}
					}
				}
			}
		}
	Treeview_pane "widget/pane"
		{
		x=0; y=300; width=800; height=300;
		bgcolor="#e0e0e0";
		style=lowered;
		Tree_scroll "widget/scrollpane"
			{
			x=0; y=0; width=798; height=298;
			Tree "widget/treeview"
				{
				x=0; y=1; width=2000;
				source = "javascript:form1";
				}
			}
		}
	}
