package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/24/2015
 * Edited from DonorApp to MissionaryApp by otter57
 *
 * Class represents a Prayer for a prayer request or update
 */
public class PrayedFor {

    private int    prayedForId;
    private String prayedForComments;
    private String date;
    private int    noteID;
    private int    supporterId;
    private String supporterName;

    /* ************************* Construct ************************* */
    public PrayedFor() {}

    public PrayedFor(int prayedForId, String prayedForComments, String date, int noteID,
                     int supporterId, String supporterName) {
        this.prayedForId       = prayedForId;
        this.prayedForComments = prayedForComments;
        this.date              = date;
        this.noteID            = noteID;
        this.supporterId       = supporterId;
        this.supporterName     = supporterName;

    }

    /* ************************* Set ************************* */

    public void setPrayedForId(int prayedForId)        { this.prayedForId = prayedForId; }

    public void setPrayedForComments(String comments)  {this.prayedForComments = comments;}

    public void setPrayedForDate(String date)          { this.date = date; }

    public void setNoteID(int noteID)                  { this.noteID = noteID; }

    public void setSupporterId(int supporterId)        { this.supporterId = supporterId; }

    public void setSupporterName(String supporterName) { this.supporterName = supporterName; }

    /* ************************* Get ************************* */

    public int    getPrayedForId()       { return prayedForId; }

    public String getPrayedForComments() { return prayedForComments; }

    public String getPrayedForDate()     { return date; }

    public int    getNoteID()            { return noteID; }

    public int    getSupporterId()       { return supporterId; }

    public String getSupporterName()     { return supporterName; }

}
