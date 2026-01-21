$Version=2$
a_fund_acct "application/filespec"
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
    a_fund_acct_class "filespec/column" { type=char(3); id=2; }
    a_account_code "filespec/column" { type=char(16); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    a_opening_balance "filespec/column" { type=decimal(14,4); id=5; }
    a_fund "filespec/column" { type=char(20); id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    a_period "filespec/column" { type=char(8); id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    a_current_balance "filespec/column" { type=decimal(14,4); id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    }
