package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;


import org.lightsys.missionaryapp.R;

/**
 * @author bosonBaas
 * created on 3/12/2015.
 *
 * Layout based on note_listview_item.xml the
 * parts that make up the ListView. It contains a Subject, a Date, the name of the missionary,
 * and a button for Prayer Response
 */
public class NoteListLayout extends RelativeLayout {
    private final TextView titleView, dateView, contentView   , aboveTextView, belowTextView;
    private final Button   prayButton;

    public NoteListLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.note_listview_item, this, true);
        titleView     = (TextView) findViewById(R.id.subjectText);
        dateView      = (TextView) findViewById(R.id.dateText);
        contentView   = (TextView) findViewById(R.id.contentText);
        aboveTextView = (TextView) findViewById(R.id.textAbovePrayingButton);
        belowTextView = (TextView) findViewById(R.id.textBelowPrayingButton);
        prayButton    = (Button)   findViewById(R.id.prayingButton);
    }

    public void setTitle(String title) {
        titleView.setText(title);
    }

    public void setDate(String date) {
        dateView.setText(date);
    }

    public void setContentView(String noteContent) {
        contentView   .setText(noteContent);
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

    public void setImageMargin(int bottom){
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        params.setMargins(0,0,0,bottom);
        prayButton.setLayoutParams(params);
    }

}