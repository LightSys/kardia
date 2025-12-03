$Version=2$
a_subtrx_xfer "application/filespec"
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
    a_batch_number "filespec/column" { type=integer; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    a_in_gl "filespec/column" { type=bit; id=3; }
    a_journal_number "filespec/column" { type=integer; id=4; }
    a_source_fund "filespec/column" { type=char(20); id=5; }
    a_comment "filespec/column" { type=varchar(255); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    a_dest_fund "filespec/column" { type=char(20); id=8; }
    a_effective_date "filespec/column" { type=datetime; id=9; }
    a_ledger_number "filespec/column" { type=char(10); id=10; }
    a_amount "filespec/column" { type=decimal(14,4); id=11; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=12; }
    a_period "filespec/column" { type=char(8); id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    }
