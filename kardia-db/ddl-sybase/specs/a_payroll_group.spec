$Version=2$
a_payroll_group "application/filespec"
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
    a_cash_fund "filespec/column" { type=char(20); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    a_payroll_interval "filespec/column" { type=char(2); id=3; }
    a_end_date "filespec/column" { type=datetime; id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    a_fund "filespec/column" { type=char(20); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    a_liab_fund "filespec/column" { type=char(20); id=8; }
    a_paydate_delay "filespec/column" { type=integer; id=9; }
    a_service_bureau_id "filespec/column" { type=integer; id=10; }
    a_acct_method "filespec/column" { type=char(1); id=11; }
    a_payroll_group_name "filespec/column" { type=char(80); id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    a_start_date "filespec/column" { type=datetime; id=15; }
    a_payroll_group_id "filespec/column" { type=integer; id=16; }
    a_issue_checks "filespec/column" { type=bit; id=17; }
    a_ledger_number "filespec/column" { type=char(10); id=18; }
    a_service_bureau_group_name "filespec/column" { type=varchar(64); id=19; }
    }
