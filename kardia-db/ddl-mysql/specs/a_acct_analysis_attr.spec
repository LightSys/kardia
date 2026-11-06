$Version=2$
a_acct_analysis_attr "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_acct_analysis_attr";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_attr_code "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_account_code "filespec/column" { type=string; id=3; }
    a_hist_id "filespec/column" { type=integer; id=4; }
    a_start_date "filespec/column" { type=datetime; id=5; }
    a_end_date "filespec/column" { type=datetime; id=6; }
    a_value "filespec/column" { type=string; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
