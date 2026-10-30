$Version=2$
p_banking_details "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_banking_details";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_banking_details_key "filespec/column" { type=integer; id=1; }
    p_banking_type "filespec/column" { type=string; id=2; }
    p_banking_card_type "filespec/column" { type=string; id=3; }
    p_partner_id "filespec/column" { type=string; id=4; }
    p_bank_partner_id "filespec/column" { type=string; id=5; }
    p_bank_account_name "filespec/column" { type=string; id=6; }
    p_bank_account_number "filespec/column" { type=string; id=7; }
    p_bank_routing_number "filespec/column" { type=string; id=8; }
    p_next_check_number "filespec/column" { type=integer; id=9; }
    p_bank_expiration "filespec/column" { type=datetime; id=10; }
    a_ledger_number "filespec/column" { type=string; id=11; }
    a_account_code "filespec/column" { type=string; id=12; }
    p_comment "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
