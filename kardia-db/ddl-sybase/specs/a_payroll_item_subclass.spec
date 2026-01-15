$Version=2$
a_payroll_item_subclass "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_payroll_item_class_code "filespec/column" { type=char(1); id=4; }
    a_desc "filespec/column" { type=varchar(32); id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    a_payroll_item_subclass_code "filespec/column" { type=char(2); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    }
