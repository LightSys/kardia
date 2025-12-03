$Version=2$
a_salary_review "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    a_interval "filespec/column" { type=integer; id=2; }
    a_actual_payroll "filespec/column" { type=decimal(14,4); id=3; }
    a_comment "filespec/column" { type=varchar(255); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    a_payroll_id "filespec/column" { type=integer; id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_percentage "filespec/column" { type=float; id=8; }
    a_review "filespec/column" { type=varchar(16); id=9; }
    a_target_payroll "filespec/column" { type=decimal(14,4); id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    }
