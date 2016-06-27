package org.lightsys.donorapp.views;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Comment;
import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.tools.CommentListAdapter;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by bosonBaas on 3/10/2015.
 * Displays detailed view of update object, opened from updateList
 */
public class DetailedUpdate extends Fragment {

    final static String ARG_UPDATE_ID = "update_id";
    int update_id = -1;

    ArrayList<HashMap<String, String>> commentList = new ArrayList<HashMap<String, String>>();

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.update_detailedview_layout, container, false);
        getActivity().setTitle("Update");

        return v;
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateUpdateView(args.getInt(ARG_UPDATE_ID));
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
        TextView subject = (TextView)getActivity().findViewById(R.id.subject);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView text = (TextView)getActivity().findViewById(R.id.text);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        Note update = db.getNoteForID(update_id);
        db.close();

        missionaryName.setText(update.getMissionaryName());
        subject.setText("Subject: " + update.getSubject());
        date.setText("Date Posted: " + Formatter.getFormattedDate(update.getDate()));
        text.setText(update.getText());

        this.update_id = update_id;

        loadComments();

        String[] from = {"userName", "date", "text"};
        int[] to = {R.id.userName,  R.id.date, R.id.text};
        if (commentList != null){
            CommentListAdapter adapter = new CommentListAdapter(getActivity(), commentList, R.layout.comment_layout, from, to);

            ListView listview = (ListView)getActivity().findViewById(R.id.commentsList);
            listview.setAdapter(adapter);

        }

    }

    private void loadComments() {
        commentList.clear();
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        ArrayList<Comment> comments = db.getComments();

        for (Comment comment : comments){
            HashMap<String, String> hm = new HashMap<String, String>();
            Log.i("DetailedUpdate", comment.getNoteID() + " : " + update_id + " : " + comment.getNoteType());
            if (comment.getNoteID() == update_id && comment.getNoteType().equals("Update")){
                Log.i("DetailedUpdate", comment.getCommentID() + " : " + comment.getNoteID());
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
