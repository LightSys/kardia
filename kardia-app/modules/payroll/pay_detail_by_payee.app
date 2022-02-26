$Version=2$
pay_detail "widget/page"
    {
    title = "Pay Detail Items - by Payee";
    width=778; height=525;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    max_requests = 5;

    require_one_endorsement="kardia:pay_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    payee "widget/parameter" { type=integer; default=null; deploy_to_client=yes; }
    paygroup "widget/parameter" { type=integer; default=null; deploy_to_client=yes; }
    period "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    // Payroll detail screen
    paydet "widget/component" 
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_detail.cmp";
	ledger = runserver(:this:ledger);
	period = runserver(:this:period);
	by_item_type = 0;

	preload "widget/connector"
	    {
	    source=pay_detail;
	    event=Load;
	    action=GotoPayee;
	    Payee=runclient(:payee:value);
	    Group=runclient(:paygroup:value);
	    }
	}
    }
