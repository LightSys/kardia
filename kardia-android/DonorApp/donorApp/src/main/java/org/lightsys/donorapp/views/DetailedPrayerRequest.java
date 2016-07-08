package org.lightsys.donorapp.views;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;

import org.json.JSONObject;
import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Comment;
import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.tools.CommentListAdapter;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;
import org.lightsys.donorapp.tools.PostJson;

import java.util.ArrayList;
import java.util.Calendar;
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
    int request_id = -1;
    private Button prayerReminder;
    private TextView instr, textAbove;
    private Note request;
    Button commentButton;

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
                startCommentActivity.putExtra("text", note.getText());
                startCommentActivity.putExtra("noteId", request_id);
                startCommentActivity.putExtra("noteType", "Update");
                startCommentActivity.putExtra("missionaryId", note.getMissionaryID());
                Log.e("Detailed Update", note.getMissionaryID() + "");

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
        TextView subject = (TextView)getActivity().findViewById(R.id.subject);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView text = (TextView)getActivity().findViewById(R.id.text);
        textAbove = (TextView)getActivity().findViewById(R.id.textAbovePrayingButton);
        instr = (TextView)getActivity().findViewById(R.id.prayButtonInstr);
        prayerReminder = (Button)getActivity().findViewById(R.id.scheduleNotification);

        request = db.getNoteForID(request_id);
        this.request_id = request_id;

        missionaryName.setText(request.getMissionaryName());
        subject.setText("Subject: " + request.getSubject());
        date.setText("Date Posted: " + Formatter.getFormattedDate(request.getDate()));
        text.setText(request.getText());

        if (request.getIsPrayedFor()) {
            prayerReminder.setBackground(getResources().getDrawable(R.drawable.active_praying_hands_icon));
        } else {
            textAbove.setText("Not Yet");
            instr.setText("Press this button to signify you will be praying/giving thanks for this item");
            prayerReminder.setBackground(getResources().getDrawable(R.drawable.inactive_praying_hands_icon));
        }


        prayerReminder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Does not allow user to launch notification activity a second time
                if (request.getIsPrayedFor()) {
                    Toast.makeText(getActivity(), "You are already praying for this item!",
                            Toast.LENGTH_SHORT).show();
                } else {
                    // Ask user if they would like notifications
                    new AlertDialog.Builder(getActivity())
                            .setCancelable(false)
                            .setTitle("Set Notifications")
                            .setMessage("Would you like to set notifications to remind you to" +
                                    " pray/give thanks for this item?")
                            .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // Launch notification activity
                                    Intent notification = new Intent(getActivity(), PrayerNotificationActivity.class);
                                    notification.putExtra("requestid", request_id);
                                    startActivityForResult(notification, 0);
                                }
                            })
                            .setNegativeButton("No", new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int which) {
                                            // return, but still set button to prayed for
                                            updateDbToPrayedFor();
                                            textAbove.setText("");
                                            instr.setText("");
                                            prayerReminder.setBackground(getResources().getDrawable(R.drawable.active_praying_hands_icon));
                                        }
                                    }
                            )
                                        .

                                setIcon(android.R.drawable.ic_dialog_alert)

                                .

                                show();

                    //send information to server
                    try {

                        JSONObject jsonObject = new JSONObject();
                        JSONObject dateCreated = new JSONObject();

                        Account account = db.getAccounts().get(0);

                        //set date info
                        Calendar calendar = Calendar.getInstance();
                        dateCreated.put("year", calendar.get(Calendar.YEAR));
                        dateCreated.put("month", calendar.get(Calendar.MONTH) + 1);
                        dateCreated.put("day", calendar.get(Calendar.DAY_OF_MONTH));
                        dateCreated.put("hour", calendar.get(Calendar.HOUR_OF_DAY));
                        dateCreated.put("minute", calendar.get(Calendar.MINUTE));
                        dateCreated.put("second", calendar.get(Calendar.SECOND));

                        jsonObject.put("e_object_type", "e_contact_history");
                        jsonObject.put("e_object_id", request.getId() + "");
                        jsonObject.put("e_ack_type", 1);
                        jsonObject.put("e_whom", account.getId() + "");
                        jsonObject.put("p_dn_partner_key",request.getMissionaryID() + "");
                        jsonObject.put("s_created_by", account.getAccountName());
                        jsonObject.put("s_modified_by", account.getAccountName());
                        jsonObject.put("s_date_created", dateCreated);
                        jsonObject.put("s_date_modified", dateCreated);

                        String url = "http://" + account.getServerName() + ":800/apps/kardia/api/supporter/" + account.getId() + "/Prayers?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";

                        PostJson postJson = new PostJson(getActivity().getBaseContext(), url, jsonObject, account);
                        postJson.execute();

                        } catch (Exception e) {
                            e.printStackTrace();
                        }

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
        db.updateNote(request_id, true);
        request = db.getNoteForID(request_id);
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
