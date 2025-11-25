$Version=2$
s_global_search "application/filespec"
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
    s_cri2 "filespec/column" { type=integer; id=1; }
    s_key "filespec/column" { type=varchar(255); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    s_cri1 "filespec/column" { type=integer; id=4; }
    s_desc "filespec/column" { type=varchar(1536); id=5; }
    s_search_id "filespec/column" { type=integer; id=6; }
    s_cri5 "filespec/column" { type=integer; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    s_label "filespec/column" { type=varchar(255); id=11; }
    s_score "filespec/column" { type=float; id=12; }
    s_cri3 "filespec/column" { type=integer; id=13; }
    s_search_res_id "filespec/column" { type=integer; id=14; }
    s_cri4 "filespec/column" { type=integer; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    s_type "filespec/column" { type=varchar(20); id=17; }
    s_username "filespec/column" { type=varchar(20); id=18; }
    }
