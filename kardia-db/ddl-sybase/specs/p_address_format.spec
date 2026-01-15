$Version=2$
p_address_format "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    p_country_code "filespec/column" { type=char(2); id=2; }
    p_address_set "filespec/column" { type=char(10); id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    p_format "filespec/column" { type=varchar(1024); id=8; }
    }
