package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.missionaryapp.data.Gift;
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
 * This page displays a list of gifts. It either shows all gifts, gifts for a 
 * specific year or for a specific fund and year.
 * 
 * @author Andrew Cameron
 */
public class GiftList extends Fragment{

	public static String ARG_PERIOD_TYPE = "period_type";
	String period_type;
	public static String ARG_PERIOD_ID = "period_id";
	String period_id;
	public static String ARG_FUND_ID = "fund_id";
	int fund_id = -1;
	private ArrayList<Gift> gifts = new ArrayList<Gift>();

	/**
	 * Grab the needed Ids, load data and view.
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

		LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		Bundle giftArgs = getArguments();
		
		if(savedInstanceState != null){
			this.period_type = giftArgs.getString(ARG_PERIOD_TYPE);
			this.period_id = savedInstanceState.getString(ARG_PERIOD_ID);
			this.fund_id = savedInstanceState.getInt(ARG_FUND_ID);

			gifts = db.getGiftsForPeriod(fund_id, period_type, period_id);
		}
		//This is used when dealing with specific segments of gifts...
		else if(giftArgs != null){
			this.period_type = giftArgs.getString(ARG_PERIOD_TYPE);
			this.period_id = giftArgs.getString(ARG_PERIOD_ID);
			this.fund_id = giftArgs.getInt(ARG_FUND_ID);

			gifts=db.getGiftsForPeriod(fund_id, period_type, period_id);
		}
		//This is used when dealing with the entire list of gifts...
		else{
			gifts = db.getGifts(); // pull ALL gifts
		}
		
		View v = inflater.inflate(R.layout.activity_main, container, false);

		// Set title appropriately to what data is shown
		String giftListTitle = "Gifts";

		if (fund_id != -1) {
			String fundStr = db.getFundByFundId(fund_id).getFundDesc();
			giftListTitle += " - " + fundStr;
		}
		getActivity().setTitle(giftListTitle);
		db.close();

		ListView listview = (ListView)v.findViewById(R.id.info_list);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>> itemList = generateListItems();

		// display donor name, fund name, date, and amount for all gifts
		String[] from = {"donorname", "giftname", "giftdate", "giftamount"};
        int[] to = {R.id.subject, R.id.fundName, R.id.date, R.id.detail};
        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
        listview.setAdapter(adapter);

		listview.setOnItemClickListener(new onGiftClicked());
		
		return v;
	}
	
	/**
	 * Formats the gift information into a hashmap arraylist.
	 * 
	 * @return a hashmap array with gift information, to be used in a SimpleAdapter
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){
		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
		
		for(Gift g : gifts){
			HashMap<String,String> hm = new HashMap<String,String>();

			hm.put("donorname", g.getGiftDonor());
			hm.put("giftname", g.getGiftFundDesc());
			hm.put("giftamount", Formatter.amountToString(g.getGiftAmount()));
			hm.put("giftdate", Formatter.getFormattedDate(g.getGiftDate()));
			
			aList.add(hm);
		}
		return aList;
	}

	/**
	 * Loads the specific details of the selected gift.
	 */
	private class onGiftClicked implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			
			Bundle args = new Bundle();
			args.putInt(DetailedGift.ARG_GIFT_ID, gifts.get(position).getId());
            args.putInt(DetailedGift.ARG_DONOR_ID, gifts.get(position).getGiftDonorId());
            args.putString(DetailedGift.ARG_DONOR_NAME, gifts.get(position).getGiftDonor());

            DetailedGift newfrag = new DetailedGift();
			newfrag.setArguments(args);
					
			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			transaction.replace(R.id.content_frame, newfrag);
			transaction.addToBackStack("ToDetailedGiftView");
			transaction.commit();
		}
	}
	
	/**
	 * Used to store the current ids in case the user navigates
	 * away from the app but leaves the app open.
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_FUND_ID, fund_id);
        outState.putString(ARG_PERIOD_TYPE, period_type);
        outState.putString(ARG_PERIOD_ID, period_id);
	}
}