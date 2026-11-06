$Version=2$
e_document_comment "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_document_comment";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_document_id "filespec/column" { type=integer; id=1; }
    e_doc_comment_id "filespec/column" { type=integer; id=2; }
    e_comments "filespec/column" { type=string; id=3; }
    e_collaborator "filespec/column" { type=string; id=4; }
    e_workflow_state_id "filespec/column" { type=integer; id=5; }
    e_target_collaborator "filespec/column" { type=string; id=6; }
    e_target_review_period "filespec/column" { type=integer; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
