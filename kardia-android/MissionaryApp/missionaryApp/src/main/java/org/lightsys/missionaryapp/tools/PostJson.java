package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.os.AsyncTask;
import android.util.Base64;
import android.util.Log;
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
import org.lightsys.missionaryapp.data.Account;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;

import javax.net.ssl.HttpsURLConnection;

/**
 * @author Judah Sistrunk
 * created on 7/7/2016.
 *
 * This class takes a json object a url and an account and posts the json object to the server
 */
public class PostJson extends AsyncTask<String, Void, String> {

    private static final String TAG = "post JSon";
    private final Account    account;
    private String           url       = "";
    private String           backupUrl = "";
    private final JSONObject jsonObject;
    private final Context    context;
    private boolean          success   = false;

    public PostJson(Context context, String Url, JSONObject jsonPost, Account userAccount){
        this.url        = Url;
        this.backupUrl  = Url;
        this.jsonObject = jsonPost;
        this.account    = userAccount;
        this.context    = context;
    }


    @Override
    protected String doInBackground(String... params) {

        //the get request for the access token is done in httpClient
        //the post request was done in httpUrlConnection
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
            String getUrl = "http://" + account.getServerName() + ":800/?cx__mode=appinit&cx__groupname=Kardia&cx__appname=Missionary";

            //set up http connection
            HttpParams HttpParams = new BasicHttpParams();
            HttpConnectionParams.setConnectionTimeout(HttpParams, 10000);
            HttpConnectionParams.setSoTimeout(HttpParams, 10000);

            DefaultHttpClient client = new DefaultHttpClient(HttpParams);

            client.setCredentialsProvider(credProvider);

            HttpResponse response = client.execute(new HttpGet(getUrl));

            inputStream = response.getEntity().getContent();

            //get access token
            if (inputStream != null) {
                result = convertInputStreamToString(inputStream);
                JSONObject token = new JSONObject(result);

                //store cookies for use later by the httpUrlConnection
                org.apache.http.client.CookieStore cookies = client.getCookieStore();

                url += "&cx__akey=" + token.getString("akey");

                //post json object
                performPostCall(cookies, url, jsonObject);


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
        function that posts a json object to the server
    */
    private String performPostCall(org.apache.http.client.CookieStore cookies, String requestURL, JSONObject jsonObject) {

        URL url;
        String response = "";
        try {

            url = new URL(requestURL);

            //credentials
            String auth = account.getAccountName() + ":" + account.getAccountPassword();

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(15000);//15 second time out
            conn.setConnectTimeout(15000);
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);

            //set creds and cookies
            conn.setRequestProperty("Authorization", "Basic " +
                    Base64.encodeToString(auth.getBytes(), Base64.NO_WRAP));
            conn.setRequestProperty("Cookie", "CXID=" + cookies.getCookies().get(0).getValue() + "; path=/");
            conn.setRequestProperty("Content-Type", "application/json");

            //get json object ready to send
            String str = jsonObject.toString();
            byte[] outputBytes = str.getBytes("UTF-8");
            OutputStream os = conn.getOutputStream();
            os.write(outputBytes);//send json object

            int responseCode = conn.getResponseCode();
            Log.e(TAG, "responseCode : " + responseCode);

            //if the things were sent properly, get the response code
            if (responseCode == HttpsURLConnection.HTTP_CREATED) {
                Log.e(TAG, "HTTP_OK");

                success = true;

                String line;
                BufferedReader br = new BufferedReader(new InputStreamReader(
                        conn.getInputStream()));
                while ((line = br.readLine()) != null) {
                    response += line;
                }
            } else {
                Log.e(TAG, "False - HTTP_OK");//send failed :(
                response = "";
                success = false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return response;
    }

    //unfinished attempt to switch usage of http client to url connection
    /*public JSONObject getAccessToken(HttpURLConnection connection, String tokenUrl, Account account){

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

            //if the thing was sent properly, get the response code
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

    }*/

    @Override
    protected void onPostExecute(String params) {

        if (success) {
            Toast.makeText(context, "Data posted successfully!", Toast.LENGTH_SHORT).show();
            DataConnection connection = new DataConnection(context, null, account);
            connection.execute();
        }
        else {
            Toast.makeText(context, "Network Issues: Your data is waiting to be sent", Toast.LENGTH_SHORT).show();
            String jsonString = jsonObject.toString();
            LocalDBHandler db = new LocalDBHandler(context, null);
            db.addJson_post(Calendar.getInstance().getTimeInMillis(), backupUrl, jsonString, account.getId());

        }
    }


}

