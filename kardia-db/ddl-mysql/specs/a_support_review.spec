$Version=2$
a_support_review "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_support_review";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_review "filespec/column" { type=string; id=2; }
    a_review_date "filespec/column" { type=datetime; id=3; }
    a_review_desc "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
