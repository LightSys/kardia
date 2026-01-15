$Version=2$
a_bank_recon_accts "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    s_modified_by "filespec/column" { type=varchar(20); id=5; }
    a_is_customizable "filespec/column" { type=bit(1); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    a_is_reconcilable "filespec/column" { type=bit(1); id=8; }
    a_account_code "filespec/column" { type=char(16); id=9; }
    }
