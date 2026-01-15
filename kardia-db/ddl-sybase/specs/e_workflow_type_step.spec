$Version=2$
e_workflow_type_step "application/filespec"
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
    e_workflow_step_trigger "filespec/column" { type=integer; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    e_workflow_step_trigger_type "filespec/column" { type=varchar(4); id=5; }
    e_collaborator "filespec/column" { type=char(10); id=6; }
    e_workflow_step_label "filespec/column" { type=varchar(40); id=7; }
    e_workflow_step_desc "filespec/column" { type=varchar(255); id=8; }
    e_workflow_step_id "filespec/column" { type=integer; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    e_workflow_id "filespec/column" { type=integer; id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    e_workflow_step_days "filespec/column" { type=integer; id=13; }
    }
