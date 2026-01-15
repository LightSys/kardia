$Version=2$
e_tag_type "application/filespec"
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
    e_is_active "filespec/column" { type=bit; id=1; }
    e_tag_threshold "filespec/column" { type=float; id=2; }
    e_tag_id "filespec/column" { type=integer; id=3; }
    e_tag_desc "filespec/column" { type=varchar(255); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    e_tag_label "filespec/column" { type=varchar(40); id=10; }
    }
