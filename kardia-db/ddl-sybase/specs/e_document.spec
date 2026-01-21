$Version=2$
e_document "application/filespec"
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
    e_current_filename "filespec/column" { type=varchar(255); id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    e_image_width "filespec/column" { type=integer; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    e_doc_type_id "filespec/column" { type=integer; id=6; }
    e_current_folder "filespec/column" { type=varchar(255); id=7; }
    e_orig_filename "filespec/column" { type=varchar(255); id=8; }
    e_title "filespec/column" { type=varchar(80); id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    e_image_height "filespec/column" { type=integer; id=11; }
    e_workflow_instance_id "filespec/column" { type=integer; id=12; }
    s_modified_by "filespec/column" { type=varchar(20); id=13; }
    e_uploading_collaborator "filespec/column" { type=char(10); id=14; }
    e_document_id "filespec/column" { type=integer; id=15; }
    }
