$Version=2$
s_role "application/filespec"
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
    s_role_id "filespec/column" { type=integer; id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    s_role_desc "filespec/column" { type=varchar(255); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    s_role_label "filespec/column" { type=varchar(32); id=8; }
    }
