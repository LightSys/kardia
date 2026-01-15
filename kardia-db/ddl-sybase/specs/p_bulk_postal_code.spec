$Version=2$
p_bulk_postal_code "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=2; }
    p_bulk_postal_code_description "filespec/column" { type=varchar(255); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    p_bulk_postal_code "filespec/column" { type=varchar(10); id=5; }
    p_bulk_code "filespec/column" { type=varchar(10); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    p_bulk_range "filespec/column" { type=varchar(20); id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    p_country_code "filespec/column" { type=varchar(2); id=10; }
    p_zip_state "filespec/column" { type=char(2); id=11; }
    }
