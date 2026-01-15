$Version=2$
s_global_search "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_global_search";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_search_id "filespec/column" { type=integer; id=1; }
    s_username "filespec/column" { type=string; id=2; }
    s_search_res_id "filespec/column" { type=integer; id=3; }
    s_score "filespec/column" { type=double; id=4; }
    s_cri1 "filespec/column" { type=integer; id=5; }
    s_cri2 "filespec/column" { type=integer; id=6; }
    s_cri3 "filespec/column" { type=integer; id=7; }
    s_cri4 "filespec/column" { type=integer; id=8; }
    s_cri5 "filespec/column" { type=integer; id=9; }
    s_type "filespec/column" { type=string; id=10; }
    s_label "filespec/column" { type=string; id=11; }
    s_desc "filespec/column" { type=string; id=12; }
    s_key "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
