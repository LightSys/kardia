$Version=2$
c_message "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    c_message "filespec/column" { type=varchar(1024); id=6; }
    c_message_id "filespec/column" { type=integer; id=7; }
    c_chat_id "filespec/column" { type=integer; id=8; }
    }
