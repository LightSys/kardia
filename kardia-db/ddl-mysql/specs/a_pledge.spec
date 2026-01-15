$Version=2$
a_pledge "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_pledge";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_pledge_id "filespec/column" { type=integer; id=2; }
    a_is_active "filespec/column" { type=integer; id=3; }
    p_donor_partner_id "filespec/column" { type=string; id=4; }
    a_fund "filespec/column" { type=string; id=5; }
    a_intent_type "filespec/column" { type=string; id=6; }
    a_amount "filespec/column" { type=money; id=7; }
    a_total_amount "filespec/column" { type=money; id=8; }
    a_pledge_date "filespec/column" { type=datetime; id=9; }
    a_start_date "filespec/column" { type=datetime; id=10; }
    a_end_date "filespec/column" { type=datetime; id=11; }
    a_giving_interval "filespec/column" { type=integer; id=12; }
    a_gift_count "filespec/column" { type=integer; id=13; }
    a_comment "filespec/column" { type=string; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_created_by "filespec/column" { type=string; id=16; }
    s_date_modified "filespec/column" { type=datetime; id=17; }
    s_modified_by "filespec/column" { type=string; id=18; }
    __cx_osml_control "filespec/column" { type=string; id=19; }
    }
