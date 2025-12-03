$Version=2$
p_notification_pref "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "Obfuscated Data";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    p_pause_discard "filespec/column" { type=bit; id=2; }
    p_notify_method "filespec/column" { type=integer; id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    p_recip_contact_id "filespec/column" { type=integer; id=5; }
    p_notify_type "filespec/column" { type=varchar(4); id=6; }
    p_pause_until_date "filespec/column" { type=datetime; id=7; }
    p_recip_partner_key "filespec/column" { type=varchar(10); id=8; }
    p_enabled "filespec/column" { type=bit; id=9; }
    p_frequency "filespec/column" { type=integer; id=10; }
    p_notify_method_item "filespec/column" { type=integer; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=14; }
    }
