package org.lightsys.donorapp;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

import org.lightsys.donorapp.customview.PrayButton;
import org.lightsys.donorapp.data.Account;

import java.util.ArrayList;
import java.util.List;
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
    final List<? extends Map<String,?>> data;
    ArrayList<View> views;
    int resource;
    String[] from;
    int[] to;
    Account user;

    public PrayerAdapter(Context context, List<? extends Map<String,?>> data, int resource, String[] from, int[] to, Account user) {
        super(context, data, resource, from, to);
        this.views = new ArrayList<View>();
        this.context = context;
        this.data = data;
        this.resource = resource;
        this.from = from;
        this.to = to;
        this.user = user;
    }

    /**
     *
     * @param position - position in ListView
     * @param convertView - view to use and convert to a new View
     * @param parent - Parent of the adapter
     * @return - Formatted, inflated view
     */
    public View getView(int position, View convertView, ViewGroup parent) {
//        ArrayList<HashMap<String, String>> info = (ArrayList<HashMap<String, String>>) data;
        PrayerLayout rowView = (PrayerLayout)convertView;
        if(rowView == null) {
            rowView = new PrayerLayout(this.context);
        }

        final Map<String, ?> pieces = data.get(position);
        rowView.setTitle((String)pieces.get("prayerName"));
        rowView.setDate((String) pieces.get("prayerDate"));
        rowView.setPrayerId((Integer) pieces.get("prayerId"));

        user.addPrayedForRequest("" + ((PrayButton)rowView.findViewById(R.id.prayingButton)).getPrayerId());

        if((Boolean)user.isRequestPrayedFor("" + ((PrayButton)rowView.findViewById(R.id.prayingButton)).getPrayerId())){
            rowView.setImage(R.drawable.praying_hands);
            rowView.setPrayers(user.getTimesPrayed("" + ((PrayButton)rowView.findViewById(R.id.prayingButton)).getPrayerId()));
        } else {
            rowView.setImage(R.drawable.inactive_praying_hands);
        }

        views.add(rowView);

        rowView.findViewById(R.id.prayingButton).setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                System.out.println(((PrayButton)v).getPrayerId());
                if(user.isRequestPrayedFor("" + ((PrayButton)v).getPrayerId())){
                } else {
                    user.PrayForRequest("" + ((PrayButton)v).getPrayerId());
                    ((PrayButton)v).setBackground(v.getResources().getDrawable(R.drawable.praying_hands));
                }
                ((PrayButton)v).setText("" + user.getTimesPrayed("" + ((PrayButton) v).getPrayerId()));
            }
        });
        return rowView;
    }

    public View getExistingView(int position){
        return views.get(position);
    }
//
//    private void setPrayerStatus(int position, boolean status){
//        data.get(position).
//    }
}
