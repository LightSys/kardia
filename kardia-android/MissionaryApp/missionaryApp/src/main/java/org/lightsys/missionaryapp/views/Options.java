package org.lightsys.missionaryapp.views;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.tools.LocalDBHandler;

/**
 * Class that governs the options menu for how often the app auto-refreshes
 * Created by Judah Sistrunk on 5/25/2016
 */

public class Options extends Fragment {

    Button applyButton;
    Spinner refreshPeriods, giftPeriods;

    LocalDBHandler db;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.refresh_options_layout, container, false);

        getActivity().setTitle("Refresh Options");

        applyButton = (Button)v.findViewById(R.id.applyButton);
        refreshPeriods = (Spinner)v.findViewById(R.id.refreshPeriods);
        giftPeriods = (Spinner)v.findViewById(R.id.giftPeriods);

        applyButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LocalDBHandler db = new LocalDBHandler(v.getContext(), null);
                db.addRefresh_Period(refreshPeriods.getSelectedItem().toString());
                db.addGiftPeriod(giftPeriods.getSelectedItem().toString());

                Toast.makeText(v.getContext(), "Changes Applied", Toast.LENGTH_SHORT).show();
            }
        });

        LocalDBHandler db = new LocalDBHandler(v.getContext(), null);
        String refresh = db.getRefreshPeriod();
        String period = db.getGiftPeriod();
        db.close();
        String[] updatePeriods = getResources().getStringArray(R.array.refresh_times);
        String[] allgiftPeriods = getResources().getStringArray(R.array.gift_periods);

        for (int i = 0; i < updatePeriods.length; i++){
            if (updatePeriods[i].equals(refresh)){
                refreshPeriods.setSelection(i);
            }
        }
        for (int i = 0; i < allgiftPeriods.length; i++){
            if (allgiftPeriods[i].equals(period)){
                giftPeriods.setSelection(i);
            }
        }
        return v;
    }


    //functions to get a database and accounts
    //for the purpose of refreshing the app
    public  LocalDBHandler setDb(LocalDBHandler db) {
        return  db;
    }

}
