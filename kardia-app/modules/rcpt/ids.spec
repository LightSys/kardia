$Version=2$
Datatypes "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = yes;
    annotation = "Datatypes test CSV Data";
    //row_annot_exp = ":full_name";
    key_is_rowid = yes;

    // Column specifications.
    i_eg_split_id "filespec/column" { type=string; id=1; }
    i_eg_target_desig_uuid "filespec/column" { type=string; id=2; }
    i_eg_target_desig_name "filespec/column" { type=string; id=3; }
    i_eg_gift_amount "filespec/column" { type=money; id=4; }
    }