$Version=2$
empty "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = yes;
    two_quote_escape = yes;
    annotation = "An empty dataset for use in ending Vanco queries";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    number "filespec/column" { type=integer; id=1; }
   
    }
