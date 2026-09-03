$Version=2$
a_fund "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_fund";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_fund "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_parent_fund "filespec/column" { type=string; id=3; }
    a_bal_fund "filespec/column" { type=string; id=4; }
    a_fund_class "filespec/column" { type=string; id=5; }
    a_reporting_level "filespec/column" { type=integer; id=6; }
    a_is_posting "filespec/column" { type=integer; id=7; }
    a_is_external "filespec/column" { type=integer; id=8; }
    a_is_balancing "filespec/column" { type=integer; id=9; }
    a_restricted_type "filespec/column" { type=string; id=10; }
    a_fund_desc "filespec/column" { type=string; id=11; }
    a_fund_comments "filespec/column" { type=string; id=12; }
    a_legacy_code "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
