$Version=2$
a_batch "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_batch";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_batch_number "filespec/column" { type=integer; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_period "filespec/column" { type=string; id=3; }
    a_batch_desc "filespec/column" { type=string; id=4; }
    a_next_journal_number "filespec/column" { type=integer; id=5; }
    a_next_transaction_number "filespec/column" { type=integer; id=6; }
    a_default_effective_date "filespec/column" { type=datetime; id=7; }
    a_origin "filespec/column" { type=string; id=8; }
    s_process_code "filespec/column" { type=string; id=9; }
    s_process_status_code "filespec/column" { type=string; id=10; }
    a_corrects_batch_number "filespec/column" { type=integer; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
