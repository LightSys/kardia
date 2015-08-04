package org.lightsys.donorapp;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by bosonBaas on 3/12/2015.
 *
 * This is an Adapter modeled off of Simple adapter. It's purpose is to enable the interaction
 * of the program with the buttons inside the ListView for Prayer Requests. The PrayButton
 * is not yet implemented in the database, yet the API should simplify that process. It is implemented
 * for UI.
 */
public class PrayerAdapter extends SimpleAdapter {

    Context context;
    final ArrayList<HashMap<String, String>> data;
    final ArrayList<Boolean> prayedForData;
    ArrayList<View> views;
    String[] from;
    int[] to;

    public PrayerAdapter(Context context, ArrayList<HashMap<String,String>> data,
            ArrayList<Boolean> prayData, int resource, String[] from, int[] to) {
        super(context, data, resource, from, to);
        this.context = context;
        this.views = new ArrayList<View>();
        this.data = data;
        this.prayedForData = prayData;
        this.from = from;
        this.to = to;
    }

    /**
     *
     * @param position - position in ListView
     * @param convertView - view to use and convert to a new View
     * @param parent - Parent of the adapter
     * @return - Formatted, inflated view
     */
    public View getView(final int position, View convertView, ViewGroup parent) {
        PrayerLayout rowView = (PrayerLayout)convertView;
        if(rowView == null) {
            rowView = new PrayerLayout(this.context);
        }

        final Map<String, String> pieces = data.get(position);
        rowView.setTitle(pieces.get("prayerSubject"));
        rowView.setDate(pieces.get("prayerDate"));
        rowView.setMissionaryNameView(pieces.get("prayerMissionary"));

        if(prayedForData.get(position)){
            rowView.setImage(R.drawable.new_praying_hands);
        } else {
            rowView.setImage(R.drawable.inactive_praying_hands);
        }

        views.add(rowView);

        return rowView;
    }
}
