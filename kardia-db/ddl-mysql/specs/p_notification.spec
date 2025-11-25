$Version=2$
p_notification "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_notification";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_notify_id "filespec/column" { type=integer; id=1; }
    p_notify_type "filespec/column" { type=string; id=2; }
    p_event_date "filespec/column" { type=datetime; id=3; }
    p_object_id "filespec/column" { type=string; id=4; }
    p_message "filespec/column" { type=string; id=5; }
    p_source_partner_key "filespec/column" { type=string; id=6; }
    p_recip_partner_key "filespec/column" { type=string; id=7; }
    p_notify_method "filespec/column" { type=integer; id=8; }
    p_notify_method_item "filespec/column" { type=integer; id=9; }
    p_contact_id "filespec/column" { type=integer; id=10; }
    p_contact_data "filespec/column" { type=string; id=11; }
    p_status "filespec/column" { type=string; id=12; }
    p_sent_date "filespec/column" { type=datetime; id=13; }
    p_ack_date "filespec/column" { type=datetime; id=14; }
    p_response "filespec/column" { type=string; id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    s_created_by "filespec/column" { type=string; id=17; }
    s_date_modified "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=string; id=19; }
    __cx_osml_control "filespec/column" { type=string; id=20; }
    }
