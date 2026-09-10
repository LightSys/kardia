$Version=2$
p_notification_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_notification_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_notify_type "filespec/column" { type=string; id=1; }
    p_notify_type_label "filespec/column" { type=string; id=2; }
    p_notify_type_desc "filespec/column" { type=string; id=3; }
    p_message "filespec/column" { type=string; id=4; }
    p_object_label "filespec/column" { type=string; id=5; }
    p_data_1_label "filespec/column" { type=string; id=6; }
    p_data_2_label "filespec/column" { type=string; id=7; }
    p_data_3_label "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
