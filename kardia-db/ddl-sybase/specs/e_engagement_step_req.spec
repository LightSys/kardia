$Version=2$
e_engagement_step_req "application/filespec"
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
    e_due_days_from_req "filespec/column" { type=integer; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    e_req_id "filespec/column" { type=integer; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    e_due_days_from_step "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    e_req_waivable "filespec/column" { type=bit; id=8; }
    e_is_active "filespec/column" { type=bit; id=9; }
    e_due_days_from_req_id "filespec/column" { type=integer; id=10; }
    e_req_doc_type_id "filespec/column" { type=integer; id=11; }
    s_created_by "filespec/column" { type=varchar(20); id=12; }
    e_req_whom "filespec/column" { type=char(1); id=13; }
    e_req_name "filespec/column" { type=varchar(255); id=14; }
    e_req_sequence "filespec/column" { type=integer; id=15; }
    e_track_id "filespec/column" { type=integer; id=16; }
    e_step_id "filespec/column" { type=integer; id=17; }
    }
