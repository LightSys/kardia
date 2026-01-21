$Version=2$
e_workflow "application/filespec"
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
    e_workflow_id "filespec/column" { type=integer; id=1; }
    e_workflow_instance_id "filespec/column" { type=integer; id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    e_workflow_step_id "filespec/column" { type=integer; id=4; }
    e_workflow_step_start "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    e_workflow_start "filespec/column" { type=datetime; id=10; }
    e_workflow_step_trigger_id "filespec/column" { type=integer; id=11; }
    e_workflow_trigger_id "filespec/column" { type=integer; id=12; }
    e_workflow_trigger_type "filespec/column" { type=varchar(4); id=13; }
    }
