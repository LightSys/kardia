package org.lightsys.missionaryapp.optionsfragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.LocalDBHandler;

/**
 * Created by Breven on 3/13/2015.
 */
public class FundDetailFrag extends Fragment {
    public final static String ARG_FUND_ID = "fund_id";
    int fund_id = -1;
    View v;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        Bundle args = getArguments();
        v = inflater.inflate(R.layout.gift_view_layout, container, false);
        if(savedInstanceState != null){
            fund_id = savedInstanceState.getInt(ARG_FUND_ID);
        }
        else if(args != null){
            updateView(args.getInt(ARG_FUND_ID));
        }
        else if(fund_id != -1){
            updateView(fund_id);
        }
        return v;
    }

    public void updateView(int fund_id){
        TextView name = (TextView)v.findViewById(R.id.title);
        TextView desc = (TextView)v.findViewById(R.id.date);
        TextView clas = (TextView)v.findViewById(R.id.giftamount);
        TextView annotation = (TextView)v.findViewById(R.id.summary);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
        Fund f = db.getFund(fund_id);

        name.setText("Name: " + f.getName());
        desc.setText("Desc: " + f.getFund_desc());
        clas.setText("Class: " + f.getFund_class());
        annotation.setText("Annotation: " + f.getAnnotation());

        this.fund_id = fund_id;
    }
}
