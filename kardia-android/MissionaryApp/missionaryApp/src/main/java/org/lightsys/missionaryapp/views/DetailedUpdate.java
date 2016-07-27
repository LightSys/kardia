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
import org.lightsys.missionaryapp.tools.CommentListAdapter;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by bosonBaas on 3/10/2015.
 * Displays detailed view of update object, opened from updateList
 *
 * edited by Judah Sistrunk summer 2016
 * added functionality to view and post comments on an item
 */
public class DetailedUpdate extends Fragment {

    final static String ARG_UPDATE_ID = "update_id";
    int update_id = -1;
    Button commentButton;

    //keeps a list of all comments on this post
    ArrayList<HashMap<String, String>> commentList = new ArrayList<HashMap<String, String>>();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.update_detailedview_layout, container, false);
        getActivity().setTitle("Update");

        commentButton = (Button)v.findViewById(R.id.commentButton);

        return v;
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateUpdateView(args.getInt(ARG_UPDATE_ID));

            commentButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent startCommentActivity = new Intent(getActivity(), CommentActivity.class);
                    Note note = new LocalDBHandler(getActivity().getBaseContext(), null).getNoteForID(update_id);
                    //stuff that the comment page needs to know
                    startCommentActivity.putExtra("text", note.getNoteText());
                    startCommentActivity.putExtra("noteId", update_id);
                    startCommentActivity.putExtra("noteType", "Update");
                    startCommentActivity.putExtra("missionaryId", note.getMissionaryID());

                    getActivity().startActivity(startCommentActivity);
                }
            });

        }
        else if(update_id != -1){
            updateUpdateView(update_id);
        }
    }

    /**
     * This function sets the text for the updates's information
     *
     * @param update_id, the update's id.
     */
    public void updateUpdateView(int update_id){

        TextView missionaryName = (TextView)getActivity().findViewById(R.id.missionaryName);
        TextView subject = (TextView)getActivity().findViewById(R.id.name);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView text = (TextView)getActivity().findViewById(R.id.text);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        Note update = db.getNoteForID(update_id);
        db.close();

        missionaryName.setText(update.getMissionaryName());
        subject.setText("Subject: " + update.getSubject());
        date.setText("Date Posted: " + Formatter.getFormattedDate(update.getDate()));
        text.setText(update.getNoteText());

        this.update_id = update_id;

        loadComments();//gets list of comments

        String[] from = {"userName", "date", "text"};//stuff for the adapter
        int[] to = {R.id.userName,  R.id.date, R.id.text};//more stuff for the adapter
        if (commentList != null){
            //if we have comments, set them to the adapter
            CommentListAdapter adapter = new CommentListAdapter(getActivity(), commentList, R.layout.comment_item, from, to);

            ListView listview = (ListView)getActivity().findViewById(R.id.commentsList);
            listview.setAdapter(adapter);

        }

    }

    //loads a list of comments on the post
    private void loadComments() {
        commentList.clear();
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        ArrayList<Comment> comments = db.getComments();
        comments = sortByDate(comments);//sort comments so that newest ones are first

        for (Comment comment : comments){
            HashMap<String, String> hm = new HashMap<String, String>();

            if (comment.getNoteID() == update_id){
                hm.put("UserName", comment.getUserName());
                hm.put("Date", comment.getDate());
                hm.put("Text", comment.getComment());
                commentList.add(hm);
            }

        }
    }

    //sorts comments by date
    //puts newest comments first
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
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_UPDATE_ID, update_id);
    }
}
