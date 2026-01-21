$Version=2$
e_partner_engagement "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    e_step_id "filespec/column" { type=integer; id=2; }
    e_exited_by "filespec/column" { type=char(10); id=3; }
    e_engagement_id "filespec/column" { type=integer; id=4; }
    e_track_id "filespec/column" { type=integer; id=5; }
    e_exited_date "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    e_desc "filespec/column" { type=varchar(40); id=9; }
    e_completion_date "filespec/column" { type=datetime; id=10; }
    p_partner_key "filespec/column" { type=char(10); id=11; }
    e_start_date "filespec/column" { type=datetime; id=12; }
    e_is_archived "filespec/column" { type=bit; id=13; }
    s_modified_by "filespec/column" { type=varchar(20); id=14; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=15; }
    e_comments "filespec/column" { type=varchar(900); id=16; }
    e_completion_status "filespec/column" { type=char(1); id=17; }
    e_started_by "filespec/column" { type=char(10); id=18; }
    e_completed_by "filespec/column" { type=char(10); id=19; }
    e_hist_id "filespec/column" { type=integer; id=20; }
    }
