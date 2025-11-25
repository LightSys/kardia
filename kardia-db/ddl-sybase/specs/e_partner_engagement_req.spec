$Version=2$
e_partner_engagement_req "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    e_req_waivable "filespec/column" { type=bit; id=3; }
    e_is_active "filespec/column" { type=bit; id=4; }
    p_partner_key "filespec/column" { type=char(10); id=5; }
    e_due_days_from_req_id "filespec/column" { type=integer; id=6; }
    e_completion_date "filespec/column" { type=datetime; id=7; }
    e_req_doc_type_id "filespec/column" { type=integer; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    e_req_name "filespec/column" { type=varchar(255); id=10; }
    e_req_whom "filespec/column" { type=char(1); id=11; }
    e_req_doc_id "filespec/column" { type=integer; id=12; }
    e_req_sequence "filespec/column" { type=integer; id=13; }
    e_step_id "filespec/column" { type=integer; id=14; }
    e_engagement_id "filespec/column" { type=integer; id=15; }
    e_track_id "filespec/column" { type=integer; id=16; }
    e_req_item_id "filespec/column" { type=integer; id=17; }
    e_due_days_from_req "filespec/column" { type=integer; id=18; }
    e_completed_by "filespec/column" { type=char(10); id=19; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=20; }
    e_hist_id "filespec/column" { type=integer; id=21; }
    e_waived_by "filespec/column" { type=char(10); id=22; }
    e_req_completion_status "filespec/column" { type=char(1); id=23; }
    e_req_id "filespec/column" { type=integer; id=24; }
    e_waived_date "filespec/column" { type=datetime; id=25; }
    s_modified_by "filespec/column" { type=varchar(20); id=26; }
    e_due_days_from_step "filespec/column" { type=integer; id=27; }
    }
