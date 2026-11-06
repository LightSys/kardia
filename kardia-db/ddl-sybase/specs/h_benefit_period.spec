$Version=2$
h_benefit_period "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for h_benefit_period";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    h_benefit_period_id "filespec/column" { type=integer; id=1; }
    h_benefit_period_label "filespec/column" { type=string; id=2; }
    h_benefit_period_start_date "filespec/column" { type=datetime; id=3; }
    h_benefit_period_end_date "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
