package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import org.json.JSONObject;
import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.PostJson;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * @author otter57
 * created on 7/12/16.
 *
 * allows user to post update letters
 */
public class PostLetterActivity extends Activity {
    private TextView  sender, contactType;
    private EditText noteText, subject;
    private String senderName;
    private Account account;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.post_note_layout);

        sender           = (TextView) findViewById(R.id.senderName);
        contactType      = (TextView) findViewById(R.id.typeText);
        subject          = (EditText)findViewById(R.id.contentText);
        noteText         = (EditText)findViewById(R.id.noteText);
        Button submit    = (Button)  findViewById(R.id.submitButton);
        Button cancel    = (Button)  findViewById(R.id.cancelButton);

        if (getActionBar() != null) {
            getActionBar().setTitle("Send Letter");
        }

        // Load list of user names from accounts for user to choose who message is from
        final LocalDBHandler db = new LocalDBHandler(this);
        account = db.getAccount();

        //set sender name
        senderName = account.getAccountName();
        sender.setText(senderName);
        contactType.setText("Letter");

        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                String messageStr = noteText.getText().toString();
                String subjectStr = subject.getText().toString();

                // If any field is blank, prompt user to fill the field
                if (messageStr.equals("")) {
                    Toast.makeText(PostLetterActivity.this,
                            "You have not entered a message!", Toast.LENGTH_SHORT).show();
                /*} else if (subjectStr.equals("")) {
                    Toast.makeText(PostLetterActivity.this,
                            "Please set a subject for this message", Toast.LENGTH_SHORT).show();*/
                } else {
                    boolean PDFCreated = createPDF(messageStr, subjectStr);

                    if (PDFCreated) {
                        //submit stuffs
                        try {


                            //post update
                            String postURL = account.getProtocal() +"://" + account.getServerName() + ":"
                                    + account.getPort() + "/apps/kardia/api/missionary/" + account.getId()
                                    + "/PrayerLetters?cx__mode=rest&cx__res_format=attrs&cx__res_attrs=basic&cx__res_type=collection";
                            JSONObject newLetter = new JSONObject();
                            JSONObject dateCreated = new JSONObject();

                            //set date for note
                            Calendar calendar = Calendar.getInstance();
                            dateCreated.put("year", calendar.get(Calendar.YEAR));
                            dateCreated.put("month", calendar.get(Calendar.MONTH) + 1);
                            dateCreated.put("day", calendar.get(Calendar.DAY_OF_MONTH));
                            dateCreated.put("hour", calendar.get(Calendar.HOUR_OF_DAY));
                            dateCreated.put("minute", calendar.get(Calendar.MINUTE));
                            dateCreated.put("second", calendar.get(Calendar.SECOND));

                            //set newNote
                            newLetter.put("e_doc_type_id", 2);
                            newLetter.put("e_title", subjectStr);
                            newLetter.put("e_orig_filename", subjectStr + " - " + account.getId() + ".pdf");
                            newLetter.put("e_current_folder", "/apps/kardia/files");
                            newLetter.put("e_current_filename", subjectStr + " - " + account.getId() + ".pdf");
                            newLetter.put("e_uploading_collaborator", account.getId() + "");
                            newLetter.put("s_date_created", dateCreated);
                            newLetter.put("s_created_by", senderName);
                            newLetter.put("s_date_modified", dateCreated);
                            newLetter.put("s_modified_by", senderName);

                            PostJson postJson = new PostJson(getBaseContext(), postURL, newLetter, account);
                            postJson.execute();

                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        //refresh the screen after post
                        //this probably won't work because separate threads and what not
                        new DataConnection(getBaseContext(), null, account, -1);

                        finish();
                    }
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
        new AlertDialog.Builder(PostLetterActivity.this)
                .setCancelable(false)
                .setTitle("Cancel")
                .setMessage("Exit without posting update?")
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

    // Method for creating a pdf file from text, saving it then opening it for display
    public boolean createPDF(String text, String subject) {

        Document doc = new Document();
        String filename = "";

        try {
            String path = Environment.getExternalStorageDirectory().getAbsolutePath() + "/Dir";

            File dir = new File(path);
            if(!dir.exists())
                dir.mkdirs();

            String formattedDate = new SimpleDateFormat("yyyy_MM_dd").format(new Date());
            filename = account.getAccountName() + formattedDate + ".pdf";
            File file = new File(dir, filename);
            FileOutputStream fOut = new FileOutputStream(file);

            PdfWriter.getInstance(doc, fOut);

            //open the document
            doc.open();

            Paragraph h1 = new Paragraph(subject);

            Paragraph p1 = new Paragraph(text);
            p1.setAlignment(Paragraph.ALIGN_LEFT);
            h1.setAlignment(Paragraph.ALIGN_CENTER);



            //add paragraph to document
            doc.add(h1);
            doc.add(p1);

        } catch (DocumentException de) {
            Log.e("PDFCreator", "DocumentException:" + de);
        } catch (IOException e) {
            Log.e("PDFCreator", "ioException:" + e);
        }
        finally {
            doc.close();
        }
        if (filename != "")
            viewPdf(filename, "Dir");

        return false;
    }

    private void viewPdf(String file, String directory) {

        File pdfFile = new File(Environment.getExternalStorageDirectory() + "/" + directory + "/" + file);
        Uri path = Uri.fromFile(pdfFile);

        // Setting the intent for pdf reader
        Intent pdfIntent = new Intent(Intent.ACTION_VIEW);
        pdfIntent.setDataAndType(path, "application/pdf");
        pdfIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        try {
            startActivity(pdfIntent);
        } catch (ActivityNotFoundException e) {
            Toast.makeText(PostLetterActivity.this, "Can't read pdf file", Toast.LENGTH_SHORT).show();
        }
    }


    }