$Version=2$
t_task_state "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_task_state";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    t_task_state_id "filespec/column" { type=integer; id=1; }
    t_task_state_label "filespec/column" { type=string; id=2; }
    t_task_state_sequence "filespec/column" { type=integer; id=3; }
    t_task_state_type "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
