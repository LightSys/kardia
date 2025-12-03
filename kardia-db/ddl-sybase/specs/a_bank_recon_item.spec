$Version=2$
a_bank_recon_item "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    a_account_code "filespec/column" { type=char(16); id=2; }
    a_origin "filespec/column" { type=char(2); id=3; }
    a_statement_id "filespec/column" { type=int(11); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_batch_key "filespec/column" { type=int(11); id=6; }
    a_amount "filespec/column" { type=decimal(14,4); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    a_ledger_number "filespec/column" { type=char(10); id=9; }
    a_comment "filespec/column" { type=varchar(255); id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    a_line_item "filespec/column" { type=integer; id=12; }
    a_is_reconciled "filespec/column" { type=bit; id=13; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=14; }
    a_group_key "filespec/column" { type=int(11); id=15; }
    a_item_key "filespec/column" { type=int(11); id=16; }
    }
