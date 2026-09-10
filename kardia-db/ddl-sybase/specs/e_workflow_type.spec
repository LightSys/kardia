$Version=2$
e_workflow_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_workflow_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_workflow_id "filespec/column" { type=integer; id=1; }
    e_workflow_label "filespec/column" { type=string; id=2; }
    e_workflow_desc "filespec/column" { type=string; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_created_by "filespec/column" { type=string; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=string; id=7; }
    __cx_osml_control "filespec/column" { type=string; id=8; }
    }
