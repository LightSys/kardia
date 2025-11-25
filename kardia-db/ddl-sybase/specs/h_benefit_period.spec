$Version=2$
h_benefit_period "application/filespec"
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
    h_benefit_period_id "filespec/column" { type=integer; id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    h_benefit_period_label "filespec/column" { type=varchar(64); id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    h_benefit_period_end_date "filespec/column" { type=datetime; id=8; }
    h_benefit_period_start_date "filespec/column" { type=datetime; id=9; }
    }
