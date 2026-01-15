$Version=2$
a_account "application/filespec"
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
    a_acct_comment "filespec/column" { type=varchar(255); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    s_date_modified "filespec/column" { type=datetime; id=4; }
    a_acct_type "filespec/column" { type=char(1); id=5; }
    a_account_class "filespec/column" { type=char(3); id=6; }
    a_is_intrafund_xfer "filespec/column" { type=bit; id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    a_reporting_level "filespec/column" { type=integer; id=9; }
    a_default_category "filespec/column" { type=char(8); id=10; }
    a_account_code "filespec/column" { type=char(16); id=11; }
    p_banking_details_key "filespec/column" { type=char(10); id=12; }
    a_is_contra "filespec/column" { type=bit; id=13; }
    a_is_posting "filespec/column" { type=bit; id=14; }
    a_legacy_code "filespec/column" { type=varchar(32); id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    s_modified_by "filespec/column" { type=varchar(20); id=17; }
    a_is_interfund_xfer "filespec/column" { type=bit; id=18; }
    a_acct_desc "filespec/column" { type=varchar(32); id=19; }
    a_is_inverted "filespec/column" { type=bit; id=20; }
    a_parent_account_code "filespec/column" { type=char(16); id=21; }
    }
