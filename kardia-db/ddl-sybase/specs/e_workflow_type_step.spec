$Version=2$
e_workflow_type_step "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_workflow_type_step";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_workflow_step_id "filespec/column" { type=integer; id=1; }
    e_workflow_id "filespec/column" { type=integer; id=2; }
    e_workflow_step_label "filespec/column" { type=string; id=3; }
    e_workflow_step_desc "filespec/column" { type=string; id=4; }
    e_workflow_step_trigger "filespec/column" { type=integer; id=5; }
    e_workflow_step_trigger_type "filespec/column" { type=string; id=6; }
    e_collaborator "filespec/column" { type=string; id=7; }
    e_workflow_step_days "filespec/column" { type=integer; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
