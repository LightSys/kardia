$Version=2$
p_zipranges "application/filespec"
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
    p_last_zip "filespec/column" { type=char(5); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    p_state_name "filespec/column" { type=varchar(20); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    p_first_zip "filespec/column" { type=char(5); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    p_state_code "filespec/column" { type=char(2); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    }
