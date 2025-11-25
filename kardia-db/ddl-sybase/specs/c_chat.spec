$Version=2$
c_chat "application/filespec"
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
    c_last_message_id "filespec/column" { type=integer; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    c_public "filespec/column" { type=char(1); id=4; }
    c_last_send "filespec/column" { type=datetime; id=5; }
    c_chat_id "filespec/column" { type=integer; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    c_title "filespec/column" { type=varchar(30); id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    }
