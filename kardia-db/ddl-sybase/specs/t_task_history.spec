$Version=2$
t_task_history "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_task_history";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_task_id "filespec/column" { type=integer; id=1; }
    t_history_id "filespec/column" { type=integer; id=2; }
    t_task_state_id "filespec/column" { type=integer; id=3; }
    t_task_hours "filespec/column" { type=double; id=4; }
    t_task_percent "filespec/column" { type=double; id=5; }
    t_transition_date "filespec/column" { type=datetime; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
