$Version=2$
a_payroll_group "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_group";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_group_id "filespec/column" { type=integer; id=2; }
    a_payroll_group_name "filespec/column" { type=string; id=3; }
    a_payroll_interval "filespec/column" { type=string; id=4; }
    a_acct_method "filespec/column" { type=string; id=5; }
    a_paydate_delay "filespec/column" { type=integer; id=6; }
    a_fund "filespec/column" { type=string; id=7; }
    a_liab_fund "filespec/column" { type=string; id=8; }
    a_cash_fund "filespec/column" { type=string; id=9; }
    a_issue_checks "filespec/column" { type=integer; id=10; }
    a_service_bureau_id "filespec/column" { type=integer; id=11; }
    a_service_bureau_group_name "filespec/column" { type=string; id=12; }
    a_start_date "filespec/column" { type=datetime; id=13; }
    a_end_date "filespec/column" { type=datetime; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_created_by "filespec/column" { type=string; id=16; }
    s_date_modified "filespec/column" { type=datetime; id=17; }
    s_modified_by "filespec/column" { type=string; id=18; }
    __cx_osml_control "filespec/column" { type=string; id=19; }
    }
