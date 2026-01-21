$Version=2$
a_transaction "application/filespec"
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
    a_batch_number "filespec/column" { type=integer; id=1; }
    a_journal_number "filespec/column" { type=integer; id=2; }
    a_transaction_number "filespec/column" { type=integer; id=3; }
    a_corrected "filespec/column" { type=bit; id=4; }
    a_gift_type "filespec/column" { type=char(1); id=5; }
    p_ext_partner_id "filespec/column" { type=char(10); id=6; }
    a_postprocess_type "filespec/column" { type=char(2); id=7; }
    a_posted "filespec/column" { type=bit; id=8; }
    a_period "filespec/column" { type=char(8); id=9; }
    a_receipt_sent "filespec/column" { type=bit; id=10; }
    p_int_partner_id "filespec/column" { type=char(10); id=11; }
    a_account_category "filespec/column" { type=char(8); id=12; }
    a_sent_document_id "filespec/column" { type=varchar(64); id=13; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=14; }
    a_recv_document_id "filespec/column" { type=varchar(64); id=15; }
    a_ledger_number "filespec/column" { type=char(10); id=16; }
    a_reconciled "filespec/column" { type=bit; id=17; }
    s_date_created "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=varchar(20); id=19; }
    a_corrected_transaction "filespec/column" { type=integer; id=20; }
    a_goods_provided "filespec/column" { type=decimal(14,4); id=21; }
    a_comment "filespec/column" { type=varchar(255); id=22; }
    a_correcting "filespec/column" { type=bit; id=23; }
    a_first_gift "filespec/column" { type=bit; id=24; }
    a_effective_date "filespec/column" { type=datetime; id=25; }
    a_fund "filespec/column" { type=char(20); id=26; }
    a_legacy_code "filespec/column" { type=varchar(20); id=27; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=28; }
    a_gift_received_date "filespec/column" { type=datetime; id=29; }
    a_modified "filespec/column" { type=bit; id=30; }
    a_transaction_type "filespec/column" { type=char(1); id=31; }
    a_origin "filespec/column" { type=char(2); id=32; }
    a_account_code "filespec/column" { type=char(16); id=33; }
    s_created_by "filespec/column" { type=varchar(20); id=34; }
    a_postprocessed "filespec/column" { type=bit; id=35; }
    a_corrected_batch "filespec/column" { type=integer; id=36; }
    s_date_modified "filespec/column" { type=datetime; id=37; }
    a_amount "filespec/column" { type=decimal(14,4); id=38; }
    a_corrected_journal "filespec/column" { type=integer; id=39; }
    a_receipt_desired "filespec/column" { type=bit; id=40; }
    }
