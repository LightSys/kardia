$Version=2$
a_analysis_attr "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_analysis_attr";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_attr_code "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_desc "filespec/column" { type=string; id=3; }
    a_fund_enab "filespec/column" { type=integer; id=4; }
    a_acct_enab "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
