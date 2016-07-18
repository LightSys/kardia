package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.json.JSONObject;
import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.PostJson;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar;

import javax.net.ssl.HttpsURLConnection;

/**
 * Created by lauradeotte on 7/12/16.
 *
 * allows user to post updates or prayer requests
 */
public class PostNoteActivity extends Activity {
//todo ASK JUDAH TO HELP POST TO API
    private Spinner sender, contactType;
    private EditText noteText, subject;
    int noteId = -1;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.post_note_layout);

        sender = (Spinner)findViewById(R.id.senderName);
        subject = (EditText)findViewById(R.id.subjectText);
        contactType = (Spinner)findViewById(R.id.typeSpinner);
        noteText = (EditText)findViewById(R.id.noteText);
        Button submit = (Button)findViewById(R.id.submitButton);
        Button cancel = (Button)findViewById(R.id.cancelButton);

        if (getActionBar() != null) {
            getActionBar().setTitle("Send Update/Prayer Request");
        }

        // Load list of user names from accounts for user to choose who message is from
        final LocalDBHandler db = new LocalDBHandler(this, null);
        ArrayList<String> partnerNames = new ArrayList<String>();
        ArrayList<Account> accts = db.getAccounts();
        for (Account a : accts) {
            String aPartnerName = a.getPartnerName();
            if (aPartnerName != null) {
                partnerNames.add(aPartnerName);
            }
        }
        // If no partner names are found, put "Unknown" as the sender, this should be rare
        // The sender can then identify themselves in the message
        if (partnerNames.isEmpty()) {
            partnerNames.add("Unknown");
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                R.layout.support_simple_spinner_dropdown_item, partnerNames);
        adapter.setDropDownViewResource( android.R.layout.simple_spinner_dropdown_item);
        sender.setAdapter(adapter);


        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {


                String senderStr = sender.getSelectedItem().toString();
                String messageStr = noteText.getText().toString();
                String subjectStr = subject.getText().toString();
                Account account = null;

                //find account
                ArrayList<Account> accts = db.getAccounts();
                for (Account a : accts) {
                    if (a.getPartnerName().equals(senderStr)){
                        account = a;
                    }
                }

                // If any field is blank, prompt user to fill the field
                if (messageStr.equals("")) {
                    Toast.makeText(PostNoteActivity.this,
                            "You have not entered a message!", Toast.LENGTH_SHORT).show();
                } else if (senderStr.equals("")) {
                    Toast.makeText(PostNoteActivity.this,
                            "Please indicate who the message is from", Toast.LENGTH_SHORT).show();
                } else if (subjectStr.equals("")) {
                    Toast.makeText(PostNoteActivity.this,
                            "Please set a subject for this message", Toast.LENGTH_SHORT).show();
                } else {
                    //submit stuffs
                    try {
                        //post update
                        String postURL = "http://" + account.getServerName() + ":800/apps/kardia/api/missionary/" + account.getId() + "/Notes?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection";

                        JSONObject newNote = new JSONObject();
                        JSONObject dateCreated = new JSONObject();

                        //set date for note
                        Calendar calendar = Calendar.getInstance();
                        dateCreated.put("year", calendar.get(Calendar.YEAR));
                        dateCreated.put("month", calendar.get(Calendar.MONTH) + 1);
                        dateCreated.put("day", calendar.get(Calendar.DAY_OF_MONTH));
                        dateCreated.put("hour", calendar.get(Calendar.HOUR_OF_DAY));
                        dateCreated.put("minute", calendar.get(Calendar.MINUTE));
                        dateCreated.put("second", calendar.get(Calendar.SECOND));
                        Log.d("POSTNOTEACTIVITY: ", dateCreated.toString());

                        // Create PrayerRequest
                        Note note = new Note();
                        note.setSubject(subjectStr);
                        note.setNoteText(messageStr);
                        note.setNumberPrayed(0);
                        switch (contactType.getSelectedItemPosition()) {
                            case 0:
                                note.setType("Update");
                                break;
                            case 1:
                                note.setType("Pray");
                                break;
                        /*case 2:
                            note.setType((Note.MessageType.Praise);
                            break;*/
                            default:
                                note.setType("Update");
                        }

                        //set newNote
                        newNote.put("e_object_type", "e_contact_history");
                        newNote.put("e_object_id", noteId + "");
                        newNote.put("e_ack_type", 3);
                        newNote.put("e_ack_comments", note);
                        newNote.put("e_whom", account.getId() + "");
                        newNote.put("p_dn_partner_key", getIntent().getIntExtra("missionaryId", -1) + "");
                        newNote.put("s_date_created", dateCreated);
                        newNote.put("s_date_modified", dateCreated);
                        newNote.put("s_created_by", account.getAccountName() + "");
                        newNote.put("s_modified_by", account.getAccountName() + "");

                        PostJson postJson = new PostJson(getBaseContext(), postURL, newNote, account);
                        postJson.execute();
                    } catch(Exception e){e.printStackTrace();}

                    //refresh the screen after post
                    //this probably won't work because separate threads and what not
                    for (Account a : accts){
                        new DataConnection(getBaseContext(), null, a);
                    }

                    finish();
                }
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Ask user to confirm leaving page without sending message
                showCancelConfirmation();
            }
        });
    }

    @Override
    public void onBackPressed() {
        // Ask user to confirm leaving page without sending message
        showCancelConfirmation();
    }

    private void showCancelConfirmation() {
        new AlertDialog.Builder(PostNoteActivity.this)
                .setCancelable(false)
                .setTitle("Cancel")
                .setMessage("Exit without posting update?")
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        finish();
                    }
                })
                .setNegativeButton("No", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                    }
                })
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
    }
}