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

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Message;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;

/**
 * @author JoshWorkman
 * created on 3/12/2015.
 *
 * Allows the user to send a message to a donor
 * TODO: the message needs sent to the API to be put into Kardia
 */
public class ContactDonorActivity extends Activity{

    private String   donorName;
    private int      donorId;
    private Spinner  sender, contactType;
    private EditText messageText, subject;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.missionary_contact_form_layout);

        Bundle args = getIntent().getExtras();
        donorName   = args.getString("donorname");
        donorId     = args.getInt("donorid");

        sender        = (Spinner) findViewById(R.id.senderName);
        subject       = (EditText)findViewById(R.id.subjectText);
        contactType   = (Spinner) findViewById(R.id.typeSpinner);
        messageText   = (EditText)findViewById(R.id.message);
        Button submit = (Button)  findViewById(R.id.submitButton);
        Button cancel = (Button)  findViewById(R.id.cancelButton);

        if (getActionBar() != null) {
            getActionBar().setTitle("Contact " + donorName);
        }

        // Load list of partner names from accounts for user to choose who message is from
        LocalDBHandler db = new LocalDBHandler(this, null);
        ArrayList<String> partnerNames = new ArrayList<String>();
        for (Account a : db.getAccounts()) {
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

                String senderStr  = sender.getSelectedItem().toString();
                String messageStr = messageText.getText().toString();
                String subjectStr = subject.getText().toString();

                // If any field is blank, prompt user to fill the field
                if (messageStr.equals("")) {
                    Toast.makeText(ContactDonorActivity.this,
                            "You have not entered a message!", Toast.LENGTH_SHORT).show();
                } else if (senderStr.equals("")) {
                    Toast.makeText(ContactDonorActivity.this,
                            "Please indicate who the message is from", Toast.LENGTH_SHORT).show();
                } else if (subjectStr.equals("")) {
                    Toast.makeText(ContactDonorActivity.this,
                            "Please set a subject for this message", Toast.LENGTH_SHORT).show();
                } else {
                    // Create message from fields and data passed from DonorList
                    Message message = new Message();
                    message.setSender(senderStr);
                    message.setText(messageStr);
                    message.setSubject(subjectStr);
                    message.setMissionaryId(donorId);
                    message.setMissionaryName(donorName);
                    switch (contactType.getSelectedItemPosition()) {
                        case 0:
                            message.setType(Message.MessageType.Update);
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
                    Toast.makeText(ContactDonorActivity.this,
                            "Message not sent; function not implemented.", Toast.LENGTH_SHORT).show();
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
        new AlertDialog.Builder(ContactDonorActivity.this)
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
