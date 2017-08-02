package org.lightsys.donorapp.views;

import org.lightsys.donorapp.tools.LocalDBHandler;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import com.example.donorapp.R;

import static android.content.ContentValues.TAG;

public class LinkBar extends Fragment {

	public final String ARG_FUND_ID = "fund_id"; //The position of the fund that was clicked
	private static String giving_url = "";
	int fund_id = -1;
	String temp_url;
	
	Button b;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		View v = inflater.inflate(R.layout.linkbar_layout, container, false);
		LocalDBHandler db = new LocalDBHandler(getActivity(), null);

		Bundle args = getArguments();
		if(savedInstanceState != null){
			fund_id = savedInstanceState.getInt(ARG_FUND_ID);
		}
		else if(args != null){
			fund_id = args.getInt(ARG_FUND_ID);
		}
		else {
			getActivity().setTitle("General Donations");
			temp_url = db.getGivingUrl();
		}

		// Retrieve giving URL from database for specific fund
		if (temp_url == null) {
			temp_url = db.getFundById(fund_id).getGiving_url();
		}
		String testString = db.getGivingUrl();
		db.close();

		// If URL not found, set to unavailable status
		// If URL does not contain Web protocol, add it to the URL
		if (temp_url == null || temp_url.equals("")) {
			giving_url = "Unavailable";
		} else if (!temp_url.contains("http://") && !temp_url.contains("https://")) {
			giving_url = "http://" + giving_url;
		}else{
			giving_url = temp_url;
		}

		b = (Button)v.findViewById(R.id.sendButton);

		b.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				if (giving_url.equals("Unavailable")) {
					Toast.makeText(getActivity(), "Donation link unavailable for this fund", Toast.LENGTH_SHORT).show();
				} else {
					Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(giving_url));
					startActivity(browserIntent);
				}
			}
			
		});
		
		return v;
	}
	
	/**
	 * Used to hold the reference id, in case the user navigates away from the app
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_FUND_ID, fund_id);
	}
}
