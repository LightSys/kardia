package org.lightsys.missionaryapp.views;


import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.tools.DownloadPDF;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.NoteListAdapter;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

import static android.content.ContentValues.TAG;

/**
 * @author Andrew Lockridge
 * created on 6/24/2015.
 *
 * Class displays a list of notes (updates and prayer requests) and prayer letters to the user
 */
public class NoteList extends Fragment {

    private final ArrayList<Object>                 combined = new ArrayList<Object>();
    private final ArrayList<HashMap<String,String>> itemList = new ArrayList<HashMap<String, String>>();

    private LinearLayout addLayout;
    private ImageButton addButton;



    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main_layout, container, false);

        getActivity().setTitle("Prayer Requests/Updates");

        addLayout = (LinearLayout)v.findViewById(R.id.addLayout);
        addButton = (ImageButton)v.findViewById(R.id.addButton);

        LocalDBHandler db = new LocalDBHandler(getActivity());
        combined.clear();
        int account_id = db.getAccount().getId();
        ArrayList<Note> notes = db.getNotesForMissionary(account_id);
        ArrayList<PrayerLetter>letters = db.getPrayerLetters();

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
        String[] from = {"subject", "date", "content", "textBelow"};
        int[] to = {R.id.subjectText,  R.id.dateText, R.id.contentText, R.id.textBelowPrayingButton};

        NoteListAdapter adapter = new NoteListAdapter(getActivity(), itemList,
                from, to);

        ListView listview = (ListView)v.findViewById(R.id.infoList);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onNoteClicked());

        //add note and add letter buttons
        addButton.setVisibility(View.VISIBLE);
        addButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(addLayout.getVisibility() == v.GONE) {
                    addLayout.setVisibility(View.VISIBLE);
                    addButton.setRotation(90);
                }
                else{
                   addLayout.setVisibility(View.GONE);
                   addButton.setRotation(-90);
                }

            }
        });

        Button letterButton = (Button)v.findViewById(R.id.addLetterButton);
        letterButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent createLetter = new Intent(getActivity(), PostLetterActivity.class);
                startActivity(createLetter);
            }
        });

        Button updateButton = (Button)v.findViewById(R.id.addUpdateButton);
        updateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent createNote = new Intent(getActivity(), PostNoteActivity.class);
                createNote.putExtra("note_type", "Update");
                startActivity(createNote);
            }
        });

        Button requestButton = (Button)v.findViewById(R.id.addRequestButton);
        requestButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent createNote = new Intent(getActivity(), PostNoteActivity.class);
                createNote.putExtra("note_type", "Prayer Request");
                startActivity(createNote);
            }
        });

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
                        args.putInt(DetailedPrayerRequest.ARG_REQUEST_ID, n.getNoteId());
                        DetailedPrayerRequest newFrag = new DetailedPrayerRequest();
                        newFrag.setArguments(args);
                        FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                        transaction.replace(R.id.contentFrame, newFrag, "DetailedPrayerRequest");
                        transaction.addToBackStack("ToDetailedRequestView");
                        transaction.commit();
                    } else if (n.getType().equals("Update")) {
                        args.putInt(DetailedUpdate.ARG_UPDATE_ID, n.getNoteId());
                        DetailedUpdate newFrag = new DetailedUpdate();
                        newFrag.setArguments(args);
                        FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                        transaction.replace(R.id.contentFrame, newFrag, "DetailedUpdateRequest");
                        transaction.addToBackStack("ToDetailedUpdateView");
                        transaction.commit();
                    }
                } else { // The selected item is a prayer letter
                    PrayerLetter letter = (PrayerLetter) combined.get(position);
                    LocalDBHandler db = new LocalDBHandler(getActivity());
                    Account account = db.getAccount();
                    db.close();

                    // Look through downloads to see if file has been downloaded
                    File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
                    boolean fileFoundInDownloads = false;
                    String[] downloads = path.list();
                    if (downloads != null && downloads.length != 0) {
                        for (String name : downloads) {
                            if (name.equals(letter.getFilename())) {
                                fileFoundInDownloads = true;
                            }
                        }
                    }
                    if (!fileFoundInDownloads) {
                        // Download file from API
                        String directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString();
                        String url = account.getProtocal() + "//" + account.getServerName() + ":" + account.getPort() + letter.getFolder() + "/" +
                                letter.getFilename();
                        DownloadPDF download = new DownloadPDF(url, account.getServerName(), account.getAccountName(),
                                account.getAccountPassword(), directory, letter.getFilename(), getActivity(),
                                getActivity());
                        download.execute("");
                    } else {
                        // Launch a PDF viewing application
                        try {
                            Intent pdfIntent = new Intent(Intent.ACTION_VIEW);
                            File file = new File(path, letter.getFilename());
                            pdfIntent.setDataAndType(Uri.fromFile(file), "application/pdf");
                            startActivity(pdfIntent);
                        } catch (ActivityNotFoundException e) {
                            // If no application is found on device, send a message to the user
                            Toast.makeText(getActivity(), "To view this document, you first must" +
                                    "install a PDF viewing application", Toast.LENGTH_LONG).show();
                            e.printStackTrace();
                        }

                    }
                }
        }
    }

    private void generateListItems(){

        int numPrayed;
        for(Object obj : combined){
            HashMap<String,String> hm = new HashMap<String,String>();
            if (obj.getClass() == Note.class) {
                Note n = (Note) obj;
                numPrayed = n.getNumberPrayed();
                Log.d(TAG, "generateListItems: " + n.getNoteText());
                hm.put("date", Formatter.getFormattedDate(n.getDate()));
                hm.put("subject", n.getSubject());
                hm.put("content", n.getNoteText());
                hm.put("type", n.getType());
                if (n.getType().equals("Pray")) {
                    hm.put("textBelow", "Praying");
                    if (numPrayed==0) {
                        hm.put("textBelow", "Request");
                        hm.put("isPrayedFor", "inactive");
                    } else {
                        hm.put("textBelow", Integer.toString(numPrayed) + "333\npraying");
                        hm.put("isPrayedFor", "active");
                    }
                }else if (n.getType().equals("Update")){
                    hm.put("textBelow","Update");
                }
            } else {
                PrayerLetter p = (PrayerLetter) obj;
                hm.put("date", Formatter.getFormattedDate(p.getDate()));
                hm.put("subject", p.getTitle());
                hm.put("content", "pdf update letter");
                hm.put("type", "Letter");
                hm.put("textBelow", "Letter");
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
