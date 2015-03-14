package org.lightsys.donorapp;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Update;

/**
 * Created by bosonBaas on 3/10/2015.
 * Displays detailed view of update object, opened from updateList
 */
public class DetailedUpdate extends Fragment {

    final static String ARG_REQUEST_ID = "request_id";
    int request_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        return inflater.inflate(R.layout.update_detailedview_layout, container, false);
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateUpdateView(args.getInt(ARG_REQUEST_ID));
        }
        else if(request_id != -1){
            updateUpdateView(request_id);
        }
    }

    /**
     * This function sets the text for the gift's information
     *
     * @param id, the gift's id.
     */
    public void updateUpdateView(int request_id){
        TextView title = (TextView)getActivity().findViewById(R.id.title);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        //   TextView amount = (TextView)getActivity().findViewById(R.id.giftamount);
        TextView summary = (TextView)getActivity().findViewById(R.id.summary);

//        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
//        Gift g = db.getGift(request_id);
        Update update = null;
        for(Update u:UpdateList.getUpdates())
            if(u.getIntId() == request_id)
            {
                update = u;
                break;
            }
         if(update!=null) {
             title.setText(update.getSubject());
             date.setText("Date: " + update.formatedDate(update.getDate()));
             summary.setText("Update: " + update.getText());
         }
        this.request_id = request_id;
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
