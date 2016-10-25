package org.lightsys.missionaryapp.data;

/**
 * Class represents a prayer notification to be sent to user at a specific time
 * Created by Andrew Lockridge on 6/8/2015.
 */
public class UpdateNotification {

    private int id; // used for database storage
    private long notificationTime; // time to be sent in milliseconds
    private String notificationMessage; // message to be displayed in reminder
    private String notificationFrequency; // reminder frequency


    public UpdateNotification() {}

    public UpdateNotification(int id, long notificationTime, String notificationMessage, String notificationFrequency) {
        this.id = id;
        this.notificationTime = notificationTime;
        this.notificationMessage = notificationMessage;
        this.notificationFrequency = notificationFrequency;
    }

    public int getId() {return id;}

    public void setId(int id) {this.id = id;}

    public long getNotificationTime() {return notificationTime;}

    public void setNotificationTime(long time) {notificationTime = time;}

    public String getNotificationMessage() {return notificationMessage;}

    public void setNotificationMessage(String notificationMessage) {this.notificationMessage = notificationMessage;}

    public String getNotificationFrequency() {return notificationFrequency;}

    public void setNotificationFrequency(String notificationFrequency) {this.notificationFrequency = notificationFrequency;}

}
