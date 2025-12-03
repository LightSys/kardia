$Version=2$
a_giving_pattern_flag "application/filespec"
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
    a_history_id "filespec/column" { type=integer; id=2; }
    a_prior_interval "filespec/column" { type=integer; id=3; }
    a_flag_resolution "filespec/column" { type=char(3); id=4; }
    a_pattern_id "filespec/column" { type=integer; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    a_flag_type "filespec/column" { type=char(3); id=7; }
    a_prior_amount "filespec/column" { type=decimal(14,4); id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    a_comment "filespec/column" { type=varchar(255); id=10; }
    a_new_amount "filespec/column" { type=decimal(14,4); id=11; }
    a_review "filespec/column" { type=varchar(16); id=12; }
    a_ledger_number "filespec/column" { type=char(10); id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    p_donor_partner_key "filespec/column" { type=char(10); id=16; }
    a_new_interval "filespec/column" { type=integer; id=17; }
    s_created_by "filespec/column" { type=varchar(20); id=18; }
    }
