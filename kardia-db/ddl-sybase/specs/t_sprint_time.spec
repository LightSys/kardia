$Version=2$
t_sprint_time "application/filespec"
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
    t_time_hours "filespec/column" { type=float; id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    t_time_id "filespec/column" { type=integer; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    t_sprint_id "filespec/column" { type=integer; id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    t_time_start "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    t_project_id "filespec/column" { type=integer; id=10; }
    }
