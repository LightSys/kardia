$Version=2$
s_sec_endorsement "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    s_subject "filespec/column" { type=varchar(20); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    s_endorsement "filespec/column" { type=varchar(64); id=4; }
    s_context "filespec/column" { type=varchar(255); id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    }
