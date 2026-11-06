$Version=2$
t_sprint_time "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_sprint_time";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_time_id "filespec/column" { type=integer; id=1; }
    t_sprint_id "filespec/column" { type=integer; id=2; }
    t_project_id "filespec/column" { type=integer; id=3; }
    t_time_start "filespec/column" { type=datetime; id=4; }
    t_time_hours "filespec/column" { type=double; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
