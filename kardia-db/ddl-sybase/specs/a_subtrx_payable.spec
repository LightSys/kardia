$Version=2$
a_subtrx_payable "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_payable";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payable_id "filespec/column" { type=integer; id=2; }
    a_batch_number_payable "filespec/column" { type=integer; id=3; }
    a_batch_number_resolution "filespec/column" { type=integer; id=4; }
    a_posted "filespec/column" { type=integer; id=5; }
    a_requested_by "filespec/column" { type=string; id=6; }
    a_requested_date "filespec/column" { type=datetime; id=7; }
    a_approved_by "filespec/column" { type=string; id=8; }
    a_approved_date "filespec/column" { type=datetime; id=9; }
    a_resolved_by "filespec/column" { type=string; id=10; }
    a_resolved_date "filespec/column" { type=datetime; id=11; }
    a_taxable "filespec/column" { type=integer; id=12; }
    a_advance "filespec/column" { type=integer; id=13; }
    a_payment_terms "filespec/column" { type=string; id=14; }
    a_payment_method "filespec/column" { type=integer; id=15; }
    a_document_id "filespec/column" { type=integer; id=16; }
    a_due_date "filespec/column" { type=datetime; id=17; }
    a_payee_partner_key "filespec/column" { type=string; id=18; }
    a_account_with_payee "filespec/column" { type=string; id=19; }
    a_invoice_number "filespec/column" { type=string; id=20; }
    a_make_payment_to "filespec/column" { type=string; id=21; }
    a_payment_comment "filespec/column" { type=string; id=22; }
    a_comment "filespec/column" { type=string; id=23; }
    s_date_created "filespec/column" { type=datetime; id=24; }
    s_created_by "filespec/column" { type=string; id=25; }
    s_date_modified "filespec/column" { type=datetime; id=26; }
    s_modified_by "filespec/column" { type=string; id=27; }
    __cx_osml_control "filespec/column" { type=string; id=28; }
    }
