package org.lightsys.missionaryapp.views;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.UpdateNotification;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Class that governs the options menu for how often the app auto-refreshes
 * Created by Judah Sistrunk on 5/25/2016
 */

public class Options extends Fragment {

    Button applyButton, reminderDate;
    Spinner refreshPeriods, giftPeriods, reminderFrequency;
    ToggleButton reminderOnOff;
    TextView reminderDetails;

    LocalDBHandler db;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.options_layout, container, false);
        getActivity().setTitle("Options");

        applyButton = (Button) v.findViewById(R.id.apply_button);
        refreshPeriods = (Spinner) v.findViewById(R.id.refresh_periods_spinner);
        giftPeriods = (Spinner) v.findViewById(R.id.gift_periods_spinner);
        reminderOnOff = (ToggleButton) v.findViewById(R.id.reminder_on_off_switch);
        reminderDetails = (TextView) v.findViewById(R.id.reminder_details_text);


        reminderOnOff.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){
                if(reminderOnOff.isChecked()) {
                    Intent reminder = new Intent(getActivity(), UpdateNotificationActivity.class);
                    startActivity(reminder);

                }else{
                    //todo cancelreminder
                    reminderDetails.setText("");
                }
            }
        });

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

        for (int i = 0; i < updatePeriods.length; i++) {
            if (updatePeriods[i].equals(refresh)) {
                refreshPeriods.setSelection(i);
            }
        }
        for (int i = 0; i < allgiftPeriods.length; i++) {
            if (allgiftPeriods[i].equals(period)) {
                giftPeriods.setSelection(i);
            }
        }
        ArrayList<UpdateNotification> notifications = db.getNotifications();
        if(notifications.size()>0){
            reminderOnOff.setChecked(true);
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US);
            reminderDetails.setText("Next Reminder \n" + format.format(notifications.get(0).getNotificationTime()));
        }else{
            reminderOnOff.setChecked(false);
            reminderDetails.setText("");
        }

        return v;
    }

    //functions to get a database and accounts
    //for the purpose of refreshing the app
    public  LocalDBHandler setDb(LocalDBHandler db) {
        return  db;
    }

}
