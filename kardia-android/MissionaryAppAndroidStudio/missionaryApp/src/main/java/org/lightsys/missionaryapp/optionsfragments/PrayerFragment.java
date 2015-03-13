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
 * Created by Breven on 3/10/2015.
 */
public class PrayerFragment extends Fragment {

    public static final String ARG_TYPE = "type";
    int type = 0; // 0 = history, 1 = specific prayer
    public static final String ARG_DONOR_ID = "donor_id";
    int donor_id = -1;
    public static final String ARG_PRAYER_ID = "prayer_id";
    int prayer_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        Bundle args = getArguments();

        View v = inflater.inflate(R.layout.split_view, container, false);

        if(savedInstanceState != null){
            this.type = savedInstanceState.getInt(ARG_TYPE);
            this.donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            if(type == 1) {
                this.prayer_id = savedInstanceState.getInt(ARG_PRAYER_ID);
            }
        }
        else if(args != null){
            this.type = args.getInt(ARG_TYPE);
            this.donor_id = args.getInt(ARG_DONOR_ID);
            if(type == 1){
                this.prayer_id = args.getInt(ARG_PRAYER_ID);
            }
        }

        Fragment Donorbar = new DonorBar();

        Bundle donorArgs = new Bundle();
        donorArgs.putInt(ARG_PRAYER_ID, prayer_id);
        Donorbar.setArguments(donorArgs);

        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction transaction = fragmentManager.beginTransaction();
        transaction.replace(R.id.donor_bar, Donorbar);

        if(type == 0){

            LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
            ArrayList<HashMap<String, String>> itemList = null;/*db.getPrayerHistory*/;
            String[] from = {"prayer_subject", "prayer_desc", "date"};
            int[] to = {R.id.prayer_subject, R.id.prayer_desc, R.id.date};
            SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.prayer_listview_item, from, to);
        }
        else{
            Bundle prayerArgs = new Bundle();
            prayerArgs.putInt(ARG_PRAYER_ID, prayer_id);
            Fragment contentFrag = new PrayerDetailFrag();
            contentFrag.setArguments(prayerArgs);
            transaction.replace(R.id.content, contentFrag);
        }
        transaction.commit();

        return v;
    }

    public void onSavedInstanceState(Bundle outstate){
        super.onSaveInstanceState(outstate);
        outstate.putInt(ARG_DONOR_ID, donor_id);
        outstate.putInt(ARG_PRAYER_ID, prayer_id);
        outstate.putInt(ARG_TYPE, type);
    }
}
