$Version=2$
email_reports "widget/page"
    {
    width = 1000;
    height = 700;
    title = "Send Statements and Reports";
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl"), "/apps/kardia/modules/base/rpts.tpl";
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    //require_one_endorsement="kardia:gl_manage","kardia:gift_manage","kardia:gift_amt";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");
    max_requests = 5;

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    period "widget/parameter" { type=string; default=null; }

    email_reports_cmp "widget/component" 
	{ 
	x=8; y=8;
	width=980;
	height=680;
	path="/apps/kardia/modules/base/email_reports_new.cmp"; 
	ledger=runserver(:this:ledger);
	period=runserver(:this:period);

	close_cn "widget/connector" { event=ClosePressed; target=email_reports; action=Close; }
	}
    }
