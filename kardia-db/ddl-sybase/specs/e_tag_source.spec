$Version=2$
e_tag_source "application/filespec"
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
    e_tag_strength "filespec/column" { type=float; id=1; }
    e_tag_certainty "filespec/column" { type=float; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    e_tag_source_key "filespec/column" { type=varchar(255); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    e_tag_id "filespec/column" { type=integer; id=6; }
    e_is_active "filespec/column" { type=bit; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    e_tag_source_type "filespec/column" { type=varchar(32); id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    }
