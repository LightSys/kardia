package org.lightsys.missionaryapp.tools;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;
import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.NewItem;
import java.util.ArrayList;
import java.util.Calendar;

/**
 * @author Judah Sistrunk
 * created on 5/25/2016.

 * service class that automatically updates local database with server database
 */
public class AutoUpdater extends Service {

    //time constants in milliseconds
    private static final int ONE_SECOND     = 1000;
    private static final int ONE_MINUTE     = ONE_SECOND * 60;
    private static final int THIRTY_MINUTES = ONE_MINUTE * 30;
    private static final int ONE_HOUR       = ONE_MINUTE * 60;
    private static final int TWELVE_HOURS   = ONE_HOUR * 12;
    private static final int ONE_DAY        = ONE_HOUR * 60;
    private static final int ONE_WEEK       = ONE_DAY * 7;
    private static final int NEVER          = -1;

    private final LocalDBHandler db; //local database
    private int   notificationID = 0; //ID of an update notification

    private int      updateMillis = NEVER; //number of milliseconds between updates
    private Calendar prevDate     = Calendar.getInstance();


    //custom timer that ticks every minute
    //used to constantly check to see if it's time to check for updates
    private final Handler  timerHandler  = new Handler();

    public AutoUpdater() {
        db = new LocalDBHandler(this);
        Runnable timerRunnable = new Runnable() {
            @Override
            public void run() {
                String updatePeriod; //period between updates

                String[] updatePeriods = getResources().getStringArray(R.array.refresh_times);
                //get update period
                updatePeriod = db.getRefreshPeriod();
                db.close();

                Calendar currentDate = Calendar.getInstance();

                //figure out how many milliseconds the update period is
                if (updatePeriod.equals(updatePeriods[0])) {
                    updateMillis = NEVER;
                } else if (updatePeriod.equals(updatePeriods[1])) {
                    updateMillis = ONE_MINUTE;
                } else if (updatePeriod.equals(updatePeriods[2])) {
                    updateMillis = THIRTY_MINUTES;
                } else if (updatePeriod.equals(updatePeriods[3])) {
                    updateMillis = ONE_HOUR;
                } else if (updatePeriod.equals(updatePeriods[4])) {
                    updateMillis = TWELVE_HOURS;
                } else if (updatePeriod.equals(updatePeriods[5])) {
                    updateMillis = ONE_DAY;
                } else if (updatePeriod.equals(updatePeriods[6])) {
                    updateMillis = ONE_WEEK;
                }

                //difference between the previous time and the current time
                long elapsedTime = currentDate.getTimeInMillis() - prevDate.getTimeInMillis();

                //check to see if the time elapsed is greater than the update period
                if (elapsedTime > updateMillis && updateMillis > 0) {
                    getUpdates();
                    prevDate = Calendar.getInstance();
                }

                //resets timer continuously
                timerHandler.postDelayed(this, ONE_MINUTE);
            }
        };
        timerHandler.postDelayed(timerRunnable, ONE_SECOND);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        //keeps service running after app is shut down
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent arg0) {
        // TODO Auto-generated method stub
        return null;
    }

    private  void getUpdates()
    {
        Account account = db.getAccount();
        db.close();

        //updates each account
           new DataConnection(this, null, account, -1).execute("");

        //list of new notifications
        ArrayList<NewItem> newItems = db.getNewItems();

        //send notifications
        for (NewItem item : newItems) {
            notificationID++;
            sendNotification("New " + item.getItemType(), item.getItemMessage(), notificationID);
        }

        db.deleteNewItems();
    }

    private void sendNotification(String title, String subject, int ID){
        Context context = this;
        NotificationManager notificationManager = (NotificationManager)
                context.getSystemService(NOTIFICATION_SERVICE);
        NotificationCompat.Builder nBuild;
        Notification n;

        // Build the notification to be sent
        // BigTextStyle allows notification to be expanded if text is more than one line
        nBuild = new NotificationCompat.Builder(context)
                .setContentTitle(title)
                .setContentText(subject)
                .setSmallIcon(R.drawable.kardiabeat_v2)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(subject));

        n = nBuild.build();
        notificationManager.notify(ID, n);
    }

}
