$Version=2$
a_bank_recon "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_bank_recon";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_account_code "filespec/column" { type=string; id=2; }
    a_statement_id "filespec/column" { type=integer; id=3; }
    a_period "filespec/column" { type=string; id=4; }
    a_end_date "filespec/column" { type=datetime; id=5; }
    a_bank_start_balance "filespec/column" { type=money; id=6; }
    a_bank_end_balance "filespec/column" { type=money; id=7; }
    a_comment "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
