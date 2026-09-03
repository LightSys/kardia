$Version=2$
a_giving_pattern_flag "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_giving_pattern_flag";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    p_donor_partner_key "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_pattern_id "filespec/column" { type=integer; id=4; }
    a_history_id "filespec/column" { type=integer; id=5; }
    a_review "filespec/column" { type=string; id=6; }
    a_prior_interval "filespec/column" { type=integer; id=7; }
    a_prior_amount "filespec/column" { type=money; id=8; }
    a_flag_type "filespec/column" { type=string; id=9; }
    a_flag_resolution "filespec/column" { type=string; id=10; }
    a_new_interval "filespec/column" { type=integer; id=11; }
    a_new_amount "filespec/column" { type=money; id=12; }
    a_comment "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
