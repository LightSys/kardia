$Version=2$
chat "widget/page"
    {
    width=600; height=300;
    background="/apps/kardia/images/bg/light_bgnd3.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    title = runserver("i18n:Chat with " + :this:WithWhom);

    WithWhom "widget/parameter" { type=string; default=runserver(user_name()); }

    cnopen "widget/connector" { event=Load; target=chat_cmp; action=Start; }

    chat_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/chat.cmp";
	width=598;height=298;
	WithWhom = runserver(:this:WithWhom);
	}
    }
