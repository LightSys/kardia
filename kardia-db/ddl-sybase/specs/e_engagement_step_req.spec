$Version=2$
e_engagement_step_req "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_engagement_step_req";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_track_id "filespec/column" { type=integer; id=1; }
    e_step_id "filespec/column" { type=integer; id=2; }
    e_req_id "filespec/column" { type=integer; id=3; }
    e_req_name "filespec/column" { type=string; id=4; }
    e_due_days_from_step "filespec/column" { type=integer; id=5; }
    e_due_days_from_req "filespec/column" { type=integer; id=6; }
    e_due_days_from_req_id "filespec/column" { type=integer; id=7; }
    e_req_whom "filespec/column" { type=string; id=8; }
    e_req_doc_type_id "filespec/column" { type=integer; id=9; }
    e_req_waivable "filespec/column" { type=integer; id=10; }
    e_req_sequence "filespec/column" { type=integer; id=11; }
    e_is_active "filespec/column" { type=integer; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
