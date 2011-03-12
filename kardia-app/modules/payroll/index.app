$Version=2$
index "widget/page"
    {
    title = "Payroll - Kardia";
    width=800;
    height=600;
    widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

    ledger "widget/parameter" { type=string; default=null; allowchars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"; }

    cnLoad "widget/connector"
	{
	condition = runserver(:this:ledger is null);
	event = "Load";
	target=selledger_cmp;
	action=OpenModal;
	}

    mnPay "widget/menu"
	{
	widget_class = "bar";
	x=0; y=0; width=800;

	mnKardia "widget/menu"
	    {
	    label = "Kardia";
	    widget_class = "popup";

	    mnWhosOnline "widget/menuitem"
		{
		label = "Who's Online";
		mnWhosOnline_cn "widget/connector" { event = Select; target = whoson_cmp; action = Open; }
		}
	    mnPrefs "widget/menuitem"
		{
		label = "Preferences";
		mnPrefs_cn "widget/connector" { event = Select; target = prefs_cmp; action = Open; }
		}
	    }

	mnPayroll "widget/menu"
	    {
	    label = "Payroll";
	    widget_class = "popup";
	    mnPayee "widget/menuitem"
		{
		label = "Payees";
		mnPayee_cn "widget/connector" { event = Select; target = payee_cmp; action = Open; }
		}
	    mnRun "widget/menuitem"
		{
		label = "Run Payroll";
		mnRun_cn "widget/connector" { event = Select; target = payrun_cmp; action = Open; }
		}
	    mnSep0 "widget/menusep" {}
	    mnBatches "widget/menuitem"
		{
		label = "GL Batches";
		mnBatches_cn "widget/connector" { event = Select; target = batchlist_cmp; action = Open; }
		}
	    mnGljEdit "widget/menuitem"
		{
		label = "GL Journal Entry";
		mnGljEdit_cn "widget/connector" { event = Select; target = glj_cmp; action = Open; }
		}
	    mnSep2 "widget/menusep" {}
	    mnRPT_ps "widget/menuitem"
		{
		label = "Report: Payroll Summary";
		mnRPT_ps_cn "widget/connector" { event = Select; target = ps_cmp; action = Open; }
		}
	    mnRPT_ms "widget/menuitem"
		{
		label = "Report: Missionary Financial Statement";
		mnRPT_ms_cn "widget/connector" { event = Select; target = mfs_cmp; action = Open; }
		}
	    }

	mnMaint "widget/menu"
	    {
	    label = "Setup & Admin";
	    widget_class = "popup";
	    mnSelectLedger "widget/menuitem"
		{
		label = runserver(condition(:this:ledger is null, "Select Ledger", "Select Different Ledger"));
		mnSelectLedger_cn "widget/connector" { event = Select; target = selledger_cmp; action = OpenModal; }
		}
	    mnSep1 "widget/menusep" {}
	    //mnTaxSetup "widget/menuitem"
	//	{
	//	label = "Tax Table Setup";
	//	mnTaxSetup_cn "widget/connector" { event = Select; target = tax_cmp; action = Open; }
	//	}
	    mnItemSetup "widget/menuitem"
		{
		label = "Payroll Line Item Types";
		mnItemSetup_cn "widget/connector" { event = Select; target = item_cmp; action = Open; }
		}
	    }

	mnTbl "widget/menu"
	    {
	    label = "Tables";
	    widget_class = "popup";

	    tbl_rpt "widget/repeat"
		{
		sql = "select :name from /apps/kardia/data/Kardia_DB where substring(:name, 1, 2) = 'a_' or substring(:name, 1, 3) = '_a_'";

		mnItem "widget/menuitem"
		    {
		    label = runserver(:tbl_rpt:name);

		    mnLink "widget/connector"
			{
			event = Select;
			target = table_cmp;
			action = "Instantiate";
			table=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt:name));
			title=runclient(runserver('/apps/kardia/data/Kardia_DB/' + :tbl_rpt:name));
			}
		    }
		}
	    }
	}

    lblLedger "widget/label"
	{
	condition = runserver(not (:this:ledger is null));
	x=500;y=0;width=295;height=24;
	font_size=15;
	align=right;
	text = runserver((select :a_ledger_number + ' - ' + :a_ledger_desc from /apps/kardia/data/Kardia_DB/a_ledger/rows where :a_ledger_number = :this:ledger ));
	fgcolor=white;
	}

    selledger_cmp "widget/component"
	{
	path = "/apps/kardia/modules/gl/ledger_select.cmp";
	visible = false;
	}

    mfs_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/financial_statement_window.cmp";
	ledger = runserver(:this:ledger);
	}
    payee_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/payees_window.cmp";
	ledger = runserver(:this:ledger);
	paydet = paydetail_cmp;
	}
    paydetail_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_detail_window.cmp";
	ledger = runserver(:this:ledger);
	}
    payform_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/pay_form_window.cmp";
	ledger = runserver(:this:ledger);
	}
    payrun_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/payroll_run_window.cmp";
	ledger = runserver(:this:ledger);
	pay_form = payform_cmp;
	}
    tax_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/tax_table_window.cmp";
	ledger = runserver(:this:ledger);
	ttwin = tax_cmp;
	}
    item_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/payroll/item_types_window.cmp";
	ledger = runserver(:this:ledger);
	ttwin = tax_cmp;
	}
    glj_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/gljournal_window.cmp";
	ledger = runserver(:this:ledger);
	batchwin = batchlist_cmp;
	}
    batchlist_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/batch_list_window.cmp";
	ledger = runserver(:this:ledger);
	editor = glj_cmp;
	}
    prefs_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/prefs_window.cmp";
	}
    whoson_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/whoson_window.cmp";
	}
    table_cmp "widget/component"
	{
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/generic_form.cmp";
	mode = dynamic;
	multiple_instantiation = yes;
	icon = "/sys/images/ico26a.gif";
	}
    }
