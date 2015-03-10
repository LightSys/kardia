package org.lightsys.missionaryapp.optionsfragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.LocalDBHandler;

/**
 * Created by Breven on 3/10/2015.
 */
public class GiftFragment extends Fragment {
    final static String ARG_GIFT_ID = "gift_id";
    int gift_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        if(savedInstanceState != null){
            gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
        }

        return inflater.inflate(R.layout.gift_view_layout, container, false);
    }


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

    public void updateGiftView(int gift_id){
        TextView title = (TextView)getActivity().findViewById(R.id.title);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView amount = (TextView)getActivity().findViewById(R.id.giftamount);
        TextView summary = (TextView)getActivity().findViewById(R.id.summary);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        Gift g = db.getGift(gift_id);

        title.setText("Gift from " + g.getGift_fund_desc());
        date.setText("Date: " + g.formatedDate());
        amount.setText("Amount: " + g.amountToString());
        summary.setText("Check Number: " + g.getGift_check_num());


        this.gift_id = gift_id;
    }

    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_GIFT_ID, gift_id);
    }
}
