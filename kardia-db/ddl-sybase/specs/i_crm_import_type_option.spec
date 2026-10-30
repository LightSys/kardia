$Version=2$
i_crm_import_type_option "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_crm_import_type_option";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    i_crm_import_type_id "filespec/column" { type=integer; id=1; }
    i_crm_import_type_option_id "filespec/column" { type=integer; id=2; }
    i_crm_import_type_option_desc "filespec/column" { type=string; id=3; }
    i_crm_option_field "filespec/column" { type=string; id=4; }
    i_crm_option_value "filespec/column" { type=string; id=5; }
    i_crm_option_type "filespec/column" { type=string; id=6; }
    i_crm_option_class "filespec/column" { type=integer; id=7; }
    i_crm_option_comment "filespec/column" { type=string; id=8; }
    i_crm_tag_strength "filespec/column" { type=double; id=9; }
    i_crm_tag_strength_expr "filespec/column" { type=string; id=10; }
    i_crm_tag_certainty "filespec/column" { type=double; id=11; }
    i_crm_tag_certainty_expr "filespec/column" { type=string; id=12; }
    i_crm_task_due_days "filespec/column" { type=integer; id=13; }
    i_crm_track_step "filespec/column" { type=integer; id=14; }
    i_crm_req_fulfill "filespec/column" { type=integer; id=15; }
    i_crm_collab_id "filespec/column" { type=string; id=16; }
    s_date_created "filespec/column" { type=datetime; id=17; }
    s_created_by "filespec/column" { type=string; id=18; }
    s_date_modified "filespec/column" { type=datetime; id=19; }
    s_modified_by "filespec/column" { type=string; id=20; }
    __cx_osml_control "filespec/column" { type=string; id=21; }
    }
