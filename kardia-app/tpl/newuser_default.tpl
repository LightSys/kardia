$Version=2$
newuser_default "widget/template"
    {
    page "widget/page"
        {
        font_name =  "Arial" ;
        font_size = 12;
        show_diagnostics = 0;
        }
    form "widget/form"
        {
        enter_mode =  "save" ;
        allow_new = 1;
        allow_modify = 1;
        allow_delete = 1;
        confirm_delete = 1;
        }
    table "widget/table"
        {
        rowheight = 18;
        }
    }
