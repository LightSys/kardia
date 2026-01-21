$Version=2$
e_data_highlight "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    e_highlight_subject "filespec/column" { type=varchar(40); id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    e_highlight_object_type "filespec/column" { type=varchar(20); id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    e_highlight_precedence "filespec/column" { type=float; id=7; }
    e_highlight_object_id "filespec/column" { type=varchar(32); id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    }
