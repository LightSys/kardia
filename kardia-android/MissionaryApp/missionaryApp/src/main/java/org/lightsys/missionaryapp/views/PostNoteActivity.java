package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import org.json.JSONObject;
import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.PostJson;

import java.util.ArrayList;
import java.util.Calendar;

/**
 * @author otter57
 * created on 7/12/16.
 *
 * allows user to post updates or prayer requests
 */
public class PostNoteActivity extends Activity {
    private Spinner  sender, contactType;
    private EditText noteText, subject;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.post_note_layout);

        sender        = (Spinner) findViewById(R.id.senderName);
        subject       = (EditText)findViewById(R.id.userNameText);
        contactType   = (Spinner) findViewById(R.id.typeSpinner);
        noteText      = (EditText)findViewById(R.id.noteText);
        Button submit = (Button)  findViewById(R.id.submitButton);
        Button cancel = (Button)  findViewById(R.id.cancelButton);

        if (getActionBar() != null) {
            getActionBar().setTitle("Send Update/Prayer Request");
        }

        // Load list of user names from accounts for user to choose who message is from
        final LocalDBHandler db = new LocalDBHandler(this);
        ArrayList<String> partnerNames = new ArrayList<String>();
        Account account = db.getAccount();

        String aPartnerName = account.getPartnerName();
        if (aPartnerName != null) {
            partnerNames.add(aPartnerName);
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


                String senderStr  = sender.getSelectedItem().toString();
                String messageStr = noteText.getText().toString();
                String subjectStr = subject.getText().toString();
                String noteType   = contactType.getSelectedItem().toString();
                Account account;

                //find account
                account = db.getAccount();

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

                        //set newNote
                        newNote.put("p_partner_key",account.getId()+"");
                        newNote.put("e_whom",account.getId()+"");
                        newNote.put("e_subject",subjectStr);
                        newNote.put("e_contact_date",dateCreated);
                        newNote.put("e_notes",messageStr);
                        newNote.put("s_date_created",dateCreated);
                        newNote.put("s_created_by",account.getAccountName() + "");
                        newNote.put("s_date_modified",dateCreated);
                        newNote.put("s_modified_by",account.getAccountName() + "");
                        if (noteType.equals("Update")) {
                            newNote.put("e_contact_history_type", 7);
                        }else if (noteType.equals("Pray")){
                            newNote.put("e_contact_history_type",5);
                        }

                        PostJson postJson = new PostJson(getBaseContext(), postURL, newNote, account);
                        postJson.execute();

                    } catch(Exception e){e.printStackTrace();}

                    //refresh the screen after post
                    //this probably won't work because separate threads and what not
                    new DataConnection(getBaseContext(), null, account);

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