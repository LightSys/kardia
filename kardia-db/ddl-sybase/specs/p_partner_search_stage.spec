$Version=2$
p_partner_search_stage "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    p_search_stage_id "filespec/column" { type=integer; id=3; }
    p_search_id "filespec/column" { type=integer; id=4; }
    p_stage_op "filespec/column" { type=char(1); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    p_stage_type "filespec/column" { type=char(3); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    p_result_count "filespec/column" { type=integer; id=9; }
    p_sequence "filespec/column" { type=integer; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    }
