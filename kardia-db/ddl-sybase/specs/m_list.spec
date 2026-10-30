$Version=2$
m_list "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for m_list";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    m_list_code "filespec/column" { type=string; id=1; }
    m_list_parent "filespec/column" { type=string; id=2; }
    m_list_description "filespec/column" { type=string; id=3; }
    m_list_status "filespec/column" { type=string; id=4; }
    m_list_type "filespec/column" { type=string; id=5; }
    m_delivery_method "filespec/column" { type=string; id=6; }
    m_discard_after "filespec/column" { type=datetime; id=7; }
    m_list_frozen "filespec/column" { type=integer; id=8; }
    m_date_sent "filespec/column" { type=datetime; id=9; }
    a_charge_ledger "filespec/column" { type=string; id=10; }
    p_postal_mode "filespec/column" { type=string; id=11; }
    a_charge_fund "filespec/column" { type=string; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
