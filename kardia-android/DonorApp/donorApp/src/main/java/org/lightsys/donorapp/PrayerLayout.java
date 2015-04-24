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
 * parts that make up the ListView. It contains a Subject, a Date, and
 *  a button for Prayer Response
 */
public class PrayerLayout extends RelativeLayout {
    TextView titleView;
    TextView dateView;
    PrayButton prayButton;

    int id;

    public PrayerLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.prayer_request_listview_item, this, true);
        titleView = (TextView)findViewById(R.id.title);
        dateView = (TextView)findViewById(R.id.date);
        prayButton = (PrayButton)findViewById(R.id.prayingButton);
    }

    public void setTitle(String title) {
        titleView.setText(title);
    }

    public void setDate(String date) {
        dateView.setText(date);
    }

    public void setImage(int id) {
        prayButton.setBackground(getResources().getDrawable(id));
    }

    public void setPrayerId(int id) {
        this.id = id;
        prayButton.setPrayerId(id);
    }
    public void setPrayers(int prayers) {
        prayButton.setText("" + prayers);
    }
}
