$Version=2$
e_highlights "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_highlights";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_highlight_user "filespec/column" { type=string; id=1; }
    e_highlight_partner "filespec/column" { type=string; id=2; }
    e_highlight_id "filespec/column" { type=string; id=3; }
    e_highlight_name "filespec/column" { type=string; id=4; }
    e_highlight_type "filespec/column" { type=string; id=5; }
    e_highlight_data "filespec/column" { type=string; id=6; }
    e_highlight_reference_info "filespec/column" { type=string; id=7; }
    e_highlight_precedence "filespec/column" { type=double; id=8; }
    e_highlight_strength "filespec/column" { type=double; id=9; }
    e_highlight_certainty "filespec/column" { type=double; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
