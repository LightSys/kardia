$Version=2$
s_motd "application/filespec"
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
    s_message_title "filespec/column" { type=varchar(255); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_motd_id "filespec/column" { type=integer; id=5; }
    s_message_text "filespec/column" { type=varchar(1536); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    s_valid_days "filespec/column" { type=integer; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    s_enabled "filespec/column" { type=bit; id=10; }
    }
