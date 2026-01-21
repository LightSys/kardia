$Version=2$
i_disb_import_classify "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    i_disb_classify_item "filespec/column" { type=integer; id=3; }
    a_ledger_number "filespec/column" { type=char(10); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    i_disb_set_fund "filespec/column" { type=varchar(20); id=6; }
    i_disb_match_comment "filespec/column" { type=varchar(255); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    i_disb_match_ckno "filespec/column" { type=varchar(20); id=9; }
    i_disb_match_amount "filespec/column" { type=decimal(14,4); id=10; }
    i_disb_classify_active "filespec/column" { type=bit; id=11; }
    i_disb_match_payee "filespec/column" { type=varchar(20); id=12; }
    i_disb_set_account "filespec/column" { type=varchar(20); id=13; }
    i_disb_set_amount "filespec/column" { type=decimal(14,4); id=14; }
    a_comment "filespec/column" { type=varchar(255); id=15; }
    i_disb_match_year "filespec/column" { type=integer; id=16; }
    i_disb_insert "filespec/column" { type=bit; id=17; }
    s_modified_by "filespec/column" { type=varchar(20); id=18; }
    }
