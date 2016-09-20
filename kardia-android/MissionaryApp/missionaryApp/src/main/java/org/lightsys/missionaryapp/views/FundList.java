package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

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

import org.lightsys.missionaryapp.R;

/**
 * This page displays a list of all funds that the user manages
 * with some info.
 * 
 * @author Andrew Cameron
 * edited from DonorApp to MissionaryApp by Laura DeOtte
 * shows each fund with the total donated to date for the specific period
 * clicking fund goes to a list of all donations to fund during time period
 */
public class FundList extends Fragment{
	
	private ArrayList<Fund> funds;
	private ArrayList<Integer> fundIds = new ArrayList<Integer>();
	private static String periodtype="Year";
	private static String periodid = Integer.toString(Calendar.getInstance().get(Calendar.YEAR));

	/**
	 * Pulls all relevant funds, and creates the view (including the bottom total bar)
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null);

		// Select Active account
        int accountID = db.getAccount().getId();
        funds = db.getFundsForMissionary(accountID);

		db.close();

		View v = inflater.inflate(R.layout.activity_main, container, false);

		getActivity().setTitle("Funds");

		if (funds == null) {
			return v;
		}

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>>itemList = generateListItems();
		String[] from = {"fundtitle","todateamount","date"};
		int[] to = {R.id.subject, R.id.detail, R.id.date_text};
		
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
		
		ListView listview = (ListView)v.findViewById(R.id.info_list);
		listview.setAdapter(adapter);
		listview.setOnItemClickListener(new onFundClicked());
		
		return v;
	}
	
	/**
	 * Formats the fund information into a hashmap arraylist.
	 * 
	 * @return a hashmap array with fund information, to be shown in a listview 
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){

		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		for(Fund f : funds){
			HashMap<String,String> hm = new HashMap<String,String>();
            Period p = db.getFundPeriodToDate(f.getFundId(), periodtype, periodid);
			hm.put("fundtitle", f.getFundDesc());
            hm.put("todateamount", Formatter.amountToString(p.getGiftTotal()));
            hm.put("date", p.getPeriodName());
			
			aList.add(hm);
		}
		return aList;
	}
	
	/**
	 * Sends the User to a list of years that they 
	 * have donated to that particular fund.
	 */
	private class onFundClicked implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			GiftList newFrag = new GiftList();
			fundIds.add(funds.get(position).getFundId());
			Bundle args = new Bundle();
			args.putIntegerArrayList(newFrag.ARG_FUND_IDS, fundIds);
			args.putString(newFrag.ARG_PERIOD_TYPE, periodtype);
			args.putString(newFrag.ARG_PERIOD_ID, periodid);
			newFrag.setArguments(args);

			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			transaction.replace(R.id.content_frame, newFrag);
			transaction.addToBackStack("ToGiftTimePeriodList");
			transaction.commit();
		}
	}

}