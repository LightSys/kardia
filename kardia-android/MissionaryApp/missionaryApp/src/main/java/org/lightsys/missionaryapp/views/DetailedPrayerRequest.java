package org.lightsys.missionaryapp.views;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.tools.CommentListAdapter;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

import static android.content.ContentValues.TAG;

/**
 * @author JoshWorkman
 * created on 3/10/2015.
 *
 *  * edited by Judah Sistrunk summer 2016
 * added functionality to view and post comments on an item
 *
 * This activity displays the expanded form of a prayerRequest
 * Primarily displays Subject, Date submitted, and request text
 *
 */
public class DetailedPrayerRequest extends Fragment{

    private final ArrayList<Object>                 combined = new ArrayList<Object>();
    final static String ARG_REQUEST_ID = "request_id";
    private int         requestId = -1, isSwitched = 0;
    private Note        request;

    private final ArrayList<HashMap<String, String>> itemList = new ArrayList<HashMap<String, String>>();//list of comments for this item

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.note_detailed_layout, container, false);
        getActivity().setTitle("Prayer Request");

        Button commentButton = (Button) v.findViewById(R.id.commentButton);

        commentButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent startCommentActivity = new Intent(getActivity(), CommentActivity.class);
                Note note = new LocalDBHandler(getActivity().getBaseContext()).getNoteForID(requestId);
                //stuff that the comment page needs to know
                startCommentActivity.putExtra("text", note.getNoteText());
                startCommentActivity.putExtra("noteId", requestId);
                startCommentActivity.putExtra("noteType", "Update");
                startCommentActivity.putExtra("missionaryId", note.getMissionaryID());

                getActivity().startActivity(startCommentActivity);
            }
        });

        return v;
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateRequestView(args.getInt(ARG_REQUEST_ID));
        }
        else if(requestId != -1){
            updateRequestView(requestId);
        }
    }

    /**
     * Sets the text fields with the detailed information about the prayer request
     * @param request_id, Request Identification
     */

    @SuppressLint("SetTextI18n")
    private void updateRequestView(final int request_id){
        final LocalDBHandler db = new LocalDBHandler(getActivity());

        TextView missionaryName   = (TextView)getActivity().findViewById(R.id.missionaryName);
        TextView subject          = (TextView)getActivity().findViewById(R.id.subjectText);
        TextView date             = (TextView)getActivity().findViewById(R.id.dateText);
        TextView text             = (TextView)getActivity().findViewById(R.id.noteText);

        request = db.getNoteForID(request_id);
        this.requestId = request_id;

        missionaryName.setText(request.getMissionaryName());
        subject.setText(request.getSubject());
        date.setText(Formatter.getFormattedDate(request.getDate()));
        text.setText(request.getNoteText());

        //gets list of comments
        ArrayList<PrayedFor> prayers = db.getPrayedFor();
        ArrayList<Comment> comments = db.getComments();
        combined.clear();
        while (!prayers.isEmpty() || !comments.isEmpty()) {
            // If one is empty, simply add the rest from the other
            if (comments.isEmpty()) {
                while(!prayers.isEmpty()) {
                    combined.add(prayers.get(0));
                    prayers.remove(0);
                }
            } else if (prayers.isEmpty()) {
                while(!comments.isEmpty()) {
                    combined.add(comments.get(0));
                    comments.remove(0);
                }
                // If both still contain items, compare dates and add the more recent
            } else {
                if(isCommentDateMoreRecent(comments.get(0), prayers.get(0))) {
                    combined.add(comments.get(0));
                    comments.remove(0);
                } else {
                    combined.add(prayers.get(0));
                    prayers.remove(0);
                }
            }
        }

        loadListItems();

        String[] from = {"userName", "date", "text"};//stuff for the adapter
        int[] to = {R.id.userName,  R.id.dateText, R.id.noteText};//more stuffs for the adapter
        if (!itemList.isEmpty()){
            //if haz comments, set comments to adapter
            CommentListAdapter adapter = new CommentListAdapter(getActivity(), itemList, from, to);

            ListView listview = (ListView)getActivity().findViewById(R.id.commentsList);
            listview.setAdapter(adapter);

        }

    }

    //loads a list of comments on the item
    private void loadListItems() {
        itemList.clear();
        for(Object obj : combined){
            HashMap<String,String> hm = new HashMap<String,String>();
            if (obj.getClass() == Comment.class) {
                Comment c = (Comment) obj;
                if (c.getNoteID() == requestId){
                    hm.put("UserName", c.getUserName());
                    hm.put("Date", c.getDate());
                    hm.put("Text", c.getComment());
                    itemList.add(hm);
                }

            } else {
                PrayedFor p = (PrayedFor) obj;
                if (p.getNoteID() == requestId){
                    hm.put("UserName", p.getSupporterName());
                    hm.put("Date", p.getPrayedForDate());
                    hm.put("Text", "PrayedForNotice");
                    itemList.add(hm);
                }
            }
        }
    }

    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_REQUEST_ID, requestId);
    }

    /**
     * Compares a note and prayer letter to see which is more recent
     * Dates must be "YYYY-MM-DD" format
     * @param c, comment to be compared
     * @param p, prayer to be compared
     * @return true if note is more recent, false if prayer letter is more recent
     */
    private boolean isCommentDateMoreRecent(Comment c, PrayedFor p) {
        int[] commentDate = parseStringDate(c.getDate());
        int[] prayerDate = parseStringDate(p.getPrayedForDate());
        for (int i = 0; i < 3; i++) {
            if (commentDate[i] > prayerDate[i]) {
                return true;
            } else if (commentDate[i] < prayerDate[i]) {
                return false;
            }
        }
        // Only reaches this point if it is the same date, so comments take precedent over prayers
        return true;
    }
    /**
     * Parses a "-" separated date into array of integers
     * @param date, date in String format separated by "-"
     * @return an array of integers representing the string passed
     */
    private int[] parseStringDate(String date) {
        int[] dateInt = new int[3];
        String[] dateSplitStr = date.split("-");
        for (int i = 0; i < 3; i++) {
            dateInt[i] = Integer.parseInt(dateSplitStr[i]);
        }
        return dateInt;
    }
}
