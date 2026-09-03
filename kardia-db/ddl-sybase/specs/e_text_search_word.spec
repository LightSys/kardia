$Version=2$
e_text_search_word "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_text_search_word";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_word_id "filespec/column" { type=integer; id=1; }
    e_word "filespec/column" { type=string; id=2; }
    e_salt "filespec/column" { type=string; id=3; }
    e_word_relevance "filespec/column" { type=double; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
