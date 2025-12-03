$Version=2$
a_account_usage "application/filespec"
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
    a_account_code "filespec/column" { type=char(16); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    a_acct_usage_code "filespec/column" { type=char(4); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    a_ledger_number "filespec/column" { type=char(10); id=8; }
    }
