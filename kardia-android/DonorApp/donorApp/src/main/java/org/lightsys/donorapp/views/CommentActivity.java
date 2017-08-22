package org.lightsys.donorapp.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;
import org.json.JSONObject;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.tools.LocalDBHandler;
import org.lightsys.donorapp.tools.PostJson;

import java.util.ArrayList;
import java.util.Calendar;


/**
 * Created by Judah on 6/27/2016.
 *
 * An activity that lets a user enter a comment to a post
 * The user must provide a comment and a user ID
 * The activity will send the comment to the server
 * The post that the user is commenting on will also be displayed
 */
public class CommentActivity extends Activity {


    TextView originalPostText;
    TextView commentText;
    TextView userIDText;
    Button submit;
    Button cancel;

    int userID = -1;
    int noteId = -1;
    int missionaryId = -1;
    String comment = "";

    //error message
    String MISSING_POST = "Original post missing!";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.post_comment_layout);


        originalPostText = (TextView)findViewById(R.id.originalPostText);
        commentText = (TextView)findViewById(R.id.commentText);
        userIDText = (TextView)findViewById(R.id.accountID);
        submit = (Button)findViewById(R.id.submitButton);
        cancel = (Button)findViewById(R.id.cancelButton);

        if (getIntent().getStringExtra("text") != null) {
            originalPostText.setText(getIntent().getStringExtra("text"));
        }
        else {
            originalPostText.setText(MISSING_POST);
        }
        missionaryId = getIntent().getIntExtra("missionaryId", -1);

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //ask if the user really wants to cancel
                showCancelConfirmation();
            }
        });

        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                //get stuff from edit texts
                noteId = getIntent().getIntExtra("noteId", -1);
                comment = commentText.getText().toString();
                if (!userIDText.getText().toString().equals("")) {
                    userID = Integer.parseInt(userIDText.getText().toString());
                }

                //find account
                LocalDBHandler db = new LocalDBHandler(getBaseContext(), null);
                ArrayList<Account> accts = db.getAccounts();
                Account account = null;
                for (Account acct : accts) {
                    if (acct.getId() == userID) {
                        account = acct;
                    }
                }

                //check to make sure proper information was given
                if (account == null) {
                    Toast.makeText(CommentActivity.this, "Account does not exist", Toast.LENGTH_SHORT).show();
                } else if (commentText.getText().equals("")) {
                    Toast.makeText(CommentActivity.this, "Please enter a comment", Toast.LENGTH_SHORT).show();
                } else {

                    //submit stuffs
                    try {
                        //post comment
                        String postURL = account.getProtocol() + "://" + account.getServerName() + ":" + account.getPortNumber() + "/apps/kardia/api/crm/Partners/" + missionaryId + "/ContactHistory/" + noteId + "/Comments?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection";

                        JSONObject newComment = new JSONObject();
                        JSONObject dateCreated = new JSONObject();

                        //set date info
                        Calendar calendar = Calendar.getInstance();
                        dateCreated.put("year", calendar.get(Calendar.YEAR));
                        dateCreated.put("month", calendar.get(Calendar.MONTH) + 1);
                        dateCreated.put("day", calendar.get(Calendar.DAY_OF_MONTH));
                        dateCreated.put("hour", calendar.get(Calendar.HOUR_OF_DAY));
                        dateCreated.put("minute", calendar.get(Calendar.MINUTE));
                        dateCreated.put("second", calendar.get(Calendar.SECOND));
                        Log.e("Comment Activity", dateCreated.toString());

                        //set newComment
                        newComment.put("e_object_type", "e_contact_history");
                        newComment.put("e_object_id", noteId + "");
                        newComment.put("e_ack_type", 3);
                        newComment.put("e_ack_comments", comment);
                        newComment.put("e_whom", account.getId() + "");
                        newComment.put("p_dn_partner_key", getIntent().getIntExtra("missionaryId", -1) + "");
                        newComment.put("s_date_created", dateCreated);
                        newComment.put("s_date_modified", dateCreated);
                        newComment.put("s_created_by", account.getAccountName() + "");
                        newComment.put("s_modified_by", account.getAccountName() + "");

                        PostJson postJson = new PostJson(getBaseContext(), postURL, newComment, account);
                        postJson.execute();

                    } catch (Exception e) {e.printStackTrace();}

                    finish();
                }
            }
        });
    }

    @Override
    public void onBackPressed() {
        // Ask user to confirm leaving page without sending comment
        showCancelConfirmation();
    }

    //function that ensures that users know they are leaving
    private void showCancelConfirmation() {
        new AlertDialog.Builder(CommentActivity.this)
                .setCancelable(false)
                .setTitle("Cancel")
                .setMessage("Exit without sending comment?")
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
