$Version=2$
a_motivational_code "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_motivational_code";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_motivational_code "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_motivational_code_status "filespec/column" { type=string; id=3; }
    a_parent_motivational_code "filespec/column" { type=string; id=4; }
    m_list_code "filespec/column" { type=string; id=5; }
    a_fund "filespec/column" { type=string; id=6; }
    a_account_code "filespec/column" { type=string; id=7; }
    a_gift_admin_fee "filespec/column" { type=double; id=8; }
    a_gift_admin_subtype "filespec/column" { type=string; id=9; }
    a_gift_comment "filespec/column" { type=string; id=10; }
    a_comments "filespec/column" { type=string; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
