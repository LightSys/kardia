$Version=2$
p_merge "application/filespec"
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
    p_comment "filespec/column" { type=varchar(900); id=1; }
    p_default_copy "filespec/column" { type=bit; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    p_allow_collate "filespec/column" { type=bit; id=4; }
    p_default_multiple "filespec/column" { type=bit; id=5; }
    p_data_source "filespec/column" { type=varchar(16); id=6; }
    p_default_marriage_move "filespec/column" { type=bit; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    p_partner_key_b "filespec/column" { type=char(10); id=9; }
    p_data_desc "filespec/column" { type=varchar(255); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    p_date_end "filespec/column" { type=datetime; id=12; }
    p_date_start "filespec/column" { type=datetime; id=13; }
    p_allow_delete "filespec/column" { type=bit; id=14; }
    p_allow_copy "filespec/column" { type=bit; id=15; }
    p_partner_key_a "filespec/column" { type=char(10); id=16; }
    p_data_key "filespec/column" { type=varchar(255); id=17; }
    s_date_created "filespec/column" { type=datetime; id=18; }
    s_date_modified "filespec/column" { type=datetime; id=19; }
    p_disposition "filespec/column" { type=varchar(3); id=20; }
    p_short_data_desc "filespec/column" { type=varchar(255); id=21; }
    p_default_marriage_copy "filespec/column" { type=bit; id=22; }
    p_allow_multiple "filespec/column" { type=bit; id=23; }
    }
