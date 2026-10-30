$Version=2$
p_pol_division "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_pol_division";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_country_code "filespec/column" { type=string; id=1; }
    p_pol_division "filespec/column" { type=string; id=2; }
    p_pol_division_parent "filespec/column" { type=string; id=3; }
    p_pol_division_name "filespec/column" { type=string; id=4; }
    p_local_name "filespec/column" { type=string; id=5; }
    p_record_status_code "filespec/column" { type=string; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
