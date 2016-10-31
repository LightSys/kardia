package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/8/2015.
 *
 * Class represents a prayer notification to be sent to user at a specific time
 */
public class UpdateNotification {

    private int    id;        // used for database storage
    private long   time;      // time to be sent in milliseconds
    private String message;   // message to be displayed in reminder
    private String frequency; // reminder frequency


    /* ************************* Construct ************************* */
    public UpdateNotification() {}

    public UpdateNotification(int id, long notificationTime, String notificationMessage,
                              String notificationFrequency) {
        this.id        = id;
        this.time      = notificationTime;
        this.message   = notificationMessage;
        this.frequency = notificationFrequency;
    }

    /* ************************* Set ************************* */

    public void setId(int id)                  { this.id = id; }

    public void setTime(long time)             { this.time = time; }

    public void setMessage(String message)     { this.message = message; }

    public void setFrequency(String frequency) { this.frequency = frequency; }

    /* ************************* Get ************************* */

    public int    getId()        { return id; }

    public long   getTime()      { return time; }

    public String getMessage()   { return message; }

    public String getFrequency() { return frequency; }

}
