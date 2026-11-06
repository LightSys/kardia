$Version=2$
h_benefit_type_sched "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for h_benefit_type_sched";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    h_benefit_type_id "filespec/column" { type=integer; id=1; }
    h_benefit_type_sched_id "filespec/column" { type=integer; id=2; }
    p_partner_key "filespec/column" { type=string; id=3; }
    h_group_id "filespec/column" { type=integer; id=4; }
    h_min_years "filespec/column" { type=integer; id=5; }
    h_max_years "filespec/column" { type=integer; id=6; }
    h_benefit_mode "filespec/column" { type=string; id=7; }
    h_new_benefits "filespec/column" { type=integer; id=8; }
    h_carryover_benefits "filespec/column" { type=integer; id=9; }
    h_accrual_threshold "filespec/column" { type=integer; id=10; }
    h_usage_increment "filespec/column" { type=integer; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
