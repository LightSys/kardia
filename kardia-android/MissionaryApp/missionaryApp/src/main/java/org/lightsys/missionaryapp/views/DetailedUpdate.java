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
 * @author bosonBaas
 * created on 3/10/2015.
 *
 * edited by Judah Sistrunk summer 2016
 * added functionality to view and post comments on an item
 *
 * Displays detailed view of update object, opened from updateList
 *
 */
public class DetailedUpdate extends Fragment {

    final static String ARG_UPDATE_ID = "update_id";
    private int         update_id     = -1;
    private Button      commentButton;

    //keeps a list of all comments on this post
    private final ArrayList<HashMap<String, String>> commentList = new ArrayList<HashMap<String, String>>();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.note_detailed_layout, container, false);
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
                    Note note = new LocalDBHandler(getActivity().getBaseContext()).getNoteForID(update_id);
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
    private void updateUpdateView(int update_id){

        TextView missionaryName = (TextView)getActivity().findViewById(R.id.subjectText);
        TextView subject        = (TextView)getActivity().findViewById(R.id.contentText);
        TextView date           = (TextView)getActivity().findViewById(R.id.dateText);
        TextView text           = (TextView)getActivity().findViewById(R.id.noteText);

        LocalDBHandler db = new LocalDBHandler(getActivity());
        Note update = db.getNoteForID(update_id);
        db.close();

        missionaryName.setText(update.getMissionaryName());
        subject.setText(update.getSubject());
        date.setText(Formatter.getFormattedDate(update.getDate()));
        text.setText(update.getNoteText());

        this.update_id = update_id;

        loadComments();//gets list of comments

        String[] from = {"userName", "date", "text"};//stuff for the adapter
        int[] to = {R.id.userName,  R.id.dateText, R.id.noteText};//more stuff for the adapter
        if (!commentList.isEmpty()){
            //if we have comments, set them to the adapter
            CommentListAdapter adapter = new CommentListAdapter(getActivity(), commentList, from, to);

            ListView listview = (ListView)getActivity().findViewById(R.id.commentsList);
            listview.setAdapter(adapter);

        }

    }

    //loads a list of comments on the post
    private void loadComments() {
        commentList.clear();
        LocalDBHandler db = new LocalDBHandler(getActivity());
        ArrayList<Comment> comments = db.getComments();

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
