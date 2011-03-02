$Version=2$
edit_table "widget/page"
    {
    height=600; width=800;
    title = "Kardia - Edit Table";
    background="/apps/kardia/images/bg/light_bgnd2.jpg";
    widget_template = "/apps/kardia/tpl/organization-kardia.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    tablepath "widget/parameter" { type=string; default=null; }

    onload "widget/connector"
	{
	condition = runserver(not (char_length(:this:tablepath) > 0));
	event=Load;
	target=opendialog;
	action=OpenModal;
	}

    sel_form "widget/form"
	{
	sel_tablepath "widget/variable"
	    {
	    fieldname="tablepath";
	    }
	}

    opendialog "widget/component"
	{
	condition = runserver(not (char_length(:this:tablepath) > 0));
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/file_selection.cmp";
	visible = no;
	title = "Select File/Table:";
	toplevel = yes;
	padding = 10;

	select_cn "widget/connector" { event="Selected"; target=sel_form; action=Submit; Target=runclient("edit_table"); tablepath=runclient(:Pathname); }
	}

    tablecmp "widget/component"
	{
	condition = runserver(char_length(:this:tablepath) > 0);
	table = runserver(:this:tablepath);
	path = "/sys/cmp/generic_form.cmp";
	}
    }
