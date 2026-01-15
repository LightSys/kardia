$Version=2$
a_subtrx_payable "application/filespec"
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
    a_batch_number_resolution "filespec/column" { type=integer; id=2; }
    a_approved_date "filespec/column" { type=datetime; id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    a_payment_method "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    a_approved_by "filespec/column" { type=char(10); id=7; }
    a_requested_date "filespec/column" { type=datetime; id=8; }
    a_invoice_number "filespec/column" { type=varchar(64); id=9; }
    a_document_id "filespec/column" { type=integer; id=10; }
    a_payment_terms "filespec/column" { type=varchar(16); id=11; }
    a_payable_id "filespec/column" { type=integer; id=12; }
    s_created_by "filespec/column" { type=varchar(20); id=13; }
    a_resolved_by "filespec/column" { type=char(10); id=14; }
    a_payee_partner_key "filespec/column" { type=char(10); id=15; }
    a_resolved_date "filespec/column" { type=datetime; id=16; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=17; }
    a_posted "filespec/column" { type=bit; id=18; }
    a_advance "filespec/column" { type=bit; id=19; }
    a_requested_by "filespec/column" { type=char(10); id=20; }
    a_due_date "filespec/column" { type=datetime; id=21; }
    a_payment_comment "filespec/column" { type=varchar(255); id=22; }
    a_taxable "filespec/column" { type=bit; id=23; }
    s_modified_by "filespec/column" { type=varchar(20); id=24; }
    a_make_payment_to "filespec/column" { type=varchar(80); id=25; }
    a_batch_number_payable "filespec/column" { type=integer; id=26; }
    a_comment "filespec/column" { type=varchar(255); id=27; }
    a_account_with_payee "filespec/column" { type=varchar(20); id=28; }
    }
