$Version=2$
pay_detail "widget/page"
    {
    title = "i18n:Pay Detail Items - by Item Type";
    width=778; height=525;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    item_type "widget/parameter" { type=string; default=null; }

    // Payroll detail screen
    paydet "widget/component" 
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_detail.cmp";
	ledger = runserver(:this:ledger);
	item_type = runserver(:this:item_type);
	by_item_type = 1;
	}
    }
