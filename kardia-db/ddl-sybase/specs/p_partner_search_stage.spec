$Version=2$
p_partner_search_stage "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_partner_search_stage";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_search_id "filespec/column" { type=integer; id=1; }
    p_search_stage_id "filespec/column" { type=integer; id=2; }
    p_stage_type "filespec/column" { type=string; id=3; }
    p_stage_op "filespec/column" { type=string; id=4; }
    p_result_count "filespec/column" { type=integer; id=5; }
    p_sequence "filespec/column" { type=integer; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
