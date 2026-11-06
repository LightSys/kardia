$Version=2$
t_task "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_task";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_task_id "filespec/column" { type=integer; id=1; }
    t_sprint_id "filespec/column" { type=integer; id=2; }
    t_project_id "filespec/column" { type=integer; id=3; }
    t_task_label "filespec/column" { type=string; id=4; }
    t_task_desc "filespec/column" { type=string; id=5; }
    t_task_hours "filespec/column" { type=double; id=6; }
    t_task_percent "filespec/column" { type=double; id=7; }
    t_task_state "filespec/column" { type=integer; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
