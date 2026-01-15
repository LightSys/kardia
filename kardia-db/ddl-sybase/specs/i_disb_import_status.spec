$Version=2$
i_disb_import_status "application/filespec"
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
    i_disb_legacy_amount "filespec/column" { type=decimal(14,4); id=2; }
    i_disb_legacy_payee "filespec/column" { type=varchar(20); id=3; }
    i_disb_legacy_enteredby "filespec/column" { type=varchar(20); id=4; }
    i_disb_partner_key "filespec/column" { type=varchar(20); id=5; }
    i_disb_legacy_key "filespec/column" { type=varchar(20); id=6; }
    i_disb_import_comments "filespec/column" { type=varchar(900); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    i_disb_legacy_approveddate "filespec/column" { type=datetime; id=11; }
    i_disb_import_status "filespec/column" { type=char(1); id=12; }
    a_ledger_number "filespec/column" { type=char(10); id=13; }
    i_disb_legacy_paydate "filespec/column" { type=datetime; id=14; }
    i_disb_legacy_approvedby "filespec/column" { type=varchar(20); id=15; }
    i_disb_legacy_ckno "filespec/column" { type=varchar(20); id=16; }
    s_created_by "filespec/column" { type=varchar(20); id=17; }
    i_disb_legacy_entereddate "filespec/column" { type=datetime; id=18; }
    }
