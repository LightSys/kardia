$Version=2$
gift_associations "widget/page"
    {
    title = "Gift Associations";
    width = 1000;
    height = 700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background = null;
    bgcolor = white;
    require_one_endorsement = "kardia:gift_entry";
    endorsement_context = runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 9;
    
    // Note: This app assumes that connectors are activated in the order they are defined.
    
    ledger "widget/parameter"
	{
	type = string;
	default = null;
	allowchars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	deploy_to_client = yes;
	}
    
    content_pane "widget/pane"
	{
	x = 10; y = 10; width = 980; height = 680;
	background = "/apps/kardia/images/bg/light_bgnd.jpg";
	border_radius = 6;
	shadow_radius = 4;
	shadow_offset = 2;
	shadow_color = "#808080";
	shadow_angle = 135;
	
	filter_layout "widget/hbox"
	    {
	    x = 0; y = 8; width = 980; height = 35;
	    spacing = 5;
	    
	    // Search box.
	    filter_search_spacer "widget/autolayoutspacer" { width = 10; }
	    filter_search_label "widget/label"
		{
		y = 10;
		width = 40;
		align = right;
		text = "Search:";
		}
	    filter_search_box "widget/editbox"
		{
		y = 5; width = 200; height = 25;
		
		trigger_manual_search "widget/connector"
		    {
		    event = ReturnPressed;
		    target = search_trigger;
		    action = SetValue;
		    Value = runclient(1);
		    }
		
		trigger_auto_search "widget/connector"
		    {
		    event = LoseFocus;
		    target = search_trigger;
		    action = SetValue;
		    Value = runclient(1);
		    }
		
		clear_search_results "widget/connector"
		    {
		    event = EscapePressed;
		    target = content_osrc;
		    action = QueryText;
		    
		    objname = runclient("eg");
		    field_list = runclient("");
		    query = runclient("");
		    }
		
		clear_search_box "widget/connector"
		    {
		    event = EscapePressed;
		    target = filter_search_box;
		    action = SetValue;
		    Value = runclient("");
		    }
		}
	    
	    // Service filter dropdown.
	    filter_service_spacer "widget/autolayoutspacer" { width = 10; }	
	    filter_service_label "widget/label"
		{
		y = 10;
		width = 40;
		align = right;
		text = "Service:";
		}
	    filter_service_dropdown "widget/dropdown"
		{
		y = 4; width = 125; height = 25;
		
		// Styling.
		bgcolor = white;
		hilight = "#d0d0d0";
		
		// Get payment service types.
		mode = "dynamic_server";
		sql = "
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
		        -- TODO: Uncomment once Noah fixes substring().
			-- substring(:a_config_name, 0, 11) = 'GiftImport_' AND
			:a_config_value = '1'
		    GROUP BY
			:a_config_name
		    ;
		    
		    SELECT * FROM collection gift_services;
		";
		filter_service_hints "widget/hints" { style = notnull; }
		
		trigger_filtered_search "widget/connector"
		    {
		    event = DataChange;
		    target = search_trigger;
		    action = SetValue;
		    Value = runclient(1);
		    }
		}
	    }
	
	content_osrc "widget/osrc"
	    {
	    filter_service_param "widget/parameter"
		{
		param_name = service;
		type = string;
		default = runclient(:filter_service_dropdown:value);
		}
	    
	    // Allows multiple connectors to easily re-run the search.
	    search_trigger "widget/variable" { type = Integer; value=runclient(0); }
	    
	    run_search "widget/connector"
		{
		source = search_trigger;
		event = DataModify;
		target = content_osrc;
		action = QueryText;
		event_condition = runclient(:search_trigger:value = 1);
		
		cx__case_insensitive = 1;
		objname = runclient("eg");
		field_list = ""
		    + "*i_eg_donor_name*,"
		    + "*i_eg_desig_name*,"
		    + "*i_eg_desig_notes*,"
		    + "p_donor_partner_key,"
		    + "*i_eg_donor_email*,"
		    + "i_eg_donor_city*,"
		    + "i_eg_donor_state";
		query = runclient(:filter_search_box:content);
		}
	    
	    reset_variable "widget/connector"
		{
		event = EndQuery;
		target = search_trigger;
		action = SetValue;
		Value = runclient(0);
		}
	    
	    // Note: This query spams the console with errors. This is not
	    // incorrect behavior, it's just how the MySQL driver & object
	    // system respond to this query. The replicasize value has been
	    // reduced to minimize performance issues.
	    sql = runserver('--\'sql=" -- Fixes syntax highlighting.
		SELECT
		    -- Primary key fields.
		    :eg:a_ledger_number,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_desig_uuid,
		    :eg:i_eg_line_item,
		    
		    -- Table display fields.
		    donor_service_name = :eg:i_eg_donor_name
			+ isnull(" (" + :eg:i_eg_donor_address + ")", ""), --sql="
		    donor_service_designation = :eg:i_eg_desig_name,
		    donor_kardia_name = rtrim(""
			+ isnull(:p:p_given_name + " ", "")
			+ isnull(:p:p_surname    + " ", "")
			+ isnull(:p:p_org_name   + " ", "")
			+ "("
			+ isnull(:eg:p_donor_partner_key, "null")
			+ ")"),
		    donor_kardia_designation = condition(
			:eg:i_eg_gift_amount = :eg:i_eg_deposit_gross_amt,
			:eg:a_fund,
			"multiple"
		    ), --sql="
		    amount = :eg:i_eg_gift_amount,
		    status = upper(ltrim(rtrim(:eg:i_eg_status))),
		    gift_id = condition(
			char_length(:eg:i_eg_gift_uuid) > 12,
			substring(:eg:i_eg_gift_uuid, 0, 12) + "...", --"sql="
			:eg:i_eg_gift_uuid
		    ),
		    gift_date = :eg:i_eg_gift_date,
		    
		    -- Editable fields.
		    :eg:i_eg_gift_uuid,         -- Gift uuid
		    :eg:i_eg_service,           -- Service
		    :eg:i_eg_processor,         -- Service (human readable)
		    :eg:i_eg_donor_uuid,        -- Donor UUID
		    :eg:i_eg_donor_name,        -- Donor Name
		    :eg:i_eg_donor_address,     -- Donor Addr
		    :eg:i_eg_desig_name,        -- Desig Name
		    :eg:i_eg_desig_notes,       -- Desig Notes
		    :eg:i_eg_gift_interval,     -- Gift interval
		    :eg:i_eg_gift_amount,       -- Gift Amount
		    :eg:i_eg_deposit_amt,       -- Deposit Amount
		    :eg:i_eg_net_amount,        -- Net Amount
		    :eg:i_eg_deposit_gross_amt, -- Gross Amount
		    :eg:p_donor_partner_key,    -- Kardia Donor
		    :eg:a_fund,                 -- Desig.
		    :eg:a_account_code          -- GL Account
		FROM
		    identity /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows eg,
		    /apps/kardia/data/Kardia_DB/p_partner/rows p
		WHERE
		    :eg:p_donor_partner_key *= :p:p_partner_key AND
		    :eg:a_ledger_number = ' + quote(:this:ledger) + ' AND
		    (:parameters:service = any or :parameters:service = :eg:i_eg_service)
		GROUP BY
		    :eg:i_eg_gift_uuid,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_service
		ORDER BY
		    :eg:i_eg_gift_date desc
	    ');// End of janky syntax hacks:'");
	    replicasize = 200;
	    readahead = 400;
	    autoquery = onfirstreveal;
	    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	    }
	
	table "widget/table"
	    {
	    x = 10; y = 50; width = 960; height = 590;
	    objectsource = content_osrc;
	    nodata_message = "No gifts to display";
	    
	    // Layout
	    rowheight = null;
	    cellvspacing = 4;
	    inner_padding = 4;
	    colsep = 0;
	    
	    // Behavior
	    overlap_scrollbar = yes;
	    demand_scrollbar  = yes;
	    initial_selection = noexpand;
	    allow_deselection = yes;
	    
	    // Rows
	    row_border_radius = 6;
	    row_shadow_radius = 2;
	    row_shadow_offset = 1;
	    row_shadow_color = "#a0a0a0";
	    row_shadow_angle = 135;
	    
	    // Columns
	    column_service_designation "widget/table-column"
		{
		width = 50;
		fieldname = donor_service_name;
		caption_fieldname = donor_service_designation;
		title = "Giving Service Donor/Designation";
		}
	    column_kardia_designation "widget/table-column"
		{
		width = 50;
		fieldname = donor_kardia_name;
		caption_fieldname = donor_kardia_designation;
		title = "Kardia Donor/Designation";
		}
	    column_amount "widget/table-column"
		{
		width = 10;
		align = right;
		fieldname = amount;
		title = "Amount";
		}
	    column_type "widget/table-column"
		{
		width = 15;
		fieldname = status;
		caption_fieldname = gift_date;
		align = center;
		caption_align = center;
		title = "Type/Date";
		}
	    
	    // Row Detail
	    table_detail "widget/table-row-detail"
		{
		height = 160;
		width = 960;
		show_on_new = 1;
		
		edit_form "widget/form"
		    {
		    objectsource = content_osrc;
		    
		    // Permissions & UX.
		    allow_view = yes;
		    allow_new = yes;
		    allow_modify = yes;
		    allow_delete = yes;
		    allow_nodata = yes; // Used when no record is selected.
		    allow_query = no;   // Not used here, disable it.
		    confirm_delete = yes;
		    confirm_discard = no;
		    enter_mode = save;
		    tab_revealed_only = yes;
		    
		    // Hidden fields.
		    ledger_number "widget/variable" { fieldname = "a_ledger_number"; ledger_val "widget/hints" { default = runclient(:ledger:value); } }
		    gift_uuid "widget/variable" { fieldname = "i_eg_gift_uuid"; gift_uuid_val "widget/hints" { default = runclient("FAKE_" + convert("string", eval("Math.floor(Math.random() * 1e15) + 1"))); } }
		    gift_date "widget/variable" { fieldname = "i_eg_gift_date"; gift_date_val "widget/hints" { default = runclient(:content_osrc:i_eg_gift_date); } }
		    trx_uuid "widget/variable" { fieldname = "i_eg_trx_uuid"; trx_uuid_val "widget/hints" { default = runclient("FAKE_" + convert("string", eval("Math.floor(Math.random() * 1e15) + 1"))); } }
		    line_item "widget/variable" { fieldname = "i_eg_line_item"; line_item_val "widget/hints" { default = runclient(1); } }
		    donor_uuid "widget/variable" { fieldname = "i_eg_donor_uuid"; donor_uuid_val "widget/hints" { default = runclient("FAKE_" + convert("string", eval("Math.floor(Math.random() * 1e15) + 1"))); } }
		    status "widget/variable" { fieldname = "i_eg_status"; status_val "widget/hints" { default = runclient("override"); } }
		    service "widget/variable" { fieldname = "i_eg_service"; service_val "widget/hints" { default = runclient("N/A"); } }
		    processor "widget/variable" { fieldname = "i_eg_processor"; processor_val "widget/hints" { default = runclient("N/A"); } }
		    gift_amount "widget/variable" { fieldname = "i_eg_gift_amount"; gift_amount_val "widget/hints" { default = runclient(0); } }
		    deposit_amt "widget/variable" { fieldname = "i_eg_deposit_amt"; deposit_amt_val "widget/hints" { default = runclient(0); } }
		    gift_interval "widget/variable" { fieldname = "i_eg_gift_interval"; gift_interval_val "widget/hints" { default = runclient("never"); } }
		    hidden_field_handler "widget/component" { path = "/apps/kardia/modules/base/record_metadata_hidden.cmp"; }
		    
		    edit_pane "widget/pane"
			{
			x = 15; y = 15; width = 930; height = 140;
			bgcolor = "#e0e0e0";
			style = "lowered";
			
			divider "widget/pane"
			    {
			    x = 10; y = 95; width = 740; height = 2; style = border;
			    }
			
			static_col "widget/vbox"
			    {
			    x = 10; y = 10; width = 150; height = 140; spacing = 10;
			    
			    service_title_label "widget/label"
				{
				x = 5; width = 180; height = 20; // y = static_col
				font_size = 12; style = bold;
				text = "Giving Service Info";
				}
			    
			    gift_id_field "widget/component"
				{
				x = 0; width = 180; height = 15; label_width = 60; // y = static_col
				path = "/sys/cmp/smart_field.cmp";
				text = "Gift ID:";
				ctl_type = label;
				type = readonly;
				field = "gift_id";
				
				gift_id_hints "widget/hints"
				    {
				    // TODO: Replace "Namespace error" placeholder with the value below
				    // after the namespace bug is fixed.
				    default = "Namespace error"; //runclient(condition(
				// 	char_length(:gift_uuid:value) > 12,
				// 	substring(:gift_uuid:value, 0, 12) + "...",
				// 	:gift_uuid:value
				//     ));
				    }
				}
			    
			    gift_date_field "widget/component"
				{
				x = 0; width = 180; height = 15; label_width = 60; // y = static_col
				path = "/sys/cmp/smart_field.cmp";
				text = "Gift Date:";
				ctl_type = label;
				type = readonly;
				field = "gift_date";
				
				gift_date_hints "widget/hints"
				    {
				    default = runclient(getdate());
				    }
				}
			    
			    divider_spacer1 "widget/autolayoutspacer" { height = 10; }
			    
			    kardia_title_label "widget/label"
				{
				x = 5; width = 180; height = 20; // y = static_col
				font_size = 12; style = bold;
				text = "Kardia Info";
				}
			    }
			
			edit_tab "widget/tab"
			    {
			    x = 170; y = 15; width = 590; height = 140;
			    
			    // Widget is invisible.
			    bgcolor = transparent;
			    border_color = transparent;
			    tab_location = none;
			    
			    selected_index = runclient(condition(upper(:content_osrc:status) = "OVERRIDE", 2, 1));
			    
			    immutable "widget/tabpage"
				{
				display_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    editable = 0;
				    ledger = runserver(:this:ledger);
				    }
				}
			    
			    editable "widget/tabpage"
				{
				edit_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    editable = 1;
				    ledger = runserver(:this:ledger);
				    }
				}
			    }
			
			button_col "widget/vbox"
			    {
			    x = 780; y = 14; width = 140; height = 140; spacing = 7;
			    fl_width = 0;
			    
			    save_cancel_buttons "widget/hbox"
				{
				x = 0; width = 140; height = 23; spacing = 20; // y = button_col
				
				save_button "widget/textbutton"
				    {
				    x = 0; y = 0; width = 60; height = 23; // x = save_cancel_buttons
				    border_radius = 5;
				    text = "Save";
				    enabled = runclient(:edit_form:is_savable);
				    
				    save_button_connector "widget/connector"
					{
					event = Click;
					target = edit_form;
					action = Save;
					FromKeyboard = 1;
					FromOSRC = 0;
					}
				    }
				
				cancel_button "widget/textbutton"
				    {
				    y = 0; width = 60; height = 23; // x = save_cancel_buttons
				    border_radius = 5;
				    text = "Cancel";
				    enabled = runclient(:edit_form:is_discardable);
				    
				    cancel_button_connector "widget/connector"
					{
					event = Click;
					target = edit_form;
					action = Discard;
					FromKeyboard = 1;
					FromOSRC = 0;
					}
				    }
				}
			    
			    copy_delete_buttons "widget/hbox"
				{
				x = 0; width = 140; height = 23; spacing = 20; // y = button_col
				
				copy_button "widget/textbutton"
				    {
				    y = 0; width = 60; height = 23; // x = copy_delete_buttons
				    border_radius = 5;
				    text = "Copy";
				    enabled = runclient(:edit_form:is_editable);
				    
				    copy_connector "widget/connector"
					{
					event = Click;
					target = content_osrc;
					action = Create;
					
					// ID fields.
					a_ledger_number = runclient(:content_osrc:a_ledger_number);
					i_eg_gift_uuid = runclient("FAKE_" + convert("string", eval("Math.floor(Math.random() * 1e15) + 1")));
					i_eg_trx_uuid = runclient("FAKE_" + convert("string", eval("Math.floor(Math.random() * 1e15) + 1")));
					i_eg_line_item = runclient(1);
					i_eg_status = runclient("override");
					
					// General fields.
					i_eg_service = runclient(:content_osrc:i_eg_service);
					i_eg_processor = runclient(:content_osrc:i_eg_processor);
					i_eg_donor_uuid = runclient(:content_osrc:i_eg_donor_uuid);
					i_eg_donor_name = runclient(:content_osrc:i_eg_donor_name);
					i_eg_donor_address = runclient(:content_osrc:i_eg_donor_address);
					i_eg_desig_uuid = runclient(:content_osrc:i_eg_desig_uuid);
					i_eg_desig_name = runclient(:content_osrc:i_eg_desig_name);
					i_eg_desig_notes = runclient(:content_osrc:i_eg_desig_notes);
					i_eg_gift_amount = runclient(:content_osrc:i_eg_gift_amount);
					i_eg_gift_interval = runclient(:content_osrc:i_eg_gift_interval);
					i_eg_deposit_amt = runclient(:content_osrc:i_eg_deposit_amt);
					i_eg_net_amount = runclient(:content_osrc:i_eg_net_amount);
					i_eg_deposit_gross_amt = runclient(:content_osrc:i_eg_deposit_gross_amt);
					p_donor_partner_key = runclient(:content_osrc:p_donor_partner_key);
					a_fund = runclient(:content_osrc:a_fund);
					a_account_code = runclient(:content_osrc:a_account_code);
					
					// Auto fields.
					i_eg_gift_date = runclient(getdate());
					s_date_created = runclient(getdate());
					s_created_by = runclient(user_name());
					s_date_modified = runclient(getdate());
					s_modified_by = runclient(user_name());
					}
				    
				    auto_update_connector "widget/connector"
					{
					event = Click;
					target = content_osrc;
					action = Refresh;
					}
				    
				    // Assumes the newly created association is at the top of the list.
				    auto_scroll_connector "widget/connector"
					{
					event = Click;
					target = content_osrc;
					action = First;
					}
				    }
				
				delete_button "widget/textbutton"
				    {
				    y = 0; width = 60; height = 23; // x = copy_delete_buttons
				    border_radius = 5;
				    text = "Delete";
				    enabled = runclient(:edit_form:is_editable AND upper(:content_osrc:status) = "OVERRIDE");
				    
				    delete_button_connector "widget/connector"
					{
					event = Click;
					target = edit_form;
					action = Delete;
					}
				    }
				}
			    
			    line_item_button "widget/textbutton"
				{
				x = 0; width = 140; height = 23; // y = button_col
				border_radius = 5;
				text = "Line Item Details";
				enabled = no; // TODO: Implement.
				}
			    
			    history_button "widget/textbutton"
				{
				x = 0; width = 140; height = 23; // y = button_col
				border_radius = 5;
				text = "Association History";
				enabled = no; // TODO: Implement.
				}
			    }
			}
		    }
		}
	    }
	
	blank_association_button "widget/textbutton"
	    {
	    x = 10; y = 650; width = 150; height = 25;
	    border_radius = 5;
	    text = "Create Blank Override";
	    
	    immutable_blank_fix "widget/connector"
		{
		event = Click;
		target = edit_tab;
		action = SetTab;
		TabIndex = 2;
		}
	    
	    blank_association_button_connector "widget/connector"
		{
		event = Click;
		target = edit_form;
		action = New;
		}
	    
	    // Fixes a bug where, when the user canceled creating a blank
	    // association, the old selected association would be editable.
	    blank_association_cancel_connector "widget/connector"
		{
		source = edit_form;
		event = ModeChange;
		target = edit_tab;
		action = SetTab;
		event_condition=runclient(:OldMode = "New" and :NewMode != "New" and upper(:content_osrc:status) != "OVERRIDE");
		TabIndex = 1;
		}
	    }
	}
    }
