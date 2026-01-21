$Version=2$
i_crm_import_type_option "application/filespec"
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
    i_crm_task_due_days "filespec/column" { type=integer; id=1; }
    i_crm_tag_strength "filespec/column" { type=float; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    i_crm_tag_certainty "filespec/column" { type=float; id=4; }
    i_crm_option_field "filespec/column" { type=varchar(255); id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    i_crm_tag_strength_expr "filespec/column" { type=varchar(900); id=7; }
    i_crm_import_type_id "filespec/column" { type=integer; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    i_crm_track_step "filespec/column" { type=integer; id=10; }
    i_crm_option_class "filespec/column" { type=integer; id=11; }
    i_crm_import_type_option_desc "filespec/column" { type=varchar(255); id=12; }
    i_crm_option_comment "filespec/column" { type=varchar(900); id=13; }
    i_crm_collab_id "filespec/column" { type=char(10); id=14; }
    i_crm_option_value "filespec/column" { type=varchar(255); id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    i_crm_option_type "filespec/column" { type=char(1); id=17; }
    s_date_modified "filespec/column" { type=datetime; id=18; }
    i_crm_import_type_option_id "filespec/column" { type=integer; id=19; }
    i_crm_req_fulfill "filespec/column" { type=integer; id=20; }
    i_crm_tag_certainty_expr "filespec/column" { type=varchar(900); id=21; }
    }
