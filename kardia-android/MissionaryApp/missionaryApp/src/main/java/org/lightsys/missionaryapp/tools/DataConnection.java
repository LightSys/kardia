package org.lightsys.missionaryapp.tools;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.views.AccountsActivity;
import org.lightsys.missionaryapp.views.EditAccountActivity;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.Year;
import org.lightsys.missionaryapp.views.MainActivity;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;

/**
 * This class is used to pull JSON files (from the API URLs)
 * for a specific account and then format and store the data into the
 * local SQLite database as well as validate a new account
 *
 * @author Andrew Cameron
 *
 */
public class DataConnection extends AsyncTask<String, Void, String> {

    private Account account;
    private String Host_Name; // Server name of account
    private String Password;
    private String AccountName; // Username of account
    private int Account_ID;
    private Context dataContext; // Context that the DataConnection was executed in
    private Activity dataActivity;
    private ProgressDialog spinner;
    private LocalDBHandler db;
    private boolean validAccount;

    private static final String Tag = "DPS";
    private static final String TAG = "DATACONNECTION";

    public DataConnection(Context context, Activity activity, Account a) {
        super();
        dataContext = context;
        dataActivity = activity;
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
            Log.w(Tag, "The DataPull failed. (probably not connected to internet or vmplayer): "
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
            dataActivity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    ((MainActivity)dataActivity).refreshCurrentFragment();
                }
            });
        } else {
            if (validAccount) {
                dataActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        dataActivity.finish();
                    }
                });
            }
        }
    }

    /**
     * Checks to see if account attempting to be connected from is a valid Kardia account
     * Displays proper error as Toast if account invalid
     */
    private boolean isValidAccount()  {
        String test;
        // Account details already set in DataPull()

        try {
            // Attempt to pull information about the missionary from the API
            test = GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + Account_ID +
                    "/?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic");
            // Unauthorized signals incorrect username or password
            // 404 not found signals invalid ID
            // Empty or null signals an incorrect server name
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
                        Toast.makeText(dataContext, "Username/Password invalid", Toast.LENGTH_LONG).show();
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
        db = new LocalDBHandler(dataContext, null);
        Host_Name = account.getServerName();
        Password = account.getAccountPassword();
        AccountName = account.getAccountName();
        Account_ID = account.getId();

        Log.i(Tag, "pulling data");

        // If call was from AccountsActivity or EditAccountActivity, it is an account being connected
        // If it was from MainActivity, it is a database update from an existing account
        boolean isNewAccount = false;
        Class c = dataContext.getClass();
        if (c == AccountsActivity.class || c == EditAccountActivity.class) {
            isNewAccount = true;
            spinner.setMessage("Connecting Account...");
        }  else
        {
            //the autoupdater doesn't run from an activity
            //the spinner messes up the autoupdater
            if (dataActivity != null) {
                spinner.setMessage("Updating...");
            }
            //clears gift table to fix a bug with updating from the server
            db.deleteGifts(Account_ID);
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

        // If it is a new account, validate account
        // If account not valid, do not attempt data pull
        if (isNewAccount) {
            validAccount = isValidAccount();
            if(!validAccount) {
                return;
            }
        }

        try {
            if (isNewAccount) {
                // If account is new and valid, update if from edit or add if from accounts
                if (dataContext.getClass() == EditAccountActivity.class) {
                    db.updateAccount(account.getId(), account.getAccountName(),
                            account.getAccountPassword(), account.getServerName());
                } else {
                    db.addAccount(account);
                }
            }
            loadPartnerName(GET("http://" + Host_Name + ":800/apps/kardia/api/partner/Partners/"
                    + Account_ID + "?cx__mode=rest&cx__res_format=attrs&cx__res_type=element&cx__res_attrs=basic"));
            loadMissionaries(GET("http://" + Host_Name + ":800/apps/kardia/api/supporter/" + Account_ID +
                    "/Missionaries?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));
            loadDonors(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + Account_ID +
                    "/Supporters?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));
            loadNotes(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + Account_ID +
                            "/Notes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"),
                    Account_ID);
            loadPrayerLetters(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + Account_ID +
                            "/PrayerLetters?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"),
                    Account_ID);
            // Loop through donors and pull notes and prayer letters
            db.deleteNewItems();
            for(Donor m : db.getDonors()) {
                int donorID = m.getId();
                loadContact(GET("http://" + Host_Name + ":800/apps/kardia/api/partner/Partners/" + donorID +
                        "/ContactInfo?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), donorID);

            }
            int i = 0;
            for(Note n : db.getNotes()){
                loadPrayedFor(GET("http://" + Host_Name +":800/apps/kardia/api/missionary/" + Account_ID + "/Notes/" + n.getNoteId() +
                        "/Prayers?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"), n.getNoteId());
            }
            // Load years so they can be connected to funds
            loadYears(GET("http://" + Host_Name + ":800/apps/kardia/api/donor/" + Account_ID +
                    "/Years?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));
            loadFunds(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/"
                    + Account_ID + "/Funds?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), Account_ID);

            for(Fund f : db.getFundsForMissionary(Account_ID)){

                String Fund_Name = "";
                try {
                    Fund_Name = URLEncoder.encode(f.getFundName(), "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                int fundid = f.getFundId();
                Log.d(TAG, "DataPull: " + fundid);

                /*loadPeriods(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + Account_ID + "/Funds/"
                        + Fund_Name + "/Periods?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), f.getFundId());

                for (Period p : db.getPeriods(f.getFundId())) {
                    System.out.println("Looking at new Period");
                    String periodname = p.getName();
                    periodname = periodname.replace("|", "%7C");
                    loadTransactions(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + Account_ID + "/Funds/" +
                            Fund_Name + "/Periods/" + periodname + "/Transactions?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), f.getFundId());
                }*/
                for(Donor m : db.getDonors()) {
                    int donorID = m.getId();
                    String donorname = m.getName();

                    loadFundYears(GET("http://" + Host_Name + ":800/apps/kardia/api/donor/" + donorID + "/Funds/"
                            + Fund_Name + "/Years?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), fundid, donorID);

                    for(Year y : db.getYearsForFund(fundid)){
                        int yearid = y.getId();
                        loadGifts(GET("http://" + Host_Name + ":800/apps/kardia/api/donor/" + donorID + "/Funds/"
                                        + Fund_Name + "/Gifts?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"),
                                yearid, fundid,donorname,donorID);
                        Log.d(TAG, "DataPull: " + yearid);
                    }
                }
            }

            //load comments
            loadComments(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/"
                    + Account_ID + "/Comments?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));

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
    public String GET(String url) throws Exception {
        InputStream inputStream;
        String result;

        try {
            // Set the user credentials to allow access to API information
            CredentialsProvider credProvider = new BasicCredentialsProvider();
            credProvider.setCredentials(new AuthScope(Host_Name, 800),
                    new UsernamePasswordCredentials(AccountName, Password));

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
    private void loadContact(String result, int partner_id) {
        JSONObject json = null;
        String email = " ";
        String phone = " ";
        String cell = " ";

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
        ArrayList<Integer> currentContactInfoList = new ArrayList<Integer>();
        for (ContactInfo p : db.getContactInfo()) {
            currentContactInfoList.add(p.getPartnerId());
        }
        // Check to see if contact info is already in the database
        if (!currentContactInfoList.contains(partner_id)) {
            ContactInfo temp = new ContactInfo();
            temp.setPartnerId(partner_id);
            temp.setEmail(email);
            temp.setPhone(phone);
            temp.setCell(cell);
            db.addContactInfo(temp);
        }
        else{
            ContactInfo temp = new ContactInfo();
            temp.setPartnerId(partner_id);
            temp.setEmail(email);
            temp.setPhone(phone);
            temp.setCell(cell);
            db.updateContactInfo(temp);

        }
    }

    /**
     * Loads all missionaries connected to account into database if they are not present
     * @param result, result of API query for missionaries
     */
    private void loadMissionaries(String result) {
        ArrayList<Integer> currentMissionaryIDList = new ArrayList<Integer>();
        for (Donor m : db.getMissionaries()) {
            currentMissionaryIDList.add(m.getId());
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
        JSONArray tempMissionaries = json.names();

        for(int i = 0; i < tempMissionaries.length(); i++){
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempMissionaries.getString(i).equals("@id")){
                    JSONObject MissionaryObj = json.getJSONObject(tempMissionaries.getString(i));

                    String missionary_name = MissionaryObj.getString("partner_name");
                    String missionary_id = MissionaryObj.getString("partner_id");

                    Donor temp = new Donor();
                    temp.setName(missionary_name);
                    temp.setId(Integer.parseInt(missionary_id));

                    // If the missionary id is not in the database, add the Donor Object to db
                    if(!currentMissionaryIDList.contains(temp.getId())){
                        db.addMissionary(temp);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * Loads all notes (prayer requests, updates) into database if they are not present
     * @param result, result from API query for a specific missionary
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

        ArrayList<String> noteIDsFromServer = new ArrayList<String>(); //used to get rid of stale notes

        JSONArray tempNotes = json.names();
        for (int i = 0; i < tempNotes.length(); i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempNotes.getString(i).equals("@id")){
                    JSONObject NoteObj = json.getJSONObject(tempNotes.getString(i));
                    int noteID = Integer.parseInt(NoteObj.getString("note_id"));
                    noteIDsFromServer.add(noteID + "");

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
                        temp.setMissionaryName(db.getMissionaryForID(missionary_id).getName());
                        temp.setType(NoteObj.getString("note_type"));
                        temp.setMissionaryID(missionary_id);
                        temp.setNumberPrayed(0);

                        //add new item
                        //this lets the autoUpdater know there is something new
                        db.addNew_Item(Calendar.getInstance().getTimeInMillis() + ""
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
     */
    private void loadPrayedFor(String result, int noteid) {
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }

        ArrayList<String> prayedForIDsFromServer = new ArrayList<String>(); //used to get rid of stale prayed for

        JSONArray tempPrayedFor = json.names();

        int numPrayedFor= tempPrayedFor.length();

        db.updateNote(noteid, numPrayedFor-1);

        String TAG = "DATA CONNECTION";
        for (int i = 0; i < numPrayedFor; i++) {
            try{
                //@id signals a new object, but contains no information on that line
                if(!tempPrayedFor.getString(i).equals("@id")){
                    JSONObject PrayedForObj = json.getJSONObject(tempPrayedFor.getString(i));
                    int prayedForID = Integer.parseInt(PrayedForObj.getString("prayedfor_id"));
                    prayedForIDsFromServer.add(prayedForID + "");

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
                        temp.setNoteId(Integer.parseInt(PrayedForObj.getString("note_id")));
                        temp.setSupporterId(Integer.parseInt(PrayedForObj.getString("supporter_partner_id")));
                        temp.setSupporterName(PrayedForObj.getString("supporter_partner_name"));

                        //add new item
                        //this lets the autoUpdater know there is something new
                        db.addNew_Item(Calendar.getInstance().getTimeInMillis() + "",
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
     * @param missionary_id, ID of missionary for the query
     */
    private void loadPrayerLetters(String result, int missionary_id) {
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
                        temp.setMissionaryName(db.getMissionaryForID(missionary_id).getName());
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
     *   the local sqlite database in a fund table
     * Adds a relation between the fund and the specific account
     *
     * @param result, the result of the Funds API GET request
     */
    private void loadFunds(String result, int accountId) {
        Log.d(TAG, "loadFunds: makes it to loadFunds");
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
                    ArrayList<String> currentFundNames = db.getFundNames(Account_ID);


                    if (!currentFundNames.contains(fundObj.getString("name"))) {
                        Fund temp = new Fund();

                        temp.setFundName(fundObj.getString("name"));
                        temp.setFundDesc(fundObj.getString("fund_desc"));
                        temp.setFundClass(fundObj.getString("fund_class"));
                        temp.setFundAnnotation(fundObj.getString("annotation"));
                        temp.setMissionaryId(accountId);
                        Log.d(TAG, "loadFunds: " + temp.getFundName());
                        Log.d(TAG, "loadFunds: " + accountId);
                        Log.d(TAG, "loadFunds: " + temp.getMissionaryId());

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
     * Formats all prayer requests and updates from the Missionaries connected to account
     *   and loads these into the local database
     *
     */

    /**
     * This pulls the years related to a specific fund.
     * If they are not yet stored adds relationships between the fund and year
     * (Notice only adds the relationship if one does not already exist)
     *
     * @param result, the JSON information returned from the back-end
     * @param fundId, id for fund that years should be pulled from
     */
    private void loadFundYears(String result, int fundId, int donorid){

        // Retrieve years for testing what is in the database
        ArrayList<String> currentYearNamesList = db.getYearNames();
        ArrayList<String> currentYearConnectionList = db.getYearNamesFund(fundId);
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempYears = json.names();

        for(int x = 0; x < tempYears.length(); x++){

            try{
                //@id signals a new object, but contains no information on that line
                if(!tempYears.getString(x).equals("@id")){
                    JSONObject YearObj = json.getJSONObject(tempYears.getString(x));
                    JSONObject giftObj = YearObj.getJSONObject("gift_total");
                    int[] gifttotal = {
                            Integer.parseInt(giftObj.getString("wholepart")),
                            Integer.parseInt(giftObj.getString("fractionpart"))
                    };
                    String name = YearObj.getString("name");
                    if(gifttotal[1] >= 100){
                        gifttotal[1] /= 100;
                    }

                    // If connection between fund and year doesn't exist... add new connection
                    if(currentYearNamesList.contains(name) && !currentYearConnectionList.contains(name)){
                        int yearid = db.getYear(name).getId();
                        db.addYear_Fund(yearid, fundId, gifttotal[0], gifttotal[1]);
                        Log.d(TAG, "loadFundYearsA: " + yearid);
                    }
                    // If the connection does exist, update the values
                    else if(currentYearNamesList.contains(name) && currentYearConnectionList.contains(name)){
                        int yearid = db.getYear(name).getId();
                        db.updateYear_Fund(yearid, fundId, gifttotal[0], gifttotal[1]);
                        Log.d(TAG, "loadFundYearsB: " + yearid);
                    }

                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

   /* //loads all of the giving periods associated with the fund.

    private void loadPeriods(String value, int fund_id) {
        ArrayList<Period> existingPeriods = db.getPeriods(fund_id);

        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempPeriods = json.names();

        for (int x = 0; x < tempPeriods.length(); x++) {
            try {
                if (!tempPeriods.getString(x).equals("@id")) {
                    JSONObject periodObj = json.getJSONObject(tempPeriods.getString(x));

                    Period period = new Period();
                    period.setName(periodObj.getString("name"));
                    period.setDate(periodObj.getString("period_desc"));

                    if (!existingPeriods.contains(period.getName())) {
                        db.addPeriod(period);
                        int temp_id = db.getLastId("period");
                        db.addFundPeriod(fund_id, temp_id);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }*/
    /*//load all transaction for a fund
    private void loadTransactions(String value, int fund_id) {
       // ArrayList<String> existingTransactions = db.getTransactions();
        ArrayList<String> existingConnections = new ArrayList<String>();

        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempTransactions = json.names();

        for (int x = 0; x < tempTransactions.length(); x++) {
            try {
                if (!tempTransactions.getString(x).equals("@id")) {
                    JSONObject transactionObj = json.getJSONObject(tempTransactions.getString(x));
                    System.out.println("There is a transaction here!");
                    JSONObject date = transactionObj.getJSONObject("trx_date");
                    JSONObject amount = transactionObj.getJSONObject("amount");

                    Gift gift = new Gift();
                    //gift.setGift_fund(transactionObj.getString("fund"));
                    gift.setName(transactionObj.getString("name"));
                    gift.setGift_amount(new int[]{
                            Integer.parseInt(amount.getString("wholepart")),
                            Integer.parseInt(amount.getString("fractionpart"))
                    });
                    gift.setGift_date(date.getString("year") + "-" + date.getString("month") + "-" + date.getString("day"));
                    gift.setGift_fund_desc(transactionObj.getString("fund_desc"));

                    if (!existingTransactions.contains(gift.getName())) {
                        db.addGift(gift);
                        int temp_id = db.getLastId("gift");
                        //db.addFundGift(fund_id, temp_id);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }*/

    /**
     * This formats the return json for every year related to an account
     * if the year and/or relationship do not exist they will be added.
     *
     * @param result, result from API GET for years
     */
    private void loadYears(String result){

        // Gather data from database to see what it already has
        ArrayList<String> currentYearNamesList = db.getYearNames();
        ArrayList<String> currentYearsForAccount = db.getYearNamesAccount(Account_ID);
        JSONObject json = null;
        try {
            json = new JSONObject(result);
        } catch (JSONException e1) {
            e1.printStackTrace();
        }
        if (json == null) {
            return;
        }
        JSONArray tempYears = json.names();

        for(int x = 0; x < tempYears.length(); x++){

            try{
                //@id signals a new object, but contains no information on that line
                if(!tempYears.getString(x).equals("@id")){
                    JSONObject YearObj = json.getJSONObject(tempYears.getString(x));
                    JSONObject giftObj = YearObj.getJSONObject("gift_total");
                    int[] gifttotal = {
                            Integer.parseInt(giftObj.getString("wholepart")),
                            Integer.parseInt(giftObj.getString("fractionpart"))
                    };
                    String name = YearObj.getString("name");
                    int yearid = db.getLastId("year") + 1;

                    if(gifttotal[1] >= 100){
                        gifttotal[1] /= 100;
                    }

                    Year temp = new Year();
                    temp.setName(name);
                    temp.setId(yearid);
                    temp.setGift_total(gifttotal);

                    // If the year doesn't exist yet.. add it and add the relationship
                    if(!currentYearNamesList.contains(name)){
                        db.addYear(temp);
                        db.addYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
                    }
                    // If the year exists but isn't related yet.. add the relationship
                    else if(!currentYearsForAccount.contains(name)){
                        yearid = db.getYear(name).getId();
                        db.addYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
                    }
                    // If the year and the relationship exist, update the values
                    else {
                        yearid = db.getYear(name).getId();
                        db.updateYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /**
     * This formats the return json into gifts and if the gift
     * was not already stored add it and a relationship to the related fund through the Fund_ID
     * and a relationship to the related year through the Year_ID
     *
     * @param result, result from API GET() for gifts
     * @param Year_ID, year related to gift
     * @param Fund_ID, fund related to gift
     */
    private void loadGifts(String result, int Year_ID, int Fund_ID, String donorName, int donorID){

        // Test to see what gifts the database already has to avoid duplicates
        ArrayList<String> currentGiftNameList = db.getGiftNames(Fund_ID, Year_ID);
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
                        int[] gifttotal = {
                                Integer.parseInt(amountObj.getString("wholepart")),
                                Integer.parseInt(amountObj.getString("fractionpart"))
                        };
                        int giftid = db.getLastId("gift") + 1;
                        String name = GiftObj.getString("name");

                        String gift_fund = GiftObj.getString("gift_fund");
                        String gift_fund_desc = GiftObj.getString("gift_fund_desc");
                        String gift_year = dateObj.getString("year");
                        String gift_month = dateObj.getString("month");

                        // Convert gift dates to YYYY-MM-DD format
                        gift_month = (gift_month.length() < 2)? "0" + gift_month : gift_month;
                        String gift_day = dateObj.getString("day");
                        gift_day = (gift_day.length() < 2)? "0" + gift_day : gift_day;
                        String gift_date = gift_year + "-"
                                + gift_month + "-" + gift_day;

                        String gift_check_num = GiftObj.getString("gift_check_num");

                        if(gifttotal[1] >= 100){
                            gifttotal[1] /= 100;
                        }

                        Gift temp = new Gift();
                        temp.setName(name);
                        temp.setId(giftid);
                        temp.setGiftFund(gift_fund);
                        temp.setGift_fund_desc(gift_fund_desc);
                        temp.setGift_date(gift_date);
                        temp.setGift_check_num(gift_check_num);
                        temp.setGift_amount(gifttotal);
                        temp.setGiftDonor(donorName);
                        temp.setGiftDonorId(donorID);
                        temp.setGiftYear(gift_year);
                        temp.setGiftMonth(gift_month);

                        db.addGift(temp);
                        db.addGift_Year(giftid, Year_ID);
                        db.addGift_Fund(giftid, Fund_ID);
                        db.addGift_Account(giftid, Account_ID);
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

    /*
    loads comments on posts
     */
    private void loadComments(String result){

        //check to see what the database already has
        ArrayList<Comment> currentComments = db.getComments();
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

                    if(!currentComments.contains(CommentObj.getString("comment_id"))){
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
                        temp.setSenderID(Account_ID);
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
                            db.addNew_Item(Calendar.getInstance().getTimeInMillis() + "", "Comment", "New Comment on a post from " + db.getNoteForID(temp.getNoteID()).getMissionaryName());
                        }
                    }
                }
            }
            catch(JSONException e){
                e.printStackTrace();
            }
        }
    }

}