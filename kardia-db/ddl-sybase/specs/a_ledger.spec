$Version=2$
a_ledger "application/filespec"
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
    a_ledger_desc "filespec/column" { type=varchar(32); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    a_is_posting "filespec/column" { type=bit; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    a_next_batch_number "filespec/column" { type=integer; id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_ledger_comment "filespec/column" { type=varchar(255); id=10; }
    }
