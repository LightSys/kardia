package org.lightsys.donorapp;

import android.app.Activity;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.NotificationCompat;
import android.view.ContextMenu;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.PopupWindow;
import android.widget.Spinner;
import android.widget.TextView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.PrayerRequest;

/**
 * Created by JoshWorkman on 3/10/2015.
 * This activity displays the expanded form of a prayerRequest\
 * Primarily displays Subject, Date submitted, and request text
 * It also includes a blank button that opens an incomplete menu to set reminders to pray for the request
 */
public class DetailedPrayerRequest extends Fragment{

    final static String ARG_REQUEST_ID = "request_id";
    int request_id = -1;
    private static boolean popupOpen = false;
    private PopupWindow popupWindow;
    private Button popupButton;
    private PrayerRequest request;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.prayer_request_detailedview, container, false);

        popupButton =(Button) v.findViewById(R.id.scheduleNotification);
        popupButton.setOnClickListener(new togglePopup());

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
     * This function sets the text for the gift's information
     *
     * @param id, the gift's id.
     */

    public void updateRequestView(int request_id){
        TextView title = (TextView)getActivity().findViewById(R.id.title);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        TextView summary = (TextView)getActivity().findViewById(R.id.summary);

//        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
//        Gift g = db.getGift(request_id);
        request = null;
        for(PrayerRequest p: PrayerRequestList.getPrayerRequests()) {
            if (p.getIntId() == request_id) {
                request = p;
                break;
            }
        }
        if(request!=null) {
            title.setText(request.getSubject());
            date.setText("Date: " + request.getDate());
            summary.setText("Request: " + request.getText());
        }
        this.request_id = request_id;
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

    public class togglePopup implements Button.OnClickListener{

        public void onClick(View view)
        {
            if(!popupOpen)
            {
                LayoutInflater layoutInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                View popupView = layoutInflater.inflate(R.layout.prayer_notification_layout, null);
                popupWindow = new PopupWindow(popupView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                popupWindow.showAsDropDown(popupButton, 0, 0);
                popupOpen=true;
            }
            else
            {
                //TODO: get state and number of occurences from spinner
                String state = "ON";//((Spinner)getActivity().findViewById(R.id.on_off)).getSelectedItem().toString();
                int occurences =1;// Integer.parseInt(((Spinner)view.findViewById(R.id.times_day)).getSelectedItem().toString());
                if(state.equals("ON"))
                {
                    for(int i=0;i<occurences;i++) {
                        NotificationCompat.Builder builder = new NotificationCompat.Builder(getActivity()).setContentTitle(request.getSubject()).setContentText(request.getText());
                        Intent intent = new Intent(getActivity(), getActivity().getClass());
//                    The stack builder object will contain an artificial back stack for the
//                    started Activity.
//                    This ensures that navigating backward from the Activity leads out of
//                    your application to the Home screen.
                        TaskStackBuilder stackBuilder = TaskStackBuilder.create(getActivity());
//                    Adds the back stack for the Intent (but not the Intent itself)
                        stackBuilder.addParentStack(getActivity().getClass());
//                    Adds the Intent that starts the Activity to the top of the stack
                        stackBuilder.addNextIntent(intent);
                        PendingIntent resultPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT);
                        builder.setContentIntent(resultPendingIntent);
                        NotificationManager mNotificationManager = (NotificationManager) getActivity().getSystemService(Context.NOTIFICATION_SERVICE);
//                    mId allows you to update the notification later on.
                        mNotificationManager.notify(0, builder.build());
                    }
                }
                popupWindow.dismiss();
                popupOpen=false;
            }
        }
    }
}
