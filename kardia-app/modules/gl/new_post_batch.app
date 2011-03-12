$Version=2$
new_post_batch "widget/page"
    {
    title = "Post Batch";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }
    batch "widget/parameter" { type=integer; default=null; }

    post_batch_cmp "widget/component"
	{
	x=10; y=10; width=780; height=580;
	condition = runserver((not (:this:ledger is null)));
	path = "/apps/kardia/modules/gl/new_post_batch.cmp";
	ledger = runserver(:this:ledger);
	batch = runserver(:this:batch);
	}
    }
