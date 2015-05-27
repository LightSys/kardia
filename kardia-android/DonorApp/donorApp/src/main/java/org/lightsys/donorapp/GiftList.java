package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.donorapp.bottombar.LinkBar;
import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.data.LocalDBHandler;

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
	public static String ARG_GIFT_QUERY = "gift_query";
	String query = "";
	private ArrayList<Gift> gifts = new ArrayList<Gift>();;
	
	/**
	 * Grab the needed Ids, load data and view.
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
		Bundle giftArgs = getArguments();
		
		if(savedInstanceState != null){
			this.year_id = savedInstanceState.getInt(ARG_YEAR_ID);
			this.fund_id = savedInstanceState.getInt(ARG_FUND_ID);
			this.query = savedInstanceState.getString(ARG_GIFT_QUERY);
		}
		//This is used when dealing with specific segments of gifts...
		else if(giftArgs != null){
			this.year_id = giftArgs.getInt(ARG_YEAR_ID);
			this.fund_id = giftArgs.getInt(ARG_FUND_ID);
			this.query = giftArgs.getString(ARG_GIFT_QUERY);

			if(this.query != null && !this.query.equals("")){
				gifts = db.getSearchResults(query);
			}
			else if(this.fund_id != -1){
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
		//This is used when dealing with the entire list of gifts... Pulls all gifts, and has a general donation link 
		else{
			gifts = db.getGifts(); // pull ALL gifts
		}

		db.close();
		
		View v = inflater.inflate(R.layout.activity_main, container, false);
		
		ArrayList<HashMap<String,String>> itemList = generateListItems();
		String[] from = {"giftname", "giftamount", "giftdate"};
		int[] to = {R.id.title, R.id.amount, R.id.date};
		
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
		
		ListView listview = (ListView)v.findViewById(R.id.info_list);
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
			
			hm.put("giftname", "Gift to: " + g.getGift_fund_desc());
			hm.put("giftamount", g.amountToString());
			hm.put("giftdate", g.formatedDate());
			
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
			
			DetailedGift newfrag = new DetailedGift();
			newfrag.setArguments(args);
					
			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			transaction.replace(R.id.content_frame, newfrag);
			transaction.addToBackStack("ToDetailedGiftView");
			transaction.commit();
			getActivity().setTitle("Gift");
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
		outState.putString(ARG_GIFT_QUERY, query);
	}
}