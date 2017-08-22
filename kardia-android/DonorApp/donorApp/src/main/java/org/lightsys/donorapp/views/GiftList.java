package org.lightsys.donorapp.views;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

/**
 * This page displays a list of gifts. It either shows all gifts, gifts for a 
 * specific year or for a specific fund and year. It also loads a bar at the bottom
 * which can be clicked to go to a donation website.
 * 
 * @author Andrew Cameron
 */
public class GiftList extends Fragment{
	
	public static String ARG_YEAR_ID = "year_id";
	int year_id = -1; 
	public static String ARG_FUND_ID = "fund_id";
	int fund_id = -1;
	private ArrayList<Gift> gifts = new ArrayList<Gift>();
	private ArrayList<Integer> giftIDs = new ArrayList<Integer>();
	private boolean isSpecificFund = false;
	LocalDBHandler db;

	/**
	 * Grab the needed Ids, load data and view.
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

		db = new LocalDBHandler(getActivity(), null);
		Bundle giftArgs = getArguments();
		
		if(savedInstanceState != null){
			this.year_id = savedInstanceState.getInt(ARG_YEAR_ID);
			this.fund_id = savedInstanceState.getInt(ARG_FUND_ID);
		}
		//This is used when dealing with specific segments of gifts...
		else if(giftArgs != null){
			this.year_id = giftArgs.getInt(ARG_YEAR_ID);
			this.fund_id = giftArgs.getInt(ARG_FUND_ID);
			this.giftIDs = giftArgs.getIntegerArrayList("giftIDs");

			if(giftIDs != null && !giftIDs.isEmpty()) {
				for (Integer id : giftIDs) {
					gifts.add(db.getGift(id));
				}
			}
			else if(this.fund_id != -1){
				isSpecificFund = true;
				gifts = db.getGiftsForFund(fund_id, year_id); // pull all the gifts for a certain fund during a certain year

				//Sets donation link bar only if for a specific fund
				LinkBar lb = new LinkBar();
				lb.setArguments(giftArgs);

				FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
				fragmentManager.beginTransaction().replace(R.id.bottom_bar, lb).commit();
			}
			else{
				gifts = db.getGiftsForYear(year_id);//pulls all the gifts for a certain year
			}
		}
		//This is used when dealing with the entire list of gifts...
		else{
			gifts = db.getGifts(); // pull ALL gifts
		}
		
		View v = inflater.inflate(R.layout.activity_main, container, false);

		// Set title appropriately to what data is shown
		String giftListTitle = "Gifts";
		if (year_id != -1) {
			String yearStr = db.getYearForID(year_id).getName();
			giftListTitle += " - " + yearStr;
		}
		if (fund_id != -1) {
			String fundStr = db.getFundById(fund_id).getFund_desc();
			giftListTitle += " - " + fundStr;
		}
		getActivity().setTitle(giftListTitle);
		db.close();

		ListView listview = (ListView)v.findViewById(R.id.info_list);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>> itemList = generateListItems();

		// If list is for specific fund, display fund as smaller (not as subject)
		String[] from = {"giftname", "giftdate", "giftamount"};
		if (isSpecificFund) {
			int[] to = {R.id.fundName, R.id.subject, R.id.detail};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
			listview.setAdapter(adapter);
		} else {
			int[] to = {R.id.subject, R.id.date, R.id.detail};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
			listview.setAdapter(adapter);
		}

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
			
			hm.put("giftname", g.getGift_fund_desc());
			hm.put("giftamount", Formatter.amountToString(g.getGift_amount()));
			hm.put("giftdate", Formatter.getFormattedDate(g.getGift_date()));
			
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
			args.putInt(ARG_FUND_ID, db.getFundByDescription(gifts.get(position).getGift_fund_desc()).getID());

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
		outState.putInt(ARG_YEAR_ID, year_id);
		outState.putIntegerArrayList("giftIDs", giftIDs);
	}
}