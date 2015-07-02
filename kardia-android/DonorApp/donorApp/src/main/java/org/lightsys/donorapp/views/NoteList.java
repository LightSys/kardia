package org.lightsys.donorapp.views;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.data.PrayerLetter;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;
import org.lightsys.donorapp.tools.NoteListAdapter;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Class displays a list of notes (updates and prayer requests) to the user
 *
 * Created by Andrew Lockridge on 6/24/2015.
 */
public class NoteList extends Fragment{

    private ArrayList<Object> combined = new ArrayList<Object>();
    private ArrayList<HashMap<String,String>> itemList = new ArrayList<HashMap<String, String>>();


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main, container, false);

        getActivity().setTitle("Prayer Requests/Updates");

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        combined.clear();
        ArrayList<Note> notes = db.getNotes();
        ArrayList<PrayerLetter> letters = db.getPrayerLetters();
        db.close();

        // Combine sorted arrays of notes and letters into one array of sorted by date items
        while (!notes.isEmpty() || !letters.isEmpty()) {
            // If one is empty, simply add the rest from the other
            if (notes.isEmpty()) {
                while(!letters.isEmpty()) {
                    combined.add(letters.get(0));
                    letters.remove(0);
                }
            } else if (letters.isEmpty()) {
                while(!notes.isEmpty()) {
                    combined.add(notes.get(0));
                    notes.remove(0);
                }
            // If both still contain items, compare dates and add the more recent
            } else {
                if(isNoteDateMoreRecent(notes.get(0), letters.get(0))) {
                    combined.add(notes.get(0));
                    notes.remove(0);
                } else {
                    combined.add(letters.get(0));
                    letters.remove(0);
                }
            }
        }

        // Map data fields to layout fields
        itemList.clear();
        generateListItems();
        String[] from = {"subject", "date", "missionary", "textAbove", "textBelow"};
        int[] to = {R.id.subject,  R.id.date, R.id.missionaryName, R.id.textAbovePrayingButton, R.id.textBelowPrayingButton};

        NoteListAdapter adapter = new NoteListAdapter(getActivity(), itemList,
                R.layout.note_listview_item, from, to);

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onNoteClicked());

        return v;
    }

    private class onNoteClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            // Send to detailed view depending on what type the list object was
            Bundle args = new Bundle();
            if (combined.get(position).getClass() == Note.class) {
                Note n = (Note) combined.get(position);
                if (n.getType().equals("Pray")) {
                    args.putInt(DetailedPrayerRequest.ARG_REQUEST_ID, n.getId());
                    DetailedPrayerRequest newFrag = new DetailedPrayerRequest();
                    newFrag.setArguments(args);
                    FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                    transaction.replace(R.id.content_frame, newFrag);
                    transaction.addToBackStack("ToDetailedRequestView");
                    transaction.commit();
                } else if (n.getType().equals("Update")) {
                    args.putInt(DetailedUpdate.ARG_UPDATE_ID, n.getId());
                    DetailedUpdate newFrag = new DetailedUpdate();
                    newFrag.setArguments(args);
                    FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                    transaction.replace(R.id.content_frame, newFrag);
                    transaction.addToBackStack("ToDetailedUpdateView");
                    transaction.commit();
                }
            } else {
                PrayerLetter p = (PrayerLetter) combined.get(position);
                args.putInt(DetailedPrayerLetter.ARG_LETTER_ID, p.getId());
                DetailedPrayerLetter newFrag = new DetailedPrayerLetter();
                newFrag.setArguments(args);
                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.content_frame, newFrag);
                transaction.addToBackStack("ToDetailedLetterView");
                transaction.commit();

            }

        }
    }

    private void generateListItems(){

        boolean nIsPrayedFor;
        for(Object obj : combined){
            HashMap<String,String> hm = new HashMap<String,String>();
            if (obj.getClass() == Note.class) {
                Note n = (Note) obj;
                nIsPrayedFor = n.getIsPrayedFor();

                hm.put("date", Formatter.getFormattedDate(n.getDate()));
                hm.put("subject", n.getSubject());
                hm.put("missionary", n.getMissionaryName());
                hm.put("type", n.getType());
                if (n.getType().equals("Pray")) {
                    hm.put("textBelow", "Praying");
                    if (!nIsPrayedFor) {
                        hm.put("textAbove", "Not");
                        hm.put("isPrayedFor", "inactive");
                    } else {
                        hm.put("isPrayedFor", "active");
                    }
                }
            } else {
                PrayerLetter p = (PrayerLetter) obj;
                hm.put("date", Formatter.getFormattedDate(p.getDate()));
                hm.put("subject", p.getTitle());
                hm.put("missionary", p.getMissionaryName());
                hm.put("type", "Letter");
            }
            itemList.add(hm);
        }
    }

    /**
     * Compares a note and prayer letter to see which is more recent
     * Dates must be "YYYY-MM-DD" format
     * @param n, note to be compared
     * @param p, prayer letter to be compared
     * @return true if note is more recent, false if prayer letter is more recent
     */
    private boolean isNoteDateMoreRecent(Note n, PrayerLetter p) {
        int[] noteDate = parseStringDate(n.getDate());
        int[] letterDate = parseStringDate(p.getDate());
        for (int i = 0; i < 3; i++) {
            if (noteDate[i] > letterDate[i]) {
                return true;
            } else if (noteDate[i] < letterDate[i]) {
                return false;
            }
        }
        // Only reaches this point if it is the same date, so notes take precedent over letters
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
