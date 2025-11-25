$Version=2$
t_sprint "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    t_sprint_label "filespec/column" { type=varchar(64); id=5; }
    t_sprint_start "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    t_sprint_id "filespec/column" { type=integer; id=8; }
    t_sprint_end "filespec/column" { type=datetime; id=9; }
    }
