$Version=2$
gift_associations "widget/page"
    {
    title = "Gift Associations";
    width = 1000;
    height = 700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl";
    background = null;
    bgcolor = white;
    require_one_endorsement = "kardia:gift_entry";
    endorsement_context = runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 9;
    
    // Note: Assumes connectors activate in the order they are defined.
    
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
		y = 10; // x = filter_layout
		width = 40;
		align = right;
		text = "Search:";
		}
	    
	    filter_search_box "widget/editbox"
		{
		y = 5; width = 200; height = 25; // x = filter_layout
		
		trigger_manual_search "widget/connector"
		    {
		    event = ReturnPressed;
		    target = associations_table;
		    action = trigger_search;
		    }
		
		trigger_auto_search "widget/connector"
		    {
		    event = LoseFocus;
		    target = associations_table;
		    action = trigger_search;
		    }
		
		clear_search_box "widget/connector"
		    {
		    event = EscapePressed;
		    target = filter_search_box;
		    action = SetValue;
		    Value = runclient("");
		    }
		
		trigger_clear_search "widget/connector"
		    {
		    event = EscapePressed;
		    target = associations_table;
		    action = trigger_search;
		    }
		}
	    
	    // Service filter dropdown.
	    filter_service_spacer "widget/autolayoutspacer" { width = 10; }	
	    filter_service_label "widget/label"
		{
		y = 10; // x = filter_layout
		width = 40;
		align = right;
		text = "Service:";
		}
	    filter_service_dropdown "widget/dropdown"
		{
		y = 4; width = 125; height = 25; // x = filter_layout
		
		// Styling.
		bgcolor = white;
		hilight = "#d0d0d0";
		
		// Get payment service types.
		mode = dynamic_server;
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
			substring(:a_config_name, 1, 11) = 'GiftImport_' AND
			:a_config_value = '1'
		    GROUP BY
			:a_config_name
		    ;
		    
		    SELECT * FROM collection gift_services
		";
		filter_service_hints "widget/hints" { style = notnull; }
		
		trigger_filtered_search "widget/connector"
		    {
		    event = DataChange;
		    target = associations_table;
		    action = trigger_search;
		    }
		}
	    }
	
	associations_table "widget/component"
	    {
	    x = 10; y = 50; width = 960; height = 590;
	    path = "/apps/kardia/modules/rcpt/gift_associations_table.cmp";
	    mode = static;
	    
	    ledger = runserver(:this:ledger);
	    filter_search_box = filter_search_box;
	    filter_service_dropdown = filter_service_dropdown;
	    line_item_window = line_item_window;
	    line_item_osrc = line_item_osrc;
	    }
	
	load_associations_table "widget/connector"
	    {
	    source = gift_associations;
	    event = Load;
	    target = associations_table;
	    action = QueryParam;
	    }
	
	blank_association_button "widget/textbutton"
	    {
	    x = 10; y = 650; width = 100; height = 25;
	    border_radius = 5;
	    text = "Add Override";
	    
	    blank_association_button_connector "widget/connector"
		{
		event = Click;
		target = associations_table;
		action = add_override;
		}
	    }
	}
    
    line_item_window "widget/childwindow"
	{
	x = 100; y = 115; width = 500; height = 475;
	title = "Line Item Details";
	style = dialog;
	toplevel = yes;
	modal = yes;
	visible = no;
	
	line_item_osrc "widget/osrc"
	    {
	    // Get current transaction from client.
	    target_trx_uuid_param "widget/parameter"
		{
		param_name = target_trx_uuid;
		type = string;
		}
	    
	    sql = runserver("
		SELECT
		    -- Table column values.
		    :eg:a_ledger_number,        -- Primary key: ledger
		    :eg:i_eg_trx_uuid,          -- Primary key: transaction UUID
		    :eg:i_eg_line_item,         -- Line Item
		    :eg:i_eg_desig_uuid,        -- Service: Desig. ID
		    :eg:i_eg_desig_name,        -- Service: Desig. Name
		    :eg:i_eg_desig_notes,       -- Service: Desig. Notes
		    :eg:i_eg_gift_amount,       -- Gross Amount
		    :eg:i_eg_net_amount,        -- Net Amount
		    :eg:i_eg_deposit_gross_amt, -- Deposit Gross Amount
		    :eg:i_eg_deposit_amt,       -- Deposit Net Amount
		    :eg:a_fund,                 -- Kardia: Fund/Desig
		    :eg:a_account_code,         -- Kardia: GL Account
		    
		    -- Display values.
		    service_desig = ''
			+ isnull(:eg:i_eg_desig_name + ' ', '')
			+ isnull('(' + nullif(:eg:i_eg_desig_uuid, '') + ')', ''),
		    kardia_desig = ''
			+ isnull(:f:a_fund_desc + ' ', '')
			+ isnull('(' + nullif(:eg:a_fund, '') + ')', ''),
		    
		    -- Logic values.
		    is_override = (lower(ltrim(rtrim(:eg:i_eg_status))) = 'override')
		FROM
		    identity /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows eg,
		    /apps/kardia/data/Kardia_DB/a_fund/rows f
		WHERE
		    :eg:i_eg_trx_uuid = :parameters:target_trx_uuid AND
		    :eg:a_ledger_number = " + quote(:this:ledger) + " AND
		    :eg:a_fund *= :f:a_fund
		-- TODO: Uncomment 'DEFAULT' after PR #127 is merged.
		ORDER BY -- DEFAULT
		    :eg:i_eg_line_item,
		    :eg:i_eg_gift_date
	    ");
	    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	    replicasize = 50;
	    readahead = 50;
	    autoquery = never;
	    }
	
	line_item_pane "widget/pane"
	    {
	    x = 5; y = 5; width = 490; height = 440;
	    
	    line_item_info "widget/hbox"
		{
		x = 15; y = 5; width = 475; height = 20; spacing = 10;
		
		deposit_title_label "widget/label"
		    {
		    y = 0; width = 80; height = 20; // x=line_item_info
		    style = bold;
		    text = "Deposit:";
		    }
		
		deposit_gross_label "widget/label"
		    {
		    y = 0; width = 120; height = 20; // x=line_item_info
		    value = runclient("Gross: " + :line_item_osrc:i_eg_deposit_gross_amt);
		    }
		
		deposit_net_label "widget/label"
		    {
		    y = 0; width = 120; height = 20; // x=line_item_info
		    value = runclient("Net: " + :line_item_osrc:i_eg_deposit_amt);
		    }
		}
	    
	    line_item_table "widget/table"
		{
		x = 10; y = 30; width = 470; height = 400;
		objectsource = line_item_osrc;
		nodata_message = "No Line Items Details";
		
		// Layout
		rowheight = null;
		cellvspacing = 4;
		inner_padding = 4;
		colsep = 0;
		
		// Behavior
		initial_selection = yes;
		followcurrent     = yes;
		overlap_scrollbar = yes;
		demand_scrollbar  = yes;
		allow_selection   = yes;
		allow_deselection = yes;
		allow_sorting     = yes;
		
		// Columns
		column_service_desig "widget/table-column"
		    {
		    width = 30;
		    fieldname = service_desig;
		    title = "Service Designation";
		    }
		column_kardia_desig "widget/table-column"
		    {
		    width = 30;
		    fieldname = kardia_desig;
		    title = "Kardia Designation";
		    }
		column_gift_amount "widget/table-column"
		    {
		    width = 10;
		    align = right;
		    fieldname = i_eg_gift_amount;
		    title = "Gift Amount";
		    }
		
		// Row Detail
		line_item_detail "widget/table-row-detail"
		    {
		    width = 470; height = 250;
		    show_on_new = 0;
		    
		    line_item_edit_form "widget/form"
			{
			objectsource = line_item_osrc;
			allow_view = yes;
			allow_new = no;
			allow_modify = yes;
			allow_delete = no;
			allow_nodata = yes;
			allow_query = no;
			confirm_discard = no;
			enter_mode = save;
			tab_revealed_only = yes;
			
			hidden_ledger "widget/variable" { fieldname = a_ledger_number; }
			hidden_trx_uuid "widget/variable" { fieldname = i_eg_trx_uuid; }
			hidden_line_item "widget/variable" { fieldname = i_eg_line_item; }
			line_item_hidden_field_handler "widget/component" { path = "/apps/kardia/modules/base/record_metadata_hidden.cmp"; }
			
			line_item_edit_pane "widget/pane"
			    {
			    x = 5; y = 15; width = 455; height = 235;
			    bgcolor = "#e0e0e0";
			    style = "lowered";
			    
			    line_item_fields_tab "widget/tab"
				{
				x = 0; y = 0; width = 455; height = 160;
				
				bgcolor = transparent;
				border_color = transparent;
				tab_location = none;
				
				selected = runclient(condition(
				    :line_item_osrc:is_override,
				    editable_line_item_page,
				    readonly_line_item_page
				));
				
				editable_line_item_page "widget/tabpage"
				    {
				    editable_line_item_cols "widget/component"
					{
					x = 0; y = 0; width = 455; height = 160;
					path = "/apps/kardia/modules/rcpt/gift_associations_line_item_edit.cmp";
					edit_mode = "editable";
					ledger = runserver(:this:ledger);
					}
				    }
				
				readonly_line_item_page "widget/tabpage"
				    {
				    readonly_line_item_cols "widget/component"
					{
					x = 0; y = 0; width = 455; height = 160;
					path = "/apps/kardia/modules/rcpt/gift_associations_line_item_edit.cmp";
					edit_mode = "readonly";
					ledger = runserver(:this:ledger);
					}
				    }
				}
			    
			    service_split_divider "widget/pane"
				{
				x = 10; y = 161; width = 440; height = 2; style = border;
				}
			    
			    split_label "widget/label"
				{
				x = 10; y = 171; width = 35; height = 18;
				style = bold;
				text = "Split:";
				}
			    
			    split_buttons "widget/hbox"
				{
				x = 50; y = 170; width = 250; height = 20; spacing = 10;
				
				split_gift_button "widget/textbutton"
				    {
				    y = 0; width = 90; height = 20; // x = split_buttons
				    border_radius = 5;
				    text = "Split Gift";
				    enabled = runclient(:line_item_osrc:is_override AND :line_item_osrc:i_eg_line_item = 1);
				    
				    open_split_popup "widget/connector"
					{
					event = Click;
					target = split_trx_popup;
					action = Open;
					}
				    }
				
				remove_split_button "widget/textbutton"
				    {
				    y = 0; width = 115; height = 20; // x = split_buttons
				    border_radius = 5;
				    text = "Remove Split";
				    enabled = runclient(:line_item_osrc:is_override AND :line_item_osrc:i_eg_line_item > 1);
				    
				    trigger_unsplit_query "widget/connector"
					{
					event = Click;
					event_confirm = runclient('Remove ' + :line_item_osrc:i_eg_gift_amount + ' split gift item?');
					target = do_unsplit_osrc;
					action = QueryParam;
					ledger   = runclient(:line_item_osrc:a_ledger_number);
					trx      = runclient(:line_item_osrc:i_eg_trx_uuid);
					desig    = runclient(:line_item_osrc:i_eg_desig_uuid);
					line     = runclient(:line_item_osrc:i_eg_line_item);
					origline = runclient(1);
					}
				    }
				}
			    
			    split_buttons_divider "widget/pane"
				{
				x = 10; y = 195; width = 440; height = 2; style = border;
				}
			    
			    line_item_save_cancel_buttons "widget/hbox"
				{
				x = 160; y = 210; width = 140; height = 22; spacing = 20;
				
				line_item_save_button "widget/textbutton"
				    {
				    y = 0; width = 55; height = 22; // x = line_item_save_cancel_buttons
				    border_radius = 5;
				    text = "Save";
				    enabled = runclient(:line_item_osrc:is_override AND :line_item_edit_form:is_savable);
				    
				    line_item_save_connector "widget/connector"
					{
					event = Click;
					target = line_item_edit_form;
					action = Save;
					FromKeyboard = 1;
					FromOSRC = 0;
					}
				    
				    line_item_refresh_on_save "widget/connector"
					{
					event = Click;
					target = associations_table; action = refresh_tables;
					}
				    }
				
				line_item_cancel_button "widget/textbutton"
				    {
				    y = 0; width = 55; height = 22; // x = line_item_save_cancel_buttons
				    border_radius = 5;
				    text = "Cancel";
				    enabled = runclient(:line_item_edit_form:is_discardable);
				    
				    line_item_cancel_connector "widget/connector"
					{
					event = Click;
					target = line_item_edit_form;
					action = Discard;
					FromKeyboard = 1;
					FromOSRC = 0;
					}
				    }
				}
			    }
			}
		    }
		}
	    }
	}
    
    // Splits a line item by inserting a new row with i_eg_line_item=null
    // (the server assigns the next line) AND subtracting the split
    // amount/prorated net from the source row.
    // Mirrors do_split_osrc in gift_import.cmp.
    do_split_osrc "widget/osrc"
	{
	split_ledger "widget/parameter" { type = string;  param_name = ledger; }
	split_trx    "widget/parameter" { type = string;  param_name = trx; }
	split_desig  "widget/parameter" { type = string;  param_name = desig; }
	split_line   "widget/parameter" { type = integer; param_name = line; }
	split_amount "widget/parameter" { type = string;  param_name = amount; }
	
	sql = "
	    -- Insert the newly split record.
	    insert
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    select
		*,
		i_eg_line_item = null,
		i_eg_net_amount = round(convert(money, :i_eg_net_amount * (convert(double, :parameters:amount) / convert(double, :i_eg_gift_amount))), 2),
		i_eg_gift_amount = convert(money, :parameters:amount)
	    from
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    where
		:a_ledger_number = :parameters:ledger AND
		:i_eg_trx_uuid = :parameters:trx AND
		:i_eg_desig_uuid = :parameters:desig AND
		:i_eg_line_item = :parameters:line
	    ;
	    
	    -- Update the previous record, removing the portion that was split away.
	    update
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    set
		:i_eg_net_amount = :i_eg_net_amount - round(convert(money, :i_eg_net_amount * (convert(double, :parameters:amount) / convert(double, :i_eg_gift_amount))), 2),
		:i_eg_gift_amount = :i_eg_gift_amount - convert(money, :parameters:amount)
	    where
		:a_ledger_number = :parameters:ledger AND
		:i_eg_trx_uuid = :parameters:trx AND
		:i_eg_desig_uuid = :parameters:desig AND
		:i_eg_line_item = :parameters:line
	    ";
	autoquery = never;
	readahead = 2;
	replicasize = 2;
	baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	
	on_split_refresh_li      "widget/connector" { event = EndQuery; target = line_item_osrc;     action = Refresh; }
	on_split_refresh_content "widget/connector" { event = EndQuery; target = associations_table; action = refresh_tables; }
	}
    
    // Removes a split by capturing its amount/net, deleting the row,
    // then adding those amounts back onto the original line.
    // Mirrors do_unsplit_osrc in gift_import.cmp.
    do_unsplit_osrc "widget/osrc"
	{
	unsplit_ledger   "widget/parameter" { type = string;  param_name = ledger; }
	unsplit_trx      "widget/parameter" { type = string;  param_name = trx; }
	unsplit_desig    "widget/parameter" { type = string;  param_name = desig; }
	unsplit_line     "widget/parameter" { type = integer; param_name = line; }
	unsplit_origline "widget/parameter" { type = integer; param_name = origline; }
	
	sql = "
	    declare object saved_amounts;
	    
	    select
		:saved_amounts:amount = :i_eg_gift_amount,
		:saved_amounts:net_amount = :i_eg_net_amount
	    from
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    where
		:a_ledger_number = :parameters:ledger AND
		:i_eg_trx_uuid = :parameters:trx AND
		:i_eg_desig_uuid = :parameters:desig AND
		:i_eg_line_item = :parameters:line
	    ;
	    
	    delete
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    where
		:a_ledger_number = :parameters:ledger AND
		:i_eg_trx_uuid = :parameters:trx AND
		:i_eg_desig_uuid = :parameters:desig AND
		:i_eg_line_item = :parameters:line
	    ;
	    
	    update
		/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
	    set
		:i_eg_gift_amount = :i_eg_gift_amount + :saved_amounts:amount,
		:i_eg_net_amount = :i_eg_net_amount + :saved_amounts:net_amount
	    where
		:a_ledger_number = :parameters:ledger AND
		:i_eg_trx_uuid = :parameters:trx AND
		:i_eg_desig_uuid = :parameters:desig AND
		:i_eg_line_item = :parameters:origline
	    ";
	autoquery = never;
	readahead = 2;
	replicasize = 2;
	baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	
	on_unsplit_refresh_li      "widget/connector" { event = EndQuery; target = line_item_osrc;     action = Refresh; }
	on_unsplit_refresh_content "widget/connector" { event = EndQuery; target = associations_table; action = refresh_tables; }
	}
    
    // Modal popover for entering the split amount, used by do_split_osrc.
    // Centered roughly over the line_item_window.
    split_trx_popup "widget/childwindow"
	{
	x = 325; y = 290; width = 350; height = 146;
	
	// Behavior
	titlebar = no;
	visible  = no;
	modal    = yes;
	toplevel = yes;
	
	// Background
	background = null;
	bgcolor    = "#f8f8f8";
	
	// Border
	border_style  = solid;
	border_color  = "#f8f8f8";
	border_radius = 12;
	
	// Shadow
	shadow_radius = 4;
	shadow_offset = 2;
	shadow_color  = "#404040";
	shadow_angle  = 135;
	
	focus_amount_on_open "widget/connector" { event = Open; target = split_popup_amount_field; action = SetFocus; }
	init_remain_on_open "widget/connector" { event = Open; target = split_popup_remain_field; action = SetValue; Value = runclient(:line_item_osrc:i_eg_gift_amount); }
	
	split_popup_vbox "widget/vbox"
	    {
	    x = 10; y = 10; width = 330; height = 126;
	    spacing = 10;
	    
	    split_popup_title "widget/label"
		{
		height = 20; // y = split_popup_vbox
		font_size = 16;
		align = center;
		style = bold;
		text = "Split Gift Line Item";
		}
	    
	    split_popup_form "widget/form"
		{
		allow_new = yes;
		
		split_popup_remain_field "widget/component"
		    {
		    height = 20; label_width = 100; // y = split_popup_vbox
		    path = "/sys/cmp/smart_field.cmp";
		    text = "Remaining:";
		    field = remain;
		    ctl_type = label;
		    }
		
		split_popup_amount_field "widget/component"
		    {
		    height = 20; label_width = 100; // y = split_popup_vbox
		    path = "/sys/cmp/smart_field.cmp";
		    text = "Split Amount:";
		    field = amount;
		    ctl_type = editbox;
		    
		    update_remain_text "widget/connector"
			{
			event = DataModify;
			target = split_popup_remain_text;
			action = SetValue;
			Value = runclient('$' + (0
			    + convert(double, :line_item_osrc:i_eg_gift_amount)
			    - convert(double, isnull(:split_popup_amount_field:content, '0'))
			    + .0001
			));
			}
		    
		    split_popup_amount_hints "widget/hints" { allowchars = "0123456789.$"; }
		    }
		
		split_popup_remain_text "widget/variable"
		    {
		    type = string;
		    
		    format_remain_display "widget/connector"
			{
			event = DataModify;
			target = split_popup_remain_field;
			action = SetValue;
			Value = runclient(condition(
			    charindex('.', :Value) > 0,
			    substring(:Value + '00', 1, charindex('.', :Value) + 2),
			    :Value + '.00'
			));
			}
		    }
		
		click_ok_on_form_save "widget/connector"
		    {
		    event = BeforeSave;
		    target = split_popup_ok;
		    action = Click;
		    event_cancel = runclient(1);
		    }
		
		close_popup_on_form_discard "widget/connector"
		    {
		    event = Discard;
		    target = split_trx_popup;
		    action = Close;
		    }
		}
	    
	    split_popup_separator "widget/autolayoutspacer" { height = 1; }
	    
	    split_popup_buttons "widget/hbox"
		{
		x = 0; height = 24; // y = split_popup_vbox
		spacing = 10;
		align = center;
		
		split_popup_ok "widget/textbutton"
		    {
		    y = 0; width = 130; height = 24; // x = split_popup_buttons
		    text = "Split";
		    enabled = runclient(
			char_length(:split_popup_amount_field:content) > 0 AND
			convert(double, :line_item_osrc:i_eg_gift_amount) > convert(double, :split_popup_amount_field:content) AND
			convert(double, :split_popup_amount_field:content) > 0
		    );
		    
		    submit_split_query "widget/connector"
			{
			event  = Click;
			target = do_split_osrc;
			action = QueryParam;
			ledger = runclient(:line_item_osrc:a_ledger_number);
			trx    = runclient(:line_item_osrc:i_eg_trx_uuid);
			desig  = runclient(:line_item_osrc:i_eg_desig_uuid);
			line   = runclient(:line_item_osrc:i_eg_line_item);
			amount = runclient(:split_popup_amount_field:content);
			}
		    
		    discard_form_on_submit "widget/connector"
			{
			event = Click;
			target = split_popup_form;
			action = Discard;
			}
		    }
		
		split_popup_cancel "widget/textbutton"
		    {
		    y = 0; width = 130; height = 24; // x = split_popup_buttons
		    text = "Cancel";
		    
		    discard_form_on_cancel "widget/connector"
			{
			event = Click;
			target = split_popup_form;
			action = Discard;
			}
		    }
		}
	    }
	}
    }
