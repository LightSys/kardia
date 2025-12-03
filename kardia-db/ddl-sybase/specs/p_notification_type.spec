$Version=2$
p_notification_type "application/filespec"
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
    p_notify_type_desc "filespec/column" { type=varchar(255); id=2; }
    p_notify_type "filespec/column" { type=varchar(4); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    p_object_label "filespec/column" { type=varchar(255); id=5; }
    p_message "filespec/column" { type=varchar(900); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    p_notify_type_label "filespec/column" { type=varchar(10); id=10; }
    }
