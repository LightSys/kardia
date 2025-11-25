$Version=2$
a_payroll_period "application/filespec"
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
    a_payroll_period_comment "filespec/column" { type=varchar(255); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    a_payroll_group_id "filespec/column" { type=integer; id=3; }
    a_ledger_number "filespec/column" { type=char(10); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_checks_batch_number "filespec/column" { type=integer; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    a_start_date "filespec/column" { type=datetime; id=8; }
    a_payroll_period_desc "filespec/column" { type=varchar(40); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    a_batch_number "filespec/column" { type=integer; id=11; }
    a_accrual_date "filespec/column" { type=datetime; id=12; }
    a_base_on_period "filespec/column" { type=char(12); id=13; }
    a_payroll_period "filespec/column" { type=char(12); id=14; }
    a_pay_date "filespec/column" { type=datetime; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    a_posted "filespec/column" { type=bit; id=17; }
    a_period "filespec/column" { type=char(8); id=18; }
    a_end_date "filespec/column" { type=datetime; id=19; }
    }
