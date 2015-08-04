$Version=2$
tax_table "widget/page"
    {
    width=800; height=600;
    title = "Tax Table";

    background="/apps/kardia/images/bg/light_bgnd2.jpg";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    require_one_endorsement="kardia:pay_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    // the ledger we are working with
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    type_code "widget/parameter" { type=string; default=null; deploy_to_client=yes; }

    EditTable_cn "widget/connector"
	{
	event=Load;
	target=tt_cmp;
	action=EditTable;
	TypeCode=runclient(:tax_table:type_code);
	}

    tt_cmp "widget/component"
	{
	path = "/apps/kardia/modules/payroll/tax_table.cmp";
	x=10; y=10;
	width=780;height=580;
	ledger = runserver(:this:ledger);
	ttwin = tax_table;
	}
    }
