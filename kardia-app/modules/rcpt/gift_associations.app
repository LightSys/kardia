$Version=2$
gift_associations "widget/page"
    {
    title = "Gift Associations";
    width=1000;
    height=700;
    widget_template="/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background=null;
    bgcolor=white;
    require_one_endorsement="kardia:gift_entry";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests=9;
    
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
//     period "widget/parameter" { type=string; default=null; }
    
    cache_services_list "widget/osrc"
	{
	
	// Note: This query spams the console with errors. This is not
	// incorrect behavior, it's just how the MySQL driver & object
	// system respond to this query. The replicasize value has been
	// reduced to minimize this possible bottleneck.
	sql=runserver('--\'sql=" -- Fixes syntax highlighting.
	    DECLARE collection gift_services scope application;
	    
	    INSERT INTO
		collection gift_services
	    SELECT
		label = "All",--"sql="
		value = "any",--"sql="
		selected = 1
	    ;
	    
	    INSERT INTO
		collection gift_services
	    SELECT
		label = substring(:a_config_name, 12),
		value = substring(:a_config_name, 12),
		selected = 0
	    FROM
		/apps/kardia/data/Kardia_DB/a_config/rows
	    WHERE
		-- substring(:a_config_name, 0, 11) = "GiftImport_" AND --"sql="
		:a_config_value = "1" --"sql="
	');// End of janky syntax hacks:'");
	autoquery=onfirstreveal;
	}
    
    content_pane "widget/pane"
	{
	x=10; y=10; width=980; height=680;
	background="/apps/kardia/images/bg/light_bgnd.jpg";
	border_radius=6;
	shadow_radius=4;
	shadow_offset=2;
	shadow_color="#808080";
	shadow_angle=135;
	
	filter_layout "widget/hbox"
	    {
	    x=0; y=8; width=980; height=35;
	    spacing=5;
	    
	    // Search box.
	    filter_search_spacer "widget/autolayoutspacer" { width=10; }
	    filter_search_label "widget/label"
		{
		y=10;
		width=40;
		align=right;
		text="Search:";
		}
	    filter_search_box "widget/editbox"
		{
		y=5; width=200; height=25;
		
		run_search "widget/connector"
		    {
		    event=ReturnPressed;
		    target=content_osrc;
		    action=QueryText;
		    
		    cx__case_insensitive=1;
		    objname=runclient("eg");
		    field_list=""
			+ "*i_eg_donor_name*,"
			+ "*i_eg_desig_name*,"
			+ "*i_eg_desig_notes*,"
			+ "p_donor_partner_key,"
			+ "*i_eg_donor_email*,"
			+ "i_eg_donor_city*,"
			+ "i_eg_donor_state";
		    query=runclient(:filter_search_box:content);
		    }
		
		run_search2 "widget/connector"
		    {
		    // Should be the same as run_search, just with a different event.
		    event=LoseFocus;
		    target=content_osrc;
		    action=QueryText;
		    
		    cx__case_insensitive=1;
		    objname=runclient("eg");
		    field_list=""
			+ "*i_eg_donor_name*,"
			+ "*i_eg_desig_name*,"
			+ "*i_eg_desig_notes*,"
			+ "p_donor_partner_key,"
			+ "*i_eg_donor_email*,"
			+ "i_eg_donor_city*,"
			+ "i_eg_donor_state";
		    query=runclient(:filter_search_box:content);
		    }
		
		clear_search_query "widget/connector"
		    {
		    event=EscapePressed;
		    target=content_osrc;
		    action=QueryText;
		    
		    objname=runclient("eg");
		    field_list=runclient("");
		    query=runclient("");
		    }
		
		clear_search "widget/connector"
		    {
		    event=EscapePressed;
		    target=filter_search_box;
		    action=SetValue;
		    Value=runclient("");
		    }
		}
	
	    // Service filter dropdown.
	    filter_service_spacer "widget/autolayoutspacer" { width=10; }	
	    filter_service_label "widget/label"
		{
		y=10;
		width=40;
		align=right;
		text="Service:";
		}
	    filter_service_dropdown "widget/dropdown"
		{
		y=4; width=125; height=25;
		
		// Styling.
		bgcolor=white;
		hilight="#d0d0d0";
		
		// Get payment service types.
		mode="dynamic_server";
		sql="
		    DECLARE collection gift_services;
		    
		    INSERT INTO
			collection gift_services
		    SELECT
			label = 'All',
			value = 'any',
			selected = 1
		    ;
		    
		    INSERT INTO
			collection gift_services
		    SELECT
			label = substring(:a_config_name, 12),
			value = substring(:a_config_name, 12),
			selected = 0
		    FROM
			/apps/kardia/data/Kardia_DB/a_config/rows
		    WHERE
			-- substring(:a_config_name, 0, 11) = 'GiftImport_' AND
			:a_config_value = '1'
		    GROUP BY
			:a_config_name
		    ;
		    
		    SELECT * FROM collection gift_services;
		";
		filter_service_hints "widget/hints" { style=notnull; }
		
		filter_service_updater "widget/connector"
		    {
		    event=DataChange;
		    target=content_osrc;
		    action=QueryParam;
		    }
		}
	    }
	
	content_osrc "widget/osrc"
	    {
	    filter_service_param "widget/parameter"
		{
		param_name=service;
		type=string;
		default=runclient(:filter_service_dropdown:value);
		}
	    
	    // Note: This query spams the console with errors. This is not
	    // incorrect behavior, it's just how the MySQL driver & object
	    // system respond to this query. The replicasize value has been
	    // reduced to minimize performance issues.
	    sql=runserver('--\'sql=" -- Fixes syntax highlighting.
		SELECT
		    -- Table display fields.
		    donor_service_name = :eg:i_eg_donor_name
			+ isnull(" (" + :eg:i_eg_donor_address + ")", ""), --sql="
		    donor_service_designation = :eg:i_eg_desig_name,
		    donor_kardia_name = :eg:p_donor_partner_key,
		    donor_kardia_designation = condition(
			:eg:i_eg_gift_amount = :eg:i_eg_deposit_gross_amt,
			:eg:a_fund,
			"multiple"
		    ), --sql="
		    amount = :eg:i_eg_gift_amount,
		    status = :eg:i_eg_status,
		    gift_date = :eg:i_eg_gift_date,
		    
		    -- Editable fields.
		    :eg:i_eg_gift_uuid,         -- Gift ID
		    :eg:i_eg_service,           -- Service
		    :eg:i_eg_gift_date,         -- Gift Date
		    :eg:i_eg_donor_name,        -- Donor Name
		    :eg:i_eg_donor_address,     -- Donor Addr
		    :eg:i_eg_desig_uuid,        -- Desig ID
		    :eg:i_eg_desig_name,        -- Desig Name
		    :eg:i_eg_desig_notes,       -- Desig Notes
		    :eg:i_eg_net_amount,        -- Gross Amount
		    :eg:i_eg_deposit_gross_amt, -- Net Amount
		    :eg:p_donor_partner_key,    -- Kardia Donor
		    :eg:a_fund,                 -- Desig.
		    :eg:a_account_code          -- GL Account
		FROM
		    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows eg,
		    /apps/kardia/data/Kardia_DB/p_partner/rows p
		WHERE
		    :eg:p_donor_partner_key = :p:p_partner_key AND
		    :eg:a_ledger_number = ' + quote(:this:ledger) + ' AND
		    (:parameters:service = any or :parameters:service = :eg:i_eg_service)
		GROUP BY
		    :eg:i_eg_gift_uuid,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_service
		ORDER BY
		    :eg:i_eg_gift_date
	    ');// End of janky syntax hacks:'");
	    replicasize=200;
	    readahead=400;
	    autoquery=onfirstreveal;
	    }
	
	table "widget/table"
	    {
	    x=10; y=50; width=960; height=590;
	    objectsource=content_osrc;
	    nodata_message="No gifts to display";
	    
	    // Layout
	    rowheight=null;
	    cellvspacing=4;
	    inner_padding=4;
	    colsep=0;
	    
	    // Behavior
	    overlap_scrollbar=yes;
	    demand_scrollbar=yes;
	    initial_selection = noexpand;
	    allow_deselection = yes;
	    
	    // Rows
	    row_border_radius=6;
	    row_shadow_radius=2;
	    row_shadow_offset=1;
	    row_shadow_color="#a0a0a0";
	    row_shadow_angle=135;
	    
	    // Columns
	    column_service_designation "widget/table-column"
		{
		width=50;
		fieldname=donor_service_name;
		caption_fieldname=donor_service_designation;
		title="Giving Service Donor/Designation";
		}
	    column_kardia_designation "widget/table-column"
		{
		width=50;
		fieldname=donor_kardia_name;
		caption_fieldname=donor_kardia_designation;
		title="Kardia Donor/Designation";
		}
	    column_amount "widget/table-column"
		{
		width=10;
		align=right;
		fieldname=amount;
		title="Amount";
		}
	    column_type "widget/table-column"
		{
		width=20;
		fieldname=status;
		caption_fieldname=gift_date;
		align=center;
		caption_align=center;
		title="Association Type/Date";
		}
	    
	    // Row Detail
	    table_detail "widget/table-row-detail"
		{
		height=160;
		width=960;
		
		edit_form "widget/form"
		    {
		    // TODO: Set up permissions.
		    objectsource=content_osrc;
		    
		    edit_pane "widget/pane"
			{
			x=15; y=15; width=930; height=140;
			bgcolor="#e0e0e0";
			style="lowered";
			
			divider "widget/pane"
			    {
			    x=10; y=95; width=760; height=2; style=border;
			    }
			
			cols "widget/hbox"
			    {
			    x=10; y=10; width=910; height=140; spacing=15;
			    
			    col1 "widget/vbox"
				{
				y=0; width=150; height=140; spacing=10; // x=cols
				
				service_title_label "widget/label"
				    {
				    x=2; width=150; height=20; // y=col1
				    font_size=12; style=bold;
				    text="Giving Service Info";
				    }
				
				gift_id_field "widget/component"
				    {
				    x=0; width=150; height=15; label_width=60; // y=col1
				    path="/sys/cmp/smart_field.cmp";
				    text="Gift ID:";
				    ctl_type=label;
				    type=readonly;
				    field="i_eg_gift_uuid";
				    }
				
				gift_date_field "widget/component"
				    {
				    x=0; width=150; height=15; label_width=60; // y=col1
				    path="/sys/cmp/smart_field.cmp";
				    text="Gift Date:";
				    ctl_type=label;
				    type=readonly;
				    field="i_eg_gift_date";
				    }
				
				divider_spacer1 "widget/autolayoutspacer" { height=10; }
				
				kardia_title_label "widget/label"
				    {
				    x=2; width=150; height=20; // y=col1
				    font_size=12; style=bold;
				    text="Kardia Info";
				    }
				}
			    
			    col2 "widget/vbox"
				{
				y=5; width=200; height=140; spacing=10; // x=cols
				
				service_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col1
				    path="/sys/cmp/smart_field.cmp";
				    text="Service:";
				    
				    // Dropdown data.
				    ctl_type=dropdown;
				    field="i_eg_service";
				    sql="
					SELECT
					    label = substring(:a_config_name, 12),
					    value = substring(:a_config_name, 12),
					    selected = 0
					FROM
					    /apps/kardia/data/Kardia_DB/a_config/rows
					WHERE
					    -- TODO: Uncomment after Noah fixes substring().
					    -- substring(:a_config_name, 0, 11) = 'GiftImport_' AND
					    :a_config_value = '1'
					GROUP BY
					    :a_config_name
					;
				    ";
				    service_hints "widget/hints" { style=applyonchange,notnull; }
				    }
				
				donor_name_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col2
				    path="/sys/cmp/smart_field.cmp";
				    text="Donor Name:";
				    ctl_type=editbox;
				    field="i_eg_donor_name";
				    }
				
				donor_address_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col2
				    path="/sys/cmp/smart_field.cmp";
				    text="Donor Address:";
				    ctl_type=editbox;
				    field="i_eg_donor_address";
				    }
				
				divider_spacer2 "widget/autolayoutspacer" { height=5; }
				
				kardia_donor_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col2
				    path="/apps/kardia/modules/base/editbox_table.cmp";
				    field="i_eg_gift_uuid";
				    text="Donor:";
				    
				    // Popup
				    popup_text="Select a Donor:";
				    popup_width=335;
				    popup_sql="
					SELECT
					    value = :p:p_partner_key,
					    label = condition(
						char_length(rtrim(:p:p_org_name)) > 0,
						:p:p_org_name,
						:p:p_given_name + ' ' + :p:p_surname
					    )
					    + isnull(
						' ['
						    + :pl:p_city + ', '
						    + :pl:p_state_province + ' '
						    + :pl:p_postal_code
						+ '] #'
						+ :p:p_partner_key,
					    '')
					FROM
					    /apps/kardia/data/Kardia_DB/p_partner/rows p,
					    /apps/kardia/data/Kardia_DB/p_location/rows pl
					WHERE
					    :p:p_partner_key *= :pl:p_partner_key
					GROUP BY
					    :p:p_partner_key
					;
				    ";
				    search_field_list=""
					+ "p_partner_key,"
					+ "*p_given_name*,"
					+ "*p_surname*,"
					+ "*p_org_name*,"
					+ "p_legacy_key_1,"
					+ "*p_legacy_key_2*";
				    key_name="p_partner_key";
				    
				    kardia_donor_hints "widget/hints" { style=notnull,applyonchange; }
				    }
				}
			    
			    col3 "widget/vbox"
				{
				y=5; width=200; height=140; spacing=10; // x=cols
				
				desig_id_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col3
				    path="/sys/cmp/smart_field.cmp";
				    text="Desig. ID:";
				    ctl_type=editbox;
				    field="i_eg_desig_uuid";
				    }
				
				desig_name_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col3
				    path="/sys/cmp/smart_field.cmp";
				    text="Desig. Name:";
				    ctl_type=editbox;
				    field="i_eg_desig_name";
				    }
				
				desig_notes_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col3
				    path="/sys/cmp/smart_field.cmp";
				    text="Desig. Notes:";
				    ctl_type=editbox;
				    field="i_eg_desig_notes";
				    }
				
				divider_spacer3 "widget/autolayoutspacer" { height=5; }
				
				kardia_designation_field "widget/component"
				    {
				    x=0; width=200; height=15; label_width=100; // y=col3
				    path="/apps/kardia/modules/base/editbox_table.cmp";
				    field="p_donor_partner_key";
				    text="Desig.:";
				    
				    // Popup
				    popup_text="Select a Designation:";
				    popup_width=335;
				    popup_sql="
					SELECT
					    value = :i_eg_desig_uuid,
					    label = :i_eg_desig_name
					FROM
					    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
					GROUP BY
					    :i_eg_desig_uuid
					;
				    ";
				    search_field_list=""
					+ "i_eg_desig_uuid,"
					+ "*i_eg_desig_name*,"
					+ "*i_eg_desig_notes*";
				    key_name="p_donor_partner_key";
				    
				    kardia_designation_hints "widget/hints" { style=notnull,applyonchange; }
				    }
				}
			    
			    col4 "widget/vbox"
				{
				y=5; width=170; height=140; spacing=10; // x=cols
				
				gross_amount_field "widget/component"
				    {
				    x=0; width=170; height=15; label_width=100; // y=col4
				    path="/sys/cmp/smart_field.cmp";
				    text="Gross Amount:";
				    ctl_type=editbox;
				    field="i_eg_net_amount";
				    }
				
				net_amount_field "widget/component"
				    {
				    x=0; width=170; height=15; label_width=100; // y=col4
				    path="/sys/cmp/smart_field.cmp";
				    text="Net Amount:";
				    ctl_type=editbox;
				    field="i_eg_deposit_gross_amt";
				    }
				
				desig_notes_spacer "widget/autolayoutspacer" { height=15; }
				
				divider_spacer4 "widget/autolayoutspacer" { height=5; }
				
				kardia_gl_account_field "widget/component"
				    {
				    x=0; width=170; height=15; label_width=100; // y=col4
				    path="/apps/kardia/modules/base/editbox_table.cmp";
				    field="a_account_code";
				    text="GL Account:";
				    
				    // Popup
				    popup_text="Select a Designation:";
				    popup_width=335;
				    popup_sql="
					SELECT
					    value = :a_account_code,
					    label = :a_account_code
					FROM
					    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
					GROUP BY
					    :a_account_code
					;
				    ";
				    search_field_list="*a_account_code*";
				    key_name="a_account_code";
				    
				    kardia_gl_account_hints "widget/hints" { style=notnull,applyonchange; }
				    }
				}
				
			    button_spacer "widget/autolayoutspacer" { width=0; }
			    
			    col5 "widget/vbox"
				{
				y=4; width=110; height=140; spacing=7; // x=cols
				
				save_cancel_buttons "widget/hbox"
				    {
				    x=0; width=110; height=23; spacing=10; // y=col5
				    
				    save_button "widget/textbutton"
					{
					x=0; y=0; width=50; height=23; // x=save_cancel_buttons
					border_radius=5;
					text="Save";
					
					save_button_connector "widget/connector"
					    {
					    event=Click;
					    target=edit_form;
					    action=Save;
					    FromKeyboard=1;
					    FromOSRC=0;
					    }
					}
				    
				    cancel_button "widget/textbutton"
					{
					y=0; width=50; height=23; // x=save_cancel_buttons
					border_radius=5;
					text="Cancel";
					
					cancel_button_connector "widget/connector"
					    {
					    event=Click;
					    target=edit_form;
					    action=Discard;
					    FromKeyboard=1;
					    FromOSRC=0;
					    }
					}
				    }
				
				copy_delete_buttons "widget/hbox"
				    {
				    x=0; width=110; height=23; spacing=10; // y=col5
				    
				    copy_button "widget/textbutton"
					{
					y=0; width=50; height=23; // x=copy_delete_buttons
					border_radius=5;
					text="Copy";
					
					// TODO: Figure out how to copy the current element into a new element.
					// copy_connector "widget/connector"
					//     {
					//     event=Click;
					//     target=edit_form;
					//     action=?;
					//     }
					}
				    
				    delete_button "widget/textbutton"
					{
					y=0; width=50; height=23; // x=copy_delete_buttons
					border_radius=5;
					text="Delete";
					
					// TODO: Add security.
					delete_button_connector "widget/connector"
					    {
					    event=Click;
					    target=edit_form;
					    action=Delete;
					    }
					}
				    }
				
				line_item_button "widget/textbutton"
				    {
				    x=0; width=110; height=23; // y=col5
				    border_radius=5;
				    text="Line Item Details";
				    }
				
				history_button "widget/textbutton"
				    {
				    x=0; width=110; height=23; // y=col5
				    border_radius=5;
				    text="Association History";
				    }
				}
			    }
			}
		    }
		}
	    }
	
	blank_association_button "widget/textbutton"
	    {
	    x=10; y=655; width=125; height=20;
	    border_radius=5;
	    text="Create Blank Association";
	    
	    blank_association_button_connector "widget/connector"
		{
		event=Click;
		target=edit_form;
		action=Create;
		ledger=runclient(runserver(:this:ledger)+"");
		
		// ???
		a_ledger_number=runclient("");
		i_eg_gift_uuid=runclient("");
		i_eg_line_item=runclient("");
		i_eg_desig_uuid=runclient("");
		
		// Empty fields
		i_eg_desig_notes=runclient("");
		i_eg_donor_uuid=runclient("");
		i_eg_deposit_amt=runclient(0);
		i_eg_deposit_gross_amt=runclient(0);
		i_eg_service=runclient("");
		a_fund=runclient("");
		}
	    }
	}
    }
