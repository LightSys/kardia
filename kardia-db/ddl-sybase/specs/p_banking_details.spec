$Version=2$
p_banking_details "application/filespec"
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
    p_partner_id "filespec/column" { type=char(10); id=1; }
    a_account_code "filespec/column" { type=char(16); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    p_banking_details_key "filespec/column" { type=integer; id=4; }
    p_bank_account_number "filespec/column" { type=varchar(32); id=5; }
    p_bank_account_name "filespec/column" { type=varchar(80); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    p_bank_partner_id "filespec/column" { type=char(10); id=8; }
    p_banking_type "filespec/column" { type=char(1); id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    a_ledger_number "filespec/column" { type=char(10); id=11; }
    p_comment "filespec/column" { type=varchar(255); id=12; }
    p_banking_card_type "filespec/column" { type=char(2); id=13; }
    s_modified_by "filespec/column" { type=varchar(20); id=14; }
    p_bank_routing_number "filespec/column" { type=varchar(32); id=15; }
    p_bank_expiration "filespec/column" { type=datetime; id=16; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=17; }
    p_next_check_number "filespec/column" { type=integer; id=18; }
    }
