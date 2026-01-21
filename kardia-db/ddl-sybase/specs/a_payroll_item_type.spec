$Version=2$
a_payroll_item_type "application/filespec"
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
    a_payroll_item_class_code "filespec/column" { type=char(1); id=1; }
    a_payroll_item_type_code "filespec/column" { type=char(4); id=2; }
    a_state_province "filespec/column" { type=char(2); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    a_exempt_from_tax "filespec/column" { type=varchar(255); id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    a_comment "filespec/column" { type=varchar(255); id=7; }
    a_ledger_number "filespec/column" { type=char(10); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    a_xfer_account_code "filespec/column" { type=char(10); id=11; }
    a_xfer_fund "filespec/column" { type=char(20); id=12; }
    a_payroll_item_form_sequence "filespec/column" { type=integer; id=13; }
    a_desc "filespec/column" { type=varchar(32); id=14; }
    a_ref_account_code "filespec/column" { type=char(10); id=15; }
    a_payroll_item_subclass_code "filespec/column" { type=char(2); id=16; }
    s_created_by "filespec/column" { type=varchar(20); id=17; }
    }
