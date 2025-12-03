$Version=2$
e_document_type "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    e_doc_type_id "filespec/column" { type=integer; id=3; }
    e_parent_doc_type_id "filespec/column" { type=integer; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    e_doc_type_desc "filespec/column" { type=varchar(255); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    e_doc_type_label "filespec/column" { type=varchar(40); id=9; }
    }
