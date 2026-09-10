$Version=2$
a_admin_fee_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_admin_fee_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_admin_fee_type "filespec/column" { type=string; id=2; }
    a_admin_fee_subtype "filespec/column" { type=string; id=3; }
    a_admin_fee_type_desc "filespec/column" { type=string; id=4; }
    a_is_default_subtype "filespec/column" { type=integer; id=5; }
    a_default_percentage "filespec/column" { type=double; id=6; }
    a_tmp_total_percentage "filespec/column" { type=double; id=7; }
    a_tmp_fixed_percentage "filespec/column" { type=double; id=8; }
    a_comment "filespec/column" { type=string; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
