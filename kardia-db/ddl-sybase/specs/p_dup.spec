$Version=2$
p_dup "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_dup";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_dup_partner_key "filespec/column" { type=string; id=2; }
    p_match_quality "filespec/column" { type=double; id=3; }
    p_location_id "filespec/column" { type=integer; id=4; }
    p_dup_location_id "filespec/column" { type=integer; id=5; }
    p_revision_id "filespec/column" { type=integer; id=6; }
    p_dup_revision_id "filespec/column" { type=integer; id=7; }
    p_contact_id "filespec/column" { type=integer; id=8; }
    p_dup_contact_id "filespec/column" { type=integer; id=9; }
    p_comment "filespec/column" { type=string; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
