$Version=2$
i_eg_gift_import "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_eg_gift_import";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_eg_gift_uuid "filespec/column" { type=string; id=2; }
    i_eg_desig_uuid "filespec/column" { type=string; id=3; }
    i_eg_line_item "filespec/column" { type=integer; id=4; }
    i_eg_trx_uuid "filespec/column" { type=string; id=5; }
    i_eg_donor_uuid "filespec/column" { type=string; id=6; }
    i_eg_donor_alt_id "filespec/column" { type=string; id=7; }
    i_eg_account_uuid "filespec/column" { type=string; id=8; }
    i_eg_service "filespec/column" { type=string; id=9; }
    i_eg_status "filespec/column" { type=string; id=10; }
    i_eg_returned_status "filespec/column" { type=string; id=11; }
    i_eg_processor "filespec/column" { type=string; id=12; }
    i_eg_donor_name "filespec/column" { type=string; id=13; }
    i_eg_donor_given_name "filespec/column" { type=string; id=14; }
    i_eg_donor_surname "filespec/column" { type=string; id=15; }
    i_eg_donor_middle_name "filespec/column" { type=string; id=16; }
    i_eg_donor_prefix "filespec/column" { type=string; id=17; }
    i_eg_donor_suffix "filespec/column" { type=string; id=18; }
    i_eg_donor_address "filespec/column" { type=string; id=19; }
    i_eg_donor_addr1 "filespec/column" { type=string; id=20; }
    i_eg_donor_addr2 "filespec/column" { type=string; id=21; }
    i_eg_donor_addr3 "filespec/column" { type=string; id=22; }
    i_eg_donor_city "filespec/column" { type=string; id=23; }
    i_eg_donor_state "filespec/column" { type=string; id=24; }
    i_eg_donor_postal "filespec/column" { type=string; id=25; }
    i_eg_donor_country "filespec/column" { type=string; id=26; }
    i_eg_donor_phone "filespec/column" { type=string; id=27; }
    i_eg_donor_phone_country "filespec/column" { type=string; id=28; }
    i_eg_donor_phone_area "filespec/column" { type=string; id=29; }
    i_eg_donor_phone_line "filespec/column" { type=string; id=30; }
    i_eg_donor_phone_ext "filespec/column" { type=string; id=31; }
    i_eg_donor_email "filespec/column" { type=string; id=32; }
    i_eg_gift_amount "filespec/column" { type=money; id=33; }
    i_eg_gift_currency_foreign_amt "filespec/column" { type=money; id=34; }
    i_eg_gift_currency "filespec/column" { type=string; id=35; }
    i_eg_gift_currency_date "filespec/column" { type=datetime; id=36; }
    i_eg_gift_currency_exch_rate "filespec/column" { type=double; id=37; }
    i_eg_gift_pmt_type "filespec/column" { type=string; id=38; }
    i_eg_gift_lastfour "filespec/column" { type=string; id=39; }
    i_eg_gift_interval "filespec/column" { type=string; id=40; }
    i_eg_gift_start_date "filespec/column" { type=datetime; id=41; }
    i_eg_gift_end_date "filespec/column" { type=datetime; id=42; }
    i_eg_gift_count "filespec/column" { type=integer; id=43; }
    i_eg_gift_date "filespec/column" { type=datetime; id=44; }
    i_eg_gift_trx_date "filespec/column" { type=datetime; id=45; }
    i_eg_gift_settlement_date "filespec/column" { type=datetime; id=46; }
    i_eg_receipt_desired "filespec/column" { type=string; id=47; }
    i_eg_anonymous "filespec/column" { type=string; id=48; }
    i_eg_prayforme "filespec/column" { type=string; id=49; }
    i_eg_desig_name "filespec/column" { type=string; id=50; }
    i_eg_desig_notes "filespec/column" { type=string; id=51; }
    i_eg_net_amount "filespec/column" { type=money; id=52; }
    i_eg_deposit_date "filespec/column" { type=datetime; id=53; }
    i_eg_deposit_uuid "filespec/column" { type=string; id=54; }
    i_eg_contra_deposit_uuid "filespec/column" { type=string; id=55; }
    i_eg_deposit_status "filespec/column" { type=string; id=56; }
    i_eg_deposit_gross_amt "filespec/column" { type=money; id=57; }
    i_eg_deposit_amt "filespec/column" { type=money; id=58; }
    i_eg_is_modified "filespec/column" { type=integer; id=59; }
    i_eg_is_donorfee "filespec/column" { type=integer; id=60; }
    i_eg_postprocess "filespec/column" { type=string; id=61; }
    p_donor_partner_key "filespec/column" { type=string; id=62; }
    i_eg_donormap_confidence "filespec/column" { type=integer; id=63; }
    i_eg_donormap_future "filespec/column" { type=integer; id=64; }
    a_fund "filespec/column" { type=string; id=65; }
    i_eg_fundmap_confidence "filespec/column" { type=integer; id=66; }
    i_eg_fundmap_future "filespec/column" { type=integer; id=67; }
    a_account_code "filespec/column" { type=string; id=68; }
    i_eg_acctmap_confidence "filespec/column" { type=integer; id=69; }
    i_eg_acctmap_future "filespec/column" { type=integer; id=70; }
    a_batch_number "filespec/column" { type=integer; id=71; }
    a_batch_number_fees "filespec/column" { type=integer; id=72; }
    a_batch_number_deposit "filespec/column" { type=integer; id=73; }
    s_date_created "filespec/column" { type=datetime; id=74; }
    s_created_by "filespec/column" { type=string; id=75; }
    s_date_modified "filespec/column" { type=datetime; id=76; }
    s_modified_by "filespec/column" { type=string; id=77; }
    __cx_osml_control "filespec/column" { type=string; id=78; }
    }
