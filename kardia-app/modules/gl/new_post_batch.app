$Version=2$
new_post_batch "widget/page"
    {
    title = "Post Batch";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:gl_entry";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }

    post_batch_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_entry' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_entry' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/gl/new_post_batch.cmp";
	ledger = runserver(:this:ledger);
	batch = runserver(:this:batch);
	}
    }
