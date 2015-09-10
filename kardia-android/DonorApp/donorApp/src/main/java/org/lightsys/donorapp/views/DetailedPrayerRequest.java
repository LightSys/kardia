package org.lightsys.donorapp.views;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;

/**
 * Created by JoshWorkman on 3/10/2015.
 * This activity displays the expanded form of a prayerRequest
 * Primarily displays Subject, Date submitted, and request text
 * It also includes a button that opens a menu to set reminders to pray for the request
 */
public class DetailedPrayerRequest extends Fragment{

    final static String ARG_REQUEST_ID = "request_id";
    int request_id = -1;
    private Button prayerReminder;
    private TextView instr, textAbove;
    private Note request;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.prayer_request_detailedview, container, false);
        getActivity().setTitle("Prayer Request");
        return v;
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateRequestView(args.getInt(ARG_REQUEST_ID));
        }
        else if(request_id != -1){
            updateRequestView(request_id);
        }
     }

     /**
     * Sets the text fields with the detailed information about the prayer request
     * @param request_id, Request Identification
     */

    public void updateRequestView(final int request_id){
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);

        TextView missionaryName = (TextView)getActivity().findViewById(R.id.missionaryName);
        TextView subject = (TextView)getActivity().findViewById(R.id.subject);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView text = (TextView)getActivity().findViewById(R.id.text);
        textAbove = (TextView)getActivity().findViewById(R.id.textAbovePrayingButton);
        instr = (TextView)getActivity().findViewById(R.id.prayButtonInstr);
        prayerReminder = (Button)getActivity().findViewById(R.id.scheduleNotification);

        request = db.getNoteForID(request_id);
        this.request_id = request_id;

        missionaryName.setText(request.getMissionaryName());
        subject.setText("Subject: " + request.getSubject());
        date.setText("Date Posted: " + Formatter.getFormattedDate(request.getDate()));
        text.setText(request.getText());

        if (request.getIsPrayedFor()) {
            prayerReminder.setBackground(getResources().getDrawable(R.drawable.active_praying_hands_icon));
        } else {
            textAbove.setText("Not Yet");
            instr.setText("Press this button to signify you will be praying/giving thanks for this item");
            prayerReminder.setBackground(getResources().getDrawable(R.drawable.inactive_praying_hands_icon));
        }


        prayerReminder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Does not allow user to launch notification activity a second time
                if (request.getIsPrayedFor()) {
                    Toast.makeText(getActivity(), "You are already praying for this item!",
                            Toast.LENGTH_SHORT).show();
                } else {
                    // Ask user if they would like notifications
                    new AlertDialog.Builder(getActivity())
                            .setCancelable(false)
                            .setTitle("Set Notifications")
                            .setMessage("Would you like to set notifications to remind you to" +
                                    " pray/give thanks for this item?")
                            .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // Launch notification activity
                                    Intent notification = new Intent(getActivity(), PrayerNotificationActivity.class);
                                    notification.putExtra("requestid", request_id);
                                    startActivityForResult(notification, 0);
                                }
                            })
                            .setNegativeButton("No", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    // return, but still set button to prayed for
                                    updateDbToPrayedFor();
                                    textAbove.setText("");
                                    instr.setText("");
                                    prayerReminder.setBackground(getResources().getDrawable(R.drawable.active_praying_hands_icon));
                                }
                            })
                            .setIcon(android.R.drawable.ic_dialog_alert)
                            .show();
                }
            }
        });
    }

    /**
     * Updates prayer request to signify it is being prayed for
     */
    private void updateDbToPrayedFor() {
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        db.updateNote(request_id, true);
        request = db.getNoteForID(request_id);
        db.close();
    }

    /**
     * Called when returning from notification activity
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        updateDbToPrayedFor();
    }

    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_REQUEST_ID, request_id);
    }
}
