package org.lightsys.missionaryapp.tools;

import android.app.AlarmManager;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.TaskStackBuilder;
import android.util.Log;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.UpdateNotification;
import org.lightsys.missionaryapp.views.PostNoteActivity;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import static android.content.Context.NOTIFICATION_SERVICE;

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
            LocalDBHandler db = new LocalDBHandler(context, null);
            ArrayList<UpdateNotification> notifications = db.getNotifications();

            Intent alarmIntent;
            PendingIntent pendingIntent;
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(context.ALARM_SERVICE);

            // Loop through all notifications
            for (UpdateNotification notification : notifications) {
                // If notification time has not passed, set alarm
                if (notification.getNotificationTime() > Calendar.getInstance().getTimeInMillis()) {
                    alarmIntent = new Intent(context, NotifyAlarmReceiver.class);
                    alarmIntent.putExtra("message", notification.getNotificationMessage());
                    alarmIntent.putExtra("id", notification.getId());
                    pendingIntent = PendingIntent.getBroadcast(context, notification.getId(), alarmIntent, 0);

                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US);
                    Log.w("tag", "Alarm set for: " + format.format(notification.getNotificationTime())
                            + ", ID:" + Integer.toString(notification.getId()));

                    alarmManager.setExact(AlarmManager.RTC_WAKEUP, notification.getNotificationTime(), pendingIntent);
                } else { // Time has passed and notification can be deleted from database
                    db.deleteNotification(notification.getId());
                }
            }
            db.close();
        }
    }

    private void sendNotification(Context context, Intent intent) {
        NotificationManager notificationMgr = (NotificationManager)
                context.getSystemService(NOTIFICATION_SERVICE);
        NotificationCompat.Builder nBuild;
        String name, message;
        int notificationID;

        name = intent.getStringExtra("title");
        message = intent.getStringExtra("message");
        notificationID = intent.getIntExtra("id", 0);

        // Build the notification to be sent
        // BigTextStyle allows notification to be expanded if text is more than one line
        nBuild = new NotificationCompat.Builder(context)
                .setContentTitle("Update Reminder")
                .setContentText(message)
                .setSmallIcon(R.drawable.kardiabeat_v2)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(message));

        Intent resultIntent = new Intent(context, PostNoteActivity.class);
        TaskStackBuilder stackBuilder = TaskStackBuilder.create(context);
        stackBuilder.addParentStack(PostNoteActivity.class);
        stackBuilder.addNextIntent(resultIntent);
        PendingIntent resultPendingIntent = stackBuilder.getPendingIntent(
                0, PendingIntent.FLAG_UPDATE_CURRENT);
        nBuild.setContentIntent(resultPendingIntent);

        notificationMgr.notify(notificationID, nBuild.build());
        // Delete notification from database once sent as it will not be needed again
        LocalDBHandler db = new LocalDBHandler(context, null);
        db.deleteNotification(notificationID);
        db.close();
    }
}
