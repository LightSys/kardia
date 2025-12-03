$Version=2$
p_dup "application/filespec"
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
    p_dup_contact_id "filespec/column" { type=integer; id=1; }
    p_partner_key "filespec/column" { type=char(10); id=2; }
    p_revision_id "filespec/column" { type=integer; id=3; }
    p_contact_id "filespec/column" { type=integer; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    p_match_quality "filespec/column" { type=float; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    p_location_id "filespec/column" { type=integer; id=10; }
    p_dup_revision_id "filespec/column" { type=integer; id=11; }
    s_created_by "filespec/column" { type=varchar(20); id=12; }
    p_dup_partner_key "filespec/column" { type=char(10); id=13; }
    p_comment "filespec/column" { type=varchar(900); id=14; }
    p_dup_location_id "filespec/column" { type=integer; id=15; }
    }
