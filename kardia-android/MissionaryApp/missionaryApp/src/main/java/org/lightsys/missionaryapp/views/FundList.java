package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.missionaryapp.data.Fund;
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
 *  * @author Andrew Cameron
 * edited from DonorApp to MissionaryApp by Laura DeOtte

 * This page displays a list of all funds that the user manages
 * with some info.
 * 
 * shows each fund with the total donated to date for the specific period
 * clicking fund goes to a list of all donations to fund during time period
 */
public class FundList extends Fragment{
	
	private ArrayList<Fund> funds;

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
		String[] from = {"fund_title","to_date_amount","date"};
		int[] to = {R.id.fundNameText, R.id.amountText, R.id.dateText};
		
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.fund_layout, from, to);
		
		ListView listview = (ListView)v.findViewById(R.id.infoList);
		listview.setAdapter(adapter);
		listview.setOnItemClickListener(new onFundClicked());
		
		return v;
	}
	
	/**
	 * Formats the fund information into a HashMap ArrayList.
	 * 
	 * @return a HashMap array with fund information, to be shown in a ListView
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){

		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		for(Fund f : funds){
			HashMap<String,String> hm = new HashMap<String,String>();
			int Total[]= new int[2];
			ArrayList<Gift> gifts = db.getGifts(Integer.toString(f.getFundId()));
			for(Gift g:gifts){
				Total[0] += g.getGiftAmount()[0];
				Total[1] += g.getGiftAmount()[1];
			}
			if (Total[1]>=100){
				Total[0]+=Math.floor(Total[1]/100);
				Total[1]-=Math.floor(Total[1]/100)*100;
			}
			hm.put("fund_title", f.getFundName());
            hm.put("to_date_amount", Formatter.amountToString(Total));
			if(gifts.size()>0) {
				String startDate = gifts.get(gifts.size() - 1).getGiftDate().substring(0, 4);
				String endDate = gifts.get(0).getGiftDate().substring(0, 4);
				hm.put("date", startDate + " - " + endDate);
			}
			
			aList.add(hm);
		}
		return aList;
	}
	
	/**
	 * Sends the User to a list of years or months that their
	 * fund has received donations.
	 */
	private class onFundClicked implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			GiftTimePeriodList newFrag = new GiftTimePeriodList();
			Bundle args = new Bundle();
			args.putInt(newFrag.ARG_FUND_ID, funds.get(position).getFundId());
			newFrag.setArguments(args);

			FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
			transaction.replace(R.id.contentFrame, newFrag);
			transaction.addToBackStack("ToGiftTimePeriodList");
			transaction.commit();
		}
	}

}