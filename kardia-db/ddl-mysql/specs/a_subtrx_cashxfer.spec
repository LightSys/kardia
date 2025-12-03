$Version=2$
a_subtrx_cashxfer "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_cashxfer";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_journal_number "filespec/column" { type=integer; id=3; }
    a_period "filespec/column" { type=string; id=4; }
    a_effective_date "filespec/column" { type=datetime; id=5; }
    a_source_cash_acct "filespec/column" { type=string; id=6; }
    a_dest_cash_acct "filespec/column" { type=string; id=7; }
    a_fund "filespec/column" { type=string; id=8; }
    a_amount "filespec/column" { type=money; id=9; }
    a_in_gl "filespec/column" { type=integer; id=10; }
    a_comment "filespec/column" { type=string; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
