package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.donorapp.bottombar.TotalBar;
import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Fund;
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
 * This page displays a list of all funds that the user has donated to
 * with some info. It also loads a bar at the bottom which has the total 
 * amount that the user has donated over all (for the current year)
 * 
 * @author Andrew Cameron
 */
public class FundList extends Fragment{
	
	private ArrayList<Fund> funds;
	
	/**
	 * Pulls all relevant funds, and creates the view (including the bottom total bar)
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
		ArrayList<Account> accounts = db.getAccounts();

		// Loop through all accounts and pull all funds for each account
		for (Account a : accounts) {
			int accountID = a.getId();
			funds = db.getFundsForAccount(accountID);
		}

		db.close();

		View v = inflater.inflate(R.layout.activity_main, container, false);

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>>itemList = generateListItems();
		String[] from = {"fundtitle", "amount", "text"};
		int[] to = {R.id.subject, R.id.detail, R.id.date};
		
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);
		
		ListView listview = (ListView)v.findViewById(R.id.info_list);
		listview.setAdapter(adapter);
		listview.setOnItemClickListener(new onFundClicked());

		// Create bottom bar
		TotalBar tb = new TotalBar();
		FragmentManager fragmentManager = getFragmentManager();
		fragmentManager.beginTransaction().replace(R.id.bottom_bar, tb).commit();
		
		return v;
	}
	
	/**
	 * Formats the fund information into a hashmap arraylist.
	 * 
	 * @return a hashmap array with fund information, to be shown in a listview 
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){
		
		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
		for(Fund f : funds){
			HashMap<String,String> hm = new HashMap<String,String>();
			
			hm.put("fundtitle", f.getFund_desc());
			hm.put("amount", f.amountToString());
			hm.put("text", "(Total Given)");
			
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
			setHistoryTitle(position);
				
				YTDList newFrag = new YTDList();

				Bundle args = new Bundle();
				args.putInt(newFrag.ARG_FUND_ID, funds.get(position).getID());
				newFrag.setArguments(args);

				FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
				transaction.replace(R.id.content_frame, newFrag);
				transaction.addToBackStack("ToYTDList");
				transaction.commit();
		}
	}

	/**
	 * Sets the title of the page to <specific fund name>'s History
	 * (Used when viewing the years donated to a fund)
	 * 
	 * @param position, The position of the fund selected within the list of funds
	 */
	public void setHistoryTitle(int position){
		getActivity().getActionBar().setTitle(funds.get(position).getFund_desc() + " - Giving History");
	}
}