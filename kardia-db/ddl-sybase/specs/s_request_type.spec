$Version=2$
s_request_type "application/filespec"
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
    s_request_type "filespec/column" { type=char(10); id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    s_request_type_desc "filespec/column" { type=varchar(255); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    s_request_sec_endorsement "filespec/column" { type=varchar(64); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    }
