$Version=2$
batches "widget/page"
    {
    title = "GL Batches";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_one_endorsement="kardia:gl_entry","kardia:gl_manage";
    endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    year_period "widget/parameter" { type=string; default=null; }
    period "widget/parameter" { type=string; default=null; }

    batches_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//condition = runserver((not (:this:ledger is null)) and ((select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_entry' and :s_context = 'ledger=' + :this:ledger and :s_subject = 'u:' + user_name()) > 0 or (select count(1) from /apps/kardia/data/Kardia_DB/s_sec_endorsement/rows where :s_endorsement = 'gl_entry' and :s_context = 'ledger=' + :this:ledger) == 0));
	path = "/apps/kardia/modules/gl/generic_byperiod.cmp";
	title = "GL Batches";
	embed = "/apps/kardia/modules/gl/batches.cmp";
	ledger = runserver(:this:ledger);
	year_period = runserver(:this:year_period);
	period = runserver(:this:period);
	}
    }
