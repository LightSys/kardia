$Version=2$
a_payroll_import "application/filespec"
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
    a_fund "filespec/column" { type=char(20); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    a_payee_name "filespec/column" { type=char(80); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    a_payroll_interval "filespec/column" { type=char(2); id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    a_start_date "filespec/column" { type=datetime; id=7; }
    a_end_date "filespec/column" { type=datetime; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    a_priority "filespec/column" { type=integer; id=11; }
    p_payee_partner_key "filespec/column" { type=char(10); id=12; }
    s_created_by "filespec/column" { type=varchar(20); id=13; }
    a_payroll_id "filespec/column" { type=integer; id=14; }
    }
