package org.lightsys.missionaryapp.views;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Transaction;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.TransactionListAdapter;

import java.util.ArrayList;
import java.util.HashMap;

/**
 *  * @author Laura DeOtte
 *
 * This page displays a list of all fund reports for the user.
 * 
 * shows report time period
 * allows user to select report for full pdf
 */
public class TransactionList extends Fragment{
	private ArrayList<Transaction> transactions;

	/**
	 * Pulls all relevant transactions
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		LocalDBHandler db = new LocalDBHandler(getActivity());

		// Select reports for account
        int accountID = db.getAccount().getId();
        //todo reportPeriod = db.getFundsForMissionary(accountID);
        transactions = new ArrayList<Transaction>();
        for(int n=0; n<5;n++){
            Transaction t = new Transaction();
            int []amount = new int[2];
            amount[0]=3*n*5-25;
            amount[1]=4+n;
            t.setTransactionFund("A Great Fund");
            t.setTransactionDate("December 12, 2015");
            t.setTransactionDonor("Donor "+n);
            t.setTransactionAmount(amount);
            transactions.add(t);
        }
        db.close();

		View v = inflater.inflate(R.layout.activity_main_layout, container, false);

        getActivity().setTitle("Transactions");

		if (transactions == null) {
			return v;
		}

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>>itemList = generateListItems();
		String[] from = {"fund_title", "donor_name", "amount", "date"};
		int[] to = {R.id.nameText, R.id.giftText, R.id.amountText, R.id.dateText};
		
		TransactionListAdapter adapter = new TransactionListAdapter(getActivity(), itemList, R.layout.funds_listview_item, from, to);
		
		ListView listview = (ListView)v.findViewById(R.id.infoList);
		listview.setAdapter(adapter);
		//listview.setOnItemClickListener(new onReportClicked());
		
		return v;
	}
	
	/**
	 * Formats the report information into a HashMap ArrayList.
	 * 
	 * @return a HashMap array with report information, to be shown in a ListView
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){

		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        LocalDBHandler db = new LocalDBHandler(getActivity());

		for(Transaction t : transactions){
			HashMap<String,String> hm = new HashMap<String,String>();
            hm.put("fund_title", t.getTransactionFund());
            hm.put("donor_name", t.getTransactionDonor());
            hm.put("amount", Formatter.amountToString(t.getTransactionAmount()));
            hm.put("date", t.getTransactionDate());

            aList.add(hm);
		}
		return aList;
	}
}