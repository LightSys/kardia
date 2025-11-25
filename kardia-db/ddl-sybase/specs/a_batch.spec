$Version=2$
a_batch "application/filespec"
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
    a_corrects_batch_number "filespec/column" { type=integer; id=1; }
    a_batch_desc "filespec/column" { type=varchar(255); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_batch_number "filespec/column" { type=integer; id=4; }
    a_default_effective_date "filespec/column" { type=datetime; id=5; }
    a_period "filespec/column" { type=char(8); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    s_process_status_code "filespec/column" { type=char(1); id=9; }
    a_origin "filespec/column" { type=char(2); id=10; }
    a_next_transaction_number "filespec/column" { type=integer; id=11; }
    s_process_code "filespec/column" { type=char(3); id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    a_next_journal_number "filespec/column" { type=integer; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    a_ledger_number "filespec/column" { type=char(10); id=16; }
    }
