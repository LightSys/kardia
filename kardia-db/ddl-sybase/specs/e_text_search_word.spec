$Version=2$
e_text_search_word "application/filespec"
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
    e_word_relevance "filespec/column" { type=float; id=2; }
    e_word_id "filespec/column" { type=integer; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    e_salt "filespec/column" { type=varchar(64); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    e_word "filespec/column" { type=varchar(64); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    }
