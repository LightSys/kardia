$Version=2$
t_task "application/filespec"
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
    t_task_percent "filespec/column" { type=float; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    t_task_state "filespec/column" { type=integer; id=5; }
    t_task_id "filespec/column" { type=integer; id=6; }
    t_task_hours "filespec/column" { type=float; id=7; }
    t_task_label "filespec/column" { type=varchar(64); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    t_project_id "filespec/column" { type=integer; id=10; }
    t_task_desc "filespec/column" { type=varchar(900); id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    t_sprint_id "filespec/column" { type=integer; id=13; }
    }
