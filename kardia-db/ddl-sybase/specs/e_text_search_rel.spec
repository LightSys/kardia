$Version=2$
e_text_search_rel "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_text_search_rel";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_word_id "filespec/column" { type=integer; id=1; }
    e_target_word_id "filespec/column" { type=integer; id=2; }
    e_rel_relevance "filespec/column" { type=double; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_created_by "filespec/column" { type=string; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=string; id=7; }
    __cx_osml_control "filespec/column" { type=string; id=8; }
    }
