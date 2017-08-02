package org.lightsys.missionaryapp.tools;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

/**
 * @author Andrew Lockridge
 * created on 7/22/2015.
 *
 * Attempts to download a PDF from the Kardia API and display it
 * Once the pdf is downloaded, it will remain locally on the device for quick retrieval
 */
public class DownloadPDF extends AsyncTask<String, Void, String> {
    private final String         url, server, username, password, outputDir, outputFile;
    private final Activity       dataActivity;
    private final Context        dataContext;
    private final ProgressDialog spinner;

    public DownloadPDF(String url, String server, String username, String password,
                       String outputDir, String outputFile, Activity activity, Context context) {
        this.url          = url;
        this.server       = server;
        this.username     = username;
        this.password     = password;
        this.outputDir    = outputDir;
        this.outputFile   = outputFile;
        this.dataActivity = activity;
        this.dataContext  = context;
        spinner           = new ProgressDialog(dataContext, R.style.MySpinnerStyle);
        spinner.setMessage("Downloading...");
        spinner.setIndeterminate(true);
        spinner.setCancelable(false);
    }


    @Override
    protected String doInBackground(String... params) {
        InputStream inputStream;

        // Show the "Downloading..." spinner
        dataActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                spinner.show();
            }
        });
        try {

            // Set the user's credentials
            CredentialsProvider credProvider = new BasicCredentialsProvider();
            credProvider.setCredentials(new AuthScope(server, 800),
                    new UsernamePasswordCredentials(username, password));

            DefaultHttpClient client = new DefaultHttpClient();
            client.setCredentialsProvider(credProvider);
            HttpResponse response = client.execute(new HttpGet(url));

            // Create a new file and connect the outputStream to this new file
            File output = new File(outputDir, outputFile);
            FileOutputStream fStream = new FileOutputStream(output);
            inputStream = response.getEntity().getContent();

            // Transfer all data from the API to the output file
            byte[] buffer = new byte[1024];
            int length;
            while ( (length = inputStream.read(buffer)) > 0 ) {
                fStream.write(buffer,0, length);
            }
            fStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Executes after downloading the file if successful
    @Override
    protected void onPostExecute(String params) {
        dataActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Remove the "Downloading..." spinner
                    spinner.dismiss();

                    // Launch the new file with a pdf application
                    Intent pdfIntent = new Intent(Intent.ACTION_VIEW);
                    File file = new File(outputDir, outputFile);
                    pdfIntent.setDataAndType(Uri.fromFile(file), "application/pdf");
                    dataActivity.startActivity(pdfIntent);
                } catch (ActivityNotFoundException e) {
                    // If no application is found, display message to user
                    Toast.makeText(dataContext, "To view this document, you must install a PDF" +
                            "viewing application", Toast.LENGTH_LONG).show();
                    e.printStackTrace();
                }

            }
        });
    }
}
