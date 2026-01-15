$Version=2$
t_task_state "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    t_task_state_label "filespec/column" { type=varchar(64); id=2; }
    t_task_state_id "filespec/column" { type=integer; id=3; }
    t_task_state_type "filespec/column" { type=char(1); id=4; }
    s_modified_by "filespec/column" { type=varchar(20); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    t_task_state_sequence "filespec/column" { type=integer; id=9; }
    }
