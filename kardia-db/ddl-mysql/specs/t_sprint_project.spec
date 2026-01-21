$Version=2$
t_sprint_project "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_sprint_project";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_project_id "filespec/column" { type=integer; id=1; }
    t_sprint_id "filespec/column" { type=integer; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    s_created_by "filespec/column" { type=string; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=string; id=6; }
    __cx_osml_control "filespec/column" { type=string; id=7; }
    }
