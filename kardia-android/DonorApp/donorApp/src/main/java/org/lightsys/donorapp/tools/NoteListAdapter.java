package org.lightsys.donorapp.tools;

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
 * of the program with the buttons inside the ListView for Prayer Requests.
 */
public class NoteListAdapter extends SimpleAdapter {

    Context context;
    final ArrayList<HashMap<String, String>> data;
    ArrayList<View> views;
    String[] from;
    int[] to;

    public NoteListAdapter(Context context, ArrayList<HashMap<String, String>> data,
                            int resource, String[] from, int[] to) {
        super(context, data, resource, from, to);
        this.context = context;
        this.views = new ArrayList<View>();
        this.data = data;
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
        NoteListLayout rowView = (NoteListLayout)convertView;
        if(rowView == null) {
            rowView = new NoteListLayout(this.context);
        }

        final Map<String, String> pieces = data.get(position);
        rowView.setTitle(pieces.get("subject"));
        rowView.setDate(pieces.get("date"));
        rowView.setMissionaryNameView(pieces.get("missionary"));
        rowView.setTextAboveButton(pieces.get("textAbove"));
        rowView.setTextBelowButton(pieces.get("textBelow"));


        // Set the icon to the right depending on what type the row is
        // Four possibilities are inactive prayer, active prayer, update, or prayer letter
        if (pieces.get("type").equals("Pray")) {
            if(pieces.get("isPrayedFor").equals("inactive")){
                rowView.setImage(R.drawable.inactive_praying_hands_icon);
            } else {
                rowView.setImage(R.drawable.active_praying_hands_icon);
            }
        } else if (pieces.get("type").equals("Update")) {
            rowView.setImage(R.drawable.update_icon);
        } else if (pieces.get("type").equals("Letter")) {
            rowView.setImage(R.drawable.prayer_letter_icon);
        }


        views.add(rowView);

        return rowView;
    }
}
