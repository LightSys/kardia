$Version=2$
p_merge "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_merge";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key_a "filespec/column" { type=string; id=1; }
    p_partner_key_b "filespec/column" { type=string; id=2; }
    p_data_source "filespec/column" { type=string; id=3; }
    p_data_key "filespec/column" { type=string; id=4; }
    p_data_desc "filespec/column" { type=string; id=5; }
    p_short_data_desc "filespec/column" { type=string; id=6; }
    p_date_start "filespec/column" { type=datetime; id=7; }
    p_date_end "filespec/column" { type=datetime; id=8; }
    p_allow_copy "filespec/column" { type=integer; id=9; }
    p_default_copy "filespec/column" { type=integer; id=10; }
    p_default_marriage_copy "filespec/column" { type=integer; id=11; }
    p_default_marriage_move "filespec/column" { type=integer; id=12; }
    p_allow_multiple "filespec/column" { type=integer; id=13; }
    p_default_multiple "filespec/column" { type=integer; id=14; }
    p_allow_delete "filespec/column" { type=integer; id=15; }
    p_allow_collate "filespec/column" { type=integer; id=16; }
    p_disposition "filespec/column" { type=string; id=17; }
    p_comment "filespec/column" { type=string; id=18; }
    s_date_created "filespec/column" { type=datetime; id=19; }
    s_created_by "filespec/column" { type=string; id=20; }
    s_date_modified "filespec/column" { type=datetime; id=21; }
    s_modified_by "filespec/column" { type=string; id=22; }
    __cx_osml_control "filespec/column" { type=string; id=23; }
    }
