$Version=2$
a_payroll_item_import "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_item_import";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_payroll_id "filespec/column" { type=integer; id=1; }
    a_payroll_item_id "filespec/column" { type=integer; id=2; }
    a_payroll_item_type_code "filespec/column" { type=string; id=3; }
    a_is_instance "filespec/column" { type=integer; id=4; }
    a_period "filespec/column" { type=string; id=5; }
    a_effective_date "filespec/column" { type=datetime; id=6; }
    a_target_amount "filespec/column" { type=money; id=7; }
    a_actual_amount "filespec/column" { type=money; id=8; }
    a_minimum_amount "filespec/column" { type=money; id=9; }
    a_percent "filespec/column" { type=double; id=10; }
    a_filing_status "filespec/column" { type=string; id=11; }
    a_allowances "filespec/column" { type=integer; id=12; }
    a_dependent_allowances "filespec/column" { type=integer; id=13; }
    a_ref_fund "filespec/column" { type=string; id=14; }
    a_ref_account_code "filespec/column" { type=string; id=15; }
    a_xfer_fund "filespec/column" { type=string; id=16; }
    a_xfer_account_code "filespec/column" { type=string; id=17; }
    a_start_date "filespec/column" { type=datetime; id=18; }
    a_end_date "filespec/column" { type=datetime; id=19; }
    s_date_created "filespec/column" { type=datetime; id=20; }
    s_created_by "filespec/column" { type=string; id=21; }
    s_date_modified "filespec/column" { type=datetime; id=22; }
    s_modified_by "filespec/column" { type=string; id=23; }
    __cx_osml_control "filespec/column" { type=string; id=24; }
    }
