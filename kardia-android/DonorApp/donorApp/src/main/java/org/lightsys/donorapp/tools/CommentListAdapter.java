package org.lightsys.donorapp.tools;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Judah on 6/20/2016.
 */
public class CommentListAdapter extends SimpleAdapter {

    Context context;
    final ArrayList<HashMap<String, String>> data;
    ArrayList<View> views;
    String[] from;
    int[] to;

    public CommentListAdapter(Context context, ArrayList<HashMap<String, String>> data,
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
        CommentListLayout rowView = (CommentListLayout)convertView;
        if(rowView == null) {
            rowView = new CommentListLayout(this.context);
        }

        final Map<String, String> pieces = data.get(position);
        Log.i("commentListAdapter", pieces.get("UserName") + " : " + position);
        if (pieces.get("UserName") != null) {
            Formatter formatter = new Formatter();
            rowView.setUserName(pieces.get("UserName"));
            rowView.setDateText(formatter.getFormattedDate(pieces.get("Date")));
            rowView.setCommentText(pieces.get("Text"));

            Log.i("commentListAdapter", "this thing might be working");

            views.add(rowView);
        }

        return rowView;
    }

}
