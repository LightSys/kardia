package org.lightsys.missionaryapp.optionsfragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.LocalDBHandler;
import org.lightsys.missionaryapp.data.Prayer;

/**
 * Created by Breven on 3/13/2015.
 */
public class PrayerDetailFrag extends Fragment{
    public final static String ARG_PRAYER_ID = "gift_id";
    int prayer_id = -1;
    View v;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        Bundle args = getArguments();
        v = inflater.inflate(R.layout.gift_view_layout, container, false);
        if(savedInstanceState != null){
            prayer_id = savedInstanceState.getInt(ARG_PRAYER_ID);
        }
        else if(args != null){
            updateView(args.getInt(ARG_PRAYER_ID));
        }
        else if(prayer_id != -1){
            updateView(prayer_id);
        }
        return v;
    }

    public void updateView(int prayer_id){
        TextView subj = (TextView)v.findViewById(R.id.prayer_subject);
        TextView desc = (TextView)v.findViewById(R.id.prayer_desc);
        TextView date = (TextView)v.findViewById(R.id.date);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
        Prayer p = db.getPrayer(prayer_id);

        subj.setText("Subject: " + p.getSubject());
        desc.setText("Desc: " + p.getDescription());
        date.setText(p.getDate());

        this.prayer_id = prayer_id;
    }

}
