$Version=2$
session "widget/page"
    {
    title = "Session Data Monitoring";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");
    background="/apps/kardia/images/bg/light_bgnd.jpg";
    require_endorsements="kardia:sys_admin";
    endorsement_context="kardia:::";

    refresh_timer "widget/timer"
	{
	msec=20000;
	auto_reset=1;
	auto_start=1;
	interval_cn1 "widget/connector" { target=users_osrc; event=Expire; action=Refresh; }
	interval_cn2 "widget/connector" { target=sessions_osrc; event=Expire; action=Refresh; }
	interval_cn3 "widget/connector" { target=groups_osrc; event=Expire; action=Refresh; }
	interval_cn4 "widget/connector" { target=apps_osrc; event=Expire; action=Refresh; }
	}

    users_osrc "widget/osrc"
	{
	sql = "select * from /sys/cx.sysinfo/session/users";
	readahead=20;
	replicasize=20;

	users_table "widget/table"
	    {
	    x=10; y=10; width=780; height=130;

	    users_name "widget/table-column" { title="User"; fieldname=name; }
	    users_session_cnt "widget/table-column" { title="Sessions"; fieldname=session_cnt; }
	    users_group_cnt "widget/table-column" { title="Groups"; fieldname=group_cnt; }
	    users_app_cnt "widget/table-column" { title="Apps"; fieldname=app_cnt; }
	    users_firstact "widget/table-column" { title="Started"; fieldname=first_activity; }
	    users_lastact "widget/table-column" { title="Recent"; fieldname=last_activity; }
	    }
	}

    sessions_osrc "widget/osrc"
	{
	sql = "select * from /sys/cx.sysinfo/session/sessions";
	readahead=20;
	replicasize=20;

	sessions_table "widget/table"
	    {
	    x=10; y=150; width=780; height=130;

	    sessions_id "widget/table-column" { title="Session#"; fieldname=name; }
	    sessions_name "widget/table-column" { title="User"; fieldname=username; }
	    sessions_group_cnt "widget/table-column" { title="Groups"; fieldname=group_cnt; }
	    sessions_app_cnt "widget/table-column" { title="Apps"; fieldname=app_cnt; }
	    sessions_last_ip "widget/table-column" { title="Last IP"; fieldname=last_ip; }
	    sessions_firstact "widget/table-column" { title="Started"; fieldname=first_activity; }
	    sessions_lastact "widget/table-column" { title="Recent"; fieldname=last_activity; }
	    }
	}

    groups_osrc "widget/osrc"
	{
	sql = "select *, start_app_path_txt=condition(charindex('?',:start_app_path) > 0, substring(:start_app_path,1,charindex('?',:start_app_path) - 1), :start_app_path) from /sys/cx.sysinfo/session/appgroups";
	readahead=20;
	replicasize=20;

	groups_table "widget/table"
	    {
	    x=10; y=290; width=780; height=130;

	    groups_id "widget/table-column" { title="Group#"; fieldname=name; width=80; }
	    groups_name "widget/table-column" { title="User"; fieldname=username; width=80; }
	    groups_group_cnt "widget/table-column" { title="Session#"; fieldname=session_id; width=80; }
	    groups_app_cnt "widget/table-column" { title="Apps"; fieldname=app_cnt; width=80; }
	    groups_firstact "widget/table-column" { title="Started"; fieldname=first_activity; width=80; }
	    groups_lastact "widget/table-column" { title="Recent"; fieldname=last_activity; width=80; }
	    groups_url "widget/table-column" { title="Path"; fieldname=start_app_path_txt; width=275; }
	    }
	}

    apps_osrc "widget/osrc"
	{
	sql = "select *, app_path_txt=condition(charindex('?',:app_path) > 0, substring(:app_path,1,charindex('?',:app_path) - 1), :app_path)  from /sys/cx.sysinfo/session/apps";
	readahead=30;
	replicasize=30;

	apps_table "widget/table"
	    {
	    x=10; y=430; width=780; height=160;

	    apps_id "widget/table-column" { title="App#"; fieldname=name; width=80; }
	    apps_name "widget/table-column" { title="User"; fieldname=username; width=80; }
	    apps_group_cnt "widget/table-column" { title="Session#"; fieldname=session_id; width=80; }
	    apps_app_cnt "widget/table-column" { title="Group#"; fieldname=group_id; width=80; }
	    apps_firstact "widget/table-column" { title="Started"; fieldname=first_activity; width=80; }
	    apps_lastact "widget/table-column" { title="Recent"; fieldname=last_activity; width=80; }
	    apps_url "widget/table-column" { title="Path"; fieldname=app_path_txt; width=275; }
	    }
	}
    }
