$Version=2$
data_qa "widget/page"
    {
    title = "Data Q/A";
    width=1000;
    height=700;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl"), "/apps/kardia/modules/rcpt/gift.tpl";
    bgcolor=white;
    background=null;
    require_one_endorsement="kardia:ptnr_manage";
    endorsement_context=runserver("kardia");
    max_requests=9;

    data_qa_cmp "widget/component"
	{
	x=10; y=10; width=980; height=680;
	path = "/apps/kardia/modules/base/data_qa.cmp";
	}
    }
