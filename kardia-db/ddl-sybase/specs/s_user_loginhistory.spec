$Version=2$
s_user_loginhistory "application/filespec"
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
    s_last_seen "filespec/column" { type=datetime; id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_username "filespec/column" { type=varchar(20); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_first_seen "filespec/column" { type=datetime; id=8; }
    s_sessionid "filespec/column" { type=integer; id=9; }
    }
