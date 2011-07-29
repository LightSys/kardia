$Version=2$
CmpTest "widget/page"
    {
    width=800; height=600;
    title = "i18n:Component container for testing"; 
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    w "widget/parameter" { default=640; type=integer; }
    h "widget/parameter" { default=480; type=integer; }
    c "widget/parameter" { default=null; type=string; }

    win "widget/childwindow"
        {
        title = runserver(:this:c);
        width = runserver(:this:w + 2);
        height = runserver(:this:h + 25);
        style=dialog;
        x = runserver((800 - (:this:w + 2)) / 2);
        y = runserver((600 - (:this:h + 25)) / 2);

        cmp "widget/component"
            {
            width = runserver(:this:w);
            height = runserver(:this:h);
            path = runserver(:this:c);
            use_toplevel_params = yes;
            }
        }
    }

