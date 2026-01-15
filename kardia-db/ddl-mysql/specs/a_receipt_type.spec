$Version=2$
a_receipt_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_receipt_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_receipt_type "filespec/column" { type=string; id=1; }
    a_receipt_type_desc "filespec/column" { type=string; id=2; }
    a_is_default "filespec/column" { type=integer; id=3; }
    a_is_enabled "filespec/column" { type=integer; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
