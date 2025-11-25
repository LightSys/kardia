$Version=2$
r_saved_param "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    r_param_value "filespec/column" { type=varchar(1536); id=5; }
    r_paramset_id "filespec/column" { type=integer; id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    r_param_name "filespec/column" { type=varchar(64); id=8; }
    }
