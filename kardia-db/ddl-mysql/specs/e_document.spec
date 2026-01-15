$Version=2$
e_document "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_document";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_document_id "filespec/column" { type=integer; id=1; }
    e_doc_type_id "filespec/column" { type=integer; id=2; }
    e_title "filespec/column" { type=string; id=3; }
    e_orig_filename "filespec/column" { type=string; id=4; }
    e_current_folder "filespec/column" { type=string; id=5; }
    e_current_filename "filespec/column" { type=string; id=6; }
    e_uploading_collaborator "filespec/column" { type=string; id=7; }
    e_workflow_instance_id "filespec/column" { type=integer; id=8; }
    e_image_width "filespec/column" { type=integer; id=9; }
    e_image_height "filespec/column" { type=integer; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
