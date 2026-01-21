$Version=2$
t_project "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    t_project_start "filespec/column" { type=datetime; id=4; }
    t_parent_project_id "filespec/column" { type=integer; id=5; }
    t_project_desc "filespec/column" { type=varchar(900); id=6; }
    t_project_status "filespec/column" { type=char(1); id=7; }
    t_project_id "filespec/column" { type=integer; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    t_project_color "filespec/column" { type=varchar(32); id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    t_project_end "filespec/column" { type=datetime; id=12; }
    t_project_label "filespec/column" { type=varchar(64); id=13; }
    }
