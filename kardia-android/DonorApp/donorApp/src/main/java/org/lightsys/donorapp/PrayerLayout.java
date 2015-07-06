package org.lightsys.donorapp;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.donorapp.R;

import org.lightsys.donorapp.customview.PrayButton;

/**
 * Created by bosonBaas on 3/12/2015.
 *
 * Layout based on prayer_request_listview_item.xml. It is the
 * parts that make up the ListView. It contains a Subject, a Date, the name of the missionary,
 * and a button for Prayer Response
 */
public class PrayerLayout extends RelativeLayout {
    TextView titleView, dateView, missionaryNameView;
    PrayButton prayButton;

    public PrayerLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.prayer_request_listview_item, this, true);
        titleView = (TextView)findViewById(R.id.subject);
        dateView = (TextView)findViewById(R.id.date);
        missionaryNameView = (TextView)findViewById(R.id.missionaryName);
        prayButton = (PrayButton)findViewById(R.id.prayingButton);
    }

    public void setTitle(String title) {
        titleView.setText(title);
    }

    public void setDate(String date) {
        dateView.setText(date);
    }

    public void setMissionaryNameView(String missionaryName) {
        missionaryNameView.setText(missionaryName);
    }

    public void setImage(int id) {
        prayButton.setBackground(getResources().getDrawable(id));
    }
}
