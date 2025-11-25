$Version=2$
a_receipt_type "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_receipt_type "filespec/column" { type=char(1); id=4; }
    a_is_enabled "filespec/column" { type=bit; id=5; }
    a_receipt_type_desc "filespec/column" { type=varchar(64); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    a_is_default "filespec/column" { type=bit; id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    }
