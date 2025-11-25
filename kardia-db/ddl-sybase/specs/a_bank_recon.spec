$Version=2$
a_bank_recon "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    a_end_date "filespec/column" { type=datetime; id=4; }
    a_period "filespec/column" { type=char(8); id=5; }
    a_bank_start_balance "filespec/column" { type=decimal(14,4); id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_account_code "filespec/column" { type=char(16); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_comment "filespec/column" { type=varchar(900); id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    a_bank_end_balance "filespec/column" { type=decimal(14,4); id=12; }
    a_statement_id "filespec/column" { type=int(11); id=13; }
    }
