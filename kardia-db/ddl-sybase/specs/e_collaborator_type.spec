$Version=2$
e_collaborator_type "application/filespec"
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
    e_collab_type_label "filespec/column" { type=varchar(40); id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    e_collab_type_id "filespec/column" { type=integer; id=5; }
    e_collab_type_desc "filespec/column" { type=varchar(255); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    }
