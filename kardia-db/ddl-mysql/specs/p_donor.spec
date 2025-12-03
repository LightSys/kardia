$Version=2$
p_donor "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_donor";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    a_gl_ledger_number "filespec/column" { type=string; id=2; }
    a_gl_account_code "filespec/column" { type=string; id=3; }
    p_account_with_donor "filespec/column" { type=string; id=4; }
    p_allow_contributions "filespec/column" { type=integer; id=5; }
    p_location_id "filespec/column" { type=integer; id=6; }
    p_contact_id "filespec/column" { type=integer; id=7; }
    p_org_name_first "filespec/column" { type=integer; id=8; }
    p_receipt_desired "filespec/column" { type=string; id=9; }
    p_is_daf "filespec/column" { type=integer; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
