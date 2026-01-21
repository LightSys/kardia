$Version=2$
a_payroll_period_payee "application/filespec"
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
    a_comment "filespec/column" { type=varchar(255); id=1; }
    a_payroll_id "filespec/column" { type=integer; id=2; }
    a_is_employee "filespec/column" { type=bit; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    p_country_code "filespec/column" { type=char(2); id=5; }
    a_base_hourly_pay "filespec/column" { type=decimal(14,4); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    a_minimum_wage "filespec/column" { type=decimal(14,4); id=8; }
    a_is_exempt "filespec/column" { type=bit; id=9; }
    a_payroll_period "filespec/column" { type=char(12); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    p_state_province "filespec/column" { type=char(2); id=12; }
    a_overtime_hours_worked "filespec/column" { type=float; id=13; }
    a_is_fica "filespec/column" { type=bit; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    a_hours_worked "filespec/column" { type=float; id=17; }
    a_base_pay "filespec/column" { type=decimal(14,4); id=18; }
    a_payroll_group_id "filespec/column" { type=integer; id=19; }
    a_overtime_pay "filespec/column" { type=decimal(14,4); id=20; }
    a_is_salaried "filespec/column" { type=bit; id=21; }
    a_ledger_number "filespec/column" { type=char(10); id=22; }
    }
