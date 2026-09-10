$Version=2$
p_zipranges "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_zipranges";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_state_code "filespec/column" { type=string; id=1; }
    p_first_zip "filespec/column" { type=string; id=2; }
    p_last_zip "filespec/column" { type=string; id=3; }
    p_state_name "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
