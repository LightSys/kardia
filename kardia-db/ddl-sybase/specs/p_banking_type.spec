$Version=2$
p_banking_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_banking_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_banking_type "filespec/column" { type=string; id=1; }
    p_banking_desc "filespec/column" { type=string; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    s_created_by "filespec/column" { type=string; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=string; id=6; }
    __cx_osml_control "filespec/column" { type=string; id=7; }
    }
