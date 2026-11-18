$Version=2$
periodmaint "widget/page"
    {
    title = "Accounting Period Maintenance";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    require_endorsements="kardia:gl_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    periodmaint_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/periodmaint.cmp";
	ledger = runserver(:this:ledger);
	}
    }
