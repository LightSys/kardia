package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.HashMap;

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
 * This class shows the year-to-date or month to date list for a certain fund
 * and shows amount given towards that fund.
 * 
 * @author otter57
 * created 7-27-16
 */
public class GiftTimePeriodList extends Fragment{

	public final String ARG_FUND_ID = "fund_id"; //The position of the fund that was clicked
	int fund_id = -1;
	private ArrayList<Period> periods = new ArrayList<Period>();
    String periodtype;
	
	/**
	 * Based on what fund the user clicked on (or visited last) it will generate a list of 
	 * years during which they donated to the fund, with the amount of money they donated that year.
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		Bundle args = getArguments();

		LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		periodtype = "gift_year";
        //todo: make this an option for user
		//periodtype = "gift_month"

		if(savedInstanceState != null){ 
			fund_id = savedInstanceState.getInt(ARG_FUND_ID);
			periods = db.getFundPeriods(fund_id, periodtype);
		} 
		else if(args != null){
			this.fund_id = args.getInt(ARG_FUND_ID);
			periods = db.getFundPeriods(fund_id, periodtype);
		}
		else{
			periods = db.getFundPeriods(periodtype);
		}
        if (periods.size()==1){
            loadRelatedGifts(0);
        }



		View v = inflater.inflate(R.layout.activity_main, container, false);
        String gtpListTitle = "Gifts By " + periodtype.replace("gift_m","M").replace("gift_y","Y") + ":";

		if (fund_id != -1) {
			gtpListTitle += " - " + db.getFundByFundId(fund_id).getFundDesc();
		}
		getActivity().setTitle(gtpListTitle);

		db.close();

		ListView listview = (ListView)v.findViewById(R.id.info_list);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>> itemList = generateListItems();
		if (fund_id == -1) {
			String[] from = {"gtptitle", "gtpamount","year"};
			int[] to = {R.id.name, R.id.detail, R.id.subject};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
			listview.setAdapter(adapter);
		} else {
			String[] from = {"gtptitle", "gtpamount", "gtpfund","year"};
			int[] to = {R.id.name, R.id.detail, R.id.fundName, R.id.subject};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
			listview.setAdapter(adapter);
		}

		listview.setOnItemClickListener(new onPeriodClicked());
		
		return v;
	}
	
	/**
	 * Formats the year data into a arraylist, for proper viewing in the listview
	 * @return an ArrayList with a HashMap of String, String
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){
		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
		
		for(Period p : periods){
			HashMap<String,String> hm = new HashMap<String,String>();
			
			hm.put("gtptitle", p.getPeriodName() + " Total");
			hm.put("gtpamount", Formatter.amountToString(p.getGiftTotal()));
			if (fund_id != -1) {
				LocalDBHandler db = new LocalDBHandler(getActivity(), null);
				hm.put("gtpfund", db.getFundByFundId(fund_id).getFundDesc());
				db.close();
			}
			hm.put("year", p.getPeriodName());

			aList.add(hm);
		}
		
		return aList;
	}
	
	/**
	 * click listener used to take the user to the list of gifts donated during that year.
	 */
	private class onPeriodClicked implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			loadRelatedGifts(position);
		}
	}
	
	/**
	 * Opens another fragment with the list of the gifts that they gave to the specific
	 * fund on a specific year.
	 * (Still has a donation button at the bottom, for that specific fund)
	 * So all it does is change what is displayed in the list.
	 * @param position, position of list that was selected
	 */
	public void loadRelatedGifts(int position){
		Bundle GiftArgs = new Bundle();
		
		GiftArgs.putString(GiftList.ARG_PERIOD_ID, periods.get(position).getPeriodName()); //Used to find what period to pull gifts for
        GiftArgs.putString(GiftList.ARG_PERIOD_TYPE, this.periodtype);
		GiftArgs.putInt(GiftList.ARG_FUND_ID, this.fund_id); //send the fund id
		
		GiftList gList = new GiftList();
		gList.setArguments(GiftArgs);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.content_frame, gList);
		transaction.addToBackStack("ToGiftList");
		transaction.commit();
	}
	
	/**
	 * used to hold the reference id in case the user navigates away from the app.
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_FUND_ID, fund_id);
	}
}