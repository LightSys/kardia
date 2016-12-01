package org.lightsys.missionaryapp.tools;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.ssl.SSLSocketFactory;
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
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.JsonPost;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.views.AccountsActivity;
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
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Calendar;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

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
    private  int currentFrag = -1;
    private final Context dataContext; // Context that the DataConnection was executed in
    private final Activity dataActivity;
    private ProgressDialog spinner;
    private LocalDBHandler db;
    private boolean validAccount;

    private static final String Tag = "DPS";

    public DataConnection(Context context, Activity activity, Account a, int Frag) {
        super();
        dataContext = context;
        dataActivity = activity;
        currentFrag = Frag;
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
        } else {
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
                }
            }
        }
        catch (Exception e) {
            // GET function throws an Exception if server not found
            dataActivity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(dataContext, "Server connection failed", Toast.LENGTH_LONG).show();
                }
            });
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
        if (port == null){
            port = "800";
        }
        protocal = account.getProtocal();
        password = account.getAccountPassword();
        accountName = account.getAccountName();
        accountId = account.getId();

        Log.i(Tag, "pulling data");

        // If call was from AccountsActivity or EditAccountActivity, it is an account being connected
        // If it was from MainActivity, it is a database update from an existing account
        boolean isNewAccount = false;
        Class c = dataContext.getClass();
        if (c == AccountsActivity.class) {
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
        if (c != AccountsActivity.class && dataActivity != null) {
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
            if (isNewAccount) {
                // If account is new and valid, add
                db.addAccount(account);
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
            db.deleteNewItems();
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
            }

            //load comments
            loadComments(GET(protocal + "://" + hostName + ":" + port + "/apps/kardia/api/missionary/"
                    + accountId + "/Comments?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));

        } catch (Exception e) {
            e.printStackTrace();
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
     * Attempts to do basic Http Authentication, and send a get request from the url
     *
     * @param url, url for get request.
     * @return string results of the query.
     * @throws Exception when could not connect to request
     */
    private String GET(String url) throws Exception {
        InputStream inputStream;
        String result;
        try {
            // Set the user credentials to allow access to API information
            CredentialsProvider credProvider = new BasicCredentialsProvider();
            credProvider.setCredentials(new AuthScope(hostName, 800),
                    new UsernamePasswordCredentials(accountName, password));

            // Set timeout parameters to avoid a long connection attempt to non-valid server
            // Timeout currently set to 10 seconds
            HttpParams params = new BasicHttpParams();
            HttpConnectionParams.setConnectionTimeout(params, 10000);
            HttpConnectionParams.setSoTimeout(params, 10000);
            DefaultHttpClient client = new DefaultHttpClient(params);

            client.setCredentialsProvider(credProvider);

            HttpResponse response = client.execute(new HttpGet(url));

            inputStream = response.getEntity().getContent();

            if (inputStream != null) {
                result = convertInputStreamToString(inputStream);
            } else {
                result = "";
            }
        } catch (Exception e) {
            // Rethrow exception for validation server error
            throw new Exception();
        }
        return result;
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

                    Donor temp = new Donor();
                    temp.setName(donor_name);
                    temp.setId(Integer.parseInt(donor_id));

                    // If the donor id is not in the database, add the Donor Object to db
                    if(!currentDonorIDList.contains(temp.getId())){
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
    private void loadPicture(String result, int partnerId) {
        JSONObject json = null;
        String url = "";
        Log.d("DataConnection", "loadPicture: " + result.substring(0,7) + partnerId);
        if (!result.contains("404 Not Found")) {
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
                        //checks the type of contact info and puts it in the correct category
                        try{
                            url = protocal + "://" + hostName + ":" + port + "/apps/kardia/api/crm/Partners/" + partnerId + "/ProfilePicture/"
                                    + PicInfoObj.getString("name");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }


                        Bitmap image = getBitmapFromURL(url);

                        if (image != null) {
                            Log.d(TAG, "loadPicture: " + "inside if");
                            Bitmap resizedImage = getResizedBitmap(image);
                            byte[] data = getBitmapAsByteArray(resizedImage);
                            db.addDonorImage(data, partnerId);
                        }
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
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

                        //add new item
                        //this lets the autoUpdater know there is something new
                        db.addNewItem(Calendar.getInstance().getTimeInMillis() + ""
                                , temp.getType()
                                , "New " + temp.getType() + " from " + temp.getMissionaryName());

                        // Dates must be stored as YYYY-MM-DD
                        JSONObject date = new JSONObject(NoteObj.getString("note_date"));
                        String day = date.getString("day");
                        day = day.length() < 2 ? "0" + day : day;
                        String month = date.getString("month");
                        month = month.length() < 2 ? "0" + month : month;
                        String year = date.getString("year");

                        temp.setDate(year + "-" + month + "-" + day);

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

                        //add new item
                        //this lets the autoUpdater know there is something new
                        db.addNewItem(Calendar.getInstance().getTimeInMillis() + "",
                                "New Prayer from ", temp.getSupporterName());

                        // Dates must be stored as YYYY-MM-DD
                        JSONObject date = new JSONObject(PrayedForObj.getString("prayedfor_date"));
                        String day = date.getString("day");
                        day = day.length() < 2 ? "0" + day : day;
                        String month = date.getString("month");
                        month = month.length() < 2 ? "0" + month : month;
                        String year = date.getString("year");

                        temp.setPrayedForDate(year + "-" + month + "-" + day);

                        db.addPrayedFor(temp);
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

                        // Dates must be stored as YYYY-MM-DD
                        JSONObject date = new JSONObject(LetterObj.getString("letter_date"));
                        String day = date.getString("day");
                        day = day.length() < 2 ? "0" + day : day;
                        String month = date.getString("month");
                        month = month.length() < 2 ? "0" + month : month;
                        String year = date.getString("year");

                        temp.setDate(year + "-" + month + "-" + day);
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
                        int giftId = db.getLastId("gift") + 1;
                        String name = GiftObj.getString("name");

                        String gift_fund = GiftObj.getString("gift_fund")+"|"+GiftObj.getString("gift_ledger");
                        String gift_fund_desc = GiftObj.getString("gift_fund_desc");
                        String gift_year = dateObj.getString("year");
                        String gift_month = dateObj.getString("month");
                        String month_year;
                        // Convert gift dates to YYYY-MM-DD format
                        month_year=gift_year + "." + gift_month;
                        gift_month = (gift_month.length() < 2)? "0" + gift_month : gift_month;
                        String gift_day = dateObj.getString("day");
                        gift_day = (gift_day.length() < 2)? "0" + gift_day : gift_day;
                        String gift_date = gift_year + "-"
                                + gift_month + "-" + gift_day;

                        String gift_check_num = GiftObj.getString("gift_check_num");

                        if(giftTotal[1] >= 100){
                            giftTotal[1] /= 100;
                        }

                        Gift temp = new Gift();
                        temp.setName(name);
                        temp.setId(giftId);
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
                        db.addGiftAccount(giftId, accountId);
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

                        String comment_year = dateObj.getString("year");
                        String comment_month = dateObj.getString("month");

                        // Convert gift dates to YYYY-MM-DD format
                        comment_month = (comment_month.length() < 2)? "0" + comment_month : comment_month;
                        String comment_day = dateObj.getString("day");
                        comment_day = (comment_day.length() < 2)? "0" + comment_day : comment_day;
                        String comment_date = comment_year + "-"
                                + comment_month + "-" + comment_day;

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
                            db.addNewItem(Calendar.getInstance().getTimeInMillis() + "", "Comment", "New Comment on a post from " + db.getNoteForID(temp.getNoteID()).getMissionaryName());
                        }
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
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

    private static Bitmap getBitmapFromURL(String src) {
        try {
            URL url = new URL(src);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            return BitmapFactory.decodeStream(input);

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}