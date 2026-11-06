$Version=2$
i_crm_partner_import_option "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_crm_partner_import_option";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    i_crm_import_id "filespec/column" { type=integer; id=1; }
    i_crm_import_session_id "filespec/column" { type=integer; id=2; }
    i_crm_import_type_id "filespec/column" { type=integer; id=3; }
    i_crm_import_type_option_id "filespec/column" { type=integer; id=4; }
    i_crm_option_comment "filespec/column" { type=string; id=5; }
    i_crm_tag_strength "filespec/column" { type=double; id=6; }
    i_crm_tag_certainty "filespec/column" { type=double; id=7; }
    i_crm_task_due_days "filespec/column" { type=integer; id=8; }
    i_crm_track_step "filespec/column" { type=integer; id=9; }
    i_crm_req_fulfill "filespec/column" { type=integer; id=10; }
    i_crm_collab_id "filespec/column" { type=string; id=11; }
    i_crm_create_option "filespec/column" { type=integer; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
