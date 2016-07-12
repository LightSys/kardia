package org.lightsys.missionaryapp;

import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

/**
 * This is used to display detailed information about a specific gift.
 * The gift is determined by the "position" int passed into the fragment
 * which then uses that to check the list of gifts and choose the one at
 * that spot. At which point it grabs all the needed information and displays
 * it in the gift_detailedview_layout.
 * 
 * @author Andrew Cameron
 *
 */
public class DetailedGift extends Fragment{
	
	final static String ARG_GIFT_ID = "gift_id";
	int gift_id = -1;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		if(savedInstanceState != null){
			gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
		}
		
		return inflater.inflate(R.layout.gift_detailedview_layout, container, false);
	}
	
	/**
	 * used to get the argument for the gift id
	 */
	@Override
	public void onStart(){
		super.onStart();
		
		Bundle args = getArguments();
		
		if(args != null){
			updateGiftView(args.getInt(ARG_GIFT_ID));
		}
		else if(gift_id != -1){
			updateGiftView(gift_id);
		}
	}
	
	/**
	 * This function sets the text for the gift's information
	 * 
	 * @param id, the gift's id.
	 */
	public void updateGiftView(int gift_id){
		TextView title = (TextView)getActivity().findViewById(R.id.title);
		TextView date = (TextView)getActivity().findViewById(R.id.date);
		TextView amount = (TextView)getActivity().findViewById(R.id.giftamount);
		TextView summary = (TextView)getActivity().findViewById(R.id.summary);
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
		Gift g = db.getGift(gift_id);
		
		title.setText("Gift to " + g.getGift_fund_desc());
		date.setText("Date: " + g.formatedDate());
		amount.setText("Amount: " + g.amountToString());
		summary.setText("Check Number: " + g.getGift_check_num());
		
		
		this.gift_id = gift_id;
	}
	
	/**
	 * Used to hold onto the id, in case the user comes back to this page
	 * (like if their phone goes into sleep mode or they temporarily leave the app)
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);	
		outState.putInt(ARG_GIFT_ID, gift_id);
	}
}
