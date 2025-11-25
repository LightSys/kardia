$Version=2$
a_giving_pattern "application/filespec"
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
    a_interval "filespec/column" { type=integer; id=1; }
    p_donor_partner_key "filespec/column" { type=char(10); id=2; }
    a_actual_fund "filespec/column" { type=char(20); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    a_percent "filespec/column" { type=float; id=5; }
    a_evaluation_date "filespec/column" { type=datetime; id=6; }
    a_review "filespec/column" { type=varchar(16); id=7; }
    a_ledger_number "filespec/column" { type=char(10); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    a_start_date "filespec/column" { type=datetime; id=11; }
    a_amount "filespec/column" { type=decimal(14,4); id=12; }
    s_modified_by "filespec/column" { type=varchar(20); id=13; }
    a_comment "filespec/column" { type=varchar(255); id=14; }
    a_history_id "filespec/column" { type=integer; id=15; }
    a_pattern_id "filespec/column" { type=integer; id=16; }
    a_fund "filespec/column" { type=char(20); id=17; }
    a_is_active "filespec/column" { type=bit; id=18; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=19; }
    a_end_date "filespec/column" { type=datetime; id=20; }
    }
