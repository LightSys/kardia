$Version=2$
p_partner "application/filespec"
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
    p_language_code "filespec/column" { type=char(3); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    p_legacy_key_2 "filespec/column" { type=char(10); id=4; }
    s_modified_by "filespec/column" { type=varchar(20); id=5; }
    p_record_status_code "filespec/column" { type=char(1); id=6; }
    p_status_change_date "filespec/column" { type=datetime; id=7; }
    p_suffix "filespec/column" { type=varchar(64); id=8; }
    p_merged_with "filespec/column" { type=char(10); id=9; }
    p_legacy_key_3 "filespec/column" { type=char(10); id=10; }
    p_comments "filespec/column" { type=varchar(1536); id=11; }
    a_fund "filespec/column" { type=varchar(20); id=12; }
    p_org_name "filespec/column" { type=varchar(64); id=13; }
    p_surname_first "filespec/column" { type=bit; id=14; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=15; }
    p_best_contact "filespec/column" { type=char(10); id=16; }
    p_acquisition_code "filespec/column" { type=char(3); id=17; }
    p_partner_key "filespec/column" { type=char(10); id=18; }
    p_no_mail_reason "filespec/column" { type=char(1); id=19; }
    s_date_created "filespec/column" { type=datetime; id=20; }
    p_status_code "filespec/column" { type=char(1); id=21; }
    p_partner_class "filespec/column" { type=char(3); id=22; }
    p_given_name "filespec/column" { type=varchar(64); id=23; }
    p_no_solicitations "filespec/column" { type=bit; id=24; }
    p_gender "filespec/column" { type=char(1); id=25; }
    p_localized_name "filespec/column" { type=varchar(96); id=26; }
    p_no_mail "filespec/column" { type=bit; id=27; }
    p_creating_office "filespec/column" { type=char(10); id=28; }
    p_surname "filespec/column" { type=varchar(64); id=29; }
    p_title "filespec/column" { type=varchar(64); id=30; }
    p_preferred_name "filespec/column" { type=varchar(64); id=31; }
    p_parent_key "filespec/column" { type=char(10); id=32; }
    p_legacy_key_1 "filespec/column" { type=char(10); id=33; }
    }
