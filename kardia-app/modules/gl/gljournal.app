$Version=2$
gljournal "widget/page"
    {
    title = "GL Batch and Journal Entry";
    width=800; height=600;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    widget_template = "/apps/kardia/tpl/organization-kardia.tpl";

    cnLoad "widget/connector"
	{
	condition = runserver(not (:this:ledger is null));
	event = "Load";
	target=glj_cmp;
	action=Open;
	}

    glj_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/gljournal_window.cmp";
	ledger = runserver(:this:ledger);
	}

    dbgwin "widget/component"
	{
	condition=0;
	mode=static;
	x=0;y=0;width=640;height=480;
	multiple_instantiation=no;
	path="/sys/cmp/debugger.cmp";
	}
    }
