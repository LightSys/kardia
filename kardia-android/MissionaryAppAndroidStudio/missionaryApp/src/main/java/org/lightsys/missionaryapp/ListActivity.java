package org.lightsys.missionaryapp;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.missionaryapp.data.LocalDBHandler;
import org.lightsys.missionaryapp.donorfragments.DonorFrag;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

/**
 * This class is used to display any list-view in the app
 * It currently is set up to cover any of the five options
 * from the optionActivity
 *
 * @author Andrew Cameron
 */
public class ListActivity extends Fragment {

	private static final String Tag = "LA";
	public static final String ARG_TYPE = "display_type";
	public static int display = 0;
	// 0 = gift, 1 = payroll, 2 = donors, 3 = reports, 4 = prayers, 5 = accounts
	private static ArrayList<HashMap<String, String>> listitems;
	private ListView listview;

	@SuppressWarnings("ResourceType")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

		View v = inflater.inflate(R.layout.activity_list, container, false);

		Bundle args = getArguments();

		if (savedInstanceState != null) {
			display = savedInstanceState.getInt(ARG_TYPE);
		} else if (args != null) {
			display = args.getInt(ARG_TYPE);
		}

		TextView tv = (TextView) v.findViewById(R.id.title);
		//tv.setText(display);
		//tv.setText(String.valueOf(display));
		//String text = "R.layout.activity" + display;
		//tv.setText(text)

		// Use to find int id for reports and payroll
		/*System.out.println(R.layout.report_listview_item);
		System.out.println(R.layout.payroll_listview_item);*/

		// 0 = gift, 1 = donors, 2 = prayers, 3 = accounts, 4 = payroll, 5 = reports
		switch (display) {
			case 0: //gifts
				//tv.setText(2130903067);
				tv.setText(getString(R.string.gift_layout));
				break;
			//TODO: Reimplement
			case 1: //donors
				//tv.setText()
				tv.setText(getString(R.string.donor_layout));
				break;
			case 2: //prayers
				//tv.setText(2130903066);
				tv.setText(getString(R.string.prayer_layout));
				break;

			case 3: //accounts
				//tv.setText();
				tv.setText(getString(R.string.accounts_layout));
				break;
			//TODO: Reimplement
			case 4: //payroll
				//tv.setText(2130903071);
				tv.setText(getString(R.string.payroll_layout));
				break;
			case 5: //reports
				//tv.setText(2130903063);
				tv.setText(getString(R.string.report_layout));
				break;
			default: //gift originally
				//tv.setText(2130903067);
				tv.setText("");
				break;
		}
		listview = (ListView) v.findViewById(R.id.list);
		listview.setAdapter(loadDisplay());
		listview.setOnItemClickListener(new onItemClicked());

		return v;
	}

	//loads the appropriate list of items, based on option selected.
	public SimpleAdapter loadDisplay() {
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
		String[] from;
		int[] to;
		int layout;

        // 0 = gift, 1 = donors, 2 = prayers, 3 = accounts, 4 = payroll, 5 = reports
		switch (display) {
			//Loads a list of gifts
			case 0:
                from = new String[]{"title", "amount_whole", "amount_part", "date",};
				to = new int[]{R.id.title, R.id.date, R.id.amount};
				layout = R.layout.gift_listview_item;
				listitems = db.getDisplayGifts();
				break;

			//Loads a list of the Donors
			case 1:
                from = new String[]{"image", "name", "email", "cellnumber"};
				to = new int[]{R.id.quickContact, R.id.name, R.id.email, R.id.cellnumber};
				layout = R.layout.donor_listview_item;
				listitems = db.getDisplayDonors();
				break;

			//Loads the prayers
			case 2:
				from = new String[]{"prayer_subject", "date", "prayer_desc"};
				to = new int[]{R.id.prayer_subject, R.id.date, R.id.prayer_desc};
				layout = R.layout.prayer_listview_item;
				listitems = db.getDisplayPrayers();
				break;

			//Loads the accounts related to the Missionary's fund
			case 3:
				from = new String[]{"account_id", "account_balance"};
				to = new int[]{R.id.account_id, R.id.account_balance};
				layout = R.layout.accounts_listview_item;
				listitems = db.getDisplayAccounts();
				break;


			//Loads a list of the payroll items
			// TODO: Reimplement
			/*case 4:
				from = new String[]{"title", "date", "amount"};
				to = new int[]{R.id.title, R.id.date, R.id.amount};
				layout = R.layout.gift_listview_item;
				listitems = db.getDisplayPayroll();
				break;*/

			//Loads a list of reports
			// TODO: Reimplement
			/*case 5:
				from = new String[]{"title"};
				to = new int[]{R.id.time};
				layout = R.layout.report_listview_item;
				listitems = db.getDisplayReports();
				break;*/

			//Used to load a list of gifts given to the missionary's fund
			default:
				from = new String[]{};
				to = new int[]{};
				layout = R.layout.gift_listview_item;
				listitems = db.getDisplayGifts();
				break;
		}

		return new SimpleAdapter(getActivity(), listitems, layout, from, to);
	}

	/**
	 * Click event is different depending on what
	 * items are being displayed.
	 *
	 * @author Andrew Cameron
	 */
	private class onItemClicked implements OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			Fragment toFrag = null;
			Bundle sendArgs = new Bundle();

			switch (display) {
			/*If the Gifts were displayed, and clicked on, takes
			* the user to the detailed gift in the DonorFrag
			*/
			case 0:
			//toFrag = new DonorFrag();
			toFrag = new DonorFrag();
			sendArgs.putInt(DonorFrag.ARG_GIFT_ID, Integer.parseInt(listitems.get(position).get("id")));
			sendArgs.putInt(DonorFrag.ARG_DONOR_ID, Integer.parseInt(listitems.get(position).get("donor_id")));
			sendArgs.putInt(DonorFrag.ARG_TYPE, 1);
			toFrag.setArguments(sendArgs);

			transaction.replace(R.id.container, toFrag);
			transaction.addToBackStack("ToGift" + listitems.get(position).get("title"));
			transaction.commit();
			break;
				
			/* If the Donors were being displayed,
			 * Then bring the user to the donorFrag and display the donor's history
			 */
			case 2:
				toFrag = new DonorFrag();
				sendArgs.putInt(DonorFrag.ARG_TYPE, 0);
				sendArgs.putInt(DonorFrag.ARG_DONOR_ID, Integer.parseInt(listitems.get(position).get("donor_id")));
				toFrag.setArguments(sendArgs);

				transaction.replace(R.id.container, toFrag);
				transaction.addToBackStack("ToDonor" + listitems.get(position).get("name"));
				transaction.commit();
				break;

			// Prayers
			//TODO: Implement
			case 4:
    			//Take to prayers
				break;

			/*
			 * if the accounts were being displayed,
			 * take the user to the list of items for that
			 * account...
			 * TODO: Figure out what falls under this category,
			 * so you can handle the click events properly/go to the right place.
			 */
			case 3:
				break;

			/* If the payroll (history) was being displayed... Then don't do anything?
			 * Not enough information to make a detailed layout. maybe share the gift's layout?
			 * TODO: Implement
			 */
			/*case 4:
				transaction.replace(R.id.container, TODO: add the fragment );
				transaction.addToBackStack("ToPayroll" + listitems.get(position).get("title"));
				transaction.commit();
				break;*/

			/* If reports were being displayed, take the user to the pdf version of
			 * of the report. if this is not available, consider showing a detailed page
			 * with all the info on it.
			 */
			 //TODO: Implement
			 /*case 5:
				Take to the report pdf.
				break;*/
			}
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_TYPE, display);
	}
}
