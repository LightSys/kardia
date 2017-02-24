package org.lightsys.missionaryapp.views;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.UpdateNotification;
import org.lightsys.missionaryapp.tools.CommentListAdapter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Locale;

import static android.content.ContentValues.TAG;

/**
 * @author Judah Sistrunk
 * created on 5/25/2016

 * Class that governs the settings menu for how often the app auto-refreshes
 * */

public class Settings extends Fragment{

    private final String EXTRA_DELETE = "delete";

    private Spinner giftPeriods, refreshPeriods;
    private ToggleButton    reminderOnOff, ssCertOnOff;
    private TextView        reminderDetails;
    private LocalDBHandler  db;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.settings_layout, container, false);
        getActivity().setTitle("Settings");

        refreshPeriods = (Spinner) v.findViewById(R.id.refreshPeriodsSpinner);
        giftPeriods = (Spinner) v.findViewById(R.id.giftPeriodsSpinner);
        reminderOnOff = (ToggleButton) v.findViewById(R.id.reminderOnOffSwitch);
        reminderDetails = (TextView) v.findViewById(R.id.reminderDetailsText);
        ssCertOnOff = (ToggleButton) v.findViewById(R.id.SSCOnOffSwitch);
        db = new LocalDBHandler(v.getContext());

        reminderOnOff.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (reminderOnOff.isChecked()) {
                    Intent reminder = new Intent(getActivity(), NotificationActivity.class);
                    startActivity(reminder);

                } else {
                    reminderDetails.setText("");
                    Intent reminder = new Intent(getActivity(), NotificationActivity.class);
                    reminder.putExtra(EXTRA_DELETE, true);
                    startActivity(reminder);
                }
            }
        });

        ssCertOnOff.setChecked((db.getAccount().getAcceptSSCert()==1)? true : false);
        Log.d(TAG, "onCreateView: " + db.getAccount().getAcceptSSCert());

        ssCertOnOff.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (ssCertOnOff.isChecked()) {
                    db.updateAcceptSSCert(1);

                } else {
                    db.updateAcceptSSCert(0);
                }
            }
        });

        refreshPeriods.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected (AdapterView<?> parent, View view, int position, long id){
                db.addRefreshPeriod(refreshPeriods.getSelectedItem().toString());
            }
            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                //do nothing
            }

        });

        giftPeriods.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
            @Override
            public void onItemSelected (AdapterView<?> parent, View view, int position, long id){
                db.addGiftPeriod(giftPeriods.getSelectedItem().toString());
            }
            @Override
            public void onNothingSelected(AdapterView<?> arg0) {
                //do nothing
            }

        });


        String refresh = db.getRefreshPeriod();
        String period = db.getGiftPeriod();
        db.close();
        String[] updatePeriods = getResources().getStringArray(R.array.refresh_times);
        String[] allGiftPeriods = getResources().getStringArray(R.array.gift_periods);

        for (int i = 0; i < updatePeriods.length; i++) {
            if (updatePeriods[i].equals(refresh)) {
                refreshPeriods.setSelection(i);
            }
        }
        for (int i = 0; i < allGiftPeriods.length; i++) {
            if (allGiftPeriods[i].equals(period)) {
                giftPeriods.setSelection(i);
            }
        }

        setAlarmInfo();

        return v;
    }

    private void setAlarmInfo(){
        ArrayList<UpdateNotification> notifications = db.getNotifications();
        Log.d(TAG, "setAlarmInfo: " + notifications.size());

        if(notifications.size()>0){
            reminderOnOff.setChecked(true);
            SimpleDateFormat format = new SimpleDateFormat("MM-dd-yy", Locale.US);
            //SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm", Locale.US);
            reminderDetails.setText(notifications.get(0).getFrequency() + "\nuntil " + format.format(notifications.get(notifications.size()-1).getTime()));
            //reminderDetails.setText(notifications.get(0).getFrequency() + "\nNext: " + format.format(notifications.get(0).getTime()));
        }else{
            reminderOnOff.setChecked(false);
            reminderDetails.setText("");
        }
    }
    public void onResume(){
        super.onResume();
        setAlarmInfo();
    }

}
