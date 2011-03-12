$Version=2$
index "widget/page"
    {
    title = "GL - Kardia";
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

    mnGL "widget/menu"
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
	    mnSupport "widget/menuitem"
		{
		label = "LightSys Support";
		mnSupport_cn "widget/connector" { event = Select; target = index; action = Launch; Width=640; Height=480; Source="https://lightsysb.bomgar.com/"; Name=runclient("Support"); }
		}
	    }

	mnTSK "widget/menu"
	    {
	    condition = runserver(not (:this:ledger is null));
	    label = "Tasks";
	    widget_class = "popup";

	    mnXfr "widget/menuitem"
		{
		label = "Funds Transfer";
		mnXfr_cn "widget/connector" { event = Select; target = xfer_cmp; action = Open; }
		}
	    }

	mnGLJ "widget/menu"
	    {
	    label = "General Ledger";
	    widget_class = "popup";
	    mnBatches "widget/menuitem"
		{
		label = "GL Batches";
		mnBatches_cn "widget/connector" { event = Select; target = batchlist_cmp; action = Open; }
		}
	    mnPeriods "widget/menuitem"
		{
		label = "GL Period Open/Close";
		mnPeriods_cn "widget/connector" { event = Select; target = periodmgmt_cmp; action = Open; }
		}
	    mnGljEdit "widget/menuitem"
		{
		label = "GL Journal Entry";
		mnGljEdit_cn "widget/connector" { event = Select; target = glj_cmp; action = Open; }
		}
	    mnGljView "widget/menuitem"
		{
		label = "View GL Activity";
		mnGljView_cn "widget/connector" { event = Select; target = gljview_cmp; action = Open; }
		}
	    mnAcctBal "widget/menuitem"
		{
		label = "View Account Balances";
		mnAcctBal_cn "widget/connector" { event = Select; target = acctbal_cmp; action = Open; }
		}
	    mnSep0 "widget/menusep" {}
	    mnRPT_coa "widget/menuitem"
		{
		label = "Report: Periods/Accounts/Funds";
		mnRPT_coa_cn "widget/connector" { event = Select; target = index; action = Launch; Width=800; Height=600; Source=runclient('/apps/kardia/modules/gl/coa.rpt?ledger=' + :index:ledger); }
		}
	    mnRPT_bs "widget/menuitem"
		{
		label = "Report: GL Balance Sheet";
		mnRPT_bs_cn "widget/connector" { event = Select; target = bs_cmp; action = Open; }
		}
	    mnRPT_tb "widget/menuitem"
		{
		label = "Report: GL Trial Balance";
		mnRPT_tb_cn "widget/connector" { event = Select; target = tb_cmp; action = Open; }
		}
	    mnRPT_ib "widget/menuitem"
		{
		label = "Report: GL Imbalance Research";
		mnRPT_ib_cn "widget/connector" { event = Select; target = ib_cmp; action = Open; }
		}
	    mnRPT_fb "widget/menuitem"
		{
		label = "Report: GL Fund Balances";
		mnRPT_fb_cn "widget/connector" { event = Select; target = fb_cmp; action = Open; }
		}
	    mnRPT_bb "widget/menuitem"
		{
		label = "Report: GL Batch Summary";
		mnRPT_bb_cn "widget/connector" { event = Select; target = bb_cmp; action = Open; }
		}
	    mnRPT_trx "widget/menuitem"
		{
		label = "Report: GL Transactions";
		mnRPT_trx_cn "widget/connector" { event = Select; target = trx_cmp; action = Open; }
		}
	    }

	mnCOA "widget/menu"
	    {
	    label = "Setup & Admin";
	    widget_class = "popup";
	    mnSelectLedger "widget/menuitem"
		{
		label = runserver(condition(:this:ledger is null, "Select Ledger", "Select Different Ledger"));
		mnSelectLedger_cn "widget/connector" { event = Select; target = selledger_cmp; action = OpenModal; }
		}
	    mnSep1 "widget/menusep" {}
	    mnCoaSetup "widget/menuitem"
		{
		label = "Chart of Accounts Setup";
		mnCoaSetup_cn "widget/connector" { event = Select; target = coa_cmp; action = Open; }
		}
	    }

	mnTbl "widget/menu"
	    {
	    label = "Tables";
	    widget_class = "popup";

	    mnItemPay "widget/menuitem"
		{
		label = "Jan09 Payroll Data";

		mnLinkPay "widget/connector"
		    {
		    event = Select;
		    target = paytable_cmp;
		    action = "Instantiate";
		    table=runclient(runserver('/apps/kardia/data/tmp/MSS.csv'));
		    title=runclient(runserver('/apps/kardia/data/tmp/MSS.csv'));
		    }
		}

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

    xfer_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/xfer_window.cmp";
	}

    coa_cmp "widget/component"
	{
	path = "/apps/kardia/modules/gl/coa_window.cmp";
	}

    selledger_cmp "widget/component"
	{
	path = "/apps/kardia/modules/gl/ledger_select.cmp";
	visible = false;
	}

    bs_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/balance_sheet_window.cmp";
	ledger = runserver(:this:ledger);
	}
    tb_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/trial_balance_window.cmp";
	ledger = runserver(:this:ledger);
	}
    ib_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/imbalance_window.cmp";
	ledger = runserver(:this:ledger);
	}
    fb_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/fund_balance_window.cmp";
	ledger = runserver(:this:ledger);
	}
    bb_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/batch_balance_window.cmp";
	ledger = runserver(:this:ledger);
	}
    trx_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/transaction_report_window.cmp";
	ledger = runserver(:this:ledger);
	}
    glj_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/gljournal_window.cmp";
	ledger = runserver(:this:ledger);
	batchwin = batchlist_cmp;
	}
    gljview_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/gljournalview_window.cmp";
	ledger = runserver(:this:ledger);
	editor = glj_cmp;
	acctbal = acctbal_cmp;
	viewer = gljview_cmp;
	}
    acctbal_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/acct_bal_window.cmp";
	ledger = runserver(:this:ledger);
	editor = glj_cmp;
	viewer = gljview_cmp;
	acctbal = acctbal_cmp;
	}
    batchlist_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/batch_list_window.cmp";
	ledger = runserver(:this:ledger);
	editor = glj_cmp;
	viewer = gljview_cmp;
	acctbal = acctbal_cmp;
	}
    periodmgmt_cmp "widget/component"
	{
	condition = runserver(not (:this:ledger is null));
	path = "/apps/kardia/modules/gl/period_mgmt_window.cmp";
	ledger = runserver(:this:ledger);
	editor = glj_cmp;
	viewer = gljview_cmp;
	acctbal = acctbal_cmp;
	}
    prefs_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/prefs_window.cmp";
	}
    whoson_cmp "widget/component"
	{
	path = "/apps/kardia/modules/base/whoson_window.cmp";
	}
    paytable_cmp "widget/component"
	{
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/generic_form.cmp";
	mode = dynamic;
	width=798; height=476; h=476; w=798;
	multiple_instantiation = no;
	icon = "/sys/images/ico26a.gif";
	}
    table_cmp "widget/component"
	{
	path = "/sys/cmp/window_container.cmp";
	component = "/sys/cmp/generic_form.cmp";
	mode = dynamic;
	//width=798; height=476; h=476;
	multiple_instantiation = yes;
	icon = "/sys/images/ico26a.gif";
	}

    }
