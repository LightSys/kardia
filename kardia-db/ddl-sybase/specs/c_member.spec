$Version=2$
c_member "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    c_chat_id "filespec/column" { type=integer; id=3; }
    c_status "filespec/column" { type=char(1); id=4; }
    c_last_read_message_id "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_username "filespec/column" { type=varchar(20); id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    }
