$Version=2$
s_document_scanner "application/filespec"
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
    s_scanner_auth_token "filespec/column" { type=varchar(255); id=1; }
    s_scanner_host "filespec/column" { type=varchar(255); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    s_scanner_id_on_server "filespec/column" { type=varchar(255); id=4; }
    s_modified_by "filespec/column" { type=varchar(20); id=5; }
    s_scanner_auth_user "filespec/column" { type=varchar(255); id=6; }
    s_scanner_type "filespec/column" { type=char(3); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_scanner_desc "filespec/column" { type=varchar(255); id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_last_used_by "filespec/column" { type=varchar(20); id=12; }
    s_scanner_port "filespec/column" { type=integer; id=13; }
    s_date_last_used "filespec/column" { type=datetime; id=14; }
    s_scanner_id "filespec/column" { type=integer; id=15; }
    }
