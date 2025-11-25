$Version=2$
a_bank_recon_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_bank_recon_item";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_line_item "filespec/column" { type=integer; id=2; }
    a_account_code "filespec/column" { type=string; id=3; }
    a_statement_id "filespec/column" { type=integer; id=4; }
    a_origin "filespec/column" { type=string; id=5; }
    a_batch_key "filespec/column" { type=integer; id=6; }
    a_group_key "filespec/column" { type=integer; id=7; }
    a_item_key "filespec/column" { type=integer; id=8; }
    a_amount "filespec/column" { type=money; id=9; }
    a_is_reconciled "filespec/column" { type=integer; id=10; }
    a_comment "filespec/column" { type=string; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
