package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import org.lightsys.missionaryapp.R;

/**
 * This page displays a list of all funds that the user has donated to
 * with some info. It also loads a bar at the bottom which has the total 
 * amount that the user has donated over all (for the current year)
 * 
 * @author Andrew Cameron
 */
public class FundList extends Fragment{
	
	private ArrayList<Fund> funds;
	String TAG="FundList";
	
	/**
	 * Pulls all relevant funds, and creates the view (including the bottom total bar)
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		ArrayList<Account> accounts = db.getAccounts();

		// Loop through all accounts and pull all funds for each account
		for (Account a : accounts) {
			int accountID = a.getId();
			funds = db.getFundsForMissionary(accountID);
            Log.d(TAG, "onCreateView: " + accountID);
            if (funds.size()>0) {
                Log.d(TAG, "onCreateView: " + funds.get(0).getFundName());
            }
		}

		db.close();

		View v = inflater.inflate(R.layout.activity_main, container, false);

		getActivity().setTitle("Funds");

		if (funds == null) {
			return v;
		}

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>>itemList = generateListItems();
		String[] from = {"fundtitle"};
		int[] to = {R.id.subject};
		
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

		for(Fund f : funds){
			HashMap<String,String> hm = new HashMap<String,String>();
			
			hm.put("fundtitle", f.getFundDesc());
			
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
			YTDList newFrag = new YTDList();

			Bundle args = new Bundle();
			args.putInt(newFrag.ARG_FUND_ID, funds.get(position).getFundId());
			newFrag.setArguments(args);

			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			transaction.replace(R.id.content_frame, newFrag);
			transaction.addToBackStack("ToYTDList");
			transaction.commit();
		}
	}
}