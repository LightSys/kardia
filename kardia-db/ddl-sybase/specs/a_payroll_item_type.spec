$Version=2$
a_payroll_item_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_item_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_item_type_code "filespec/column" { type=string; id=2; }
    a_payroll_item_class_code "filespec/column" { type=string; id=3; }
    a_payroll_item_subclass_code "filespec/column" { type=string; id=4; }
    a_payroll_item_form_sequence "filespec/column" { type=integer; id=5; }
    a_ref_account_code "filespec/column" { type=string; id=6; }
    a_xfer_fund "filespec/column" { type=string; id=7; }
    a_xfer_account_code "filespec/column" { type=string; id=8; }
    a_state_province "filespec/column" { type=string; id=9; }
    a_desc "filespec/column" { type=string; id=10; }
    a_exempt_from_tax "filespec/column" { type=string; id=11; }
    a_comment "filespec/column" { type=string; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
