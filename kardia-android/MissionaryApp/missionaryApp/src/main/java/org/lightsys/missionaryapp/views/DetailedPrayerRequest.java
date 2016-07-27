package org.lightsys.missionaryapp.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.tools.CommentListAdapter;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by JoshWorkman on 3/10/2015.
 * This activity displays the expanded form of a prayerRequest
 * Primarily displays Subject, Date submitted, and request text
 * It also includes a button that opens a menu to set reminders to pray for the request
 *
 * edited by Judah Sistrunk summer 2016
 * added functionality to view and post comments on an item
 */
public class DetailedPrayerRequest extends Fragment{

    final static String ARG_REQUEST_ID = "request_id";
    int request_id = -1, isswitched=0;
    private Button prayerButton;
    private TextView supporterlist, textBelow;
    private Note request;
    Button commentButton;
    String nameslist="no one is currently praying for this request";
    final String TAG = "DETAILED PRAYER REQUEST";

    ArrayList<HashMap<String, String>> commentList = new ArrayList<HashMap<String, String>>();//list of comments for this item

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.prayer_request_detailedview, container, false);
        getActivity().setTitle("Prayer Request");

        commentButton = (Button)v.findViewById(R.id.commentButton);

        commentButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent startCommentActivity = new Intent(getActivity(), CommentActivity.class);
                Note note = new LocalDBHandler(getActivity().getBaseContext(), null).getNoteForID(request_id);
                //stuff that the comment page needs to know
                startCommentActivity.putExtra("text", note.getNoteText());
                startCommentActivity.putExtra("noteId", request_id);
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
        else if(request_id != -1){
            updateRequestView(request_id);
        }
    }

    /**
     * Sets the text fields with the detailed information about the prayer request
     * @param request_id, Request Identification
     */

    public void updateRequestView(final int request_id){
        final LocalDBHandler db = new LocalDBHandler(getActivity(), null);

        TextView missionaryName = (TextView)getActivity().findViewById(R.id.missionaryName);
        TextView subject = (TextView)getActivity().findViewById(R.id.name);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView text = (TextView)getActivity().findViewById(R.id.text);
        supporterlist = (TextView)getActivity().findViewById(R.id.supporterlist);
        textBelow = (TextView)getActivity().findViewById(R.id.textBelowPrayingButton);
        prayerButton = (Button)getActivity().findViewById(R.id.scheduleNotification);

        request = db.getNoteForID(request_id);
        this.request_id = request_id;

        if (request.getNumberPrayed() > 0) {
            nameslist = "";
            ArrayList<PrayedFor> prayedforlist = db.getPrayedFor();
            for (int i = 0; i < prayedforlist.size();i++) {
                PrayedFor p = prayedforlist.get(i);
                if (!nameslist.contains(p.getSupporterName())) {
                    if (i != 0) {
                        nameslist = nameslist + ", ";
                    }
                    nameslist = nameslist + p.getSupporterName();
                }
            }
        }
        supporterlist.setText(nameslist);

        missionaryName.setText(request.getMissionaryName());
        subject.setText("Subject: " + request.getSubject());
        date.setText("Date Posted: " + Formatter.getFormattedDate(request.getDate()));
        text.setText(request.getNoteText());

        final int numPrayed = request.getNumberPrayed();
        if (numPrayed>0) {
            prayerButton.setBackground(getResources().getDrawable(R.drawable.active_praying_hands_icon));
            textBelow.setText(numPrayed + " Praying");
        } else {
            textBelow.setText(numPrayed + " Praying");
            prayerButton.setBackground(getResources().getDrawable(R.drawable.inactive_praying_hands_icon));
        }



        //displays the usernames of supporters who are praying for request
        //allows user to turn list of supporters on or off
        prayerButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isswitched == 0) {
                    isswitched = 1;
                    if (numPrayed>0){
                        supporterlist.setVisibility(View.VISIBLE);
                    } else {
                        supporterlist.setVisibility(View.VISIBLE);
                    }

                } else{
                    isswitched=0;
                    supporterlist.setVisibility(View.INVISIBLE);
                }
            }
        });

        //gets list of comments
        loadComments();

        String[] from = {"userName", "date", "text"};//stuff for the adapter
        int[] to = {R.id.userName,  R.id.date, R.id.text};//more stuffs for the adapter
        if (commentList != null){
            //if haz comments, set comments to adapter
            CommentListAdapter adapter = new CommentListAdapter(getActivity(), commentList, R.layout.comment_item, from, to);

            ListView listview = (ListView)getActivity().findViewById(R.id.commentsList);
            listview.setAdapter(adapter);

        }

    }

    //loads a list of comments on the item
    private void loadComments() {
        commentList.clear();
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        ArrayList<Comment> comments = db.getComments();
        comments = sortByDate(comments);

        for (Comment comment : comments){
            HashMap<String, String> hm = new HashMap<String, String>();
            if (comment.getNoteID() == request_id){
                hm.put("UserName", comment.getUserName());
                hm.put("Date", comment.getDate());
                hm.put("Text", comment.getComment());
                commentList.add(hm);
            }
        }
    }

    //sorts comments by date so that newest ones are first
    private ArrayList<Comment> sortByDate(ArrayList<Comment> comments) {

        Comment highestComment = null;//this will hold the highest comment for each pass

        ArrayList<Comment> sortedComments = new ArrayList<Comment>();
        while (comments.size() > 0){
            int[] highestDate = {0, 0, 0};//start low because we are looking for dates larger
            for (Comment c : comments) {
                int[] date = parseStringDate(c.getDate());
                if (date[0] > highestDate[0]) { //if the year is bigger the date is newer
                    highestDate = date;
                    highestComment = c;
                }
                else if (date[0] == highestDate[0]){//if the years are the same look at the month
                    if (date[1] > highestDate[1]){//if the month in bigger the date is newer
                        highestDate = date;
                        highestComment = c;
                    }
                    else if (date[1] == highestDate[1]){//if the months are the same look at the days
                        if (date[2] >= highestDate[2]){//if the day is bigger the date is newer
                            highestDate = date;
                            highestComment = c;
                        }
                    }
                }

            }
            sortedComments.add(highestComment);//add newest comment to list
            comments.remove(highestComment);//get rid of newest comment in old list as to not cause confusion
        }

        return sortedComments;//return sorted list of comments
    }

    private int[] parseStringDate(String date) {
        int[] dateInt = new int[3];
        String[] dateSplitStr = date.split("-");
        for (int i = 0; i < 3; i++) {
            dateInt[i] = Integer.parseInt(dateSplitStr[i]);
        }
        return dateInt;
    }


    /**
     * Updates prayer request to signify it is being prayed for
     */
    private void updateDbToPrayedFor() {
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        request = db.getNoteForID(request_id);
        db.updateNote(request_id, request.getNumberPrayed());
        db.close();
    }

    /**
     * Called when returning from notification activity
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        updateDbToPrayedFor();
    }

    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_REQUEST_ID, request_id);
    }
}
