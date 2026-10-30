$Version=2$
i_crm_partner_import "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_crm_partner_import";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    i_crm_import_id "filespec/column" { type=integer; id=1; }
    i_crm_import_session_id "filespec/column" { type=integer; id=2; }
    i_crm_import_type_id "filespec/column" { type=integer; id=3; }
    i_crm_import_status "filespec/column" { type=string; id=4; }
    i_crm_external_key "filespec/column" { type=string; id=5; }
    i_crm_partner_key "filespec/column" { type=string; id=6; }
    i_crm_create_partner "filespec/column" { type=integer; id=7; }
    i_crm_create_email "filespec/column" { type=integer; id=8; }
    i_crm_create_phone "filespec/column" { type=integer; id=9; }
    i_crm_surname "filespec/column" { type=string; id=10; }
    i_crm_given_name "filespec/column" { type=string; id=11; }
    i_crm_date "filespec/column" { type=datetime; id=12; }
    i_crm_org_name "filespec/column" { type=string; id=13; }
    i_crm_phone "filespec/column" { type=string; id=14; }
    i_crm_email "filespec/column" { type=string; id=15; }
    i_crm_address1 "filespec/column" { type=string; id=16; }
    i_crm_address2 "filespec/column" { type=string; id=17; }
    i_crm_address3 "filespec/column" { type=string; id=18; }
    i_crm_in_care_of "filespec/column" { type=string; id=19; }
    i_crm_city "filespec/column" { type=string; id=20; }
    i_crm_state_province "filespec/column" { type=string; id=21; }
    i_crm_postal_code "filespec/column" { type=string; id=22; }
    i_crm_country_code "filespec/column" { type=string; id=23; }
    i_crm_comment "filespec/column" { type=string; id=24; }
    i_crm_addr_comment "filespec/column" { type=string; id=25; }
    s_date_created "filespec/column" { type=datetime; id=26; }
    s_created_by "filespec/column" { type=string; id=27; }
    s_date_modified "filespec/column" { type=datetime; id=28; }
    s_modified_by "filespec/column" { type=string; id=29; }
    __cx_osml_control "filespec/column" { type=string; id=30; }
    }
