$Version=2$
e_document_comment "application/filespec"
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
    e_document_id "filespec/column" { type=integer; id=1; }
    e_workflow_state_id "filespec/column" { type=integer; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    e_target_review_period "filespec/column" { type=integer; id=4; }
    e_doc_comment_id "filespec/column" { type=integer; id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    e_collaborator "filespec/column" { type=char(10); id=7; }
    e_target_collaborator "filespec/column" { type=char(10); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    e_comments "filespec/column" { type=varchar(999); id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    }
