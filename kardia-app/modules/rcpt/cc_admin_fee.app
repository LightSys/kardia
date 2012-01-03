$Version=2$
cc_admin_fee "widget/page"
    {
    title = "Admin Fees for Funds Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    af_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gift_manage' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gift_manage' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/rcpt/cc_admin_fee.cmp";
	ledger = runserver(:this:ledger);
	}
    }
