package org.lightsys.donorapp.views;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;
import org.lightsys.donorapp.data.Year;

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
 * This class shows the year-to-date list for a certain fund, with the amount
 * that has been given towards that specific fund.
 * There is also a donation button at the bottom of the page, which when clicked
 * takes the user to a donation page (outside of the app) for that specific fund.
 * 
 * @author Andrew Cameron
 */
public class YTDList extends Fragment{

	public final String ARG_FUND_ID = "fund_id"; //The position of the fund that was clicked
	int fund_id = -1;
	private ArrayList<Year> years = new ArrayList<Year>();
	
	/**
	 * Based on what fund the user clicked on (or visited last) it will generate a list of 
	 * years during which they donated to the fund, with the amount of money they donated that year.
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		Bundle args = getArguments();

		LocalDBHandler db = new LocalDBHandler(getActivity(), null);

		if(savedInstanceState != null){ 
			fund_id = savedInstanceState.getInt(ARG_FUND_ID);
			years = db.getYearsForFund(fund_id);
		} 
		else if(args != null){
			this.fund_id = args.getInt(ARG_FUND_ID);
			years = db.getYearsForFund(fund_id);

			//Only sets link bar if list is for specific fund, not for all years
			LinkBar lb = new LinkBar();
			lb.setArguments(args);

			FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
			fragmentManager.beginTransaction().add(R.id.bottom_bar, lb).commit();
		}
		else{
			years = db.getYears();
		}

		View v = inflater.inflate(R.layout.activity_main, container, false);
		String ytdListTitle = "Gifts By Year";
		if (fund_id != -1) {
			ytdListTitle += " - " + db.getFundById(fund_id).getFund_desc();
		}
		getActivity().setTitle(ytdListTitle);

		db.close();

		ListView listview = (ListView)v.findViewById(R.id.info_list);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>> itemList = generateListItems();
		if (fund_id == -1) {
			String[] from = {"ytdtitle", "ytdamount"};
			int[] to = {R.id.subject, R.id.detail};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
			listview.setAdapter(adapter);
		} else {
			String[] from = {"ytdtitle", "ytdamount", "ytdfund"};
			int[] to = {R.id.subject, R.id.detail, R.id.fundName};
			SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
			listview.setAdapter(adapter);
		}

		listview.setOnItemClickListener(new onFundClicked());
		
		return v;
	}
	
	/**
	 * Formats the year data into a arraylist, for proper viewing in the listview
	 * @return an ArrayList with a HashMap of String, String
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){
		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
		
		for(Year y : years){
			HashMap<String,String> hm = new HashMap<String,String>();
			
			hm.put("ytdtitle", y.getName() + " Total");
			hm.put("ytdamount", Formatter.amountToString(y.getGift_total()));
			if (fund_id != -1) {
				LocalDBHandler db = new LocalDBHandler(getActivity(), null);
				hm.put("ytdfund", db.getFundById(fund_id).getFund_desc());
				db.close();
			}

			aList.add(hm);
		}
		
		return aList;
	}
	
	/**
	 * click listener used to take the user to the list of gifts donated during that year.
	 */
	private class onFundClicked implements OnItemClickListener{

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
		
		GiftArgs.putInt(GiftList.ARG_YEAR_ID, years.get(position).getId()); //Used to find what year to pull gifts for
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