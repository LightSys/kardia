$Version=2$
p_search_stage_criteria "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    p_criteria_name "filespec/column" { type=varchar(32); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    p_criteria_value "filespec/column" { type=varchar(900); id=7; }
    p_search_stage_id "filespec/column" { type=integer; id=8; }
    p_search_id "filespec/column" { type=integer; id=9; }
    }
