$Version=2$
a_payroll_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_item";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_group_id "filespec/column" { type=integer; id=2; }
    a_payroll_id "filespec/column" { type=integer; id=3; }
    a_payroll_item_id "filespec/column" { type=integer; id=4; }
    a_payroll_item_type_code "filespec/column" { type=string; id=5; }
    a_is_instance "filespec/column" { type=integer; id=6; }
    a_period "filespec/column" { type=string; id=7; }
    a_effective_date "filespec/column" { type=datetime; id=8; }
    a_target_amount "filespec/column" { type=money; id=9; }
    a_actual_amount "filespec/column" { type=money; id=10; }
    a_minimum_amount "filespec/column" { type=money; id=11; }
    a_percent "filespec/column" { type=double; id=12; }
    a_filing_status "filespec/column" { type=string; id=13; }
    a_allowances "filespec/column" { type=integer; id=14; }
    a_dependent_allowances "filespec/column" { type=integer; id=15; }
    a_ref_fund "filespec/column" { type=string; id=16; }
    a_ref_account_code "filespec/column" { type=string; id=17; }
    a_xfer_fund "filespec/column" { type=string; id=18; }
    a_xfer_account_code "filespec/column" { type=string; id=19; }
    a_start_date "filespec/column" { type=datetime; id=20; }
    a_end_date "filespec/column" { type=datetime; id=21; }
    s_date_created "filespec/column" { type=datetime; id=22; }
    s_created_by "filespec/column" { type=string; id=23; }
    s_date_modified "filespec/column" { type=datetime; id=24; }
    s_modified_by "filespec/column" { type=string; id=25; }
    __cx_osml_control "filespec/column" { type=string; id=26; }
    }
