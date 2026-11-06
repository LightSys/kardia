$Version=2$
a_salary_review "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_salary_review";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_id "filespec/column" { type=integer; id=2; }
    a_review "filespec/column" { type=string; id=3; }
    a_target_payroll "filespec/column" { type=money; id=4; }
    a_interval "filespec/column" { type=integer; id=5; }
    a_percentage "filespec/column" { type=double; id=6; }
    a_actual_payroll "filespec/column" { type=money; id=7; }
    a_comment "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
