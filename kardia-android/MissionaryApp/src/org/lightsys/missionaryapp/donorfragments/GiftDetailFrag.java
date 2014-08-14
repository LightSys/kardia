package org.lightsys.missionaryapp.donorfragments;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.R.id;
import org.lightsys.missionaryapp.R.layout;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

/**
 * The GiftDetailFrag is a detailed view 
 * of a gift or transaction.
 * 
 * @author Andrew Cameron
 */
public class GiftDetailFrag extends Fragment {

	final static String ARG_GIFT_ID = "gift_id";
	int gift_id = -1;
	View v;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		Bundle args = getArguments(); 
		v = inflater.inflate(R.layout.gift_view_layout, container, false);
		if(savedInstanceState != null){
			gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
		}
		else if(args != null){
			updateView(args.getInt(ARG_GIFT_ID));
		}
		else if(gift_id != -1){
			updateView(gift_id);
		}
		return v;
	}
	
	public void updateView(int gift_id){
		TextView to = (TextView)v.findViewById(R.id.title);
		TextView date = (TextView)v.findViewById(R.id.date);
		TextView amount = (TextView)v.findViewById(R.id.giftamount);
		TextView summary = (TextView)v.findViewById(R.id.summary);
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
		Gift g = db.getGift(gift_id);
		
		to.setText("Gift to: " + g.getGift_fund_desc());
		date.setText("Date: " + g.formatedDate());
		amount.setText("Amount" + g.amountToString());
		summary.setText("Check Number: " + g.getGift_check_num());
		
		this.gift_id = gift_id;
	}
}
