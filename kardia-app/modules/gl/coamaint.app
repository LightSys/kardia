$Version=2$
coamaint "widget/page"
    {
    title = "Chart of Accounts Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gl_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    fund "widget/parameter" { type=string; default=null; }

    coamaint_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/gl/coamaint.cmp";
	ledger = runserver(:this:ledger);
	mainfund = runserver((select :a_bal_cost_center from /apps/kardia/data/Kardia_DB/a_cost_center/rows cc where :cc:a_ledger_number = :this:ledger and :cc:a_cost_center = :this:fund));
	fund = runserver(:this:fund);
	}
    }
