$Version=2$
coa "widget/page"
    {
    title = runserver("GL Master List for " + :this:ledger);
    width=800; height=600;

    widget_template = "/apps/kardia/tpl/kardia-system.tpl";

    ledger "widget/parameter" { type=string; default="0US"; }

    coawin "widget/childwindow"
	{
	title = runserver("GL Master List for " + :this:ledger);
	width=750; height=550;
	x=25; y=25;
	icon = "/apps/kardia/images/icons/gift.gif";

	master_list_cmp "widget/component"
	    {
	    path = "/apps/kardia/modules/gl/cc_acct_edit.cmp";
	    width=748;height=525;

	    ledger = runserver(:this:ledger);
	    }
	}
    }
