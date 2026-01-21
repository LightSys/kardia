$Version=2$
a_subtrx_cashdisb "application/filespec"
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
    a_posted_to_gl "filespec/column" { type=bit; id=1; }
    a_cash_account_code "filespec/column" { type=char(10); id=2; }
    a_comment "filespec/column" { type=varchar(900); id=3; }
    a_line_item "filespec/column" { type=integer; id=4; }
    a_batch_number "filespec/column" { type=integer; id=5; }
    a_paid_by "filespec/column" { type=varchar(20); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    a_payee_partner_key "filespec/column" { type=char(10); id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    a_memo "filespec/column" { type=varchar(255); id=10; }
    a_posted "filespec/column" { type=bit; id=11; }
    a_period "filespec/column" { type=char(8); id=12; }
    a_check_number "filespec/column" { type=varchar(16); id=13; }
    a_effective_date "filespec/column" { type=datetime; id=14; }
    a_fund "filespec/column" { type=char(20); id=15; }
    a_paid_date "filespec/column" { type=datetime; id=16; }
    a_voided "filespec/column" { type=bit; id=17; }
    s_created_by "filespec/column" { type=varchar(20); id=18; }
    a_account_code "filespec/column" { type=char(10); id=19; }
    a_approved_by "filespec/column" { type=varchar(20); id=20; }
    a_disbursement_id "filespec/column" { type=integer; id=21; }
    s_date_modified "filespec/column" { type=datetime; id=22; }
    a_amount "filespec/column" { type=decimal(14,4); id=23; }
    s_date_created "filespec/column" { type=datetime; id=24; }
    a_ledger_number "filespec/column" { type=char(10); id=25; }
    a_approved_date "filespec/column" { type=datetime; id=26; }
    a_reconciled "filespec/column" { type=bit; id=27; }
    }
