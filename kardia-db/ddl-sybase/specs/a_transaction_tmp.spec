$Version=2$
a_transaction_tmp "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_transaction_tmp";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_journal_number "filespec/column" { type=integer; id=3; }
    a_transaction_number "filespec/column" { type=integer; id=4; }
    a_period "filespec/column" { type=string; id=5; }
    a_effective_date "filespec/column" { type=datetime; id=6; }
    a_transaction_type "filespec/column" { type=string; id=7; }
    a_fund "filespec/column" { type=string; id=8; }
    a_account_category "filespec/column" { type=string; id=9; }
    a_account_code "filespec/column" { type=string; id=10; }
    a_amount "filespec/column" { type=money; id=11; }
    a_posted "filespec/column" { type=integer; id=12; }
    a_modified "filespec/column" { type=integer; id=13; }
    a_corrected "filespec/column" { type=integer; id=14; }
    a_correcting "filespec/column" { type=integer; id=15; }
    a_corrected_batch "filespec/column" { type=integer; id=16; }
    a_corrected_journal "filespec/column" { type=integer; id=17; }
    a_corrected_transaction "filespec/column" { type=integer; id=18; }
    a_reconciled "filespec/column" { type=integer; id=19; }
    a_postprocessed "filespec/column" { type=integer; id=20; }
    a_postprocess_type "filespec/column" { type=string; id=21; }
    a_origin "filespec/column" { type=string; id=22; }
    a_recv_document_id "filespec/column" { type=string; id=23; }
    a_sent_document_id "filespec/column" { type=string; id=24; }
    p_ext_partner_id "filespec/column" { type=string; id=25; }
    p_int_partner_id "filespec/column" { type=string; id=26; }
    a_legacy_code "filespec/column" { type=string; id=27; }
    a_receipt_sent "filespec/column" { type=integer; id=28; }
    a_receipt_desired "filespec/column" { type=integer; id=29; }
    a_first_gift "filespec/column" { type=integer; id=30; }
    a_gift_type "filespec/column" { type=string; id=31; }
    a_goods_provided "filespec/column" { type=money; id=32; }
    a_gift_received_date "filespec/column" { type=datetime; id=33; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=34; }
    a_comment "filespec/column" { type=string; id=35; }
    s_date_created "filespec/column" { type=datetime; id=36; }
    s_created_by "filespec/column" { type=string; id=37; }
    s_date_modified "filespec/column" { type=datetime; id=38; }
    s_modified_by "filespec/column" { type=string; id=39; }
    __cx_osml_control "filespec/column" { type=string; id=40; }
    }
