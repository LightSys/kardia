$Version=2$
a_fund_acct "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_fund_acct";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_period "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_account_code "filespec/column" { type=string; id=4; }
    a_fund_acct_class "filespec/column" { type=string; id=5; }
    a_opening_balance "filespec/column" { type=money; id=6; }
    a_current_balance "filespec/column" { type=money; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
