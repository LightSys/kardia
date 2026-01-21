$Version=2$
i_crm_import_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_crm_import_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    i_crm_import_type_id "filespec/column" { type=integer; id=1; }
    i_crm_import_type_desc "filespec/column" { type=string; id=2; }
    i_crm_import_type_subsys "filespec/column" { type=string; id=3; }
    i_crm_import_type_path "filespec/column" { type=string; id=4; }
    i_crm_field_pk "filespec/column" { type=string; id=5; }
    i_crm_field_surname "filespec/column" { type=string; id=6; }
    i_crm_field_given_name "filespec/column" { type=string; id=7; }
    i_crm_field_middle_name "filespec/column" { type=string; id=8; }
    i_crm_field_date "filespec/column" { type=string; id=9; }
    i_crm_field_org_name "filespec/column" { type=string; id=10; }
    i_crm_field_phone "filespec/column" { type=string; id=11; }
    i_crm_field_email "filespec/column" { type=string; id=12; }
    i_crm_field_addr1 "filespec/column" { type=string; id=13; }
    i_crm_field_addr2 "filespec/column" { type=string; id=14; }
    i_crm_field_addr3 "filespec/column" { type=string; id=15; }
    i_crm_field_careof "filespec/column" { type=string; id=16; }
    i_crm_field_city "filespec/column" { type=string; id=17; }
    i_crm_field_stateprov "filespec/column" { type=string; id=18; }
    i_crm_field_postal_code "filespec/column" { type=string; id=19; }
    i_crm_field_country "filespec/column" { type=string; id=20; }
    i_crm_country_type "filespec/column" { type=string; id=21; }
    i_crm_field_comment "filespec/column" { type=string; id=22; }
    i_crm_field_addr_comment "filespec/column" { type=string; id=23; }
    s_date_created "filespec/column" { type=datetime; id=24; }
    s_created_by "filespec/column" { type=string; id=25; }
    s_date_modified "filespec/column" { type=datetime; id=26; }
    s_modified_by "filespec/column" { type=string; id=27; }
    __cx_osml_control "filespec/column" { type=string; id=28; }
    }
