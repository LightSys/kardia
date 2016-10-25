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
public class GiftTimePeriodList extends Fragment {

	public final String ARG_FUND_ID = "fund_id"; //The funds managed by the missionary
	private int fundId=-1;
	private ArrayList<Period> periods = new ArrayList<Period>();
	private String periodtype;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

		Bundle args = getArguments();

		LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		periodtype = db.getGiftPeriod();
        periods.clear();
		if(savedInstanceState != null){ 
			this.fundId = savedInstanceState.getInt(ARG_FUND_ID);
			periods.addAll(db.getFundPeriods(fundId, periodtype));
		} 
		else if(args != null){
			this.fundId = args.getInt(ARG_FUND_ID);
			periods = db.getFundPeriods(fundId, periodtype);
		}

		View v = inflater.inflate(R.layout.activity_main, container, false);
        String gtpListTitle = "Gifts By " + periodtype;

		if (fundId!=-1) {
			gtpListTitle += ": " + db.getFundByFundId(fundId).getFundName();
		}
		getActivity().setTitle(gtpListTitle);

		db.close();

		ListView listview = (ListView)v.findViewById(R.id.infoList);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>> itemList = generateListItems();
		String[] from = {"gtpamount", "gtpfund","period"};
		int[] to = {R.id.amountText, R.id.fundNameText, R.id.donorText};
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.gift_listview_item_layout, from, to);
		listview.setAdapter(adapter);

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
			String Date;
			if (periodtype.equals("Month")){
				String[] parts = p.getPeriodName().split("\\.");
				Date = Formatter.getMonthYearDate(parts[1], parts[0]);
			}else{
				Date = p.getPeriodName();
			}

			hm.put("gtpamount", Formatter.amountToString(p.getGiftTotal()));
			LocalDBHandler db = new LocalDBHandler(getActivity(), null);
			hm.put("gtpfund", db.getFundByFundId(p.getFundId()).getFundName());
			db.close();

			hm.put("period", Date);

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
	private void loadRelatedGifts(int position){
		Bundle GiftArgs = new Bundle();
		ArrayList<Integer> fund = new ArrayList<Integer>();
		fund.add(fundId);
		GiftArgs.putString(GiftList.ARG_PERIOD_ID, periods.get(position).getPeriodName()); //Used to find what period to pull gifts for
        GiftArgs.putString(GiftList.ARG_PERIOD_TYPE, this.periodtype);
		GiftArgs.putIntegerArrayList(GiftList.ARG_FUND_IDS, fund); //send the fund id
		
		GiftList gList = new GiftList();
		gList.setArguments(GiftArgs);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, gList);
		transaction.addToBackStack("ToGiftList");
		transaction.commit();
	}

	/**
	 * used to hold the reference id in case the user navigates away from the app.
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_FUND_ID, fundId);
	}
}