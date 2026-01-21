$Version=2$
a_dimension "application/filespec"
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
    a_dim_fund "filespec/column" { type=char(20); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    a_dim_fund_class "filespec/column" { type=char(3); id=3; }
    a_lock_always_show "filespec/column" { type=bit; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_lock_position "filespec/column" { type=integer; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    a_default_item "filespec/column" { type=varchar(20); id=8; }
    a_start_date "filespec/column" { type=datetime; id=9; }
    a_ledger_number "filespec/column" { type=char(10); id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    a_is_posting "filespec/column" { type=bit; id=12; }
    a_dim_desc "filespec/column" { type=char(32); id=13; }
    a_dimension "filespec/column" { type=char(20); id=14; }
    a_end_date "filespec/column" { type=datetime; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    a_legacy_code "filespec/column" { type=varchar(32); id=17; }
    a_required "filespec/column" { type=bit; id=18; }
    a_dim_usage "filespec/column" { type=char(1); id=19; }
    a_dim_comments "filespec/column" { type=varchar(255); id=20; }
    }
