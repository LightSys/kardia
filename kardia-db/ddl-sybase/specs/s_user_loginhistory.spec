$Version=2$
s_user_loginhistory "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_user_loginhistory";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_username "filespec/column" { type=string; id=1; }
    s_sessionid "filespec/column" { type=integer; id=2; }
    s_first_seen "filespec/column" { type=datetime; id=3; }
    s_last_seen "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
