$Version=2$
e_partner_engagement "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_partner_engagement";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    e_engagement_id "filespec/column" { type=integer; id=2; }
    e_hist_id "filespec/column" { type=integer; id=3; }
    e_track_id "filespec/column" { type=integer; id=4; }
    e_step_id "filespec/column" { type=integer; id=5; }
    e_is_archived "filespec/column" { type=integer; id=6; }
    e_completion_status "filespec/column" { type=string; id=7; }
    e_desc "filespec/column" { type=string; id=8; }
    e_comments "filespec/column" { type=string; id=9; }
    e_start_date "filespec/column" { type=datetime; id=10; }
    e_started_by "filespec/column" { type=string; id=11; }
    e_completion_date "filespec/column" { type=datetime; id=12; }
    e_completed_by "filespec/column" { type=string; id=13; }
    e_exited_date "filespec/column" { type=datetime; id=14; }
    e_exited_by "filespec/column" { type=string; id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    s_created_by "filespec/column" { type=string; id=17; }
    s_date_modified "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=string; id=19; }
    __cx_osml_control "filespec/column" { type=string; id=20; }
    }
