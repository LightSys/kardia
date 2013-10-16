$Version=2$
item_types "widget/page"
    {
    width=800; height=600;
    title = "Payroll Line Item Types";
    background="/apps/kardia/images/bg/light_bgnd2.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    require_endorsements="kardia:pay_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    //tax_cmp "widget/component"
//	{
//	condition = runserver(not (:this:ledger is null));
//	path = "/apps/kardia/modules/payroll/tax_table_window.cmp";
//	ledger = runserver(:this:ledger);
//	ttwin = tax_cmp;
//	}

    it_cmp "widget/component"
	{
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'pay_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/payroll/item_types.cmp";
	ledger = runserver(:this:ledger);
	ttwin = tax_cmp;
	}
    }
