$Version=2$
s_motd_viewed "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_motd_viewed";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_motd_id "filespec/column" { type=integer; id=1; }
    s_username "filespec/column" { type=string; id=2; }
    s_viewed_date "filespec/column" { type=datetime; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_created_by "filespec/column" { type=string; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=string; id=7; }
    __cx_osml_control "filespec/column" { type=string; id=8; }
    }
