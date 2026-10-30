$Version=2$
a_payroll_period "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_period";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_group_id "filespec/column" { type=integer; id=2; }
    a_payroll_period "filespec/column" { type=string; id=3; }
    a_period "filespec/column" { type=string; id=4; }
    a_start_date "filespec/column" { type=datetime; id=5; }
    a_end_date "filespec/column" { type=datetime; id=6; }
    a_accrual_date "filespec/column" { type=datetime; id=7; }
    a_pay_date "filespec/column" { type=datetime; id=8; }
    a_payroll_period_desc "filespec/column" { type=string; id=9; }
    a_payroll_period_comment "filespec/column" { type=string; id=10; }
    a_posted "filespec/column" { type=integer; id=11; }
    a_batch_number "filespec/column" { type=integer; id=12; }
    a_checks_batch_number "filespec/column" { type=integer; id=13; }
    a_base_on_period "filespec/column" { type=string; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_created_by "filespec/column" { type=string; id=16; }
    s_date_modified "filespec/column" { type=datetime; id=17; }
    s_modified_by "filespec/column" { type=string; id=18; }
    __cx_osml_control "filespec/column" { type=string; id=19; }
    }
