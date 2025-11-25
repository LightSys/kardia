$Version=2$
p_church "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    p_approximate_size "filespec/column" { type=integer; id=6; }
    p_denomination_code "filespec/column" { type=char(3); id=7; }
    p_partner_key "filespec/column" { type=char(10); id=8; }
    }
