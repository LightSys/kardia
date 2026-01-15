$Version=2$
a_subtrx_gift_rcptcnt "application/filespec"
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
    a_next_receipt_number "filespec/column" { type=integer; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    }
