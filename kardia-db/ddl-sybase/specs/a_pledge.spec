$Version=2$
a_pledge "application/filespec"
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
    a_ledger_number "filespec/column" { type=char(10); id=1; }
    a_start_date "filespec/column" { type=datetime; id=2; }
    a_amount "filespec/column" { type=decimal(14,4); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_giving_interval "filespec/column" { type=integer; id=6; }
    p_donor_partner_id "filespec/column" { type=char(10); id=7; }
    a_intent_type "filespec/column" { type=varchar(1); id=8; }
    a_pledge_date "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    a_fund "filespec/column" { type=char(20); id=11; }
    a_gift_count "filespec/column" { type=integer; id=12; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=13; }
    a_end_date "filespec/column" { type=datetime; id=14; }
    a_is_active "filespec/column" { type=bit; id=15; }
    s_modified_by "filespec/column" { type=varchar(20); id=16; }
    a_total_amount "filespec/column" { type=decimal(14,4); id=17; }
    a_pledge_id "filespec/column" { type=integer; id=18; }
    a_comment "filespec/column" { type=varchar(255); id=19; }
    }
