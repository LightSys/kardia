$Version=2$
p_notification "application/filespec"
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
    p_notify_type "filespec/column" { type=varchar(4); id=1; }
    p_event_date "filespec/column" { type=datetime; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    p_response "filespec/column" { type=varchar(900); id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    p_message "filespec/column" { type=varchar(900); id=6; }
    p_status "filespec/column" { type=char(1); id=7; }
    p_sent_date "filespec/column" { type=datetime; id=8; }
    p_source_partner_key "filespec/column" { type=varchar(10); id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    p_object_id "filespec/column" { type=varchar(255); id=11; }
    p_contact_data "filespec/column" { type=varchar(255); id=12; }
    p_notify_method "filespec/column" { type=integer; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    p_notify_method_item "filespec/column" { type=integer; id=16; }
    p_ack_date "filespec/column" { type=datetime; id=17; }
    p_recip_partner_key "filespec/column" { type=varchar(10); id=18; }
    p_notify_id "filespec/column" { type=integer; id=19; }
    p_contact_id "filespec/column" { type=integer; id=20; }
    }
