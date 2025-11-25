$Version=2$
a_currency_exch_rate "application/filespec"
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
    a_ledger_number "filespec/column" { type=char(10); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    a_base_currency_code "filespec/column" { type=char(3); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_exch_rate "filespec/column" { type=float; id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    a_foreign_currency_code "filespec/column" { type=char(3); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_exch_rate_date "filespec/column" { type=datetime; id=10; }
    }
