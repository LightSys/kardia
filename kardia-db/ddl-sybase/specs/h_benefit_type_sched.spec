$Version=2$
h_benefit_type_sched "application/filespec"
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
    h_min_years "filespec/column" { type=integer; id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    h_benefit_type_id "filespec/column" { type=integer; id=4; }
    p_partner_key "filespec/column" { type=char(10); id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    h_carryover_benefits "filespec/column" { type=integer; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    h_usage_increment "filespec/column" { type=integer; id=9; }
    h_accrual_threshold "filespec/column" { type=integer; id=10; }
    h_benefit_mode "filespec/column" { type=char(1); id=11; }
    h_max_years "filespec/column" { type=integer; id=12; }
    h_benefit_type_sched_id "filespec/column" { type=integer; id=13; }
    h_group_id "filespec/column" { type=integer; id=14; }
    s_modified_by "filespec/column" { type=varchar(20); id=15; }
    h_new_benefits "filespec/column" { type=integer; id=16; }
    }
