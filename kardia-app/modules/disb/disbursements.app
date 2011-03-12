$Version=2$
disbursements "widget/page"
    {
    title = "Cash Disbursements - Checking";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
	
    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }

    on_open "widget/connector"
	{
	condition=runserver(not (:this:batch is null));
	event=Load;
	event_delay=1;
	target=checking_cmp;
	action=GotoBatch;
	Batch=runclient(:disbursements:batch);
	}

    //GotoBatchSelectRow_cn2 "widget/connector" { event="GotoBatchSelectRow"; target="glj_cmp"; action="GotoBatchSelectRow"; sr_ledger=runclient(convert(string,:sr_ledger)); Batch=runclient(convert(integer,:Batch)); sr_disbursement_id=runclient(convert(integer,:sr_disbursement_id)); sr_line_item=runclient(convert(integer,:sr_line_item)); }
						
    checking_cmp "widget/component"
	{
	path = "/apps/kardia/modules/disb/cashdisb_subform.cmp";
	width=778;height=525;
	ledger = runserver(:this:ledger);
	external_itself=disbursements;
	}
    }
