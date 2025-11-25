$Version=2$
p_notification_method "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    p_expects_ack "filespec/column" { type=bit; id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    p_allowed_contact_types "filespec/column" { type=varchar(32); id=6; }
    p_notify_method_desc "filespec/column" { type=varchar(255); id=7; }
    p_notify_method_label "filespec/column" { type=varchar(10); id=8; }
    p_notify_method "filespec/column" { type=integer; id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    }
