package org.lightsys.missionaryapp.optionsfragments;

import java.util.ArrayList;
import java.util.HashMap;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.LocalDBHandler;
import org.lightsys.missionaryapp.donorfragments.DonorBar;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;

/**
 * The DonorFrag consists of both the DonorBar and
 * either the a list of gift histories or the GiftDetailFrag
 *
 * @author Andrew Cameron
 *
 */
public class DonorFragment extends Fragment {

    public static final String ARG_TYPE = "type";
    int type = 0; // 0 = history, 1 = specific gift
    public static final String ARG_DONOR_ID = "donor_id";
    int donor_id = -1;
    public static final String ARG_GIFT_ID = "gift_id";
    int gift_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        Bundle args = getArguments();

        View v = inflater.inflate(R.layout.split_view, container, false);

        if(savedInstanceState != null){
            this.type = savedInstanceState.getInt(ARG_TYPE);
            this.donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            if(type == 1){
                this.gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
            }
        }
        else if(args != null){
            this.type = args.getInt(ARG_TYPE);
            this.donor_id = args.getInt(ARG_DONOR_ID);
            if(type == 1){
                this.gift_id = args.getInt(ARG_GIFT_ID);
            }
        }

        Fragment Donorbar = new DonorBar();

        Bundle donorArgs = new Bundle();
        donorArgs.putInt(ARG_DONOR_ID, donor_id);
        Donorbar.setArguments(donorArgs);

        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction transaction = fragmentManager.beginTransaction();
        transaction.replace(R.id.donor_bar, Donorbar);

        if(type == 0){

            LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
            ArrayList<HashMap<String,String>> itemList = null/*db.getDonorHistory(donor_id)*/;
            String[] from = {"title","date","amount"};
            int[] to = {R.id.title, R.id.date, R.id.amount};
            SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.gift_listview_item, from, to);
        }
        else{
            Bundle giftArgs = new Bundle();
            giftArgs.putInt(ARG_GIFT_ID, gift_id);
            Fragment contentFrag = new GiftFragment();
            contentFrag.setArguments(giftArgs);
            transaction.replace(R.id.content, contentFrag);
        }
        transaction.commit();

        return v;
    }

    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_DONOR_ID, donor_id);
        outState.putInt(ARG_GIFT_ID, gift_id);
        outState.putInt(ARG_TYPE, type);
    }

}
