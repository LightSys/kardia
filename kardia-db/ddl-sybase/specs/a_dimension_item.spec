$Version=2$
a_dimension_item "application/filespec"
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
    a_legacy_code "filespec/column" { type=varchar(32); id=2; }
    a_end_date "filespec/column" { type=datetime; id=3; }
    a_dimension "filespec/column" { type=char(20); id=4; }
    a_is_posting "filespec/column" { type=bit; id=5; }
    a_dim_item_desc "filespec/column" { type=char(32); id=6; }
    a_dim_item_fund "filespec/column" { type=char(20); id=7; }
    a_dim_item_fund_class "filespec/column" { type=char(3); id=8; }
    a_dim_item_usage "filespec/column" { type=char(1); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    a_dimension_item "filespec/column" { type=char(20); id=11; }
    a_start_date "filespec/column" { type=datetime; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    a_dim_item_comments "filespec/column" { type=varchar(255); id=15; }
    a_ledger_number "filespec/column" { type=char(10); id=16; }
    s_created_by "filespec/column" { type=varchar(20); id=17; }
    }
