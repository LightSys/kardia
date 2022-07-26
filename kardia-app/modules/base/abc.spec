$Version=2$
"abc" "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    annotation = "abc";
    key_is_rowid = yes;

    // Column specifications.
    letter "filespec/column" { type=string; id=1; }
    }
