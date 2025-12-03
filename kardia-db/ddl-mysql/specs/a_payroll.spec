$Version=2$
a_payroll "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_group_id "filespec/column" { type=integer; id=2; }
    a_payroll_id "filespec/column" { type=integer; id=3; }
    p_payee_partner_key "filespec/column" { type=string; id=4; }
    a_payee_name "filespec/column" { type=string; id=5; }
    a_priority "filespec/column" { type=integer; id=6; }
    a_payroll_interval "filespec/column" { type=string; id=7; }
    a_fund "filespec/column" { type=string; id=8; }
    a_start_date "filespec/column" { type=datetime; id=9; }
    a_end_date "filespec/column" { type=datetime; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
