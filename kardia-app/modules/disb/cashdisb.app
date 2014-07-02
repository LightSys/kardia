$Version=2$
index "widget/page"
{
	title = "Checking - Cash Disbursements - Kardia";
	width=800;
	height=600;
	widget_template = "/apps/kardia/tpl/kardia-system.tpl", runserver("/apps/kardia/tpl/" + user_name() + ".tpl");

	require_one_endorsement = "kardia:disb_manage","kardia:disb_entry";
	endorsement_context=runserver("kardia:ledger:" + :this:ledger + ":");

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
		x=0; y=0; width=799;

		// Dv's sub-Menu System
		mnDv "widget/menu" // Hi Mom!
		{
			label = "Checking Menu";
			widget_class = "popup";
			
			mnDv_cd_batch_list_window_form "widget/menuitem"
			{
				label = "Select Batch";
				mnDv_cd_batch_list_window_cn "widget/connector"
				{
					event = Select;
					target = cd_batch_list_window_cmp;
					action = Open;
					//external_itself = cd_batch_list_window_cmp;
				}
			}
			mnDv_cd_search_for_check_window_form "widget/menuitem"
			{
				label = "Search for Check";
				mnDv_cd_search_for_check_window_cn "widget/connector"
				{
					event = Select;
					target = cd_check_lookup_cmp;
					action = Open;
					// IsModal=runclient(1);
					
				}
			}
		}
	}
	selledger_cmp "widget/component"
	{
		path = "/apps/kardia/modules/gl/ledger_select.cmp";
		visible = false;
	}
	// Dv's Compontents

	cd_check_lookup_cmp "widget/component"
	{
		condition = runserver(not (:this:ledger is null));
		path = "/apps/kardia/modules/disb/check_search_window.cmp";
		cd_details_window=cashdisb_form_cmp;
		ledger = runserver(:this:ledger);
		param_cashdisb_form = cashdisb_form_cmp;
	}
	cd_batch_list_window_cmp "widget/component"
	{
		condition = runserver(not (:this:ledger is null));
		path = "/apps/kardia/modules/disb/batch_list_window.cmp";
		cd_details_window=cashdisb_form_cmp;
		ledger = runserver(:this:ledger);
	}
	cashdisb_form_cmp "widget/component"
	{
		condition = runserver(not (:this:ledger is null));
		path = "/apps/kardia/modules/disb/cashdisb_form.cmp";
		ledger = runserver(:this:ledger);
	}
}
