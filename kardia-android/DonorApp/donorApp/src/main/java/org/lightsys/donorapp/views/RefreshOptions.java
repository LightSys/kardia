package org.lightsys.donorapp.views;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewStub;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.tools.AutoUpdater;
import org.lightsys.donorapp.tools.DataConnection;
import org.lightsys.donorapp.tools.LocalDBHandler;

import java.util.ArrayList;

/**
 * Class that governs the options menu for how often the app auto-refreshes
 * Created by Judah Sistrunk on 5/25/2016
 */

public class RefreshOptions extends Fragment {

    Button applyButton;
    Spinner refreshPeriods;

    LocalDBHandler db;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.refresh_options_layout, container, false);

        getActivity().setTitle("Refresh Options");

        applyButton = (Button)v.findViewById(R.id.applyButton);
        refreshPeriods = (Spinner)v.findViewById(R.id.refreshPeriods);

        applyButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LocalDBHandler db = new LocalDBHandler(v.getContext(), null);
                db.addRefresh_Period(refreshPeriods.getSelectedItem().toString());
                Toast.makeText(v.getContext(), "Changes Applied", Toast.LENGTH_SHORT).show();
            }
        });

        LocalDBHandler db = new LocalDBHandler(v.getContext(), null);
        String refresh = db.getRefreshPeriod();
        db.close();
        String[] updatePeriods = getResources().getStringArray(R.array.refresh_times);
        int index = 0;

        for (int i = 0; i < updatePeriods.length; i++){
            if (updatePeriods[i].equals(refresh)){
                index = i;
                i = updatePeriods.length + 1;
            }
            else {
                index = 0;
            }
        }

        refreshPeriods.setSelection(index);

        return v;
    }


    //functions to get a database and accounts
    //for the purpose of refreshing the app
    public  LocalDBHandler setDb(LocalDBHandler db) {
        return  db;
    }

}
