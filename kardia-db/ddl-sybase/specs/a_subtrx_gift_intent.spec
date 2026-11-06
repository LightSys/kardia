$Version=2$
a_subtrx_gift_intent "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_gift_intent";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_gift_number "filespec/column" { type=integer; id=3; }
    a_intent_number "filespec/column" { type=integer; id=4; }
    a_split_number "filespec/column" { type=integer; id=5; }
    a_pledge_id "filespec/column" { type=integer; id=6; }
    p_dn_donor_partner_id "filespec/column" { type=string; id=7; }
    p_dn_ack_partner_id "filespec/column" { type=string; id=8; }
    a_fund "filespec/column" { type=string; id=9; }
    a_intent_type "filespec/column" { type=string; id=10; }
    a_amount "filespec/column" { type=money; id=11; }
    a_total_amount "filespec/column" { type=money; id=12; }
    a_start_date "filespec/column" { type=datetime; id=13; }
    a_end_date "filespec/column" { type=datetime; id=14; }
    a_giving_interval "filespec/column" { type=integer; id=15; }
    a_gift_count "filespec/column" { type=integer; id=16; }
    a_comment "filespec/column" { type=string; id=17; }
    a_autogen "filespec/column" { type=integer; id=18; }
    s_date_created "filespec/column" { type=datetime; id=19; }
    s_created_by "filespec/column" { type=string; id=20; }
    s_date_modified "filespec/column" { type=datetime; id=21; }
    s_modified_by "filespec/column" { type=string; id=22; }
    __cx_osml_control "filespec/column" { type=string; id=23; }
    }
