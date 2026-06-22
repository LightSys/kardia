$Version=2$
// The main content table used in the Gift Associations app.
// Integrates with the containing window, using its filter bar, "Add Override"
// button, and the Line Item Details window.
// 
// Note: Assumes connectors activate in the order they are defined.
gift_associations_table "widget/component-decl"
    {
    width = 960; height = 590;
    
    expose_actions_for = content_osrc;
    expose_properties_for = content_osrc;
    
    ledger "widget/parameter" { type = string; deploy_to_client = yes; }
    
    // Parameters for linking to widgets on containing page.
    filter_search_box       "widget/parameter" { type = object; } // The search box widget used to filter entries.
    filter_service_dropdown "widget/parameter" { type = object; } // The dropdown widget used to filter by service.
    line_item_window        "widget/parameter" { type = object; } // The window that the Line Item Details button opens.
    line_item_osrc          "widget/parameter" { type = object; } // OSRC of the shared Line Item Details window; for querying the selected trx.
    
    // History mode: Used internally for by the Association History button.
    // When is_history is set to 1, the table shows only one gift's
    // association history (hiding the Association History button).
    // The gift id itself is delivered at runtime via show_gift_history.
    is_history "widget/parameter" { type = integer; default = 0; }
    gift_id_var "widget/variable" { type = string; value = runclient(""); }
    
    // Action to add a new blank override entry to the table.
    add_override "widget/component-decl-action" {}
    on_add_override_set_tab "widget/connector"
	{
	source = gift_associations_table;
	event = add_override;
	target = edit_tab;
	action = SetTab;
	TabIndex = 3;
	}
    on_add_override_new "widget/connector"
	{
	source = gift_associations_table;
	event = add_override;
	target = edit_form;
	action = New;
	}
    
    // Action to refresh the table content using the current values of the
    // search and service filters.
    trigger_search "widget/component-decl-action" {}
    on_trigger_search "widget/connector"
	{
	source = gift_associations_table;
	event = trigger_search;
	target = content_osrc;
	action = QueryText;
	    
	cx__case_insensitive = 1;
	objname = runclient("eg");
	field_list = ""
	    + "p_donor_partner_key,"
	    + "*i_eg_desig_name*,"
	    + "*i_eg_desig_notes*,"
	    + "*i_eg_donor_name*,"
	    + "*i_eg_donor_given_name*,"
	    + "*i_eg_donor_surname*,"
	    + "*i_eg_donor_middle_name*,"
	    + "*i_eg_donor_email*,"
	    + "*i_eg_donor_address*,"
	    + "*i_eg_donor_addr1*,"
	    + "*i_eg_donor_addr2*,"
	    + "*i_eg_donor_addr3*,"
	    + "i_eg_donor_city,"
	    + "i_eg_donor_state,"
	    + "i_eg_donor_phone";
	query = runclient(:filter_search_box:content);
	}
	
    // History mode: The parent (default copy) calls show_gift_history on the
    // nested copy, passing the clicked gift id; we store it and re-query.
    show_gift_history "widget/component-decl-action" {}
    on_show_gift_history_set "widget/connector"
	{
	source = gift_associations_table;
	event  = show_gift_history;
	target = gift_id_var;
	action = SetValue;
	Value  = runclient(:GiftId);
	}
    on_show_gift_history_query "widget/connector"
	{
	source = gift_associations_table;
	event  = show_gift_history;
	target = content_osrc;
	action = QueryParam;
	}
    
    // Refresh the visible table(s) after a line item is saved in the shared
    // Line Item window.
    refresh_tables "widget/component-decl-action" {}
    on_refresh_tables_content "widget/connector"
	{
	source = gift_associations_table;
	event  = refresh_tables;
	target = content_osrc;
	action = Refresh;
	}
    on_refresh_tables_history "widget/connector"
	{
	// Pass on the event to the nested history table, unless
	// we are that table.
	condition = runserver(:this:is_history == 0);
	source = gift_associations_table;
	event  = refresh_tables;
	target = history_table;
	action = Refresh;
	}
    
    content_osrc "widget/osrc"
	{
	filter_service_param "widget/parameter"
	    {
	    condition = runserver(:this:is_history == 0);
	    param_name = service;
	    type = string;
	    default = runclient(:filter_service_dropdown:value);
	    }
	
	filter_override_only_param "widget/parameter"
	    {
	    condition = runserver(:this:is_history == 0);
	    param_name = override_only;
	    type = integer;
	    default = runclient(condition(:filter_search_box:content = '', 1, 0));
	    }
	
	// History mode: filter to a single gift, fed by gift_id_var at runtime.
	gift_id_param "widget/parameter"
	    {
	    condition = runserver(:this:is_history == 1);
	    param_name = gift_id;
	    type = string;
	    default = runclient(:gift_id_var:value);
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
		is_override = (lower(ltrim(rtrim(:eg:i_eg_status))) = 'override'),
		
		-- Table column display fields.
		donor_service_name = ''
		    + isnull(nullif(:eg:i_eg_donor_name, ''), '??')
		    + isnull(' (' + nullif(:eg:i_eg_donor_address, '') + ')', ''),
		donor_service_desig_caption = condition(
		    :eg:i_eg_gift_amount = :eg:i_eg_deposit_gross_amt,
		    ''  + isnull(nullif(:eg:i_eg_desig_name, '') + ' ', '')
			+ isnull('(' + nullif(:eg:i_eg_desig_uuid, '') + ')', ''),
		    'multiple (' + count(1) + ')'
		),
		donor_kardia_name = ''
		    + isnull(nullif(:p:p_given_name, '') + ' ', '')
		    + isnull(nullif(:p:p_surname,    '') + ' ', '')
		    + isnull(nullif(:p:p_org_name,   '') + ' ', '')
		    + '('
		    + isnull(nullif(:eg:p_donor_partner_key, ''), '??')
		    + ')',
		donor_kardia_desig_caption = condition(
		    :eg:i_eg_gift_amount = :eg:i_eg_deposit_gross_amt,
		    ''  + isnull(nullif(:f:a_fund_desc, '') + ' ', '')
			+ isnull('(' + nullif(:eg:a_fund, '') + ')', ''),
		    'multiple (' + count(1) + ')'
		),
		amount = isnull(:eg:i_eg_deposit_gross_amt, '??'),
		amount_caption = isnull(:eg:i_eg_deposit_amt, '??'),
		status = isnull(upper(ltrim(rtrim(nullif(:eg:i_eg_status, '')))), '??'),
		service = isnull(:eg:i_eg_service, ''),
		gift_id = nullif(condition(
		    char_length(:eg:i_eg_gift_uuid) > 12,
		    substring(:eg:i_eg_gift_uuid, 1, 12) + '...',
		    :eg:i_eg_gift_uuid
		), '??'),
		gift_date = isnull(dateformat(:eg:i_eg_gift_date, 'M/d/yyyy'), '??'),
		
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
		" + condition(:this:is_history = 1,
		    ":eg:i_eg_gift_uuid = :parameters:gift_id",
		    "(:parameters:override_only = 0 OR lower(:eg:i_eg_status) = 'override') AND "
		  + "(:parameters:service = 'any'   OR :eg:i_eg_service = :parameters:service)"
		) + "
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
	x = 0; y = 0; width = 960; height = 590;
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
			    
			    // Open the shared Line Item window, then load the selected trx
			    // into its OSRC by querying it directly.
			    open_line_item_window "widget/connector"
				{
				event = Click;
				target = line_item_window;
				action = Open;
				}
			    query_line_items "widget/connector"
				{
				event = Click;
				target = line_item_osrc;
				action = QueryParam;
				target_trx_uuid = runclient(:content_osrc:i_eg_trx_uuid);
				}
			    }
			
			history_button "widget/textbutton"
			    {
			    // Not visible in history mode.
			    condition = runserver(:this:is_history == 0);
			    x = 0; width = 140; height = 23; // y = button_col
			    border_radius = 5;
			    text = "Association History";
			    enabled = runclient(not :edit_form:is_discardable);
			    
			    // Pass the clicked gift id to the nested history cmp, then open
			    // its popup window.
			    show_history_connector "widget/connector"
				{
				event = Click;
				target = history_table;
				action = show_gift_history;
				GiftId = runclient(:content_osrc:i_eg_gift_uuid);
				}
			    open_history_window_connector "widget/connector"
				{
				event = Click;
				target = history_window;
				action = Open;
				}
			    }
			}
		    }
		}
	    }
	}
    
    // Popup showing one gift's full association history, using a nested copy
    // of this component set to history mode.
    history_window "widget/childwindow"
	{
	condition = runserver(:this:is_history == 0);
	x = 0; y = 0; width = 960; height = 600;
	title = "Association History";
	style = dialog;
	toplevel = yes;
	modal = yes;
	visible = no;
	
	// Info for the entry whose Association History button was clicked.
	history_header "widget/hbox"
	    {
	    x = 15; y = 5; width = 940; height = 30; spacing = 10;
	    
	    hdr_gift_id       "widget/label" { y = 5; width = 150; height = 20; value = runclient("Gift ID: "       + :content_osrc:gift_id); }
	    hdr_service_donor "widget/label" { y = 5; width = 240; height = 20; value = runclient("Service Donor: " + :content_osrc:donor_service_name); }
	    hdr_kardia_donor  "widget/label" { y = 5; width = 240; height = 20; value = runclient("Kardia Donor: "  + :content_osrc:donor_kardia_name); }
	    hdr_deposit       "widget/label" { y = 5; width = 130; height = 20; value = runclient("Gross Deposit: " + :content_osrc:amount); }
	    hdr_service       "widget/label" { y = 5; width = 100; height = 20; value = runclient("Service: "       + :content_osrc:service); }
	    }
	
	// Nested copy (in history mode).
	history_table "widget/component"
	    {
	    x = 10; y = 40; width = 940; height = 550;
	    path = "/apps/kardia/modules/rcpt/gift_associations_table.cmp";
	    mode = static;
	    
	    is_history = 1;
	    ledger = runserver(:this:ledger);
	    line_item_window = line_item_window;
	    line_item_osrc = line_item_osrc;
	    }
	}
    
    // Reset our tab display when the form leaves "New" mode and focus is
    // returned to the previously selected record.
    on_exit_new_mode_set_tab "widget/connector"
	{
	source = edit_form;
	event  = ModeChange;
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
