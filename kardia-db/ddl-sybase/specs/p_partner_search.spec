$Version=2$
p_partner_search "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    p_search_id "filespec/column" { type=integer; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    p_search_desc "filespec/column" { type=varchar(255); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    p_search_visibility "filespec/column" { type=char(1); id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    p_is_temporary "filespec/column" { type=bit; id=9; }
    }
