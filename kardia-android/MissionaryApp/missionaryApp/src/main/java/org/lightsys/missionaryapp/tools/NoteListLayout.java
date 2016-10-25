package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

/**
 * Created by bosonBaas on 3/12/2015.
 *
 * Layout based on note_listview_item.xml the
 * parts that make up the ListView. It contains a Subject, a Date, the name of the missionary,
 * and a button for Prayer Response
 */
public class NoteListLayout extends RelativeLayout {
    private final TextView titleView, dateView, missionaryNameView, aboveTextView, belowTextView;
    private final Button prayButton;

    public NoteListLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.note_listview_item, this, true);
        titleView = (TextView) findViewById(R.id.nameText);
        dateView = (TextView) findViewById(R.id.dateText);
        missionaryNameView = (TextView) findViewById(R.id.missionaryName);
        aboveTextView = (TextView) findViewById(R.id.textAbovePrayingButton);
        belowTextView = (TextView) findViewById(R.id.textBelowPrayingButton);
        prayButton = (Button) findViewById(R.id.prayingButton);
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

    public void setTextAboveButton(String aboveText) {
        aboveTextView.setText(aboveText);
    }

    public void setTextBelowButton(String belowText) {
        belowTextView.setText(belowText);
    }

    public void setImage(int id) {
        prayButton.setBackground(getResources().getDrawable(id));
    }

}