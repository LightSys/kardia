package org.lightsys.donorapp.tools;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.data.PrayerNotification;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by Andrew Lockridge on 6/2/2015.
 *
 * This class receives a signal when the alarm goes off and sends a notification
 * This class also takes care of receiving the signal of a boot up completed
 * When the device boots up, all alarms need to be reset
 */
public class NotifyAlarmReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        // If signal received was from bootup, go through process to reset notification alarms
        if (intent.getAction() != null && intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            resetAlarms(context);
        } else { // Signal came from alarm going off and notification should be sent to user
            sendNotification(context, intent);
        }
    }

    /**
     * Retrieves all notifications from database and resets them if they are valid
     * @param context, context called in
     */
    private void resetAlarms(Context context) {
        // Setting alarms requires sdk version 19 or newer
        if (Build.VERSION.SDK_INT >= 19) {
            LocalDBHandler db = new LocalDBHandler(context, null, null, 9);
            ArrayList<PrayerNotification> notifications = db.getNotifications();
            Note request;
            Intent alarmIntent;
            PendingIntent pendingIntent;
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(context.ALARM_SERVICE);

            // Loop through all notifications
            for (PrayerNotification notification : notifications) {
                // If notification time has not passed, set alarm
                if (notification.getNotificationTime() > Calendar.getInstance().getTimeInMillis()) {
                    request = db.getNoteForID(notification.getRequestID());
                    alarmIntent = new Intent(context, NotifyAlarmReceiver.class);
                    alarmIntent.putExtra("title", request.getMissionaryName());
                    alarmIntent.putExtra("message", request.getSubject());
                    alarmIntent.putExtra("id", notification.getId());
                    pendingIntent = PendingIntent.getBroadcast(context, notification.getId(), alarmIntent, 0);

                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
                    Log.w("tag", "Alarm set for: " + format.format(notification.getNotificationTime())
                            + ", ID:" + Integer.toString(notification.getId()) + ", Name:" + request.getMissionaryName());

                    alarmManager.setExact(AlarmManager.RTC_WAKEUP, notification.getNotificationTime(), pendingIntent);
                } else { // Time has passed and notification can be deleted from database
                    db.deleteNotification(notification.getId());
                }
            }
            db.close();
        }
    }

    private void sendNotification(Context context, Intent intent) {
        NotificationManager notificationManager = (NotificationManager)
                context.getSystemService(context.NOTIFICATION_SERVICE);
        NotificationCompat.Builder nBuild;
        Notification n;
        String name, subject;
        int notificationID;

        name = intent.getStringExtra("title");
        subject = intent.getStringExtra("message");
        notificationID = intent.getIntExtra("id", 0);

        // Build the notification to be sent
        nBuild = new NotificationCompat.Builder(context)
                .setContentTitle("Prayer Reminder")
                .setContentText(name)
                .setSmallIcon(R.drawable.kardiabeat_v2)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(subject));

        n = nBuild.build();
        notificationManager.notify(notificationID, n);

        // Delete notification from database once sent as it will not be needed again
        LocalDBHandler db = new LocalDBHandler(context, null, null, 9);
        db.deleteNotification(notificationID);
        db.close();
    }
}
