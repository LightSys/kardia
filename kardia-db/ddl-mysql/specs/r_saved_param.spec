$Version=2$
r_saved_param "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for r_saved_param";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    r_paramset_id "filespec/column" { type=integer; id=1; }
    r_param_name "filespec/column" { type=string; id=2; }
    r_param_value "filespec/column" { type=string; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_created_by "filespec/column" { type=string; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=string; id=7; }
    __cx_osml_control "filespec/column" { type=string; id=8; }
    }
