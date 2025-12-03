$Version=2$
a_payroll_form_group "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    a_payroll_form_group_name "filespec/column" { type=varchar(80); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_payroll_form_sequence "filespec/column" { type=integer; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    a_payroll_form_desc "filespec/column" { type=varchar(255); id=8; }
    a_payroll_item_type_code "filespec/column" { type=char(3); id=9; }
    a_ledger_number "filespec/column" { type=char(8); id=10; }
    }
