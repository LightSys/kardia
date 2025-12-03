$Version=2$
r_group_sched_report "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    r_group_sched_error "filespec/column" { type=varchar(900); id=4; }
    r_group_sched_file "filespec/column" { type=varchar(900); id=5; }
    r_group_sched_status "filespec/column" { type=char(1); id=6; }
    p_recipient_partner_key "filespec/column" { type=char(10); id=7; }
    r_group_sched_sent_date "filespec/column" { type=datetime; id=8; }
    r_group_sched_id "filespec/column" { type=integer; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    r_group_sched_address "filespec/column" { type=varchar(80); id=11; }
    r_report_id "filespec/column" { type=integer; id=12; }
    s_modified_by "filespec/column" { type=varchar(20); id=13; }
    r_group_name "filespec/column" { type=char(8); id=14; }
    r_delivery_method "filespec/column" { type=varchar(1); id=15; }
    }
