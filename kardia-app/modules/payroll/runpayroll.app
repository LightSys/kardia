$Version=2$
runpayroll "widget/page"
    {
    title = "Run Payroll - Kardia";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    payform_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_form_window.cmp";
	ledger = runserver(:this:ledger);
	}
    payrun_cmp "widget/component"
	{
	x=10; y=10; width=780; height=565;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/payroll_run.cmp";
	ledger = runserver(:this:ledger);
	pay_form = payform_cmp;
	}
    }
