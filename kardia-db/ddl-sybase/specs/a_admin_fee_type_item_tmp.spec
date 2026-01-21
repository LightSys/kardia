$Version=2$
a_admin_fee_type_item_tmp "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    a_admin_fee_type "filespec/column" { type=char(3); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    a_comment "filespec/column" { type=varchar(255); id=4; }
    a_dest_fund "filespec/column" { type=char(20); id=5; }
    a_percentage "filespec/column" { type=float; id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_is_fixed "filespec/column" { type=bit; id=8; }
    a_admin_fee_subtype "filespec/column" { type=char(1); id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    }
