package org.lightsys.donorapp.views;

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

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Message;
import org.lightsys.donorapp.tools.LocalDBHandler;

import java.util.ArrayList;

/**
 * Created by JoshWorkman on 3/12/2015.
 *
 * Allows the user to send a message to a missionary
 * TODO: the message needs sent to the API to be put into Kardia
 */
public class ContactMissionaryActivity extends Activity{

    private String missionaryName;
    private int missionaryId;
    private Spinner sender, contactType;
    private EditText messageText, subject;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.missionary_contact_form_layout);

        Bundle args = getIntent().getExtras();
        missionaryName = args.getString("missionaryname");
        missionaryId = args.getInt("missionaryid");

        sender = (Spinner)findViewById(R.id.senderName);
        subject = (EditText)findViewById(R.id.subjectText);
        contactType = (Spinner)findViewById(R.id.typeSpinner);
        messageText = (EditText)findViewById(R.id.message);
        Button submit = (Button)findViewById(R.id.submitButton);
        Button cancel = (Button)findViewById(R.id.cancelButton);

        if (getActionBar() != null) {
            getActionBar().setTitle("Contact " + missionaryName);
        }

        // Load list of partner names from accounts for user to choose who message is from
        LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
        ArrayList<String> partnerNames = new ArrayList<String>();
        for (Account a : db.getAccounts()) {
            String aPartnerName = a.getPartnerName();
            if (aPartnerName != null) {
                partnerNames.add(aPartnerName);
            }
        }
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
                R.layout.support_simple_spinner_dropdown_item, partnerNames);
        adapter.setDropDownViewResource( android.R.layout.simple_spinner_dropdown_item);
        sender.setAdapter(adapter);


        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String senderStr = sender.getSelectedItem().toString();
                String messageStr = messageText.getText().toString();
                String subjectStr = subject.getText().toString();

                // If any field is blank, prompt user to fill the field
                if (messageStr.equals("")) {
                    Toast.makeText(ContactMissionaryActivity.this,
                            "You have not entered a message!", Toast.LENGTH_SHORT).show();
                } else if (senderStr.equals("")) {
                    Toast.makeText(ContactMissionaryActivity.this,
                            "Please indicate who the message is from", Toast.LENGTH_SHORT).show();
                } else if (subjectStr.equals("")) {
                    Toast.makeText(ContactMissionaryActivity.this,
                            "Please set a subject for this message", Toast.LENGTH_SHORT).show();
                } else {
                    // Create message from fields and data passed from MissionaryList
                    Message message = new Message();
                    message.setSender(senderStr);
                    message.setText(messageStr);
                    message.setSubject(subjectStr);
                    message.setMissionaryId(missionaryId);
                    message.setMissionaryName(missionaryName);
                    switch (contactType.getSelectedItemPosition()) {
                        case 0:
                            message.setType(Message.MessageType.Encouragement);
                            break;
                        case 1:
                            message.setType(Message.MessageType.Prayer);
                            break;
                        case 2:
                            message.setType(Message.MessageType.Praise);
                            break;
                        default:
                            message.setType(Message.MessageType.Other);
                    }
                    // Send message object to API connection to insert into Kardia
                    // Will need AsyncTask to connect to API
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
        new AlertDialog.Builder(ContactMissionaryActivity.this)
                .setCancelable(false)
                .setTitle("Cancel")
                .setMessage("Exit without sending message?")
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
