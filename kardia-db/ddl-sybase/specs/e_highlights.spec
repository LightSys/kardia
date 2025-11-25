$Version=2$
e_highlights "application/filespec"
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
    e_highlight_reference_info "filespec/column" { type=varchar(255); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    e_highlight_strength "filespec/column" { type=float; id=3; }
    e_highlight_name "filespec/column" { type=varchar(64); id=4; }
    e_highlight_type "filespec/column" { type=varchar(20); id=5; }
    e_highlight_id "filespec/column" { type=varchar(64); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    e_highlight_certainty "filespec/column" { type=float; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    e_highlight_user "filespec/column" { type=varchar(20); id=10; }
    e_highlight_data "filespec/column" { type=varchar(900); id=11; }
    e_highlight_precedence "filespec/column" { type=float; id=12; }
    s_created_by "filespec/column" { type=varchar(20); id=13; }
    s_modified_by "filespec/column" { type=varchar(20); id=14; }
    e_highlight_partner "filespec/column" { type=char(10); id=15; }
    }
