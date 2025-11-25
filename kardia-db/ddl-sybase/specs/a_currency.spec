$Version=2$
a_currency "application/filespec"
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
    a_enabled "filespec/column" { type=bit; id=3; }
    a_currency_code "filespec/column" { type=char(3); id=4; }
    a_currency_desc "filespec/column" { type=varchar(64); id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    a_ledger_number "filespec/column" { type=char(10); id=9; }
    }
