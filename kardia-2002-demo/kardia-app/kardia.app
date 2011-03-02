$Version=2$
wholePage "widget/page" {
	title = "Kardia";
	loadstatus="true";
	background = "/kardia/images/bgnd.png";
	_3bConfirmWindow "widget/htmlwindow" {
		title = "Changes were detected.";
		titlebar = yes;
		hdr_bgcolor="#880000";
		bgcolor= "#c0c0c0";
		textcolor="#ffffff";
		style="dialog";
		visible = false;
		x=200;y=200;width=300;height=80;

		_3bConfirmDiscard "widget/textbutton" {
			x=10;y=15;width=80;height=30;
			fgcolor1 = "#000000";
			fgcolor2 = "#bababa";
			bgcolor = "#bababa";
			text = "Discard";
			tristate = "no";
		}
		_3bConfirmSave "widget/textbutton" {
			x=110;y=15;width=80;height=30;
			text = "Save";
			fgcolor1 = "#000000";
			fgcolor2 = "#bababa";
			bgcolor = "#bababa";
			tristate = "no";
		}
		_3bConfirmCancel "widget/textbutton" {
			x=210;y=15;width=80;height=30;
			text = "Cancel";
			fgcolor1 = "#000000";
			fgcolor2 = "#bababa";
			bgcolor = "#bababa";
			tristate = "no";
		}
	}

	sidebarButton1 "widget/textbutton" {
		x=10; y=10; height=25; width=90;
		fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
		bgcolor="#c0c0c0";
		tristate="no";
		text="People";
		cn1 "widget/connector" {
			event="Click"; target="ptnrQueryWindow"; action="ToggleVisibility";
		}
	}
	sidebarButton2 "widget/textbutton" {
		x=110; y=10; height=25; width=90;
		fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
		bgcolor="#c0c0c0";
		tristate="no";
		text="Churches";
		cn2 "widget/connector" {
			event="Click"; target="ptnrChurchWindow"; action="ToggleVisibility";
		}
	}
	btnDebug "widget/textbutton" {
		x=710; y=10; width=90; height=25;
		fgcolor1 = "#000000"; fgcolor2 = "#cfcfcf";
		text="";
		cn3 "widget/connector" {
			event="Click"; target="debugWindow"; action="SetVisibility";
		}
	}

	ptnrQueryWindow "widget/htmlwindow" {
		title="Partner Management";
		titlebar=yes;
		style="dialog";
		background="/kardia/images/bg_person.png";
		hdr_bgcolor="#36526d";
		textcolor="white";
		visible="true";
		x=10;y=55;width=630;height=465;
		osrc1 "widget/osrc" {
			replicasize=9;
			readahead=3;
			sql="SELECT :ptnr_pkey_i,:ptnr_okey_i,:ptnr_pkey_unit_i,:ptnr_okey_unit_i,:ptnr_title_c,:ptnr_first_name_c,:ptnr_prefered_name_c,:ptnr_middle_name_c,:ptnr_family_name_c,:ptnr_decorations_c,:ptnr_previous_family_name_c,:ptnr_date_of_birth_d,:ptnr_gender_c,:ptnr_marital_status_c,:ptnr_occupation_code_c,:smgr_date_created_d,:smgr_pkey_modified_by_i,:smgr_okey_modified_by_i,:smgr_pkey_created_by_i,:smgr_okey_created_by_i,:ptnr_academic_title_c FROM /kardia/kardia_DB/ptnr_person/rows";
			form1 "widget/form" {
				_3bconfirmwindow = "_3bConfirmWindow";

				formstatus "widget/formstatus" {
					x=10; y=410;
				}
				cn2 "widget/connector" { event="View"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="Query"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="Modify"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="New"; target="btnSave"; action="Disable"; }
				cn2 "widget/connector" { event="DataChange"; target="btnSave"; action="Enable"; }

				cn2 "widget/connector" { event="View"; target="btnQuery"; action="Enable"; }
				cn2 "widget/connector" { event="Query"; target="btnQuery"; action="Enable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnQuery"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnQuery"; action="Enable"; }
				cn2 "widget/connector" { event="Modify"; target="btnQuery"; action="Enable"; }
				cn2 "widget/connector" { event="New"; target="btnQuery"; action="Enable"; }

				cn2 "widget/connector" { event="View"; target="btnQueryExec"; action="Disable"; }
				cn2 "widget/connector" { event="Query"; target="btnQueryExec"; action="Enable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnQueryExec"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnQueryExec"; action="Disable"; }
				cn2 "widget/connector" { event="Modify"; target="btnQueryExec"; action="Disable"; }
				cn2 "widget/connector" { event="New"; target="btnQueryExec"; action="Disable"; }

				btnFirst "widget/imagebutton" {
					x=55; y=410; width=20; height=20; 
					image = "/sys/images/ico16aa.gif";
					pointimage = "/sys/images/ico16ab.gif"; 
					clickimage = "/sys/images/ico16ac.gif";
					cn4 "widget/connector" { 
						event="Click"; target="form1"; action="First";
					}
				}
				btnPrev "widget/imagebutton" {
					x=75; y=410; width=20; height=20; 
					image = "/sys/images/ico16ba.gif";
					pointimage = "/sys/images/ico16bb.gif"; 
					clickimage = "/sys/images/ico16bc.gif";
					cn5 "widget/connector" { 
						event="Click"; target="form1"; action="Prev";
					}
				}
				btnNext "widget/imagebutton" {
					x=95; y=410; width=20; height=20; 
					image = "/sys/images/ico16ca.gif";
					pointimage = "/sys/images/ico16cb.gif"; 
					clickimage = "/sys/images/ico16cc.gif";
					cn6 "widget/connector" { 
						event="Click"; target="form1"; action="Next";
					}
				}
				btnLast "widget/imagebutton" {
					x=115; y=410; width=20; height=20; 
					image = "/sys/images/ico16da.gif";
					pointimage = "/sys/images/ico16db.gif"; 
					clickimage = "/sys/images/ico16dc.gif";
					tristate="no";
					cn7 "widget/connector" { 
						event="Click"; target="form1"; action="Last";
					}
				}

				btnSave "widget/imagebutton" {
					x=5; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/save-normal.gif";
					pointimage="/kardia/images/save-up.gif";
					clickimage="/kardia/images/save-down.gif";
					disabledimage="/kardia/images/save-disabled.gif";
					cn8 "widget/connector" {
						event="Click"; target="form1"; action="Save";
					}
				}
				btnQuery "widget/imagebutton" {
					x=32; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/query-normal.gif";
					pointimage="/kardia/images/query-up.gif";
					clickimage="/kardia/images/query-down.gif";
					disabledimage="/kardia/images/query-disabled.gif";
					cn9 "widget/connector" {
						event="Click"; target="form1"; action="Query";
					}
				}
				btnQueryExec "widget/imagebutton" {
					x=59; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/go-normal.gif";
					pointimage="/kardia/images/go-up.gif";
					clickimage="/kardia/images/go-down.gif";
					disabledimage="/kardia/images/go-disabled.gif";

					cn10 "widget/connector" {
						event="Click"; target="form1"; action="QueryExec";
					}
				}


				ptnr_pkey_i_label "widget/label" {
					x=10; y=40; width=170; height=15; style="lowered"; text="Partner Key:";align="right";
				}
				ptnr_pkey_i_data "widget/editbox" {
					x=180; y=40; width=60; height=15; style="lowered"; fieldname="ptnr_pkey_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_okey_i_label "widget/label" {
					x=10; y=60; width=170; height=15; style="lowered"; text="Office Key:";align="right";
				}
				ptnr_okey_i_data "widget/editbox" {
					x=180; y=60; width=60; height=15; style="lowered"; fieldname="ptnr_okey_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_pkey_unit_i_label "widget/label" {
					x=10; y=80; width=170; height=15; style="lowered"; text="Unit Partner Key:";align="right";
				}
				ptnr_pkey_unit_i_data "widget/editbox" {
					x=180; y=80; width=60; height=15; style="lowered"; fieldname="ptnr_pkey_unit_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_okey_unit_i_label "widget/label" {
					x=10; y=100; width=170; height=15; style="lowered"; text="Unit Office Key:";align="right";
				}
				ptnr_okey_unit_i_data "widget/editbox" {
					x=180; y=100; width=60; height=15; style="lowered"; fieldname="ptnr_okey_unit_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_title_c_label "widget/label" {
					x=10; y=120; width=170; height=15; style="lowered"; text="Title:";align="right";
				}
				ptnr_title_c_data "widget/editbox" {
					x=180; y=120; width=120; height=15; style="lowered"; fieldname="ptnr_title_c";
					bgcolor="#ffffff";
				}
				ptnr_first_name_c_label "widget/label" {
					x=10; y=140; width=170; height=15; style="lowered"; text="First Name:";align="right";
				}
				ptnr_first_name_c_data "widget/editbox" {
					x=180; y=140; width=120; height=15; style="lowered"; fieldname="ptnr_first_name_c";
					bgcolor="#ffffff";
				}
				ptnr_prefered_name_c_label "widget/label" {
					x=10; y=160; width=170; height=15; style="lowered"; text="Preferred Name:";align="right";
				}
				ptnr_prefered_name_c_data "widget/editbox" {
					x=180; y=160; width=120; height=15; style="lowered"; fieldname="ptnr_prefered_name_c";
					bgcolor="#ffffff";
				}
				ptnr_middle_name_c_label "widget/label" {
					x=10; y=180; width=170; height=15; style="lowered"; text="Middle Name:";align="right";
					bgcolor="#ffffff";
				}
				ptnr_middle_name_c_data "widget/editbox" {
					x=180; y=180; width=120; height=15; style="lowered"; fieldname="ptnr_middle_name_c";
					bgcolor="#ffffff";
				}
				ptnr_family_name_c_label "widget/label" {
					x=10; y=200; width=170; height=15; style="lowered"; text="Family Name:";align="right";
				}
				ptnr_family_name_c_data "widget/editbox" {
					x=180; y=200; width=120; height=15; style="lowered"; fieldname="ptnr_family_name_c";
					bgcolor="#ffffff";
				}
				ptnr_decorations_c_label "widget/label" {
					x=10; y=220; width=170; height=15; style="lowered"; text="Decorations:";align="right";
				}
				ptnr_decorations_c_data "widget/editbox" {
					x=180; y=220; width=120; height=15; style="lowered"; fieldname="ptnr_decorations_c";
					bgcolor="#ffffff";
				}
				ptnr_previous_family_name_c_label "widget/label" {
					x=10; y=240; width=170; height=15; style="lowered"; text="Previous Family Name:";align="right";
				}
				ptnr_previous_family_name_c_data "widget/editbox" {
					x=180; y=240; width=120; height=15; style="lowered"; fieldname="ptnr_previous_family_name_c";
					bgcolor="#ffffff";
				}


				ptnr_gender_c_label "widget/label" {
					x=330; y=40; width=100; height=15; style="lowered"; text="Gender:";align="right";
				}
				ptnr_gender_c_data "widget/dropdown" {
					x=430; y=40; width=160; height=20;
					hilight="#b5b5b5";
					bgcolor="#cfcfcf";
					fieldname='ptnr_gender_c';
					mode="static";
				
					gender_data_1 "widget/dropdownitem" { label="Male"; value="1"; }
					gender_data_2 "widget/dropdownitem" { label="Female"; value="2"; }
					gender_data_3 "widget/dropdownitem" { label="Unspecified"; value="0"; }
				}
				ptnr_marital_status_c_label "widget/label" {
					x=330; y=60; width=100; height=15; style="lowered"; text="Marital Status:";align="right";
				}
				ptnr_marital_status_c_data "widget/dropdown" {
					x=430; y=60; width=160; height=15;
					sql="SELECT :ptnr_description_c, :ptnr_marital_code_c FROM /kardia/kardia_DB/ptnr_marital_status/rows";
					numdisplay=4;
					fieldname="ptnr_marital_status_c";
					hilight="#b5b5b5";
					bgcolor="#cfcfcf";
					mode="dynamic_server";
				}
				ptnr_occupation_code_c_label "widget/label" {
					x=350; y=80; width=80; height=15; style="lowered"; text="Occupation:";align="right";
				}
				ptnr_occupation_code_c_data "widget/dropdown" {
					x=430; y=80; width=160; height=20;
					numdisplay=5;
					sql="SELECT :ptnr_occupation_description_c, :ptnr_occupation_code_c FROM /kardia/kardia_DB/ptnr_occupation/rows";
					fieldname="ptnr_occupation_code_c";
					hilight="#b5b5b5";
					bgcolor="#cfcfcf";
					mode="dynamic_server";
				}

				churchButton "widget/textbutton" {
					x=430; y=110; height=45; width=160;
					fgcolor1="#000000"; fgcolor2="#cfcfcf";
					text="Supporting Church(s)";
					tristate="no";
					cn11 "widget/connector" {
						event="Click"; target="ptnrChurchWindow"; action="SetVisibility"; NoInit="(1)";
					}
					cn12 "widget/connector" {
						event="Click"; target="osrcPartnerChurch"; action="DoubleSync";
						ParentOSRC="(osrc1)"; ParentKey1="'ptnr_pkey_i'"; ParentKey2="'ptnr_okey_i'";
							ParentSelfKey1="'ptnr_pkey_relation_i'"; ParentSelfKey2="'ptnr_okey_relation_i'";
						ChildOSRC="(osrcChurch)"; ChildKey1="'ptnr_pkey_i'"; ChildKey2="'ptnr_okey_i'";
							SelfChildKey1="'ptnr_pkey_partner_i'"; SelfChildKey2="'ptnr_okey_partner_i'";
					}
				}
				relationButton "widget/textbutton" {
					x=430; y=160; height=45; width=160;
					fgcolor1="#000000"; fgcolor2="#cfcfcf";
					text="Relationships";
					tristate="no";
					cn13 "widget/connector" {
						event="Click"; target="ptnrRelationshipWindow"; action="SetVisibility"; NoInit="(1)";
					}
					cn14 "widget/connector" {
						event="Click"; target="osrc2"; action="Sync";
						ParentOSRC="(osrc1)"; ParentKey1="'ptnr_pkey_i'"; ParentKey2="'ptnr_okey_i'";
											  ChildKey1="'ptnr_pkey_relation_i'"; ChildKey2="'ptnr_okey_relation_i'";
					}
				}

				pane1 "widget/pane" {
					x=10; y=270; height=126; width=586;
					style="lowered";
					bgcolor="#b8b8b8";

					tblPersonList "widget/table" {
						mode="dynamicrow";
						width=580;
						windowsize=5;
						height=120;
						x=2;y=2;
						cellhspacing=1;
						cellvspacing=1;
						rowheight=20;
						inner_border=1;
						inner_padding=0;
						bgcolor="#b8b8b8";
						row_bgcolor1="#acacac";
						row_bgcolor2="#acacac";
						row_bgcolorhighlight="#9a9a9a";
						hdr_bgcolor="#b8b8b8";
						textcolor="black";
						textcolorhighlight="black";
						titlecolor="#555555";
						ptnr_title_c "widget/table-column" { title="Title";width=50; }
						ptnr_first_name_c "widget/table-column" { title="First Name"; width=100; }
						ptnr_prefered_name_c "widget/table-column" { title="Preferred Name"; width=120; }
						ptnr_middle_name_c "widget/table-column" { title="Middle Name"; width=100; }
						ptnr_family_name_c "widget/table-column" { title="Family Name"; width=210; }
					}
				}
			}
		}
	}

	osrcPartnerChurch "widget/osrc" {
		replicasize=9;
		readahead=3;
		sql="SELECT :ptnr_pkey_relation_i,:ptnr_okey_relation_i,:ptnr_pkey_partner_i,:ptnr_okey_partner_i FROM /kardia/kardia_DB/ptnr_partner_relationship/rows";
		filter=":ptnr_relation_name_c = 'SUPPCHURCH'";
	}

	
	ptnrChurchWindow "widget/htmlwindow" {
		title="Church Management";
		titlebar=yes;
		style="dialog";
		background="/kardia/images/bg_church.png";
		hdr_bgcolor="#176820";
		textcolor="white";
		visible="false";
		x=270;y=25;width=460;height=380;
		osrcChurch "widget/osrc" {
			replicasize=9;
			readahead=3;
			sql = "SELECT :ptnr_pkey_i, :ptnr_okey_i, :ptnr_accomodation_type_c, :ptnr_church_name_c, :ptnr_approximate_size_i, :ptnr_denomination_code_c, :ptnr_accomodation_l, :ptnr_prayer_cel_l, :ptnr_map_on_file_l, :ptnr_accomodation_size_n, :smgr_date_created_d, :smgr_date_modified_d, :smgr_pkey_modified_by_i, :smgr_okey_modified_by_i, :smgr_pkey_created_by_i, :smgr_okey_created_by_i, :ptnr_pkey_contact_i, :ptnr_okey_contact_i FROM /kardia/kardia_DB/ptnr_church/rows";

			formChurch "widget/form" {
				_3bconfirmwindow = "_3bConfirmWindow";
				formstatus "widget/formstatus" {
					x=10; y=320;
				}
				cn2 "widget/connector" { event="View"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="Query"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="Modify"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="New"; target="btnSave1"; action="Disable"; }
				cn2 "widget/connector" { event="DataChange"; target="btnSave1"; action="Enable"; }

				cn2 "widget/connector" { event="View"; target="btnQuery1"; action="Enable"; }
				cn2 "widget/connector" { event="Query"; target="btnQuery1"; action="Enable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnQuery1"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnQuery1"; action="Enable"; }
				cn2 "widget/connector" { event="Modify"; target="btnQuery1"; action="Enable"; }
				cn2 "widget/connector" { event="New"; target="btnQuery1"; action="Enable"; }

				cn2 "widget/connector" { event="View"; target="btnQueryExec1"; action="Disable"; }
				cn2 "widget/connector" { event="Query"; target="btnQueryExec1"; action="Enable"; }
				cn2 "widget/connector" { event="QueryExec"; target="btnQueryExec1"; action="Disable"; }
				cn2 "widget/connector" { event="NoData"; target="btnQueryExec1"; action="Disable"; }
				cn2 "widget/connector" { event="Modify"; target="btnQueryExec1"; action="Disable"; }
				cn2 "widget/connector" { event="New"; target="btnQueryExec1"; action="Disable"; }

				btnFirst1 "widget/imagebutton" {
					x=55; y=320; width=20; height=20; 
					image = "/sys/images/ico16aa.gif";
					pointimage = "/sys/images/ico16ab.gif"; 
					clickimage = "/sys/images/ico16ac.gif";
					cn15 "widget/connector" { 
						event="Click"; target="formChurch"; action="First";
					}
				}
				btnPrev1 "widget/imagebutton" {
					x=75; y=320; width=20; height=20; 
					image = "/sys/images/ico16ba.gif";
					pointimage = "/sys/images/ico16bb.gif"; 
					clickimage = "/sys/images/ico16bc.gif";
					cn16 "widget/connector" { 
						event="Click"; target="formChurch"; action="Prev";
					}
				}
				btnNext1 "widget/imagebutton" {
					x=95; y=320; width=20; height=20; 
					image = "/sys/images/ico16ca.gif";
					pointimage = "/sys/images/ico16cb.gif"; 
					clickimage = "/sys/images/ico16cc.gif";
					cn17 "widget/connector" { 
						event="Click"; target="formChurch"; action="Next";
					}
				}
				btnLast1 "widget/imagebutton" {
					x=115; y=320; width=20; height=20; 
					image = "/sys/images/ico16da.gif";
					pointimage = "/sys/images/ico16db.gif"; 
					clickimage = "/sys/images/ico16dc.gif";
					tristate="no";
					cn18 "widget/connector" { 
						event="Click"; target="formChurch"; action="Last";
					}
				}

				btnSave1 "widget/imagebutton" {
					x=5; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/save-normal.gif";
					pointimage="/kardia/images/save-up.gif";
					clickimage="/kardia/images/save-down.gif";
					disabledimage="/kardia/images/save-disabled.gif";

					cn19 "widget/connector" {
						event="Click"; target="formChurch"; action="Save";
					}
				}
				btnQuery1 "widget/imagebutton" {
					x=32; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/query-normal.gif";
					pointimage="/kardia/images/query-up.gif";
					clickimage="/kardia/images/query-down.gif";
					disabledimage="/kardia/images/query-disabled.gif";

					cn20 "widget/connector" {
						event="Click"; target="formChurch"; action="Query";
					}
				}
				btnQueryExec1 "widget/imagebutton" {
					x=59; y=5; width=27; height=27;
					enabled = "false";
					image="/kardia/images/go-normal.gif";
					pointimage="/kardia/images/go-up.gif";
					clickimage="/kardia/images/go-down.gif";
					disabledimage="/kardia/images/go-disabled.gif";

					cn21 "widget/connector" {
						event="Click"; target="formChurch"; action="QueryExec";
					}
				}

				ptnr_pkey_i_label "widget/label" {
					x=10; y=40; width=170; height=15; style="lowered"; text="Partner Key:";align="right";
				}
				ptnr_pkey_i_data "widget/editbox" {
					x=180; y=40; width=60; height=15; style="lowered"; fieldname="ptnr_pkey_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_okey_i_label "widget/label" {
					x=10; y=60; width=170; height=15; style="lowered"; text="Office Key:";align="right";
				}
				ptnr_okey_i_data "widget/editbox" {
					x=180; y=60; width=60; height=15; style="lowered"; fieldname="ptnr_okey_i";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_accomodation_type_c_label "widget/label" {
					x=10; y=80; width=170; height=15; style="lowered"; text="Accomidation Type:";align="right";
				}
				ptnr_accomodation_type_c_data "widget/editbox" {
					x=180; y=80; width=60; height=15; style="lowered"; fieldname="ptnr_accomodation_type_c";
					readonly="yes";
					bgcolor="#ffffff";
				}
				ptnr_church_name_c_label "widget/label" {
					x=10; y=100; width=170; height=15; style="lowered"; text="Church Name:";align="right";
				}
				ptnr_church_name_c_data "widget/editbox" {
					x=180; y=100; width=230; height=15; style="lowered"; fieldname="ptnr_church_name_c";
					bgcolor="#ffffff";
				}
				ptnr_denomination_code_c_label "widget/label" {
					x=10; y=120; width=170; height=15; style="lowered"; text="Denomination Code:";align="right";
				}
				ptnr_denomination_code_c_data "widget/dropdown" {
					x=180; y=120; width=230; height=20; 
					sql="SELECT :ptnr_denomination_name_c, :ptnr_denomination_code_c FROM /kardia/kardia_DB/ptnr_denomination/rows";
					fieldname="ptnr_denomination_code_c";
					numdisplay=12;
					bgcolor="#cfcfcf";
					hilight="#b5b5b5";
					mode="dynamic_server";
				}
				ptnr_approximate_size_i_label "widget/label" {
					x=10; y=140; width=170; height=15; style="lowered"; text="Approximate Size:";align="right";
				}
				ptnr_approximate_size_i_data "widget/editbox" {
					x=180; y=140; width=60; height=15; style="lowered"; fieldname="ptnr_approximate_size_i";
					bgcolor="#ffffff";
				}

				personButton "widget/textbutton" {
					x=260; y=40; height=45; width=130;
					fgcolor1="#000000"; fgcolor2="#cfcfcf";
					text="List Supportees";
					tristate="no";
					cn29 "widget/connector" {
						event="Click"; target="ptnrQueryWindow"; action="SetVisibility"; NoInit="(1)";
					}
					cn22 "widget/connector" {
						event="Click"; target="osrcPartnerChurch"; action="DoubleSync";
						ParentOSRC="(osrcChurch)"; ParentKey1="'ptnr_pkey_i'"; ParentKey2="'ptnr_okey_i'";
							ParentSelfKey1="'ptnr_pkey_partner_i'"; ParentSelfKey2="'ptnr_okey_partner_i'";
						ChildOSRC="(osrc1)"; ChildKey1="'ptnr_pkey_i'"; ChildKey2="'ptnr_okey_i'";
							SelfChildKey1="'ptnr_pkey_relation_i'"; SelfChildKey2="'ptnr_okey_relation_i'";
					}
				}


				pane1 "widget/pane" {
					x=10; y=180; height=126; width=436;
					style="lowered";
					bgcolor="#b8b8b8";

					tblChurchList "widget/table" {
						mode="dynamicrow";
						width=430;
						windowsize=5;
						height=120;
						x=2;y=2;
						cellhspacing=1;
						cellvspacing=1;
						rowheight=20;
						inner_border=1;
						inner_padding=0;
						bgcolor="#b8b8b8";
						row_bgcolor1="#acacac";
						row_bgcolor2="#acacac";
						row_bgcolorhighlight="#9a9a9a";
						hdr_bgcolor="#b8b8b8";
						textcolor="black";
						textcolorhighlight="black";
						titlecolor="#555555";
						ptnr_church_name_c "widget/table-column" { title="Church Name";width=250; }
						ptnr_approximate_size_i "widget/table-column" { title="Size"; width=50; }
						ptnr_denomination_code_c "widget/table-column" { title="Denomination"; width=130; }
					}
				}
			}
		}
	}

	ptnrRelationshipWindow "widget/htmlwindow" {
		title="Partner Relationship Lookup";
		titlebar=yes;
		style="dialog";
		bgcolor="#c0c0c0";
		hdr_bgcolor="#944833";
		textcolor="white";
		visible="false";
		x=270;y=420;width=460;height=180;
		ptnr_okey_contact_i_label "widget/label" {
			x=10; y=10; width=170; height=15; 
			text="Relationships:";
			align="left";
		}
		osrc2 "widget/osrc" {
			replicasize=9;
			readahead=3;
			sql="SELECT :ppr:ptnr_pkey_partner_i,:ppr:ptnr_okey_partner_i,:ppr:ptnr_relation_name_c,:pp:ptnr_first_name_c,:pp:ptnr_family_name_c FROM /kardia/kardia_DB/ptnr_partner_relationship/rows ppr, /kardia/kardia_DB/ptnr_person/rows pp";
			filter=":pp:ptnr_pkey_i = :ppr:ptnr_pkey_partner_i AND :pp:ptnr_okey_i = :ppr:ptnr_okey_partner_i";

			pane1 "widget/pane" {
				x=10; y=40; height=106; width=436;
				style="lowered";
				bgcolor="#b8b8b8";

				tblRelationList "widget/table" {
					mode="dynamicrow";
					width=430;
					height=100;
					windowsize=3;
					x=2;y=2;
					cellhspacing=1;
					cellvspacing=1;
					rowheight=20;
					inner_border=1;
					inner_padding=0;
					bgcolor="#b8b8b8";
					row_bgcolor1="#acacac";
					row_bgcolor2="#acacac";
					row_bgcolorhighlight="#9a9a9a";
					hdr_bgcolor="#b8b8b8";
					textcolor="black";
					textcolorhighlight="black";
					titlecolor="#555555";
					ptnr_first_name_c "widget/table-column" { title="First Name";width=150; }
					ptnr_family_name_c "widget/table-column" { title="Last Name";width=150; }
					ptnr_relation_name_c "widget/table-column" { title="Relationship"; width=150; }
					cn23 "widget/connector" {
						event="Click"; target="osrc1"; action="Sync";
						ParentOSRC="(osrc2)"; 
						ParentKey1="'ptnr_pkey_partner_i'"; ParentKey2="'ptnr_okey_partner_i'";
						ChildKey1="'ptnr_pkey_i'"; ChildKey2="'ptnr_okey_i'";
					}
					cn24 "widget/connector" {
						event="Click"; target="ptnrRelationshipWindow"; action="SetVisibility"; NoInit="(1)";
						IsVisible="(0)";
					}
				}
			}
		}
	}
	debugWindow "widget/htmlwindow" {
		hdr_bgcolor="#cc0000";
		x=50;y=50;width=800;height=500;
		floating=yes; 
		titlebar=yes; 
		title="Debugging window"; 
		visible=false;
		style="dialog";
		Treeview_pane "widget/pane" {
			x=0; y=0; width=800; height=480;
			bgcolor="#e0e0e0";
			Tree_scroll "widget/scrollpane" {
				x=1; y=1; width=794; height=470;
				Tree "widget/treeview" {
					x=0; y=1; width=20000;
					source = "javascript:";
				}
			}
		}
	}
}
