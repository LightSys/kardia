package org.lightsys.missionaryapp.views;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.NewItem;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import static android.content.ContentValues.TAG;

/**
 * @author otter57 on 6/11/2015.
 *
 * Home Page for Missionary app
 * welcomes user and displays page buttons
 */
public class HomePage extends Fragment {

    ArrayList<NewItem> newEvents = new ArrayList<NewItem>();
    LocalDBHandler db;

    @SuppressLint("SetTextI18n")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        db = new LocalDBHandler(getActivity());
        Account account = db.getAccount();
        db.close();

        View v = inflater.inflate(R.layout.home_page_layout, container, false);
        getActivity().setTitle("Home");

        TextView welcome = (TextView) v.findViewById(R.id.welcomeHeader);
        ListView events = (ListView) v.findViewById(R.id.eventList);

        //layout welcome header
        welcome.setText("Welcome\n" + account.getPartnerName() + "\n\n");

        //get all unseen events within the last week
        newEvents = db.getNewEvents();

        ArrayList<HashMap<String,String>> itemList = generateListItems();

        // display donor name, fund name, date, and amount for all gifts
        String[] from = {"header_text", "content", "date"};
        int[] to = {R.id.userName, R.id.noteText, R.id.dateText};
        final SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.comment_item, from, to );

        events.setAdapter(adapter);
        events.setOnItemClickListener(new onEventClicked());

        return v;
    }
    /**
     * Formats the gift information into a HashMap ArrayList.
     *
     * @return a HashMap array with gift information, to be used in a SimpleAdapter
     */
    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();

        for(NewItem event : newEvents){
            HashMap<String,String> hm = new HashMap<String,String>();
            hm.put("header_text", event.getHeader());
            hm.put("content", event.getContent());
            hm.put("date", event.getDate());
            aList.add(hm);
        }
        return aList;
    }

    /**
     * Loads the event that has been clicked
     */
    private class onEventClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            NewItem eventClicked = newEvents.get(position);
            if(eventClicked.getItemType().equals("Donor")){
                Donor object = db.getDonorById(eventClicked.getEventId());
                sendToDonor(object, eventClicked.getId());
            } else if (eventClicked.getItemType().equals("Gift")) {
                Gift object = db.getGift(eventClicked.getEventId());
                sendToGift(object, eventClicked.getId());
            } else if (eventClicked.getItemType().equals("Comment")) {
                Comment object = db.getCommentById(eventClicked.getEventId());
                sendToComment(object, eventClicked.getId());
            }
        }

        private void sendToDonor(Donor object, int id){
            db.deleteNewEvent(id);

            Bundle args = new Bundle();
            args.putString("donor_name", object.getName());
            args.putInt("donor_id", object.getId());
            args.putByteArray("donor_image", object.getImage());

            DetailedDonor newFrag = new DetailedDonor();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.contentFrame, newFrag, "DetailedDonor");
            transaction.addToBackStack("ToDetailedDonorView");
            transaction.commit();

        }
        private void sendToGift(Gift object, int id){

            db.deleteNewEvent(id);

            Bundle args = new Bundle();

            args.putInt(DetailedGift.ARG_GIFT_ID, object.getId());
            args.putInt(DetailedGift.ARG_DONOR_ID, object.getGiftDonorId());
            args.putString(DetailedGift.ARG_DONOR_NAME, object.getGiftDonor());

            DetailedGift newFrag = new DetailedGift();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.contentFrame, newFrag, "DetailedGift");
            transaction.addToBackStack("ToDetailedGiftView");
            transaction.commit();
        }

        private void sendToComment(Comment object, int id){
            db.deleteNewEvent(id);

            Note note = db.getNoteForID(object.getNoteID());

            Bundle args = new Bundle();

            if (note.getType().equals("Pray")) {
                args.putInt(DetailedPrayerRequest.ARG_REQUEST_ID, note.getNoteId());
                DetailedPrayerRequest newFrag = new DetailedPrayerRequest();
                newFrag.setArguments(args);
                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.contentFrame, newFrag, "DetailedPrayerRequest");
                transaction.addToBackStack("ToDetailedRequestView");
                transaction.commit();
            } else if (note.getType().equals("Update")) {
                args.putInt(DetailedUpdate.ARG_UPDATE_ID, note.getNoteId());
                DetailedUpdate newFrag = new DetailedUpdate();
                newFrag.setArguments(args);
                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.contentFrame, newFrag, "DetailedUpdateRequest");
                transaction.addToBackStack("ToDetailedUpdateView");
                transaction.commit();
            }
        }
    }
}
