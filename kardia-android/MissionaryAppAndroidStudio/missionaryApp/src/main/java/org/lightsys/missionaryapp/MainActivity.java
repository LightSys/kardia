package org.lightsys.missionaryapp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.LocalDBHandler;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.Prayer;
import org.lightsys.missionaryapp.data.PrayerReplies;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

/**
 * This activity is used to login and load the user's information
 * or send them to the OptionsActivity if they are already loged in
 *
 * @author Andrew Cameron
 */
public class MainActivity extends Activity {
    private EditText username, password, serveraddress, userid;
    private static String Host_Name, Password, User_Name, User_Id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LocalDBHandler db = new LocalDBHandler(this, null, null, 1);
        if (db.hasAccount()) {
            goToHome();
        } else {
            setContentView(R.layout.login);

            username = (EditText) findViewById(R.id.username);
            password = (EditText) findViewById(R.id.password);
            serveraddress = (EditText) findViewById(R.id.serveraddress);
            userid = (EditText) findViewById(R.id.userid);
        }
    }

    public void login(View v) {
        if (!username.getText().toString().equals("") &&
                !password.getText().toString().equals("") &&
                !serveraddress.getText().toString().equals("") &&
                !userid.getText().toString().equals("")) {

            User_Name = username.getText().toString();
            Password = password.getText().toString();
            Host_Name = serveraddress.getText().toString();
            User_Id = userid.getText().toString();
            Log.d("BasicAuth", "About to attempt background task.");
            new DataConnection().execute("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + User_Id + "?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic");
        }
    }

    public void goToHome() {
        Intent intent = new Intent(this, OptionsActivity.class);
        startActivity(intent);
        finish();
    }


    /**
     * This is used for pulling the information from the backend
     * in the background and storing it to the local database.
     *
     * @author Andrew Cameron
     */
    public class DataConnection extends AsyncTask<String, Integer, String> {


        @Override
        protected String doInBackground(String... testUrl) {
            //get the fundmanager
            //then pull down stuff related to them and store it in the local database.

            // Get The Manager's Funds: (not detailed enough, other queries must be made to get the balances) (maybe don't need this query?)
            // "http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + User_Id + "/Funds?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"

            //Get the list of periods:
            // "http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + User_Id + "/Funds/" + Period + "/Periods?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"

            //Get list of transactions for the period:
            // "http://" +  + ":800/apps/kardia/api/fundmanager/" +  + "/Funds/" +  + "/Periods/" +  + "/Transactions?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"

            String returnVal = GET(testUrl[0]);

            if (returnVal != null && !returnVal.equals("") && !returnVal.contains("Unauthorized")) {
                publishProgress(1);
                DataPull();
                return returnVal; //TODO: replace with something else
            } else {
                return null;
            }

        }

        @Override
        protected void onProgressUpdate(Integer... values) {
            Toast.makeText(MainActivity.this, "Loading account information", Toast.LENGTH_LONG).show();
        }

        @Override
        protected void onPostExecute(String params) {

            Log.d("BasicAuth", "Return parameters were:  " + params);

            if (params == null || params.contains("Unauthorized")) {

                Toast.makeText(MainActivity.this, "Incorrect User name or Password.", Toast.LENGTH_SHORT).show();
            } else {

                Toast.makeText(MainActivity.this, "Login Successful", Toast.LENGTH_SHORT).show();
                goToHome();
            }
        }
    }


    private void DataPull() {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);

        db.addAccount(new Account(User_Name, Password, Host_Name, Integer.parseInt(User_Id)));

        loadFunds(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/"
                + User_Id + "/Funds?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"));
        System.out.println("How many funds? " + db.getFunds());
        for (Fund f : db.getFunds()) {
            System.out.println("Looking at new fund: " + f.getName());
            String string = f.getName();
            string = string.replace("|", "%7C");
            loadPeriods(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + User_Id + "/Funds/"
                    + string + "/Periods?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), f.getId());

            for (Period p : db.getPeriods(f.getId())) {
                System.out.println("Looking at new Period");
                String string2 = p.getName();
                string2 = string2.replace("|", "%7C");
                loadTransactions(GET("http://" + Host_Name + ":800/apps/kardia/api/fundmanager/" + User_Id + "/Funds/" + string + "/Periods/"
                        + string2 + "/Transactions?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), f.getId());
            }
        }

        loadDonors(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + User_Id +
                "/Supporters?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"));

        loadPrayers(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + User_Id +
                "/Notes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"));

        for (Prayer p : db.getPrayers()) {
            loadWhoPrays(GET("http://" + Host_Name + ":800/apps/kardia/api/missionary/" + User_Id + "/Notes/" + p.getID() +
                    "/Prayers?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"), p);
        }

    }


    public static String GET(String url) {
        InputStream inputStream = null;
        String result = "";

        try {

            CredentialsProvider credProvider = new BasicCredentialsProvider();
            credProvider.setCredentials(new AuthScope(Host_Name, 800),
                    new UsernamePasswordCredentials(User_Name, Password));

            DefaultHttpClient client = new DefaultHttpClient();

            client.setCredentialsProvider(credProvider);

            HttpResponse response = client.execute(new HttpGet(url));

            inputStream = response.getEntity().getContent();

            if (inputStream != null) {
                result = convertInputStreamToString(inputStream);
            } else {
                result = "err";
            }
        } catch (Exception e) {
            Log.d("BasicAuth", "Broke on attempt. Err: " + e.getLocalizedMessage());
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
    private static String convertInputStreamToString(InputStream in) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        String line = "", result = "";

        while ((line = reader.readLine()) != null) {
            result += line;
        }
        in.close();
        return result;
    }


    private void loadFunds(String value) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<String> existingFunds = db.getFundNames();

        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempFunds = json.names();

        for (int x = 0; x < tempFunds.length(); x++) {
            try {
                if (!tempFunds.getString(x).equals("@id")) {
                    JSONObject fundObj = json.getJSONObject(tempFunds.getString(x));

                    Fund temp = new Fund();
                    temp.setName(fundObj.getString("name"));
                    temp.setFund_desc(fundObj.getString("fund_desc"));
                    temp.setFund_class(fundObj.getString("fund_class"));
                    temp.setAnnotation(fundObj.getString("annotation"));

                    if (!existingFunds.contains(temp.getName())) {
                        db.addFund(temp);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }

    private void loadPeriods(String value, int fund_id) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<String> existingPeriods = db.getPeriodNames();
        ArrayList<String> existingConnections = db.getPeriodNames(fund_id);

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
                    period.setFundName("" + fund_id);

                    if (!existingPeriods.contains(period.getName())) {
                        db.addPeriod(period);
                        int temp_id = db.getLastId("period");
                        db.addFundPeriod(fund_id, temp_id);
                    } else if (!existingConnections.contains(period.getName())) {
                        int temp_id = db.getPeriodId(period.getName());
                        db.addFundPeriod(fund_id, temp_id);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }

    private void loadTransactions(String value, int fund_id) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<String> existingTransactions = db.getTransactions();
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
                    gift.setGift_fund(transactionObj.getString("fund"));
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
                        db.addFundGift(fund_id, temp_id);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }

    private void loadDonors(String value) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<Donor> donors = db.getDonor();


        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempDonors = json.names();
        for (int x = 0; x < tempDonors.length(); x++) {

            try {
                if (!tempDonors.getString(x).equals("@id")) {
                    JSONObject fundObj = json.getJSONObject(tempDonors.getString(x));

                    Donor temp = new Donor();
                    temp.setName(fundObj.getString("partner_name"));
                    temp.setId(fundObj.getInt("name"));
                    //temp.setEmail(fundObj.getString("email"));
                    //temp.setCellNumber(fundObj.getString("cellnumber"));

                    if(!donors.contains(temp)){
                        db.addDonor(temp);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }

    private void loadPrayers(String value) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<Prayer> existingPrayers = db.getPrayers();

        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempPrayer = json.names();

        for (int x = 0; x < tempPrayer.length(); x++) {
            try {
                if (!tempPrayer.getString(x).equals("@id")) {
                    JSONObject fundObj = json.getJSONObject(tempPrayer.getString(x));

                    Prayer temp = new Prayer();
                    temp.setSubject(fundObj.getString("note_subject"));
                    temp.setDescription(fundObj.getString("note_text"));
                    JSONObject date = fundObj.getJSONObject("note_date");
                    temp.setDate(date.getString("year") + "-" + date.getString("month") + "-" + date.getString("day"));
                    temp.setID(fundObj.getInt("note_id"));

                    if(!existingPrayers.contains(temp)){
                        db.addPrayer(temp);

                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }

    private void loadWhoPrays(String value, Prayer prayer) {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 1);
        ArrayList<PrayerReplies> existingPrayers = db.getPeoplePraying(prayer);

        JSONObject json = null;
        try {
            json = new JSONObject(value);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JSONArray tempPrayer = json.names();

        for (int x = 0; x < tempPrayer.length(); x++) {

            try {
                if (!tempPrayer.getString(x).equals("@id")) {
                    JSONObject fundObj = json.getJSONObject(tempPrayer.getString(x));

                    PrayerReplies temp = new PrayerReplies();
                    temp.setComment(fundObj.getString("prayedfor_comments"));
                    temp.setPrayerID(fundObj.getInt("note_id"));
                    JSONObject date = fundObj.getJSONObject("prayedfor_date");
                    prayer.setDate(date.getString("year") + "-" + date.getString("month") + "-" + date.getString("day"));
                    temp.setID(fundObj.getInt("prayedfor_id"));
                    temp.setName(fundObj.getString("supporter_partner_name"));

                    if(!existingPrayers.contains(temp)){
                        db.addPraying(temp);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        db.close();
    }
}
