$Version=2$
a_account "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_account";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_account_code "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_parent_account_code "filespec/column" { type=string; id=3; }
    a_acct_type "filespec/column" { type=string; id=4; }
    a_account_class "filespec/column" { type=string; id=5; }
    a_reporting_level "filespec/column" { type=integer; id=6; }
    p_banking_details_key "filespec/column" { type=string; id=7; }
    a_is_contra "filespec/column" { type=integer; id=8; }
    a_is_posting "filespec/column" { type=integer; id=9; }
    a_is_inverted "filespec/column" { type=integer; id=10; }
    a_is_intrafund_xfer "filespec/column" { type=integer; id=11; }
    a_is_interfund_xfer "filespec/column" { type=integer; id=12; }
    a_acct_desc "filespec/column" { type=string; id=13; }
    a_acct_comment "filespec/column" { type=string; id=14; }
    a_legacy_code "filespec/column" { type=string; id=15; }
    a_default_category "filespec/column" { type=string; id=16; }
    s_date_created "filespec/column" { type=datetime; id=17; }
    s_created_by "filespec/column" { type=string; id=18; }
    s_date_modified "filespec/column" { type=datetime; id=19; }
    s_modified_by "filespec/column" { type=string; id=20; }
    __cx_osml_control "filespec/column" { type=string; id=21; }
    }
