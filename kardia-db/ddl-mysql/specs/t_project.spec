$Version=2$
t_project "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_project";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_project_id "filespec/column" { type=integer; id=1; }
    t_parent_project_id "filespec/column" { type=integer; id=2; }
    t_project_label "filespec/column" { type=string; id=3; }
    t_project_desc "filespec/column" { type=string; id=4; }
    t_project_start "filespec/column" { type=datetime; id=5; }
    t_project_end "filespec/column" { type=datetime; id=6; }
    t_project_color "filespec/column" { type=string; id=7; }
    t_project_status "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
