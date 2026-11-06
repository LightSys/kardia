$Version=2$
a_giving_pattern "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_giving_pattern";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    p_donor_partner_key "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_pattern_id "filespec/column" { type=integer; id=4; }
    a_history_id "filespec/column" { type=integer; id=5; }
    a_review "filespec/column" { type=string; id=6; }
    a_amount "filespec/column" { type=money; id=7; }
    a_interval "filespec/column" { type=integer; id=8; }
    a_is_active "filespec/column" { type=integer; id=9; }
    a_start_date "filespec/column" { type=datetime; id=10; }
    a_end_date "filespec/column" { type=datetime; id=11; }
    a_evaluation_date "filespec/column" { type=datetime; id=12; }
    a_actual_fund "filespec/column" { type=string; id=13; }
    a_percent "filespec/column" { type=double; id=14; }
    a_comment "filespec/column" { type=string; id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    s_created_by "filespec/column" { type=string; id=17; }
    s_date_modified "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=string; id=19; }
    __cx_osml_control "filespec/column" { type=string; id=20; }
    }
