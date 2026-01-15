$Version=2$
a_fund "application/filespec"
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
    a_ledger_number "filespec/column" { type=char(10); id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    a_is_balancing "filespec/column" { type=bit; id=3; }
    a_fund_comments "filespec/column" { type=varchar(255); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    a_reporting_level "filespec/column" { type=integer; id=7; }
    a_fund_desc "filespec/column" { type=char(32); id=8; }
    a_fund "filespec/column" { type=char(20); id=9; }
    a_is_external "filespec/column" { type=bit; id=10; }
    a_restricted_type "filespec/column" { type=char(1); id=11; }
    a_is_posting "filespec/column" { type=bit; id=12; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=13; }
    a_legacy_code "filespec/column" { type=varchar(32); id=14; }
    s_modified_by "filespec/column" { type=varchar(20); id=15; }
    a_fund_class "filespec/column" { type=char(3); id=16; }
    a_parent_fund "filespec/column" { type=char(20); id=17; }
    a_bal_fund "filespec/column" { type=char(20); id=18; }
    }
