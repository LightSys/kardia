$Version=2$
i_disb_import_classify "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_disb_import_classify";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_disb_classify_item "filespec/column" { type=integer; id=2; }
    i_disb_classify_active "filespec/column" { type=integer; id=3; }
    i_disb_match_ckno "filespec/column" { type=string; id=4; }
    i_disb_match_payee "filespec/column" { type=string; id=5; }
    i_disb_match_year "filespec/column" { type=integer; id=6; }
    i_disb_match_amount "filespec/column" { type=money; id=7; }
    i_disb_match_comment "filespec/column" { type=string; id=8; }
    i_disb_insert "filespec/column" { type=integer; id=9; }
    i_disb_set_account "filespec/column" { type=string; id=10; }
    i_disb_set_fund "filespec/column" { type=string; id=11; }
    i_disb_set_amount "filespec/column" { type=money; id=12; }
    a_comment "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
