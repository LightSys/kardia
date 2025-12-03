$Version=2$
a_giving_pattern_allocation "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    a_history_id "filespec/column" { type=integer; id=4; }
    a_pattern_id "filespec/column" { type=integer; id=5; }
    a_review "filespec/column" { type=varchar(16); id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_fund "filespec/column" { type=char(20); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_comment "filespec/column" { type=varchar(255); id=10; }
    a_percent "filespec/column" { type=float; id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    p_donor_partner_key "filespec/column" { type=char(10); id=13; }
    a_actual_fund "filespec/column" { type=char(20); id=14; }
    }
