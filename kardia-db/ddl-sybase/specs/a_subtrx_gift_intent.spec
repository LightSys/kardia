$Version=2$
a_subtrx_gift_intent "application/filespec"
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
    a_giving_interval "filespec/column" { type=integer; id=2; }
    a_intent_number "filespec/column" { type=integer; id=3; }
    a_start_date "filespec/column" { type=datetime; id=4; }
    a_amount "filespec/column" { type=decimal(14,4); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    a_gift_number "filespec/column" { type=integer; id=7; }
    a_ledger_number "filespec/column" { type=char(10); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_intent_type "filespec/column" { type=varchar(1); id=10; }
    p_dn_donor_partner_id "filespec/column" { type=char(10); id=11; }
    p_dn_ack_partner_id "filespec/column" { type=char(10); id=12; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=13; }
    a_end_date "filespec/column" { type=datetime; id=14; }
    a_gift_count "filespec/column" { type=integer; id=15; }
    a_fund "filespec/column" { type=char(20); id=16; }
    a_comment "filespec/column" { type=varchar(255); id=17; }
    a_autogen "filespec/column" { type=bit; id=18; }
    a_total_amount "filespec/column" { type=decimal(14,4); id=19; }
    s_modified_by "filespec/column" { type=varchar(20); id=20; }
    a_pledge_id "filespec/column" { type=integer; id=21; }
    a_split_number "filespec/column" { type=integer; id=22; }
    a_batch_number "filespec/column" { type=integer; id=23; }
    }
