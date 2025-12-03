$Version=2$
e_text_search_occur "application/filespec"
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
    e_document_id "filespec/column" { type=integer; id=1; }
    e_eol "filespec/column" { type=bit; id=2; }
    e_sequence "filespec/column" { type=integer; id=3; }
    e_word_id "filespec/column" { type=integer; id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    }
