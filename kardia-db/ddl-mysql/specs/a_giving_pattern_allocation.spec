$Version=2$
a_giving_pattern_allocation "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_giving_pattern_allocation";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    p_donor_partner_key "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_pattern_id "filespec/column" { type=integer; id=4; }
    a_history_id "filespec/column" { type=integer; id=5; }
    a_review "filespec/column" { type=string; id=6; }
    a_actual_fund "filespec/column" { type=string; id=7; }
    a_percent "filespec/column" { type=double; id=8; }
    a_comment "filespec/column" { type=string; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
