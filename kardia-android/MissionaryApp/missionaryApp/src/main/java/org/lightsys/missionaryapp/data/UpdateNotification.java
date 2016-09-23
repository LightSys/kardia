package org.lightsys.missionaryapp.data;

/**
 * Class represents a prayer notification to be sent to user at a specific time
 * Created by Andrew Lockridge on 6/8/2015.
 */
public class UpdateNotification {

    private int id; // used for database storage
    private long notificationTime; // time to be sent in milliseconds
    private String notificationMessage; // id of prayer request to be reminded of

    public UpdateNotification() {}

    public UpdateNotification(int id, long notificationTime, String notificationMessage) {
        this.id = id;
        this.notificationTime = notificationTime;
        this.notificationMessage = notificationMessage;
    }

    public int getId() {return id;}

    public void setId(int id) {this.id = id;}

    public long getNotificationTime() {return notificationTime;}

    public void setNotificationTime(long time) {notificationTime = time;}

    public String getNotificationMessage() {return notificationMessage;}

    public void setNotificationMessage(int notificationMessage) {notificationMessage = notificationMessage;}
}
