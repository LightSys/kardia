$Version=2$
p_notification_method "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_notification_method";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_notify_method "filespec/column" { type=integer; id=1; }
    p_notify_method_label "filespec/column" { type=string; id=2; }
    p_notify_method_desc "filespec/column" { type=string; id=3; }
    p_allowed_contact_types "filespec/column" { type=string; id=4; }
    p_expects_ack "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
