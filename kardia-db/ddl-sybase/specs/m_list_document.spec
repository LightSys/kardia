$Version=2$
m_list_document "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for m_list_document";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    m_list_code "filespec/column" { type=string; id=1; }
    e_document_id "filespec/column" { type=integer; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    s_created_by "filespec/column" { type=string; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=string; id=6; }
    __cx_osml_control "filespec/column" { type=string; id=7; }
    }
