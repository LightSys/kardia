$Version=2$
c_chat "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for c_chat";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    c_chat_id "filespec/column" { type=integer; id=1; }
    c_last_send "filespec/column" { type=datetime; id=2; }
    c_last_message_id "filespec/column" { type=integer; id=3; }
    c_public "filespec/column" { type=string; id=4; }
    c_title "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
