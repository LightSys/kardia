$Version=2$
i_disb_import_status "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_disb_import_status";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_disb_legacy_key "filespec/column" { type=string; id=2; }
    i_disb_legacy_amount "filespec/column" { type=money; id=3; }
    i_disb_legacy_payee "filespec/column" { type=string; id=4; }
    i_disb_partner_key "filespec/column" { type=string; id=5; }
    i_disb_legacy_ckno "filespec/column" { type=string; id=6; }
    i_disb_legacy_paydate "filespec/column" { type=datetime; id=7; }
    i_disb_legacy_entereddate "filespec/column" { type=datetime; id=8; }
    i_disb_legacy_approveddate "filespec/column" { type=datetime; id=9; }
    i_disb_legacy_enteredby "filespec/column" { type=string; id=10; }
    i_disb_legacy_approvedby "filespec/column" { type=string; id=11; }
    i_disb_import_status "filespec/column" { type=string; id=12; }
    i_disb_import_comments "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
