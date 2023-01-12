$Version=2$
pay_form_app "widget/page"
    {
    title = "Payroll Form";

    width=800; height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    require_one_endorsement="kardia:pay_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 10;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    groupid "widget/parameter" { type=integer; default=null; }
    payrollid "widget/parameter" { type=integer; default=null; }
    payperiod "widget/parameter" { type=string; default=null; }
    period "widget/parameter" { type=string; default=null; }
    ref_period "widget/parameter" { type=string; default=null; }
    prev_period "widget/parameter" { type=string; default=null; }
    readonly "widget/parameter" { type=integer; default=0; }

    pf_cmp "widget/component"
	{
	path = "/apps/kardia/modules/payroll/pay_form.cmp";
	x=10;y=5;width=780;height=690;

	ledger=runserver(:this:ledger);
	payperiod=runserver(:this:payperiod);
	period=runserver(:this:period);
	payroll_id=runserver(:this:payrollid);
	group_id=runserver(:this:groupid);
	fund=runserver( (select :a_fund from /apps/kardia/data/Kardia_DB/a_payroll/rows y where :y:a_ledger_number = :this:ledger and :y:a_payroll_id = :this:payrollid and :y:a_payroll_group_id = :this:groupid) );
	ref_period=runserver(:this:ref_period);
	prev_period=runserver(:this:prev_period);
	payee_name=runserver( (select :a_payee_name from /apps/kardia/data/Kardia_DB/a_payroll/rows y where :y:a_ledger_number = :this:ledger and :y:a_payroll_id = :this:payrollid and :y:a_payroll_group_id = :this:groupid) );
	readonly=runserver(:this:readonly);
	}
    }
