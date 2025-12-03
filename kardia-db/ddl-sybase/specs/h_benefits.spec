$Version=2$
h_benefits "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    h_benefit_period_id "filespec/column" { type=integer; id=3; }
    h_carried_over "filespec/column" { type=integer; id=4; }
    h_benefit_type_sched_id "filespec/column" { type=integer; id=5; }
    h_newly_accrued "filespec/column" { type=integer; id=6; }
    h_benefit_type_id "filespec/column" { type=integer; id=7; }
    p_partner_key "filespec/column" { type=char(10); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    }
