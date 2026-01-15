$Version=2$
e_text_expansion "application/filespec"
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
    e_exp_desc "filespec/column" { type=varchar(64); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    e_exp_expansion "filespec/column" { type=varchar(900); id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    e_exp_tag "filespec/column" { type=varchar(16); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    }
