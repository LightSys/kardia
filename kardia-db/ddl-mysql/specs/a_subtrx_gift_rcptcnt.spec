$Version=2$
a_subtrx_gift_rcptcnt "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_gift_rcptcnt";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_next_receipt_number "filespec/column" { type=integer; id=2; }
    __cx_osml_control "filespec/column" { type=string; id=3; }
    }
