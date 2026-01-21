$Version=2$
a_subtrx_cashdisb "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_cashdisb";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_disbursement_id "filespec/column" { type=integer; id=3; }
    a_line_item "filespec/column" { type=integer; id=4; }
    a_period "filespec/column" { type=string; id=5; }
    a_effective_date "filespec/column" { type=datetime; id=6; }
    a_cash_account_code "filespec/column" { type=string; id=7; }
    a_amount "filespec/column" { type=money; id=8; }
    a_fund "filespec/column" { type=string; id=9; }
    a_account_code "filespec/column" { type=string; id=10; }
    a_payee_partner_key "filespec/column" { type=string; id=11; }
    a_check_number "filespec/column" { type=string; id=12; }
    a_posted "filespec/column" { type=integer; id=13; }
    a_posted_to_gl "filespec/column" { type=integer; id=14; }
    a_voided "filespec/column" { type=integer; id=15; }
    a_approved_by "filespec/column" { type=string; id=16; }
    a_approved_date "filespec/column" { type=datetime; id=17; }
    a_paid_by "filespec/column" { type=string; id=18; }
    a_paid_date "filespec/column" { type=datetime; id=19; }
    a_reconciled "filespec/column" { type=integer; id=20; }
    a_memo "filespec/column" { type=string; id=21; }
    a_comment "filespec/column" { type=string; id=22; }
    s_date_created "filespec/column" { type=datetime; id=23; }
    s_created_by "filespec/column" { type=string; id=24; }
    s_date_modified "filespec/column" { type=datetime; id=25; }
    s_modified_by "filespec/column" { type=string; id=26; }
    __cx_osml_control "filespec/column" { type=string; id=27; }
    }
