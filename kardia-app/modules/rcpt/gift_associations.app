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
		    target = search_trigger;
		    action = SetValue;
		    Value = runclient(1);
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
	    
	    filter_override_only_param "widget/parameter"
		{
		param_name = override_only;
		type = integer;
		default = runclient(condition(:filter_search_box:content = '', 1, 0));
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
	    
	    reset_search_trigger "widget/connector"
		{
		event = EndQuery;
		target = search_trigger;
		action = SetValue;
		Value = runclient(0);
		}
	    
	    page_load_connector "widget/connector"
		{
		source=gift_associations;
		event=Load;
		action=QueryParam;
		target=content_osrc;
		}
	    
	    sql = runserver("
		SELECT
		    -- Primary key fields.
		    :eg:a_ledger_number,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_desig_uuid,
		    :eg:i_eg_line_item,
		    
		    -- Logical values.
		    n_line_items = count(1),
		    is_override = lower(ltrim(rtrim(:eg:i_eg_status))) = 'override',
		    
		    -- Table display fields.
		    donor_service_name = ''
			+ isnull(:eg:i_eg_donor_name, 'Missing')
			+ isnull(' (' + nullif(:eg:i_eg_donor_address, '') + ')', ''),
		    donor_service_desig_caption = ''
			+ isnull(:eg:i_eg_desig_name + ' ', '')
			+ isnull('(' + nullif(:eg:i_eg_desig_uuid, '') + ')', ''),
		    donor_kardia_name = ''
			+ isnull(:p:p_given_name + ' ', '')
			+ isnull(:p:p_surname    + ' ', '')
			+ isnull(:p:p_org_name   + ' ', '')
			+ '('
			+ isnull(:eg:p_donor_partner_key, 'Missing')
			+ ')',
		    donor_kardia_desig_caption = condition(
			:eg:i_eg_gift_amount = :eg:i_eg_deposit_gross_amt,
			isnull(:f:a_fund_desc + ' ', '') + '(' + :eg:a_fund + ')',
			'multiple (' + count(1) + ')'
		    ),
		    amount = isnull(:eg:i_eg_deposit_gross_amt, 'Missing'),
		    amount_caption = isnull(:eg:i_eg_deposit_amt, 'Missing'),
		    status = upper(ltrim(rtrim(:eg:i_eg_status))),
		    gift_id = condition(
			char_length(:eg:i_eg_gift_uuid) > 12,
			substring(:eg:i_eg_gift_uuid, 1, 12) + '...',
			:eg:i_eg_gift_uuid
		    ),
		    gift_date = dateformat(:eg:i_eg_gift_date, 'M/d/yyyy'),
		    
		    -- Editable fields.
		    :eg:i_eg_gift_uuid,         -- Gift uuid
		    :eg:i_eg_service,           -- Service
		    :eg:i_eg_processor,         -- Service (human readable)
		    :eg:i_eg_donor_uuid,        -- Donor UUID
		    :eg:i_eg_donor_name,        -- Donor Name
		    :eg:i_eg_donor_address,     -- Donor Addr
		    :eg:i_eg_desig_name,        -- Desig Name
		    :eg:i_eg_desig_notes,       -- Desig Notes
		    :eg:i_eg_gift_interval,     -- Interval
		    :eg:i_eg_gift_amount,       -- Gross Amount
		    :eg:i_eg_net_amount,        -- Net Amount
		    :eg:i_eg_deposit_gross_amt, -- Deposit Gross Amount
		    :eg:i_eg_deposit_amt,       -- Deposit Net Amount
		    :eg:p_donor_partner_key,    -- Kardia Donor
		    :eg:a_fund,                 -- Desig.
		    :eg:a_account_code          -- GL Account
		FROM
		    identity /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows eg,
		    /apps/kardia/data/Kardia_DB/p_partner/rows p,
		    /apps/kardia/data/Kardia_DB/a_fund/rows f
		WHERE
		    :eg:p_donor_partner_key *= :p:p_partner_key AND
		    :eg:a_fund *= :f:a_fund AND
		    :eg:a_ledger_number = " + quote(:this:ledger) + " AND
		    (:f:a_ledger_number is null OR :f:a_ledger_number = " + quote(:this:ledger) + ") AND
		    (:parameters:override_only = 0 OR lower(:eg:i_eg_status) = 'override') AND
		    (:parameters:service = 'any' OR :parameters:service = :eg:i_eg_service)
		GROUP BY
		    :eg:i_eg_gift_date desc,
		    :eg:i_eg_gift_uuid,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_service
		ORDER BY
		    :eg:i_eg_gift_date desc,
		    :eg:i_eg_gift_uuid,
		    :eg:i_eg_trx_uuid,
		    :eg:i_eg_service
	    ");
	    replicasize = 100;
	    readahead = 200;
	    autoquery = never;
	    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	    }
	
	// Saves must propagate because the associations_table may aggregate
	// multiple line items of the same transaction, but the edit_form's
	// Save action only writes to one record (the line item used for the
	// row's primary key).  This propagator writes the data to the others.
	propagate_shared_osrc "widget/osrc"
	    {
	    ledger_param        "widget/parameter" { param_name = ledger;        type = string; }
	    trx_uuid_param      "widget/parameter" { param_name = trx_uuid;      type = string; }
	    service_param       "widget/parameter" { param_name = service;       type = string; }
	    donor_name_param    "widget/parameter" { param_name = donor_name;    type = string; }
	    donor_address_param "widget/parameter" { param_name = donor_address; type = string; }
	    partner_key_param   "widget/parameter" { param_name = partner_key;   type = string; }
	    
	    sql = "
		UPDATE
		    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
		SET
		    :i_eg_service        = :parameters:service,
		    :i_eg_donor_name     = :parameters:donor_name,
		    :i_eg_donor_address  = :parameters:donor_address,
		    :p_donor_partner_key = :parameters:partner_key
		WHERE
		    :a_ledger_number = :parameters:ledger AND
		    :i_eg_trx_uuid   = :parameters:trx_uuid
	    ";
	    autoquery = never;
	    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
	    
	    // Refresh so the table re-groups if i_eg_service was edited.
	    refresh_after_propagate "widget/connector"
		{
		event = EndQuery;
		target = content_osrc;
		action = Refresh;
		}
	    }
	
	associations_table "widget/table"
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
	    initial_selection = noexpand;
	    followcurrent     = yes;
	    overlap_scrollbar = yes;
	    demand_scrollbar  = yes;
	    allow_selection   = yes;
	    allow_deselection = yes;
	    allow_sorting     = no;
	    
	    // Rows
	    row_border_radius = 6;
	    row_shadow_radius = 2;
	    row_shadow_offset = 1;
	    row_shadow_color  = "#a0a0a0";
	    row_shadow_angle  = 135;
	    
	    // Columns
	    column_service_designation "widget/table-column"
		{
		width = 50;
		align = left;
		caption_align = left;
		fieldname = donor_service_name;
		caption_fieldname = donor_service_desig_caption;
		sort_fieldname = ':eg:i_eg_donor_name';
		title = "Giving Service Donor/Designation";
		}
	    column_kardia_designation "widget/table-column"
		{
		width = 50;
		align = left;
		caption_align = left;
		fieldname = donor_kardia_name;
		caption_fieldname = donor_kardia_desig_caption;
		sort_fieldname = ':p:p_surname';
		title = "Kardia Donor/Designation";
		}
	    column_amount "widget/table-column"
		{
		width = 15;
		align = right;
		caption_align = right;
		fieldname = amount;
		caption_fieldname = amount_caption;
		sort_fieldname = ':eg:i_eg_deposit_gross_amt';
		title = "Gross/Net Amount";
		}
	    column_status_date "widget/table-column"
		{
		width = 15;
		align = center;
		caption_align = center;
		fieldname = status;
		caption_fieldname = gift_date;
		sort_fieldname = ':eg:i_eg_status';
		title = "Status/Date";
		}
	    
	    // Row Detail
	    associations_table_detail "widget/table-row-detail"
		{
		height = 160;
		width = 960;
		show_on_new = 1;
		
		edit_form "widget/form"
		    {
		    objectsource = content_osrc;
		    
		    // Permissions & UX
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
		    
		    // Hidden Fields
		    ledger_number "widget/variable" { fieldname = a_ledger_number; ledger_default "widget/hints" { default = runclient(:ledger:value); } }
		    gift_uuid "widget/variable" { fieldname = i_eg_gift_uuid; gift_uuid_default "widget/hints" { default = runclient("FAKE_" + convert("string", round(rand() * 2147483646) + 1)); } }
		    gift_date "widget/variable" { fieldname = i_eg_gift_date; gift_date_default "widget/hints" { default = runclient(getdate()); } }
		    trx_uuid "widget/variable" { fieldname = i_eg_trx_uuid; trx_uuid_default "widget/hints" { default = runclient("FAKE_" + convert("string", round(rand() * 2147483646) + 1)); } }
		    line_item "widget/variable" { fieldname = i_eg_line_item; line_item_default "widget/hints" { default = runclient(1); } }
		    donor_uuid "widget/variable" { fieldname = i_eg_donor_uuid; donor_uuid_default "widget/hints" { default = runclient("FAKE_" + convert("string", round(rand() * 2147483646) + 1)); } }
		    status "widget/variable" { fieldname = i_eg_status; status_default "widget/hints" { default = runclient("override"); } }
		    service "widget/variable" { fieldname = i_eg_service; service_default "widget/hints" { default = runclient("N/A"); } }
		    processor "widget/variable" { fieldname = i_eg_processor; processor_default "widget/hints" { default = runclient("N/A"); } }
		    gift_amount "widget/variable" { fieldname = i_eg_gift_amount; gift_amount_default "widget/hints" { default = runclient(0); } }
		    net_amount "widget/variable" { fieldname = i_eg_net_amount; net_amount_default "widget/hints" { default = runclient(0); } }
		    deposit_gross_amt "widget/variable" { fieldname = i_eg_deposit_gross_amt; deposit_gross_amt_default "widget/hints" { default = runclient(0); } }
		    deposit_net_amt "widget/variable" { fieldname = i_eg_deposit_amt; deposit_net_amt_default "widget/hints" { default = runclient(0); } }
		    gift_interval "widget/variable" { fieldname = i_eg_gift_interval; gift_interval_default "widget/hints" { default = runclient("never"); } }
		    hidden_field_handler "widget/component" { path = "/apps/kardia/modules/base/record_metadata_hidden.cmp"; }
		    
		    // When a row aggregates multiple line items, sync the shared
		    // fields so that edits are applied to all line items.
		    propagate_shared_fields "widget/connector"
			{
			event = DataSaved;
			target = propagate_shared_osrc;
			action = QueryParam;
			event_condition = runclient(:content_osrc:n_line_items > 1);
			
			ledger        = runclient(:content_osrc:a_ledger_number);
			trx_uuid      = runclient(:content_osrc:i_eg_trx_uuid);
			service       = runclient(:content_osrc:i_eg_service);
			donor_name    = runclient(:content_osrc:i_eg_donor_name);
			donor_address = runclient(:content_osrc:i_eg_donor_address);
			partner_key   = runclient(:content_osrc:p_donor_partner_key);
			}
		    
		    edit_pane "widget/pane"
			{
			x = 15; y = 15; width = 930; height = 140;
			bgcolor = "#e0e0e0";
			style = "lowered";
			
			pane_bottom_divider "widget/pane"
			    {
			    x = 10; y = 95; width = 740; height = 2; style = border;
			    }
			
			info_col "widget/vbox"
			    {
			    x = 10; y = 10; width = 150; height = 140; spacing = 10;
			    
			    service_title_label "widget/label"
				{
				x = 5; width = 180; height = 20; // y = info_col
				font_size = 12; style = bold;
				text = "Giving Service Info";
				}
			    
			    gift_id_field "widget/component"
				{
				x = 0; width = 180; height = 15; label_width = 60; // y = info_col
				path = "/sys/cmp/smart_field.cmp";
				text = "Gift ID:";
				ctl_type = label;
				type = readonly;
				field = "gift_id";
				
				gift_id_hints "widget/hints"
				    {
				    // TODO: Replace placeholder below with the specified value
				    // after the namespace bug is fixed.
				    default = "Oops!"; //runclient(condition(
				// 	char_length(:gift_uuid:value) > 12,
				// 	substring(:gift_uuid:value, 1, 12) + "...",
				// 	:gift_uuid:value
				//     ));
				    }
				}
			    
			    // Date display only, the gift_date variable stores the date written to the DB.
			    gift_date_field "widget/component"
				{
				x = 0; width = 180; height = 15; label_width = 60; // y = info_col
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
			    
			    service_kardia_spacer "widget/autolayoutspacer" { height = 10; }
			    
			    kardia_title_label "widget/label"
				{
				x = 5; width = 180; height = 20; // y = info_col
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
			    
			    // Determine index.
			    selected = runclient(condition(
				:content_osrc:n_line_items > 1,
				condition(:content_osrc:is_override, view_shared_editable, view_shared_readonly), // Merged line items.
				condition(:content_osrc:is_override, view_all_editable,    view_all_readonly)     // Single line item.
			    ));
			    
			    // Note: blank_association_button hardcodes these tab indexes:
			    // (1=view_all_readonly, 2=view_shared_editable,
			    //  3=view_all_editable, 4=view_shared_readonly).
			    // Keep that code up to date if reordering the tabpages below.
			    
			    view_all_readonly "widget/tabpage"
				{
				view_all_readonly_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    visible_fields = "all";
				    edit_mode = "readonly";
				    ledger = runserver(:this:ledger);
				    }
				}
			    
			    view_shared_editable "widget/tabpage"
				{
				view_shared_editable_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    visible_fields = "shared_only";
				    edit_mode = "editable";
				    ledger = runserver(:this:ledger);
				    }
				}
			    
			    view_all_editable "widget/tabpage"
				{
				view_all_editable_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    visible_fields = "all";
				    edit_mode = "editable";
				    ledger = runserver(:this:ledger);
				    }
				}
			    
			    view_shared_readonly "widget/tabpage"
				{
				view_shared_readonly_cols "widget/component"
				    {
				    x = 0; y = 0; width = 590; height = 140;
				    path = "/apps/kardia/modules/rcpt/gift_associations_edit.cmp";
				    visible_fields = "shared_only";
				    edit_mode = "readonly";
				    ledger = runserver(:this:ledger);
				    }
				}
			    }
			
			button_col "widget/vbox"
			    {
			    x = 780; y = 14; width = 140; height = 140; spacing = 7;
			    
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
				    
				    // Clones every line item of an aggregated row,
				    // not just the row bound to the form.
				    copy_connector "widget/connector"
					{
					event  = Click;
					target = copy_osrc;
					action = QueryParam;
					
					ledger            = runclient(:content_osrc:a_ledger_number);
					source_trx_uuid   = runclient(:content_osrc:i_eg_trx_uuid);
					new_trx_uuid      = runclient("FAKE_" + convert("string", round(rand() * 2147483646) + 1));
					new_gift_uuid     = runclient("FAKE_" + convert("string", round(rand() * 2147483646) + 1));
					gift_date         = runclient(getdate());
					current_time      = runclient(getdate());
					current_user_name = runclient(user_name());
					}
				    }
	
				// Copies every line item of a transaction as a new override
				// transaction.
				// We use INSERT ... SELECT to clone all line items atomically.
				// The new records share a i_eg_trx_uuid / i_eg_gift_uuid while
				// preserving each source row's i_eg_line_item / i_eg_desig_uuid.
				copy_osrc "widget/osrc"
				    {
				    copy_ledger_param          "widget/parameter" { param_name = ledger;            type = string; }
				    copy_source_trx_uuid_param "widget/parameter" { param_name = source_trx_uuid;   type = string; }
				    copy_new_trx_uuid_param    "widget/parameter" { param_name = new_trx_uuid;      type = string; }
				    copy_new_gift_uuid_param   "widget/parameter" { param_name = new_gift_uuid;     type = string; }
				    copy_gift_date_param       "widget/parameter" { param_name = gift_date;         type = string; }
				    copy_current_time_param    "widget/parameter" { param_name = current_time;      type = string; }
				    copy_current_user_param    "widget/parameter" { param_name = current_user_name; type = string; }
				    
				    sql = "
					INSERT
					    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
					SELECT
					    *,
					    i_eg_gift_uuid  = :parameters:new_gift_uuid,
					    i_eg_trx_uuid   = :parameters:new_trx_uuid,
					    i_eg_status     = 'override',
					    i_eg_gift_date  = :parameters:gift_date,
					    s_date_created  = :parameters:current_time,
					    s_created_by    = :parameters:current_user_name,
					    s_date_modified = :parameters:current_time,
					    s_modified_by   = :parameters:current_user_name
					FROM
					    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
					WHERE
					    :a_ledger_number = :parameters:ledger AND
					    :i_eg_trx_uuid   = :parameters:source_trx_uuid
				    ";
				    autoquery = never;
				    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
				    
				    refresh_content_after_copy "widget/connector"
					{
					event = EndQuery;
					target = content_osrc;
					action = Refresh;
					}
				    }
				
				delete_button "widget/textbutton"
				    {
				    y = 0; width = 60; height = 23; // x = copy_delete_buttons
				    border_radius = 5;
				    text = "Delete";
				    enabled = runclient(:edit_form:is_editable AND :content_osrc:is_override);
				    
				    // Deletes all line items of the transaction (not just the
				    // row bound to edit_form).
				    // event_confirm replaces the form's confirm_delete (this
				    // connector doesn't route through it), and reports the
				    // line-item count to the user.
				    delete_button_connector "widget/connector"
					{
					event = Click;
					event_confirm = runclient(condition(
					    :content_osrc:n_line_items > 1,
					    'Delete this gift association and its ' + :content_osrc:n_line_items + ' line items?',
					    'Delete this gift association?'
					));
					target = delete_osrc;
					action = QueryParam;
					
					ledger   = runclient(:content_osrc:a_ledger_number);
					trx_uuid = runclient(:content_osrc:i_eg_trx_uuid);
					}
				    }
				
				// Deletes every line item of a transaction.
				// Note: edit_form's Delete only removes the one record
				// bound to the form, leaving orphaned rows in the DB.
				delete_osrc "widget/osrc"
				    {
				    delete_ledger_param   "widget/parameter" { param_name = ledger;   type = string; }
				    delete_trx_uuid_param "widget/parameter" { param_name = trx_uuid; type = string; }
				    
				    sql = "
					DELETE
					    /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows
					WHERE
					    :a_ledger_number = :parameters:ledger AND
					    :i_eg_trx_uuid   = :parameters:trx_uuid
				    ";
				    autoquery = never;
				    baseobj = "/apps/kardia/data/Kardia_DB/i_eg_gift_import/rows";
				    
				    refresh_content_after_delete "widget/connector"
					{
					event = EndQuery;
					target = content_osrc;
					action = Refresh;
					}
				    }
				}
			    
			    line_item_button "widget/textbutton"
				{
				x = 0; width = 140; height = 23; // y = button_col
				border_radius = 5;
				text = "Line Item Details";
				enabled = runclient(
				    :content_osrc:is_override AND
				    not :edit_form:is_discardable
				);
				
				open_line_item_window "widget/connector"
				    {
				    event = Click;
				    target = line_item_window;
				    action = Open;
				    }
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
	    x = 10; y = 650; width = 100; height = 25;
	    border_radius = 5;
	    text = "Add Override";
	    
	    // New records are always fully editable.
	    blank_association_new_tab_connector "widget/connector"
		{
		event = Click;
		target = edit_tab;
		action = SetTab;
		TabIndex = 3;
		}
	    
	    blank_association_button_connector "widget/connector"
		{
		event = Click;
		target = edit_form;
		action = New;
		}
	    
	    // When exiting "New" mode (save or discard), pick the correct tab to
	    // display the new current record. Mirrors edit_tab.selected above
	    // (keep the two expressions in sync).
	    blank_association_cancel_connector "widget/connector"
		{
		source = edit_form;
		event = ModeChange;
		target = edit_tab;
		action = SetTab;
		event_condition = runclient(:OldMode = "New" AND :NewMode != "New");
		TabIndex = runclient(condition(
		    :content_osrc:n_line_items > 1,
		    condition(:content_osrc:is_override, 2, 4), // view_shared_editable, view_shared_readonly
		    condition(:content_osrc:is_override, 3, 1)  // view_all_editable,    view_all_readonly
		));
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
	
	load_on_open "widget/connector"
	    {
	    event = Open;
	    target = line_item_osrc;
	    action = QueryParam;
	    }
	
	line_item_osrc "widget/osrc"
	    {
	    // Get current transaction from client.
	    target_trx_uuid_param "widget/parameter"
		{
		param_name = target_trx_uuid;
		type = string;
		default = runclient(:content_osrc:i_eg_trx_uuid);
		}
	    
	    sql = runserver("
		SELECT
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
		    :eg:a_account_code          -- Kardia: GL Account
		FROM
		    identity /apps/kardia/data/Kardia_DB/i_eg_gift_import/rows eg
		WHERE
		    :eg:i_eg_trx_uuid = :parameters:target_trx_uuid AND
		    :eg:a_ledger_number = " + quote(:this:ledger) + "
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
		column_desig_uuid "widget/table-column"
		    {
		    width = 25;
		    fieldname = i_eg_desig_uuid;
		    title = "Service Desig. ID";
		    }
		column_line_item "widget/table-column"
		    {
		    width = 10;
		    fieldname = i_eg_line_item;
		    title = "Line Item";
		    }
		column_gift_amount "widget/table-column"
		    {
		    width = 15;
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
			    
			    kardia_label "widget/label"
				{
				x = 10; y = 5; width = 300; height = 16;
				font_size = 12; style = bold;
				text = "Kardia Association:";
				}
			    
			    kardia_row "widget/hbox"
				{
				x = 10; y = 24; width = 445; height = 24; spacing = 10;
				
				fund_desig_field "widget/component"
				    {
				    y = 0; width = 215; height = 24; label_width = 80; // x = kardia_row
				    path = "/apps/kardia/modules/base/editbox_table.cmp";
				    text = "Fund/Desig.:";
				    field = a_fund;
				    
				    // Popup
				    popup_text = "Select a Designation:";
				    popup_width = 335;
				    popup_sql = runserver("
					SELECT
					    value = :c:a_fund + '',
					    label = :c:a_fund + ' - ' + condition(
						isnull(:cr:a_receiptable,0) = 1,
						:c:a_fund_desc + isnull(' (legacy # ' + :c:a_legacy_code + ')',''),
						'** CLOSED **'
					    )
					FROM
					    /apps/kardia/data/Kardia_DB/a_fund/rows c,
					    /apps/kardia/data/Kardia_DB/a_fund_receipting/rows cr
					WHERE
					    :c:a_ledger_number = " + quote(:this:ledger) + " AND
					    :cr:a_ledger_number =* :c:a_ledger_number AND
					    :cr:a_fund =* :c:a_fund AND
					    :c:a_is_posting = 1
				    ");
				    search_field_list = "*a_fund*,*a_fund_desc*,*a_legacy_code*";
				    search_objname = c;
				    key_name = a_fund;
				    
				    fund_desig_hints "widget/hints" { style = applyonchange,notnull,strnull; }
				    }
				
				gl_account_field "widget/component"
				    {
				    y = 0; width = 215; height = 24; label_width = 80; // x = kardia_row
				    path = "/apps/kardia/modules/base/editbox_table.cmp";
				    text = "GL Account:";
				    field = a_account_code;
				    
				    // Popup
				    popup_text = "Select a GL Account:";
				    popup_width = 335;
				    popup_sql = runserver("
					SELECT
					    value = :a_account_code + '',
					    label = :a_account_code + ' - ' + isnull(:a_acct_desc, '')
					FROM
					    /apps/kardia/data/Kardia_DB/a_account/rows
					WHERE
					    :a_ledger_number = " + quote(:this:ledger) + " AND
					    :a_is_posting = 1
					ORDER BY
					    :a_account_code
				    ");
				    search_field_list = "*a_account_code*";
				    key_name = a_account_code;
				    
				    gl_account_hints "widget/hints" { style = applyonchange,notnull,strnull; }
				    }
				}
			    
			    kardia_service_divider "widget/pane"
				{
				x = 10; y = 52; width = 440; height = 2; style = border;
				}
			    
			    service_label "widget/label"
				{
				x = 10; y = 58; width = 300; height = 16;
				font_size = 12; style = bold;
				text = "Giving Service Info:";
				}
			    
			    service_row "widget/hbox"
				{
				x = 10; y = 77; width = 445; height = 80; spacing = 20;
				
				service_info_left_col "widget/vbox"
				    {
				    y = 0; width = 210; height = 80; spacing = 8; // x = service_row
				    
				    gift_amount_field "widget/component"
					{
					x = 0; width = 210; height = 20; label_width = 80; // y = service_info_left_col
					path = "/sys/cmp/smart_field.cmp";
					text = "Gift Amount";
					ctl_type = editbox;
					field = i_eg_gift_amount;
					
					gift_amount_hints "widget/hints" { style = applyonchange; }
					}
				    
				    net_amount_field "widget/component"
					{
					x = 0; width = 210; height = 20; label_width = 80; // y = service_info_left_col
					path = "/sys/cmp/smart_field.cmp";
					text = "Net Amount:";
					ctl_type = editbox;
					field = i_eg_net_amount;
					
					net_amount_hints "widget/hints" { style = applyonchange; }
					}
				    
				    desig_id_field "widget/component"
					{
					x = 0; width = 210; height = 20; label_width = 80; // y = service_info_left_col
					path = "/sys/cmp/smart_field.cmp";
					text = "Desig. ID:";
					ctl_type = editbox;
					field = i_eg_desig_uuid;
					
					desig_id_hints "widget/hints" { style = applyonchange; }
					}
				    }
				
				service_info_right_col "widget/vbox"
				    {
				    y = 0; width = 210; height = 80; spacing = 2; // x = service_row
				    
				    desig_notes_label "widget/label"
					{
					x = 0; width = 210; height = 15; // y = service_info_right_col
					text = "Desig. Notes:";
					style = italic;
					}
				    
				    desig_notes_field "widget/component"
					{
					x = 0; width = 210; height = 60; // y = service_info_right_col
					path = "/sys/cmp/smart_field.cmp";
					text = "";
					label_width = 0;
					ctl_type = textarea;
					field = i_eg_desig_notes;
					
					desig_notes_hints "widget/hints" { style = applyonchange; }
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
				    enabled = runclient(:line_item_osrc:i_eg_line_item = 1);
				    
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
				    enabled = runclient(:line_item_osrc:i_eg_line_item > 1);
				    
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
				    enabled = runclient(:line_item_edit_form:is_savable);
				    
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
					target = content_osrc;
					action = Refresh;
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
	
	on_split_refresh_li      "widget/connector" { event = EndQuery; target = line_item_osrc; action = Refresh; }
	on_split_refresh_content "widget/connector" { event = EndQuery; target = content_osrc;   action = Refresh; }
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
	
	on_unsplit_refresh_li      "widget/connector" { event = EndQuery; target = line_item_osrc; action = Refresh; }
	on_unsplit_refresh_content "widget/connector" { event = EndQuery; target = content_osrc;   action = Refresh; }
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
