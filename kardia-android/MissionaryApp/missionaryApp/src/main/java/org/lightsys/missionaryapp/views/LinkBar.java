package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

public class LinkBar extends Fragment {

	public static String ARG_FUND_ID = "fund";
	private static String giving_url = "";
	int fund_id = -1;
	
	Button b;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		View v = inflater.inflate(R.layout.linkbar_layout, container, false);
	
		Bundle args = getArguments();
		if(savedInstanceState != null){
			fund_id = savedInstanceState.getInt(ARG_FUND_ID);
		}
		else if(args != null){
			fund_id = args.getInt(ARG_FUND_ID);
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
