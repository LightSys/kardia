$Version=2$
e_tag_type_relationship "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    e_tag_id "filespec/column" { type=integer; id=4; }
    e_rel_tag_id "filespec/column" { type=integer; id=5; }
    e_rel_certainty "filespec/column" { type=float; id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    e_rel_strength "filespec/column" { type=float; id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    }
