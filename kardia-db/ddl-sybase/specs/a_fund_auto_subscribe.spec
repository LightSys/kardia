$Version=2$
a_fund_auto_subscribe "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_fund_auto_subscribe";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_fund "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    m_list_code "filespec/column" { type=string; id=3; }
    a_minimum_gift "filespec/column" { type=money; id=4; }
    a_subscribe_months "filespec/column" { type=integer; id=5; }
    a_comments "filespec/column" { type=string; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
