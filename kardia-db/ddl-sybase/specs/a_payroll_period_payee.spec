$Version=2$
a_payroll_period_payee "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_payroll_period_payee";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payroll_group_id "filespec/column" { type=integer; id=2; }
    a_payroll_period "filespec/column" { type=string; id=3; }
    a_payroll_id "filespec/column" { type=integer; id=4; }
    a_comment "filespec/column" { type=string; id=5; }
    p_country_code "filespec/column" { type=string; id=6; }
    p_state_province "filespec/column" { type=string; id=7; }
    a_is_employee "filespec/column" { type=integer; id=8; }
    a_is_fica "filespec/column" { type=integer; id=9; }
    a_is_exempt "filespec/column" { type=integer; id=10; }
    a_is_salaried "filespec/column" { type=integer; id=11; }
    a_minimum_wage "filespec/column" { type=money; id=12; }
    a_hours_worked "filespec/column" { type=double; id=13; }
    a_overtime_hours_worked "filespec/column" { type=double; id=14; }
    a_base_hourly_pay "filespec/column" { type=money; id=15; }
    a_base_pay "filespec/column" { type=money; id=16; }
    a_overtime_pay "filespec/column" { type=money; id=17; }
    s_date_created "filespec/column" { type=datetime; id=18; }
    s_created_by "filespec/column" { type=string; id=19; }
    s_date_modified "filespec/column" { type=datetime; id=20; }
    s_modified_by "filespec/column" { type=string; id=21; }
    __cx_osml_control "filespec/column" { type=string; id=22; }
    }
