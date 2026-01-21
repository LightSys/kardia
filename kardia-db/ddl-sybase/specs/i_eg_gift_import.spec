$Version=2$
i_eg_gift_import "application/filespec"
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
    i_eg_gift_currency_date "filespec/column" { type=datetime; id=1; }
    i_eg_fundmap_confidence "filespec/column" { type=integer; id=2; }
    i_eg_donor_phone_line "filespec/column" { type=varchar(20); id=3; }
    i_eg_donor_email "filespec/column" { type=varchar(80); id=4; }
    i_eg_gift_pmt_type "filespec/column" { type=varchar(16); id=5; }
    p_donor_partner_key "filespec/column" { type=char(10); id=6; }
    i_eg_service "filespec/column" { type=varchar(16); id=7; }
    i_eg_deposit_uuid "filespec/column" { type=char(36); id=8; }
    i_eg_donor_address "filespec/column" { type=varchar(160); id=9; }
    i_eg_gift_currency_exch_rate "filespec/column" { type=double; id=10; }
    a_batch_number_deposit "filespec/column" { type=integer; id=11; }
    i_eg_donor_phone_ext "filespec/column" { type=varchar(20); id=12; }
    i_eg_donormap_confidence "filespec/column" { type=integer; id=13; }
    i_eg_deposit_status "filespec/column" { type=char(16); id=14; }
    i_eg_gift_count "filespec/column" { type=integer; id=15; }
    i_eg_donor_prefix "filespec/column" { type=varchar(80); id=16; }
    a_fund "filespec/column" { type=char(20); id=17; }
    i_eg_gift_trx_date "filespec/column" { type=datetime; id=18; }
    i_eg_receipt_desired "filespec/column" { type=varchar(255); id=19; }
    i_eg_donor_addr2 "filespec/column" { type=varchar(80); id=20; }
    i_eg_donor_uuid "filespec/column" { type=char(36); id=21; }
    i_eg_donor_middle_name "filespec/column" { type=varchar(80); id=22; }
    i_eg_deposit_amt "filespec/column" { type=decimal(14,4); id=23; }
    i_eg_returned_status "filespec/column" { type=varchar(16); id=24; }
    i_eg_desig_uuid "filespec/column" { type=varchar(36); id=25; }
    i_eg_gift_currency "filespec/column" { type=varchar(16); id=26; }
    i_eg_desig_notes "filespec/column" { type=varchar(255); id=27; }
    i_eg_donor_city "filespec/column" { type=varchar(80); id=28; }
    i_eg_gift_uuid "filespec/column" { type=char(36); id=29; }
    i_eg_donor_postal "filespec/column" { type=varchar(80); id=30; }
    i_eg_donor_suffix "filespec/column" { type=varchar(80); id=31; }
    a_ledger_number "filespec/column" { type=char(10); id=32; }
    i_eg_gift_lastfour "filespec/column" { type=char(4); id=33; }
    i_eg_donor_addr3 "filespec/column" { type=varchar(80); id=34; }
    i_eg_donor_name "filespec/column" { type=varchar(80); id=35; }
    i_eg_donor_state "filespec/column" { type=varchar(80); id=36; }
    i_eg_fundmap_future "filespec/column" { type=integer; id=37; }
    i_eg_is_modified "filespec/column" { type=integer; id=38; }
    a_account_code "filespec/column" { type=char(16); id=39; }
    s_created_by "filespec/column" { type=varchar(20); id=40; }
    i_eg_acctmap_confidence "filespec/column" { type=integer; id=41; }
    i_eg_donor_alt_id "filespec/column" { type=char(36); id=42; }
    i_eg_gift_settlement_date "filespec/column" { type=datetime; id=43; }
    i_eg_is_donorfee "filespec/column" { type=integer; id=44; }
    i_eg_status "filespec/column" { type=varchar(16); id=45; }
    i_eg_contra_deposit_uuid "filespec/column" { type=char(36); id=46; }
    i_eg_line_item "filespec/column" { type=integer; id=47; }
    s_date_modified "filespec/column" { type=datetime; id=48; }
    s_modified_by "filespec/column" { type=varchar(20); id=49; }
    i_eg_gift_currency_foreign_amt "filespec/column" { type=decimal(14,4); id=50; }
    a_batch_number_fees "filespec/column" { type=integer; id=51; }
    i_eg_donor_addr1 "filespec/column" { type=varchar(80); id=52; }
    i_eg_postprocess "filespec/column" { type=varchar(255); id=53; }
    i_eg_gift_amount "filespec/column" { type=decimal(14,4); id=54; }
    i_eg_donor_phone_country "filespec/column" { type=varchar(10); id=55; }
    i_eg_processor "filespec/column" { type=varchar(80); id=56; }
    i_eg_deposit_gross_amt "filespec/column" { type=decimal(14,4); id=57; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=58; }
    i_eg_donor_phone_area "filespec/column" { type=varchar(10); id=59; }
    i_eg_donor_country "filespec/column" { type=varchar(80); id=60; }
    i_eg_anonymous "filespec/column" { type=varchar(255); id=61; }
    i_eg_trx_uuid "filespec/column" { type=char(36); id=62; }
    i_eg_gift_start_date "filespec/column" { type=datetime; id=63; }
    i_eg_donor_phone "filespec/column" { type=varchar(80); id=64; }
    i_eg_deposit_date "filespec/column" { type=datetime; id=65; }
    i_eg_account_uuid "filespec/column" { type=varchar(36); id=66; }
    i_eg_gift_end_date "filespec/column" { type=datetime; id=67; }
    s_date_created "filespec/column" { type=datetime; id=68; }
    i_eg_donor_surname "filespec/column" { type=varchar(80); id=69; }
    i_eg_acctmap_future "filespec/column" { type=integer; id=70; }
    i_eg_net_amount "filespec/column" { type=decimal(14,4); id=71; }
    i_eg_gift_interval "filespec/column" { type=varchar(16); id=72; }
    a_batch_number "filespec/column" { type=integer; id=73; }
    i_eg_donor_given_name "filespec/column" { type=varchar(80); id=74; }
    i_eg_prayforme "filespec/column" { type=varchar(255); id=75; }
    i_eg_desig_name "filespec/column" { type=varchar(80); id=76; }
    i_eg_gift_date "filespec/column" { type=datetime; id=77; }
    i_eg_donormap_future "filespec/column" { type=integer; id=78; }
    }
