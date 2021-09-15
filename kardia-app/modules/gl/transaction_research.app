$Version=2$
transaction_research "widget/page"
    {
    width=1000;
    height=700;
    title="GL Transaction Research";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    require_endorsements="kardia:gl_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    trx_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	path = "/apps/kardia/modules/gl/transaction_research.cmp";
	ledger = runserver(:this:ledger);
	}
    }
