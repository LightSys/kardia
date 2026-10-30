$Version=2$
s_document_scanner "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_document_scanner";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_scanner_id "filespec/column" { type=integer; id=1; }
    s_scanner_desc "filespec/column" { type=string; id=2; }
    s_scanner_type "filespec/column" { type=string; id=3; }
    s_scanner_host "filespec/column" { type=string; id=4; }
    s_scanner_port "filespec/column" { type=integer; id=5; }
    s_scanner_auth_user "filespec/column" { type=string; id=6; }
    s_scanner_auth_token "filespec/column" { type=string; id=7; }
    s_scanner_id_on_server "filespec/column" { type=string; id=8; }
    s_date_last_used "filespec/column" { type=datetime; id=9; }
    s_last_used_by "filespec/column" { type=string; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
