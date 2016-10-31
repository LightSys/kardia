package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.SimpleAdapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Judah Sistrunk
 * created on 6/20/2016.
 *
 * this class sets a list of comments to a custom ListView
 */
public class CommentListAdapter extends SimpleAdapter {

    private final Context         context;
    private final ArrayList<HashMap<String, String>> data;

    public CommentListAdapter(Context context, ArrayList<HashMap<String, String>> data,
                              String[] from, int[] to) {
        super(context, data, org.lightsys.missionaryapp.R.layout.comment_item, from, to);
        this.context = context;
        this.data    = data;
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

        Formatter formatter = new Formatter();
        rowView.setUserName(pieces.get("UserName"));
        rowView.setDateText(Formatter.getFormattedDate(pieces.get("Date")));
        rowView.setCommentText(pieces.get("Text"));

        return rowView;
    }

}
