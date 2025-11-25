$Version=2$
e_partner_document "application/filespec"
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
    e_workflow_instance_id "filespec/column" { type=integer; id=1; }
    e_image_scale_height "filespec/column" { type=integer; id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    e_document_id "filespec/column" { type=integer; id=4; }
    e_engagement_id "filespec/column" { type=integer; id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    e_image_offset_y "filespec/column" { type=integer; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    e_image_offset_x "filespec/column" { type=integer; id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    p_partner_key "filespec/column" { type=char(10); id=12; }
    e_pardoc_assoc_id "filespec/column" { type=integer; id=13; }
    }
