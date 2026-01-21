$Version=2$
a_payroll_item_import "application/filespec"
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
    a_target_amount "filespec/column" { type=decimal(14,4); id=1; }
    a_filing_status "filespec/column" { type=char(1); id=2; }
    a_start_date "filespec/column" { type=datetime; id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_xfer_account_code "filespec/column" { type=char(10); id=6; }
    a_xfer_fund "filespec/column" { type=char(20); id=7; }
    a_percent "filespec/column" { type=float; id=8; }
    a_ref_fund "filespec/column" { type=char(20); id=9; }
    a_ref_account_code "filespec/column" { type=char(10); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    a_effective_date "filespec/column" { type=datetime; id=12; }
    a_payroll_item_type_code "filespec/column" { type=char(4); id=13; }
    a_minimum_amount "filespec/column" { type=decimal(14,4); id=14; }
    a_end_date "filespec/column" { type=datetime; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    a_actual_amount "filespec/column" { type=decimal(14,4); id=17; }
    a_period "filespec/column" { type=char(8); id=18; }
    a_payroll_item_id "filespec/column" { type=integer; id=19; }
    a_dependent_allowances "filespec/column" { type=integer; id=20; }
    s_modified_by "filespec/column" { type=varchar(20); id=21; }
    a_allowances "filespec/column" { type=integer; id=22; }
    a_is_instance "filespec/column" { type=bit; id=23; }
    a_payroll_id "filespec/column" { type=integer; id=24; }
    }
