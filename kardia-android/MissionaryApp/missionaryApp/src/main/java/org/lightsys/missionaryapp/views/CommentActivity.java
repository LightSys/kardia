package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

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
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

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
                    PostComment postComment = new PostComment(account, new Comment(-1, userID, noteId, account.getAccountName(), getIntent().getStringExtra("noteType"), null, comment));
                    postComment.execute();

                    //refresh the screen after post
                    //this probably won't work because separate threads and what not
                     for (Account a : accts){
                         new DataConnection(getBaseContext(), null, a);
                    }

                    finish();
                }

            }
        });

    }

    //This private class does all the networking stuff
    //This is because you can't network in the main thread
    //a simple warning could have saved hours of headaches
    private class PostComment extends AsyncTask<String, Void, String>{

        private static final String TAG = "post JSon";

        private Account account;
        private Comment comment;

        public PostComment(Account userAccount, Comment newComment){
            account = userAccount;
            comment = newComment;
        }


        //this is where the magic happens
        @Override
        protected String doInBackground(String... params) {

            //the get request for the access token is done in httpClient
            //the post request for the comment was done in httpUrlConnection
            //it was discovered that httpClient is deprecated so the second part used httpUrlConnection
            //this needs to be fixed eventually

                    InputStream inputStream;
                    String result;
                    try {
                        // Set the user credentials to allow access to API information
                        CredentialsProvider credProvider = new BasicCredentialsProvider();

                        credProvider.setCredentials(new AuthScope(account.getServerName(), 800),
                                new UsernamePasswordCredentials(account.getAccountName(), account.getAccountPassword()));

                        //url used to retrieve the access token
                        String url = "http://" + account.getServerName() + ":800/?cx__mode=appinit&cx__groupname=Kardia&cx__appname=Donor";

                        //set up http connection
                        HttpParams HttpParams = new BasicHttpParams();
                        HttpConnectionParams.setConnectionTimeout(HttpParams, 10000);
                        HttpConnectionParams.setSoTimeout(HttpParams, 10000);

                        DefaultHttpClient client = new DefaultHttpClient(HttpParams);

                        client.setCredentialsProvider(credProvider);

                        HttpResponse response = client.execute(new HttpGet(url));

                        inputStream = response.getEntity().getContent();

                        //get access token
                        if (inputStream != null) {
                            result = convertInputStreamToString(inputStream);
                            JSONObject token = new JSONObject(result);

                            //store cookies for use later by the httpUrlConnection
                            org.apache.http.client.CookieStore cookies = client.getCookieStore();


                            //post comment
                            String postURL = "http://" + account.getServerName() + ":800/apps/kardia/api/crm/Partners/" + missionaryId + "/ContactHistory/" + comment.getNoteID() + "/Comments?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection&cx__akey=" + token.getString("akey");
                            performPostCall(cookies, postURL, comment, account);


                        }
                    } catch (Exception e) {e.printStackTrace();}

            return null;
        }

        private String convertInputStreamToString(InputStream in) throws IOException {
            BufferedReader reader = new BufferedReader(new InputStreamReader(in));
            String line, result = "";

            while ((line = reader.readLine()) != null) {
                result += line;
            }
            in.close();
            return result;
        }

        /*
            Class that posts a comment to the server
        */
        public String performPostCall(org.apache.http.client.CookieStore cookies, String requestURL, Comment comment, Account account) {

            URL url;
            String response = "";
            try {

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

                //set newComment to comment
                newComment.put("e_object_type", "e_contact_history");
                newComment.put("e_object_id", comment.getNoteID() + "");
                newComment.put("e_ack_type", 3);
                newComment.put("e_ack_comments", comment.getComment());
                newComment.put("e_whom", account.getId() + "");
                newComment.put("p_dn_partner_key", getIntent().getIntExtra("missionaryId", -1) + "");
                newComment.put("s_date_created",dateCreated);
                newComment.put("s_date_modified", dateCreated);
                newComment.put("s_created_by", account.getAccountName() + "");
                newComment.put("s_modified_by", account.getAccountName() + "");

                url = new URL(requestURL);

                //credentials
                String auth = account.getAccountName() + ":" + account.getAccountPassword();

                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setReadTimeout(15000);//15 second time out
                conn.setConnectTimeout(15000);
                conn.setRequestMethod("POST");//this is a post
                conn.setDoInput(true);
                conn.setDoOutput(true);

                //set creds and cookies
                conn.setRequestProperty("Authorization", "Basic " +
                        Base64.encodeToString(auth.getBytes(), Base64.NO_WRAP));
                conn.setRequestProperty("Cookie", "CXID=" + cookies.getCookies().get(0).getValue() + "; path=/");
                conn.setRequestProperty("Content-Type", "application/json");

                JSONObject root = newComment;
                //get json object ready to send
                String str = root.toString();
                byte[] outputBytes = str.getBytes("UTF-8");
                OutputStream os = conn.getOutputStream();
                os.write(outputBytes);//send json object

                int responseCode = conn.getResponseCode();

                Log.e(TAG, "responseCode : " + responseCode);

                //if the things was sent properly, get the response code
                if (responseCode == HttpsURLConnection.HTTP_CREATED) {
                    Log.e(TAG, "HTTP_OK");


                    String line;
                    BufferedReader br = new BufferedReader(new InputStreamReader(
                            conn.getInputStream()));
                    while ((line = br.readLine()) != null) {
                        response += line;
                    }
                } else {
                    Log.e(TAG, "False - HTTP_OK");//send failed
                    response = "";
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            return response;
        }

        //unfinished attempt to switch usage of http client to url connection
        public JSONObject getAccessToken(HttpURLConnection connection, String tokenUrl, Account account){

            String response = "";

            try {

                URL url = new URL(tokenUrl);
                connection = (HttpURLConnection) url.openConnection();

                String auth = account.getAccountName() + ":" + account.getAccountPassword();


                connection.setReadTimeout(15000);//15 second time out
                connection.setConnectTimeout(15000);
                connection.setRequestMethod("GET");
                connection.setDoInput(true);
                connection.setDoOutput(true);
                connection.setRequestProperty("Authorization", "Basic " +
                        Base64.encodeToString(auth.getBytes(), Base64.NO_WRAP));
                connection.setRequestProperty("Content-Type", "application/json");

                InputStream is = connection.getInputStream();
                is.read();

                int responseCode = connection.getResponseCode();

                Log.e(TAG, "responseCode : " + responseCode);

                //if the things was sent properly, get the response code
                if (responseCode == HttpsURLConnection.HTTP_OK) {
                    Log.e(TAG, "HTTP_OK");
                    String line;
                    BufferedReader br = new BufferedReader(new InputStreamReader(
                            connection.getInputStream()));
                    while ((line = br.readLine()) != null) {
                        response += line;
                    }

                    JSONObject token = new JSONObject(response);


                } else {
                    Log.e(TAG, "False - HTTP_OK");//send failed
                    response = "";
                }

            }
            catch (Exception e){
                e.printStackTrace();
            }
            return new JSONObject();

        }

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
