package org.lightsys.missionaryapp.data;

/**
 * Class represents a prayer notification to be sent to user at a specific time
 * Created by Andrew Lockridge on 6/8/2015.
 */
public class PrayerNotification {

    private int id; // used for database storage
    private long notificationTime; // time to be sent in milliseconds
    private int request_id; // id of prayer request to be reminded of

    public PrayerNotification() {}

    public PrayerNotification(int id, long notificationTime, int request_id) {
        this.id = id;
        this.notificationTime = notificationTime;
        this.request_id = request_id;
    }

    public int getId() {return id;}

    public void setId(int id) {this.id = id;}

    public long getNotificationTime() {return notificationTime;}

    public void setNotificationTime(long time) {notificationTime = time;}

    public int getRequestID() {return request_id;}

    public void setRequest_id(int id) {request_id = id;}
}
