$Version=2$
acctmaint "widget/page"
    {
    title = "GL Accounts Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    ledger_osrc "widget/osrc"
	{
	sql = runserver("select :a_ledger_number, :a_next_batch_number, :a_is_posting, :a_ledger_desc, :a_ledger_comment, :s_date_created, :s_created_by, :s_date_modified, :s_modified_by FROM /apps/kardia/data/Kardia_DB/a_ledger/rows WHERE :a_ledger_number = " + quote(:this:ledger));
	baseobj = "/apps/kardia/data/Kardia_DB/a_ledger/rows";
	replicasize = 40;
	readahead = 20;
	autoquery = onload;
	}

    accts_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//x=0;y=0;width=756;height=449;
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/accts_edit.cmp";
	ledger = runserver(:this:ledger);
	ledger_osrc = ledger_osrc;
	}
    }
