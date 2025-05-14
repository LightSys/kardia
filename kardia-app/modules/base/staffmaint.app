$Version=2$
staffmaint "widget/page"
    {
    title = "Manage Staff";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    max_requests = 5;

    require_one_endorsement="kardia:ptnr_manage";
    endorsement_context=runserver("kardia");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    staffmaint_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	path = "/apps/kardia/modules/base/staffmaint.cmp";
	ledger = runserver(:this:ledger);
	}
    }
