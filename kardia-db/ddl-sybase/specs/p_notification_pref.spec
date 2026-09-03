$Version=2$
p_notification_pref "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_notification_pref";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_notify_type "filespec/column" { type=string; id=1; }
    p_notify_method "filespec/column" { type=integer; id=2; }
    p_notify_method_item "filespec/column" { type=integer; id=3; }
    p_recip_partner_key "filespec/column" { type=string; id=4; }
    p_recip_contact_id "filespec/column" { type=integer; id=5; }
    p_enabled "filespec/column" { type=integer; id=6; }
    p_frequency "filespec/column" { type=integer; id=7; }
    p_pause_until_date "filespec/column" { type=datetime; id=8; }
    p_pause_discard "filespec/column" { type=integer; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
