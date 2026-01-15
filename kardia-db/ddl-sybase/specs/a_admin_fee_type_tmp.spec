$Version=2$
a_admin_fee_type_tmp "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_is_default_subtype "filespec/column" { type=bit; id=4; }
    a_tmp_fixed_percentage "filespec/column" { type=float; id=5; }
    a_ledger_number "filespec/column" { type=char(10); id=6; }
    a_admin_fee_subtype "filespec/column" { type=char(1); id=7; }
    a_default_percentage "filespec/column" { type=float; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    a_admin_fee_type_desc "filespec/column" { type=varchar(255); id=10; }
    a_comment "filespec/column" { type=varchar(255); id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    a_admin_fee_type "filespec/column" { type=char(3); id=13; }
    a_tmp_total_percentage "filespec/column" { type=float; id=14; }
    }
