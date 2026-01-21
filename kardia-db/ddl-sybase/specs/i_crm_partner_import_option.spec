$Version=2$
i_crm_partner_import_option "application/filespec"
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
    i_crm_tag_certainty "filespec/column" { type=float; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    i_crm_tag_strength "filespec/column" { type=float; id=3; }
    i_crm_create_option "filespec/column" { type=bit; id=4; }
    i_crm_task_due_days "filespec/column" { type=integer; id=5; }
    i_crm_import_type_id "filespec/column" { type=integer; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    i_crm_import_id "filespec/column" { type=integer; id=8; }
    i_crm_collab_id "filespec/column" { type=char(10); id=9; }
    i_crm_option_comment "filespec/column" { type=varchar(900); id=10; }
    i_crm_track_step "filespec/column" { type=integer; id=11; }
    s_created_by "filespec/column" { type=varchar(20); id=12; }
    i_crm_import_type_option_id "filespec/column" { type=integer; id=13; }
    i_crm_req_fulfill "filespec/column" { type=integer; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    i_crm_import_session_id "filespec/column" { type=integer; id=16; }
    s_date_created "filespec/column" { type=datetime; id=17; }
    }
