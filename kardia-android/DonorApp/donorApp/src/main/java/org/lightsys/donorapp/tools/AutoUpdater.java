package org.lightsys.donorapp.tools;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import com.example.donorapp.R;
import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.NewItem;
import java.util.ArrayList;
import java.util.Calendar;

/**
 * service class that automatically updates local database with server database
 * Created by Judah Sistrunk on 5/25/2016.
 */
public class AutoUpdater extends Service {

    //time constants in milliseconds
    private static final int ONE_SECOND = 1000;
    private static final int ONE_MINUTE = ONE_SECOND * 60;
    private static final int THIRTY_MINUTES = ONE_MINUTE * 30;
    private static final int ONE_HOUR = ONE_MINUTE * 60;
    private static final int TWELVE_HOURS = ONE_HOUR * 12;
    private static final int ONE_DAY = ONE_HOUR * 60;
    private static final int ONE_WEEK = ONE_DAY * 7;
    private static final int NEVER = -1;

    private static final String TAG = "donorapp.autoupdater"; //tag used for log notes
    LocalDBHandler db; //local database
    int notificationID = 0; //ID of an update notification

    String updatePeriod = "Minute"; //period between updates
    int updateMillis = NEVER; //number of milliseconds between updates
    int updateCounter = 0; //seconds between updates
    Calendar currentDate = Calendar.getInstance();
    Calendar prevDate = Calendar.getInstance();


    //custom timer like thing that ticks every minute
    //used to constantly check to see if it's time to check for updates
    private Handler timerHandler = new Handler();


    public AutoUpdater() {

        Runnable timerRunnable = new Runnable() {
            @Override
            public void run() {

                String[] updatePeriods = getResources().getStringArray(R.array.refresh_times);
                //get update period
                updatePeriod = db.getRefreshPeriod();
                db.close();

                currentDate = Calendar.getInstance();

                //figure out how many milliseconds the update period is
                if (updatePeriod.equals(updatePeriods[0])){
                    updateMillis = NEVER;
                }
                else if (updatePeriod.equals(updatePeriods[1])) {
                    updateMillis = ONE_MINUTE;
                }
                else if (updatePeriod.equals(updatePeriods[2])){
                    updateMillis = THIRTY_MINUTES;
                }
                else if (updatePeriod.equals(updatePeriods[3])){
                    updateMillis = ONE_HOUR;
                }
                else if (updatePeriod.equals(updatePeriods[4])){
                    updateMillis = TWELVE_HOURS;
                }
                else if (updatePeriod.equals(updatePeriods[5])){
                    updateMillis = ONE_DAY;
                }
                else if (updatePeriod.equals(updatePeriods[6])){
                    updateMillis = ONE_WEEK;
                }

                //difference between the previous time and the current time
                long elapsedTime = currentDate.getTimeInMillis() - prevDate.getTimeInMillis();

                //check to see if the time elapsed is greater than the update period
                if (elapsedTime > updateMillis && updateMillis > 0){
                    getUpdates();
                    updateCounter = 0;
                    prevDate = Calendar.getInstance();
                }
                updateCounter++;
                timerHandler.postDelayed(this, ONE_MINUTE);//resets timer continuously
            }
        };

        db = new LocalDBHandler(this, null);
        timerHandler.postDelayed(timerRunnable, ONE_SECOND);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY; //keeps service running after app is shut down
    }

    @Override
    public IBinder onBind(Intent arg0) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    private  void getUpdates()
    {
        ArrayList<Account> accts = db.getAccounts();
        db.close();

        for (Account a : accts) {//updates each account
           new DataConnection(this, null, a).execute("");
        }

        ArrayList<NewItem> newItems = db.getNewItems(); //list of new notifications
        for (NewItem item : newItems) {//send notifications
            notificationID++;
            sendNotification("New " + item.getItemType(), item.getItemMessage(), notificationID);
        }

        db.deleteNewItems();
        Log.d(TAG, "Updated");
    }

    public void sendNotification(String title, String subject, int ID){
        Context context = this;
        NotificationManager notificationManager = (NotificationManager)
                context.getSystemService(Context.NOTIFICATION_SERVICE);
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
