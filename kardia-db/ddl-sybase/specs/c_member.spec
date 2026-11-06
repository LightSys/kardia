$Version=2$
c_member "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for c_member";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    c_chat_id "filespec/column" { type=integer; id=1; }
    s_username "filespec/column" { type=string; id=2; }
    c_last_read_message_id "filespec/column" { type=integer; id=3; }
    c_status "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
