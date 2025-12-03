$Version=2$
t_task_history "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    t_task_state_id "filespec/column" { type=integer; id=2; }
    t_task_hours "filespec/column" { type=float; id=3; }
    t_history_id "filespec/column" { type=integer; id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    t_task_id "filespec/column" { type=integer; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    t_task_percent "filespec/column" { type=float; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    t_transition_date "filespec/column" { type=datetime; id=11; }
    }
