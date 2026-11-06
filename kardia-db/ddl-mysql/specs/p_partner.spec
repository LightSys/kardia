$Version=2$
p_partner "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_partner";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_creating_office "filespec/column" { type=string; id=2; }
    p_parent_key "filespec/column" { type=string; id=3; }
    p_partner_class "filespec/column" { type=string; id=4; }
    p_status_code "filespec/column" { type=string; id=5; }
    p_status_change_date "filespec/column" { type=datetime; id=6; }
    p_title "filespec/column" { type=string; id=7; }
    p_given_name "filespec/column" { type=string; id=8; }
    p_preferred_name "filespec/column" { type=string; id=9; }
    p_surname "filespec/column" { type=string; id=10; }
    p_surname_first "filespec/column" { type=integer; id=11; }
    p_localized_name "filespec/column" { type=string; id=12; }
    p_suffix "filespec/column" { type=string; id=13; }
    p_org_name "filespec/column" { type=string; id=14; }
    p_gender "filespec/column" { type=string; id=15; }
    p_language_code "filespec/column" { type=string; id=16; }
    p_acquisition_code "filespec/column" { type=string; id=17; }
    p_comments "filespec/column" { type=string; id=18; }
    p_record_status_code "filespec/column" { type=string; id=19; }
    p_no_mail_reason "filespec/column" { type=string; id=20; }
    p_no_solicitations "filespec/column" { type=integer; id=21; }
    p_no_mail "filespec/column" { type=integer; id=22; }
    a_fund "filespec/column" { type=string; id=23; }
    p_best_contact "filespec/column" { type=string; id=24; }
    p_merged_with "filespec/column" { type=string; id=25; }
    p_legacy_key_1 "filespec/column" { type=string; id=26; }
    p_legacy_key_2 "filespec/column" { type=string; id=27; }
    p_legacy_key_3 "filespec/column" { type=string; id=28; }
    s_date_created "filespec/column" { type=datetime; id=29; }
    s_created_by "filespec/column" { type=string; id=30; }
    s_date_modified "filespec/column" { type=datetime; id=31; }
    s_modified_by "filespec/column" { type=string; id=32; }
    __cx_osml_control "filespec/column" { type=string; id=33; }
    }
