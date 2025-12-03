$Version=2$
a_subtrx_deposit "application/filespec"
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
    a_num_checks "filespec/column" { type=integer; id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_cash_amount "filespec/column" { type=decimal(14,4); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    a_amount "filespec/column" { type=decimal(14,4); id=6; }
    a_from_account_code "filespec/column" { type=char(10); id=7; }
    a_account_code "filespec/column" { type=char(10); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_effective_date "filespec/column" { type=datetime; id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    a_period "filespec/column" { type=char(8); id=12; }
    a_posted "filespec/column" { type=bit; id=13; }
    s_modified_by "filespec/column" { type=varchar(20); id=14; }
    a_batch_number "filespec/column" { type=integer; id=15; }
    a_comment "filespec/column" { type=varchar(255); id=16; }
    a_posted_to_gl "filespec/column" { type=bit; id=17; }
    }
