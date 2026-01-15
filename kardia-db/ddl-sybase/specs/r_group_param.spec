$Version=2$
r_group_param "application/filespec"
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
    r_is_group_param "filespec/column" { type=bit; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    r_param_cmp_file "filespec/column" { type=varchar(256); id=3; }
    r_param_ui_sequence "filespec/column" { type=integer; id=4; }
    r_param_name "filespec/column" { type=varchar(64); id=5; }
    r_pass_to_template "filespec/column" { type=bit; id=6; }
    r_param_description "filespec/column" { type=varchar(255); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    r_group_name "filespec/column" { type=char(8); id=9; }
    r_pass_to_report "filespec/column" { type=bit; id=10; }
    r_is_required "filespec/column" { type=bit; id=11; }
    s_created_by "filespec/column" { type=varchar(20); id=12; }
    r_is_report_param "filespec/column" { type=bit; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    r_param_default "filespec/column" { type=varchar(1536); id=15; }
    r_param_cmp_module "filespec/column" { type=varchar(64); id=16; }
    r_is_sched_param "filespec/column" { type=bit; id=17; }
    r_param_default_expr "filespec/column" { type=varchar(1536); id=18; }
    s_date_modified "filespec/column" { type=datetime; id=19; }
    }
