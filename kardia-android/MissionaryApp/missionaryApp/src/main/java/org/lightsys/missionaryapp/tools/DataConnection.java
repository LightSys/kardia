package org.lightsys.missionaryapp.tools;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.params.ConnManagerPNames;
import org.apache.http.conn.params.ConnPerRouteBean;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.protocol.RequestExpectContinue;
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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.JsonPost;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.views.LoginActivity;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.views.MainActivity;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.SocketTimeoutException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;

import javax.net.ssl.SSLHandshakeException;

import static android.content.ContentValues.TAG;

/**
 * This class is used to pull JSON files (from the API URLs)
 * for a specific account and then format and store the data into the
 * local SQLite database as well as validate a new account
 *
 * @author Andrew Cameron
 *
 */
public class DataConnection extends AsyncTask<String, Void, String> {

    private final Account account;
    private String hostName;          // Server name of account
    private String port;
    private String protocal;
    private String password;
    private String accountName;        // Username of account
    private int accountId;
    private int currentFrag = -1;
    private final Context dataContext; // Context that the DataConnection was executed in
    private final Activity dataActivity;
    private ProgressDialog spinner;
    private LocalDBHandler db;
    private boolean validAccount;
    private int allowSSC;

    private ClientConnectionManager clientConnectionManager;
    private HttpContext context = null;
    private HttpParams params;
    private DefaultHttpClient client = null;
    private CookieStore cookies = null;

    private static final String Tag = "DPS";

    public DataConnection(Context context, Activity activity, Account a, int Frag, int allowSelfSigned) {
        super();
        dataContext = context;
        dataActivity = activity;
        currentFrag = Frag;
        allowSSC = allowSelfSigned;
        if (activity != null) {
            spinner = new ProgressDialog(dataContext, R.style.MySpinnerStyle);
        }
        account = a;
    }

    @Override
    protected String doInBackground(String... params) {
        try{
            DataPull();
        }
        catch(Exception e){
            Log.w(Tag, "The DataPull failed. (probably not connected to internet or vmPlayer): "
                    + e.getLocalizedMessage());
        }
        try {
            Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            Ringtone r = RingtoneManager.getRingtone(dataContext, notification);
            r.play();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void onPostExecute(String params) {
        // Dismiss spinner to show data retrieval is done
        if (dataActivity != null) {
            spinner.dismiss();
        }

        // If valid account was connected, close the account activity
        // Otherwise refresh the page the user was on
        if (dataContext.getClass() == MainActivity.class) {
            if (dataActivity != null) {
                dataActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if(currentFrag != -1) {
                            ((MainActivity) dataActivity).selectItem(currentFrag);
                        }else{
                            ((MainActivity) dataActivity).refreshCurrentFragment();
                        }
                    }
                });
            }
        }else {
            if (validAccount) {
                if (dataActivity != null) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            dataActivity.finish();
                        }
                    });
                }
            }
        }
    }

    /**
     * Checks to see if account attempting to be connected from is a valid Kardia account
     * Displays proper error as Toast if account invalid
     */
    private boolean isValidAccount(boolean isNewAccount)  {
        String test;
        try {
            // Attempt to pull information about the missionary from the API
            test = GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/" + accountId +
                    "/?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic");
            // Unauthorized signals incorrect username or password
            // 404 not found signals invalid ID
            // Empty or null signals an incorrect server name
            if (isNewAccount) {
                if (test.equals("") || test.equals("Access Not Permitted")) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
                        }
                    });
                    return false;
                } else if (test.contains("<H1>Unauthorized</H1>")) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(dataContext, "Username/password invalid", Toast.LENGTH_LONG).show();
                        }
                    });
                    return false;
                } else if (test.contains("404 Not Found")) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(dataContext, "Invalid User ID", Toast.LENGTH_LONG).show();
                        }
                    });
                    return false;
                }
            }else { //if run from app refresh test server connection only
                if (test.equals("") || test.equals("Access Not Permitted")) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
                        }
                    });
                    return false;
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            // GET function throws an Exception if server not found
            if(e.getClass()==SocketTimeoutException.class){
                dataActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(dataContext, "Server connection timed out", Toast.LENGTH_LONG).show();
                    }
                });
            }else if(e.getClass()!=SSLHandshakeException.class) {
                dataActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
                    }
                });
            }
            return false;
        }
        return true;
    }

    /**
     * Pulls all data attached to account
     */
    private void DataPull()  {
        db = new LocalDBHandler(dataContext);
        hostName = account.getServerName();
        port = account.getPort();
        protocal = account.getProtocal();
        password = account.getAccountPassword();
        accountName = account.getAccountName();
        accountId = account.getId();

        Log.i(Tag, "pulling data");

        // If call was from LoginActivity or EditAccountActivity, it is an account being connected
        // If it was from MainActivity, it is a database update from an existing account
        boolean isNewAccount = false;
        Class c = dataContext.getClass();
        if (c == LoginActivity.class) {
            isNewAccount = true;
            spinner.setMessage("Connecting Account...");
        }  else
        {
            //the autoupdater doesn't run from an activity
            //the spinner messes up the autoupdater
            if (dataActivity != null) {
                spinner.setMessage("Updating...");
            }
        }

        if (dataActivity != null) {
            dataActivity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    spinner.setIndeterminate(true);
                    spinner.setCancelable(false);
                    spinner.show();
                }
            });
        }

        // validate account
        // If account not valid, do not attempt data pull
        validAccount = isValidAccount(isNewAccount);
        if(!validAccount) {
            return;
        }

        //if updating, send un-posted messages and notes to server
        if (c != LoginActivity.class && dataActivity != null) {
            ArrayList<JsonPost> JsonToPost = db.getJsonPosts();
            if (JsonToPost != null) {
                for (JsonPost j : JsonToPost) {
                    try {
                        JSONObject newJson = new JSONObject(j.getJsonString());

                        PostJson postJson = new PostJson(dataContext, j.getUrl(), newJson, account);
                        postJson.execute();

                        db.deleteJsonPost(j.getId());
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }


        try {
            Log.d(TAG, "DataPull: " + isNewAccount);
            if (isNewAccount) {
                Log.d(TAG, "DataPull: " + account);

                // If account is new and valid, add
                db.addAccount(account);
            }
            if (allowSSC==2) {
                db.updateAcceptSSCert(1);
            }

            loadPartnerName(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/partner/Partners/"
                    + accountId + "?cx__mode=rest&cx__res_format=attrs&cx__res_type=element&cx__res_attrs=basic"));
            loadDonors(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/" + accountId +
                    "/Supporters?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"));
            loadNotes(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/" + accountId +
                            "/Notes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"),
                    accountId);
            loadPrayerLetters(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/" + accountId +
                            "/PrayerLetters?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"));

            // Loop through donors and pull contact info
            for(Donor m : db.getDonors()) {
                int donorID = m.getId();
                loadContact(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/partner/Partners/" + donorID +
                        "/ContactInfo?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), donorID);
                loadAddress(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/partner/Partners/" + donorID +
                        "/Addresses?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), donorID);
                loadPicture(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/crm/Partners/" + donorID
                        + "/ProfilePicture?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"), donorID);
            }
            // Loop through notes and pull prayer for info
            for(Note n : db.getNotesForMissionary(accountId)){
                loadPrayedFor(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/" + accountId + "/Notes/" + n.getNoteId() +
                        "/Prayers?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"), n.getNoteId());
            }

            loadFunds(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/fundmanager/"
                    + accountId + "/Funds?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), accountId);

            // Loop through funds and pull all gifts
            for(Fund f : db.getFundsForMissionary(accountId)){

                String Fund_Name = "";
                try {
                    Fund_Name = URLEncoder.encode(f.getFundName(), "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                int fundId = f.getFundId();

                for(Donor m : db.getDonors()) {
                    int donorID = m.getId();
                    String donorName = m.getName();

                    loadGifts(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/donor/" + donorID + "/Funds/"
                            + Fund_Name + "/Gifts?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"),fundId,donorName,donorID);
                }
                for (Period p : db.getFundPeriods(fundId, "Month")){
                    loadTransactions(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/fundmanager/"
                            + accountId + "/Funds/" + Fund_Name + "/Periods/" + p.getPeriodName()
                            + "/Transactions?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"),
                            fundId, Fund_Name, p.getPeriodName());
                }
            }

            //load comments
            loadComments(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/"
                    + accountId + "/Comments?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));

        } catch (Exception e) {
            e.printStackTrace();
            //todo added to cancel download if server is timing out
            if (e.getClass().equals(SocketTimeoutException.class)){
                Toast.makeText(dataContext, "Server connection timed out", Toast.LENGTH_LONG).show();
            }else{
                Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
            }
            return;
            //to here
        }

        // If no timestamp found, add timestamp, otherwise update timestamp
        long originalStamp = db.getTimeStamp();
        if (originalStamp == -1) {
            db.addTimeStamp("" + Calendar.getInstance().getTimeInMillis());
        } else {
            long currentStamp = Calendar.getInstance().getTimeInMillis();
            db.updateTimeStamp("" + originalStamp, "" + currentStamp);
        }
        db.close();
    }

    /**
     * If there are results, change them into a string.
     *
     * @param in, the inputStream containing the results of the query (if any)
     * @return a string with the results of the query.
     * @throws IOException
     */
    private String convertInputStreamToString(InputStream in) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        String line, result = "";

        while ((line = reader.readLine()) != null) {
            result += line;
        }
        in.close();
        return result;
    }

    /**
     * Loads the partner name for the donor into the Accounts Table of the database
     * @param result, result of the API query for the partner info
     */
    private void loadPartnerName(String result) {
        JSONObject partner;
        try {
            partner = new JSONObject(result);
            String partnerName = partner.getString("partner_name");
            if (partnerName != null) {
                db.updatePartnerNameForAccount(account.getId(), partnerName);
            }
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
    }

    /**
     * Loads all missionaries connected to account into database if they are not present and adds contact info
     * @param result, result of API query for missionaries
     */
    private void loadDonors(String result) {
        ArrayList<Integer> currentDonorIDList = new ArrayList<Integer>();
        for (Donor m : db.getDonors()) {
            currentDonorIDList.add(m.getId());
        }
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempDonors = json.names();

        for(int i = 0; i < tempDonors.length(); i++){
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempDonors.getString(i).equals("@id")){
                    JSONObject DonorObj = json.getJSONObject(tempDonors.getString(i));

                    String donor_name = DonorObj.getString("partner_name");
                    String donor_id = DonorObj.getString("partner_id");

                    // If the donor id is not in the database, add the Donor Object to db
                    if(!currentDonorIDList.contains(Integer.parseInt(donor_id))){
                        Donor temp = new Donor();
                        temp.setName(donor_name);
                        temp.setId(Integer.parseInt(donor_id));

                        db.addDonor(temp);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * Loads all contact info for specific donor
     * @param result, result of API query for missionaries
     * @param partner_id, id of the donor
     */
    private void loadContact(String result, int partner_id) {
        JSONObject json = null;
        String email = "";
        String phone = "";
        String cell = "";

        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempContactInfo = json.names();
        for (int i = 0; i < tempContactInfo.length(); i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempContactInfo.getString(i).equals("@id")){
                    JSONObject ContactInfoObj = json.getJSONObject(tempContactInfo.getString(i));
                        //checks the type of contact info and puts it in the correct category
                        if (ContactInfoObj.getString("contact_type").equals("Email")) {
                            email = ContactInfoObj.getString("contact");
                        }
                        else if (ContactInfoObj.getString("contact_type").equals("Phone")) {
                            phone = ContactInfoObj.getString("contact");

                        }
                        else if (ContactInfoObj.getString("contact_type").equals("Cell")) {
                            cell = ContactInfoObj.getString("contact");
                        }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }

        //Prioritize cell over phone
        if(cell.equals("")) {
            cell = phone;
        }
        db.addContactInfo(partner_id, cell, email);
    }

    /**
     * Loads all contact info for specific donor
     * @param result, result of API query for missionaries
     * @param partner_id, id of the donor
     */
    private void loadAddress(String result, int partner_id) {
        JSONObject json = null;
        String address = "";

        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempAddress = json.names();
        for (int i = 0; i < tempAddress.length(); i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempAddress.getString(i).equals("@id")){
                    JSONObject ContactInfoObj = json.getJSONObject(tempAddress.getString(i));
                    //checks the type of contact info and puts it in the correct category
                    address = ContactInfoObj.getString("address");
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
        db.addAddress(partner_id, address);
    }

    /**
     * Loads all profile picture for specific donor
     * @param result, result of API query for missionaries
     * @param partnerId, id of the donor
     */
    private void loadPicture(String result, int partnerId) throws Exception{
        JSONObject json = null;
        String url = "";
        if (!result.contains("404 Not Found") && !result.equals("")) {
            try {
                json = new JSONObject(result);
            } catch (JSONException e1) {
                e1.printStackTrace();
            }
            if (json == null) {
                return;
            }
            JSONArray tempPicInfo = json.names();
            for (int i = 0; i < tempPicInfo.length(); i++) {
                try {
                    //@id signals a new object, but contains no information on that line
                    if (!tempPicInfo.getString(i).equals("@id")) {
                        JSONObject PicInfoObj = json.getJSONObject(tempPicInfo.getString(i));
                        //gets name for image
                        String name = PicInfoObj.getString("name");
                        //attempts to retrieve image matching name
                        if (!name.equals(db.getDonorImage(partnerId))) {
                            try {
                                url = protocal + "://" + hostName + ":" + port + "/apps/kardia/api/crm/Partners/"
                                        + partnerId + "/ProfilePicture/" + name;
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            httpsSetup();
                            HttpResponse response = getResponseFromUrl(url);
                            Bitmap image = null;
                            try {
                                InputStream input = response.getEntity().getContent();
                                image = BitmapFactory.decodeStream(input);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }

                            if (image != null) {
                                Bitmap resizedImage = getResizedBitmap(image);
                                byte[] data = getBitmapAsByteArray(resizedImage);
                                db.addDonorImage(data, partnerId, name);
                            }
                        }
                    }
                } catch (JSONException e) {
                    throw e;
                } catch (Exception e){
                    throw e;
                }
            }
        }
    }


    /**
     * Loads all notes (prayer requests, updates) into database if they are not present
     * @param result, result from API query for a specific missionary
     * @param missionary_id, id of the missionary notes are from
     */
    private void loadNotes(String result, int missionary_id) {
        JSONObject json = null;

        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }

        JSONArray tempNotes = json.names();
        for (int i = 0; i < tempNotes.length(); i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempNotes.getString(i).equals("@id")){
                    JSONObject NoteObj = json.getJSONObject(tempNotes.getString(i));
                    int noteID = Integer.parseInt(NoteObj.getString("note_id"));

                    ArrayList<Integer> currentNoteIDList = new ArrayList<Integer>();
                    for (Note n : db.getNotes()) {
                        currentNoteIDList.add(n.getNoteId());
                    }
                    // Check to see if prayer request is already in the database
                    if (!currentNoteIDList.contains(noteID)) {
                        Note temp = new Note();
                        temp.setNoteId(noteID);
                        temp.setNoteText(NoteObj.getString("note_text"));
                        temp.setSubject(NoteObj.getString("note_subject"));
                        temp.setMissionaryName(db.getAccount().getAccountName());
                        temp.setType(NoteObj.getString("note_type"));
                        temp.setMissionaryID(missionary_id);
                        temp.setNumberPrayed(0);

                        // Dates must be stored as YYYY-MM-DD HH:MM:SS format
                        JSONObject dateObj = new JSONObject(NoteObj.getString("note_date"));

                        String note_date = dateObj.getString("year");
                        note_date += "-"+formatDate(dateObj.getString("month"));
                        note_date += "-"+formatDate(dateObj.getString("day"));
                        note_date += " "+formatDate(dateObj.getString("hour"));
                        note_date += ":"+formatDate(dateObj.getString("minute"));
                        note_date += ":"+formatDate(dateObj.getString("second"));

                        temp.setDate(note_date);

                        db.addNote(temp);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * Loads prayed for information for all notes (prayer requests, updates) into database if they are not present
     * @param result, result from API query for a specific missionary
     * @param noteId, id of note 'prayer for' is associated with
     */
    private void loadPrayedFor(String result, int noteId) {
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }

        JSONArray tempPrayedFor = json.names();

        int numPrayedFor= tempPrayedFor.length();

        db.updateNote(noteId, numPrayedFor-1);

        for (int i = 0; i < numPrayedFor; i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempPrayedFor.getString(i).equals("@id")){
                    JSONObject PrayedForObj = json.getJSONObject(tempPrayedFor.getString(i));
                    int prayedForID = Integer.parseInt(PrayedForObj.getString("prayedfor_id"));

                    ArrayList<Integer> currentPrayedForIDList = new ArrayList<Integer>();

                    for (PrayedFor n : db.getPrayedFor()) {
                        currentPrayedForIDList.add(n.getPrayedForId());
                    }

                    // Check to see if prayer request is already in the database
                    if (!currentPrayedForIDList.contains(prayedForID)) {
                        currentPrayedForIDList.add(prayedForID);
                        PrayedFor temp = new PrayedFor();
                        temp.setPrayedForId(prayedForID);
                        temp.setPrayedForComments(PrayedForObj.getString("prayedfor_comments"));
                        temp.setNoteID(Integer.parseInt(PrayedForObj.getString("note_id")));
                        temp.setSupporterId(Integer.parseInt(PrayedForObj.getString("supporter_partner_id")));
                        temp.setSupporterName(PrayedForObj.getString("supporter_partner_name"));

                        // Dates must be stored as YYYY-MM-DD HH:MM:SS format
                        JSONObject dateObj = new JSONObject(PrayedForObj.getString("prayedfor_date"));

                        String prayer_for_date = dateObj.getString("year");
                        prayer_for_date += "-"+formatDate(dateObj.getString("month"));
                        prayer_for_date += "-"+formatDate(dateObj.getString("day"));
                        prayer_for_date += " "+formatDate(dateObj.getString("hour"));
                        prayer_for_date += ":"+formatDate(dateObj.getString("minute"));
                        prayer_for_date += ":"+formatDate(dateObj.getString("second"));

                        temp.setPrayedForDate(prayer_for_date);

                        db.addPrayedFor(temp);
                        db.addNewEvent("Prayer", temp.getNoteID(),
                                "New prayer on " + db.getNoteForID(temp.getNoteID()).getSubject(),
                                temp.getSupporterName() + " is praying.", temp.getPrayedForDate());
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * Loads all prayer letters into the database if they are not present
     * @param result, result from API query for specific missionary
     */
    private void loadPrayerLetters(String result) {
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempLetters = json.names();
        for (int i = 0; i < tempLetters.length(); i++) {
            try{
                //@id signals a new object, but contains no information on that line

                if(!tempLetters.getString(i).equals("@id")){
                    JSONObject LetterObj = json.getJSONObject(tempLetters.getString(i));
                    int letterID = Integer.parseInt(LetterObj.getString("letter_id"));
                    ArrayList<Integer> currentLetterNoteIDList = new ArrayList<Integer>();
                    for (PrayerLetter p : db.getPrayerLetters()) {
                        currentLetterNoteIDList.add(p.getId());
                    }

                    // Check to see if prayer request is already in the database
                    if (!currentLetterNoteIDList.contains(letterID)) {
                        PrayerLetter temp = new PrayerLetter();
                        temp.setId(letterID);
                        temp.setMissionaryName(db.getAccount().getAccountName());
                        temp.setTitle(LetterObj.getString("letter_title"));
                        temp.setFilename(LetterObj.getString("letter_filename"));
                        temp.setFolder(LetterObj.getString("letter_folder"));

                        // Dates must be stored as YYYY-MM-DD HH:MM:SS format
                        JSONObject dateObj = new JSONObject(LetterObj.getString("letter_date"));

                        String letter_date = dateObj.getString("year");
                        letter_date += "-"+formatDate(dateObj.getString("month"));
                        letter_date += "-"+formatDate(dateObj.getString("day"));
                        letter_date += " "+formatDate(dateObj.getString("hour"));
                        letter_date += ":"+formatDate(dateObj.getString("minute"));
                        letter_date += ":"+formatDate(dateObj.getString("second"));

                        temp.setDate(letter_date);
                        db.addPrayerLetter(temp);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * Formats the result string into funds and if a fund was not stored yet, adds it to
     *   the local SQLite database in a fund table
     * Adds a relation between the fund and the specific account
     *
     * @param result, the result of the Funds API GET request
     * @param accountId, id of the account tied to fund query
     */
    private void loadFunds(String result, int accountId) {
        // List of funds already in database for account
        JSONObject json = null;
        try{
            json = new JSONObject(result);
        }catch(JSONException e){
            e.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempFunds = json.names();

        for (int x = 0; x < tempFunds.length(); x++) {
            try {
                //@id signals a new object, but contains no information on that line
                if(!tempFunds.getString(x).equals("@id")){
                    JSONObject fundObj = json.getJSONObject(tempFunds.getString(x));
                    // If fund already in database, skip that fund
                    ArrayList<String> currentFundNames = db.getFundNames(this.accountId);


                    if (!currentFundNames.contains(fundObj.getString("name"))) {

                        Fund temp = new Fund();

                        temp.setFundName(fundObj.getString("name"));
                        temp.setFundDesc(fundObj.getString("fund_desc"));
                        temp.setFundClass(fundObj.getString("fund_class"));
                        temp.setFundAnnotation(fundObj.getString("annotation"));
                        temp.setMissionaryId(accountId);

                        // Add fund and Account-Fund relationship to database
                        db.addFund(temp);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * This formats the return json into gifts and if the gift
     * was not already stored adds it and a relationship to the related fund through the Fund_ID
     * and a relationship to the related year through the Year_ID
     *
     * @param result, result from API GET() for gifts
     * @param Fund_ID, fund related to gift
     * @param donorName, name of donor who gave gift
     * @param donorID, id of donor who gave gift
     */
    private void loadGifts(String result, int Fund_ID, String donorName, int donorID){

        // Test to see what gifts the database already has to avoid duplicates
        ArrayList<String> currentGiftNameList = db.getGiftNames(Fund_ID);
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempGifts = json.names();


        for(int i = 0; i < tempGifts.length(); i++){
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempGifts.getString(i).equals("@id")){
                    JSONObject GiftObj = json.getJSONObject(tempGifts.getString(i));

                    if(!currentGiftNameList.contains(GiftObj.getString("name"))) {
                        JSONObject dateObj = GiftObj.getJSONObject("gift_date");
                        JSONObject amountObj = GiftObj.getJSONObject("gift_amount");
                        int[] giftTotal = {
                                Integer.parseInt(amountObj.getString("wholepart")),
                                Integer.parseInt(amountObj.getString("fractionpart"))
                        };
                        String name = GiftObj.getString("name");

                        String gift_fund = GiftObj.getString("gift_fund")+"|"+GiftObj.getString("gift_ledger");
                        String gift_fund_desc = GiftObj.getString("gift_fund_desc");
                        String gift_year = dateObj.getString("year");
                        String gift_month = dateObj.getString("month");
                        String month_year;
                        // Convert gift dates to YYYY-MM-DD HH:MM:SS format
                        month_year=gift_year + "." + gift_month;

                        String gift_date = gift_year;
                        gift_date += "-"+ gift_month;
                        gift_date += "-"+formatDate(dateObj.getString("day"));
                        gift_date += " "+formatDate(dateObj.getString("hour"));
                        gift_date += ":"+formatDate(dateObj.getString("minute"));
                        gift_date += ":"+formatDate(dateObj.getString("second"));

                        String gift_check_num = GiftObj.getString("gift_check_num");

                        if(giftTotal[1] >= 100){
                            giftTotal[1] /= 100;
                        }

                        Gift temp = new Gift();
                        temp.setName(name);
                        temp.setGiftFund(gift_fund);
                        temp.setGiftFundDesc(gift_fund_desc);
                        temp.setGiftDate(gift_date);
                        temp.setGiftCheckNum(gift_check_num);
                        temp.setGiftAmount(giftTotal);
                        temp.setGiftDonor(donorName);
                        temp.setGiftDonorId(donorID);
                        temp.setGiftYear(gift_year);
                        temp.setGiftMonth(month_year);

                        db.addGift(temp);

                        db.addNewEvent("Gift", db.getGift(0, name).getId(), "New gift", donorName + " donated " + Formatter.amountToString(giftTotal), gift_date);
                        // id, type, eventid, header, content, date
                        if (i==0) {
                            db.addNewEvent("Donor", donorID, "New donor", donorName, gift_date);
                        }
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * This formats the return json into transactions and if the transaction
     * was not already stored adds it to the database
     *
     * @param result, result from API GET() for gifts
     * @param Fund_ID, fund related to gift
     */
    private void loadTransactions(String result, int Fund_ID, String transaction_fund, String periodName){

        // Test to see what gifts the database already has to avoid duplicates
        ArrayList<String> currentTransactionNameList = db.getTransactionNames(Fund_ID);
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempTransactions = json.names();


        for(int i = 0; i < tempTransactions.length(); i++){
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempTransactions.getString(i).equals("@id")){
                    JSONObject TransactionObj = json.getJSONObject(tempTransactions.getString(i));

                    if(!currentTransactionNameList.contains(TransactionObj.getString("name"))) {
                        JSONObject dateObj = TransactionObj.getJSONObject("trx_date");
                        JSONObject amountObj = TransactionObj.getJSONObject("amount");
                        int[] giftTotal = {
                                Integer.parseInt(amountObj.getString("wholepart")),
                                Integer.parseInt(amountObj.getString("fractionpart"))
                        };
                        String name = TransactionObj.getString("name");
                        String donorName = TransactionObj.getString("to_from");
                        int donorID = Integer.parseInt(TransactionObj.getString("to_from_id"));


                        String transaction_fund_desc = TransactionObj.getString("fund_desc");
                        String transaction_year = dateObj.getString("year");
                        String transaction_month = dateObj.getString("month");
                        String month_year;

                        // Convert gift dates to YYYY-MM-DD HH:MM:SS format
                        month_year=transaction_year + "." + transaction_month;

                        String gift_date = transaction_year;
                        gift_date += "-"+transaction_month;
                        gift_date += "-"+formatDate(dateObj.getString("day"));
                        gift_date += " "+formatDate(dateObj.getString("hour"));
                        gift_date += ":"+formatDate(dateObj.getString("minute"));
                        gift_date += ":"+formatDate(dateObj.getString("second"));

                        if(giftTotal[1] >= 100){
                            giftTotal[1] /= 100;
                        }

                        Gift temp = new Gift();
                        temp.setName(name);
                        temp.setGiftFund(transaction_fund);
                        temp.setGiftFundDesc(transaction_fund_desc);
                        temp.setGiftDate(gift_date);
                        temp.setGiftAmount(giftTotal);
                        temp.setGiftDonor(donorName);
                        temp.setGiftDonorId(donorID);
                        temp.setGiftYear(transaction_year);
                        temp.setGiftMonth(month_year);

                        /*todo employ if transaction total is Fund total
                        ArrayList<Period> currentPeriods= db.getFundPeriods(Fund_ID, "Month");
                        if( month_year.equals(currentPeriods.get(currentPeriods.size()-1)) && i == tempTransactions.length()-1 ){
                            try {
                                String balanceResult = GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/fundmanager/"
                                        + accountId + "/Funds/" + transaction_fund + "/Periods/" + periodName
                                        + "?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic");
                                JSONObject jsonBalance = null;
                                try {
                                    jsonBalance = new JSONObject(balanceResult);
                                } catch (JSONException e1) {
                                    e1.printStackTrace();
                                }
                                if (json != null) {
                                    JSONArray tempBalance = jsonBalance.names();
                                    for(int j = 0; j < tempBalance.length(); j++) {
                                        JSONObject fundBalanceObj = json.getJSONObject(tempBalance.getString(j));
                                        if(fundBalanceObj.getString("name").equals("Balances")) {
                                            JSONObject balanceObj = fundBalanceObj.getJSONObject("balance");

                                            int[] balance = {
                                                    Integer.parseInt(balanceObj.getString("wholepart")),
                                                    Integer.parseInt(balanceObj.getString("fractionpart"))
                                            };
                                            if(balance[1] >= 100){
                                                balance[1] /= 100;
                                            }
                                            db.setFundBalance();
                                        }
                                    }
                                }
                            }catch (Exception ex) {
                                ex.printStackTrace();
                                //todo added to cancel download if server is timing out
                                if (ex.getClass().equals(SocketTimeoutException.class)) {
                                    Toast.makeText(dataContext, "Server connection timed out", Toast.LENGTH_LONG).show();
                                } else {
                                    Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
                                }
                            }
                        }*/

                        db.addTransaction(temp);

                        db.addNewEvent("Transaction", db.getGift(0, name).getId(), "New transaction", transaction_fund_desc + ": " + Formatter.amountToString(giftTotal), gift_date);
                        // id, type, eventid, header, content, date
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }
    /**
     * loads comments on posts
     *
     * @param result, result from API GET() for comments
     **/
    private void loadComments(String result){

        //check to see what the database already has
        ArrayList<Comment> currentComments = db.getComments();
        ArrayList<Integer> currentCommentIds = new ArrayList<Integer>();
        for(Comment c: currentComments){
            currentCommentIds.add(c.getCommentID());
        }

        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempComments = json.names();


        for (int i = 0; i < tempComments.length(); i++){
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempComments.getString(i).equals("@id")){
                    JSONObject CommentObj = json.getJSONObject(tempComments.getString(i));

                    if(!currentCommentIds.contains(Integer.parseInt(CommentObj.getString("comment_id")))){
                        JSONObject dateObj = CommentObj.getJSONObject("comment_date");

                        int ID = Integer.parseInt(CommentObj.getString("comment_id"));
                        String noteType = CommentObj.getString("note_type");
                        int noteID = Integer.parseInt(CommentObj.getString("note_id"));
                        String comment = CommentObj.getString("comment");

                        String userName = CommentObj.getString("supporter_partner_name");

                        String comment_date = dateObj.getString("year");

                        // Convert comment date to YYYY-MM-DD HH:MM:SS format
                        comment_date += "-"+formatDate(dateObj.getString("month"));
                        comment_date += "-"+formatDate(dateObj.getString("day"));
                        comment_date += " "+formatDate(dateObj.getString("hour"));
                        comment_date += ":"+formatDate(dateObj.getString("minute"));
                        comment_date += ":"+formatDate(dateObj.getString("second"));


                        Comment temp = new Comment();
                        temp.setCommentID(ID);
                        temp.setNoteID(noteID);
                        temp.setNoteType(noteType);
                        temp.setDate(comment_date);
                        temp.setSenderID(accountId);
                        temp.setComment(comment);
                        temp.setUserName(userName);

                        //check to see if this is new
                        Boolean newComment = true;
                        for (Comment c : currentComments){
                            if (c.getCommentID() == temp.getCommentID()){
                                newComment = false;
                            }
                        }

                        //if it's new, add it to database
                        if (newComment) {
                            db.addComment(temp.getCommentID(), temp.getSenderID(), temp.getNoteID(), temp.getUserName(), temp.getNoteType(), temp.getDate(), temp.getComment());
                            db.addNewEvent("Comment", temp.getNoteID(), "New comment on \"" + db.getNoteForID(noteID).getSubject() + "\"",
                                    userName + " said:\n" + comment, comment_date);
                        }
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    private String formatDate(String date){
        date = (date.length() < 2)? "0" + date : date;
        return date;
    }

    private static byte[] getBitmapAsByteArray(Bitmap bitmap) {
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 0, outputStream);
        return outputStream.toByteArray();
    }

    private Bitmap getResizedBitmap(Bitmap image) {
        int maxSize = 68;
        int width = image.getWidth();
        int height = image.getHeight();

        float bitmapRatio = (float) width / (float) height;
        if (bitmapRatio > 1) {
            width = maxSize;
            height = (int) (width / bitmapRatio);
        } else {
            height = maxSize;
            width = (int) (height * bitmapRatio);
        }

        return Bitmap.createScaledBitmap(image, width, height, true);
    }

    /**
     * Attempts to do basic Http Authentication, and send a get request from the url
     *
     * @param url, url for get request.
     * @return string results of the query.
     * @throws Exception when could not connect to request
     */
    private String GET(String url) throws Exception {
        InputStream inputStream;
        String result = "";
        Log.d(TAG, "GET: " +url);
        httpsSetup();
        try {
            HttpResponse response = getResponseFromUrl(url);

            if (response!=null) {
                inputStream = response.getEntity().getContent();

                if (inputStream != null) {
                    result = convertInputStreamToString(inputStream);
                } else {
                    result = "";
                }
            }
        } catch (Exception e) {
            // Rethrow exception for validation server error
            throw e;
            //throw new Exception();
        }
        return result;
    }


    public HttpResponse getResponseFromUrl(final String url) throws Exception {
        //connection (client has to be created for every new connection)
        try {
            client = new DefaultHttpClient(clientConnectionManager, params);
            client.removeRequestInterceptorByClass(RequestExpectContinue.class);//theoretically faster
            if (cookies != null) {
                client.setCookieStore(cookies);
            }

            HttpGet get = new HttpGet(url);

            HttpResponse response = client.execute(get, context);

            if (cookies == null) {
                cookies = client.getCookieStore();
            }
            return response;
        } catch (IOException e) {
            if (e.getClass().equals(SSLHandshakeException.class) && allowSSC==0) {
                if (dataActivity != null) {
                    dataActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            new AlertDialog.Builder(dataContext)
                                    .setCancelable(false)
                                    .setTitle("Server error")
                                    .setMessage("Server uses self-signed certificate. Allow connection?")
                                    .setNegativeButton(R.string.always, new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int which) {
                                            new DataConnection(dataContext, dataActivity, account, -1, 2).execute("");
                                        }
                                    })
                                    .setNeutralButton(R.string.allow, new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int which) {
                                            new DataConnection(dataContext, dataActivity, account, -1, 1).execute("");
                                        }
                                    })
                                    .setPositiveButton(R.string.no, new DialogInterface.OnClickListener() {
                                        public void onClick(DialogInterface dialog, int which) {
                                            Toast.makeText(dataContext, "Cannot connect to server", Toast.LENGTH_SHORT).show();
                                            allowSSC = 0;
                                        }
                                    })
                                    .setIcon(android.R.drawable.ic_dialog_alert)
                                    .show();
                        }
                    });
                }
            }else if (e.getClass().equals(ClientProtocolException.class)){
                e.printStackTrace();
                return null;
            }
            throw e;
        }
    }

    private void httpsSetup(){

        SchemeRegistry schemeRegistry = new SchemeRegistry();

        // https scheme
        if (protocal.equals("https")) {
            if (allowSSC==0) {
                //todo check that this works for signed ssl
                schemeRegistry.register(new Scheme(protocal, SSLSocketFactory.getSocketFactory(), 443));
            }else{
                schemeRegistry.register(new Scheme(protocal, new EasySSLSocketFactory(), 443));
            }
        }
        // http scheme
        else {
            schemeRegistry.register(new Scheme(protocal, PlainSocketFactory.getSocketFactory(), 80));
        }

        params = new BasicHttpParams();
        params.setParameter(ConnManagerPNames.MAX_TOTAL_CONNECTIONS, 1);
        params.setParameter(ConnManagerPNames.MAX_CONNECTIONS_PER_ROUTE, new ConnPerRouteBean(1));
        params.setParameter(HttpProtocolParams.USE_EXPECT_CONTINUE, false);
        params.setParameter(HttpConnectionParams.SO_TIMEOUT,15000); //set timout to 15s
        params.setParameter(HttpConnectionParams.CONNECTION_TIMEOUT, 15000);
        HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
        HttpProtocolParams.setContentCharset(params, "utf8");

        CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        //set the user credentials for our site "example.com"
        credentialsProvider.setCredentials(new AuthScope(hostName, Integer.parseInt(port)),
                new UsernamePasswordCredentials(accountName, password));
        clientConnectionManager = new ThreadSafeClientConnManager(params, schemeRegistry);

        context = new BasicHttpContext();
        context.setAttribute("http.auth.credentials-provider", credentialsProvider);
    }
}
