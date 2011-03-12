$Version=2$
mlist_maint "widget/page"
    {
    title = "Mailing Lists Maintenance";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    //ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    mlist_maint_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	//condition = runserver((not (:this:ledger is null)) and (user_name() == 'gbeeley' or user_name() == 'carol' or user_name() == 'kimberly' or user_name() == 'brianf'));
	path = "/apps/kardia/modules/base/mlist_maint.cmp";
	//ledger = runserver(:this:ledger);
	}
    }
