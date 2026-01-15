$Version=2$
a_acct_analysis_attr "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    a_account_code "filespec/column" { type=char(16); id=2; }
    a_hist_id "filespec/column" { type=integer; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    a_attr_code "filespec/column" { type=char(8); id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    a_start_date "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    a_end_date "filespec/column" { type=datetime; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    a_value "filespec/column" { type=varchar(255); id=11; }
    a_ledger_number "filespec/column" { type=char(10); id=12; }
    }
