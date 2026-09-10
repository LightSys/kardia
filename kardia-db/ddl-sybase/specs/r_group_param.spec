$Version=2$
r_group_param "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for r_group_param";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    r_group_name "filespec/column" { type=string; id=1; }
    r_param_name "filespec/column" { type=string; id=2; }
    r_param_description "filespec/column" { type=string; id=3; }
    r_is_group_param "filespec/column" { type=integer; id=4; }
    r_is_report_param "filespec/column" { type=integer; id=5; }
    r_is_sched_param "filespec/column" { type=integer; id=6; }
    r_is_required "filespec/column" { type=integer; id=7; }
    r_pass_to_report "filespec/column" { type=integer; id=8; }
    r_pass_to_template "filespec/column" { type=integer; id=9; }
    r_param_cmp_module "filespec/column" { type=string; id=10; }
    r_param_cmp_file "filespec/column" { type=string; id=11; }
    r_param_ui_sequence "filespec/column" { type=integer; id=12; }
    r_param_default "filespec/column" { type=string; id=13; }
    r_param_default_expr "filespec/column" { type=string; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_created_by "filespec/column" { type=string; id=16; }
    s_date_modified "filespec/column" { type=datetime; id=17; }
    s_modified_by "filespec/column" { type=string; id=18; }
    __cx_osml_control "filespec/column" { type=string; id=19; }
    }
