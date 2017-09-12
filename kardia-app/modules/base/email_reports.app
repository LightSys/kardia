$Version=2$
email_reports "widget/page"
    {
    width = 844;
    height=600;
    title = "Email Reports";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:gl_manage","kardia:gift_manage","kardia:gift_amt";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    email_reports_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=828;
	height=584;
	path="/apps/kardia/modules/base/email_reports.cmp"; 
	ledger=runserver(:this:ledger);
	period=runserver(:this:period);

	close_cn "widget/connector" { event=ClosePressed; target=email_reports; action=Close; }
	}
    }
