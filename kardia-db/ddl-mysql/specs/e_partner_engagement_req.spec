$Version=2$
e_partner_engagement_req "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_partner_engagement_req";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    e_engagement_id "filespec/column" { type=integer; id=2; }
    e_hist_id "filespec/column" { type=integer; id=3; }
    e_req_item_id "filespec/column" { type=integer; id=4; }
    e_track_id "filespec/column" { type=integer; id=5; }
    e_step_id "filespec/column" { type=integer; id=6; }
    e_req_id "filespec/column" { type=integer; id=7; }
    e_req_completion_status "filespec/column" { type=string; id=8; }
    e_req_name "filespec/column" { type=string; id=9; }
    e_due_days_from_step "filespec/column" { type=integer; id=10; }
    e_due_days_from_req "filespec/column" { type=integer; id=11; }
    e_due_days_from_req_id "filespec/column" { type=integer; id=12; }
    e_req_whom "filespec/column" { type=string; id=13; }
    e_req_doc_type_id "filespec/column" { type=integer; id=14; }
    e_req_waivable "filespec/column" { type=integer; id=15; }
    e_req_doc_id "filespec/column" { type=integer; id=16; }
    e_completion_date "filespec/column" { type=datetime; id=17; }
    e_completed_by "filespec/column" { type=string; id=18; }
    e_waived_date "filespec/column" { type=datetime; id=19; }
    e_waived_by "filespec/column" { type=string; id=20; }
    e_req_sequence "filespec/column" { type=integer; id=21; }
    e_is_active "filespec/column" { type=integer; id=22; }
    s_date_created "filespec/column" { type=datetime; id=23; }
    s_created_by "filespec/column" { type=string; id=24; }
    s_date_modified "filespec/column" { type=datetime; id=25; }
    s_modified_by "filespec/column" { type=string; id=26; }
    __cx_osml_control "filespec/column" { type=string; id=27; }
    }
