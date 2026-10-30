$Version=2$
gl_import "widget/page"
    {
    title = "GL Batch Import";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl"), "/apps/kardia/modules/rcpt/gift.tpl";
    bgcolor=white;
    background=null;
    require_one_endorsement="kardia:gl_manage","kardia:gl_entry";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests=9;

    send_refresh "widget/parameter" { type=object; default=null; deploy_to_client=yes; }

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }

    import_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/gl_import.cmp";
	ledger = runserver(:this:ledger);
	batch = runserver(:this:batch);
	send_refresh = send_refresh;
	}
    }
