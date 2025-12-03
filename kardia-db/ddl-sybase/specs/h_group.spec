$Version=2$
h_group "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    h_group_comments "filespec/column" { type=varchar(900); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    h_group_label "filespec/column" { type=varchar(64); id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    h_group_id "filespec/column" { type=integer; id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    }
