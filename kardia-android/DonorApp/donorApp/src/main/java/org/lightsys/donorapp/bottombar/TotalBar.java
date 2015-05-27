package org.lightsys.donorapp.bottombar;

import java.util.Calendar;

import org.lightsys.donorapp.data.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.donorapp.R;

/**
 * Displays the total amount that the user has given (Year to Date)
 * 
 * @author Andrew Cameron
 *
 */
public class TotalBar extends Fragment {
	
	private final String ARG_YEAR = "currentYear";
	private String yearAmount = "";
	private int year = -1;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.totalbar_layout, container, false);
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 7);
		if(savedInstanceState != null){
			year = savedInstanceState.getInt(ARG_YEAR);
		}else{
			year = Calendar.getInstance().get(Calendar.YEAR);
		}
		yearAmount = db.getYTDAmount();
		db.close();
		updateTotal(v);
		return v;
	}
	
	/**
	 * Pulls and updates the view with the amount of money.
	 */
	public void updateTotal(View v){
		TextView totalText = (TextView)v.findViewById(R.id.totalytd);
		TextView totalCount = (TextView)v.findViewById(R.id.total);
		
		totalText.setText("Total (" + year + " YTD): ");
		totalCount.setText(yearAmount);
	}
}