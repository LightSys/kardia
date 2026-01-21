$Version=2$
p_address_format_set "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    p_address_set "filespec/column" { type=char(10); id=3; }
    p_address_set_desc "filespec/column" { type=char(255); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    p_is_active "filespec/column" { type=bit; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    }
