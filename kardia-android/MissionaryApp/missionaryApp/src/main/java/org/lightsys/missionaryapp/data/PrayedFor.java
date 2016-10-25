package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/24/2015
 * Edited from DonorApp to MissionaryApp by Laura DeOtte
 *
 * Class represents a Prayer for a prayer request or update
 */
public class PrayedFor {

    private int    prayedForId;
    private String prayedForComments;
    private String date;
    private int    noteId;
    private int    supporterId;
    private String supporterName;

    public PrayedFor() {}

    public PrayedFor(int prayedForId, String prayedForComments, String date, int noteId,
                     int supporterId, String supporterName) {
        this.prayedForId       = prayedForId;
        this.prayedForComments = prayedForComments;
        this.date              = date;
        this.noteId            = noteId;
        this.supporterId       = supporterId;
        this.supporterName     = supporterName;

    }

    /* ************************* Set ************************* */

    public void setPrayedForId(int prayedForId)        { this.prayedForId = prayedForId; }

    public void setPrayedForComments(String comments)  {this.prayedForComments = comments;}

    public void setPrayedForDate(String date)          { this.date = date; }

    public void setNoteId(int noteId)                  { this.noteId = noteId; }

    public void setSupporterId(int supporterId)        { this.supporterId = supporterId; }

    public void setSupporterName(String supporterName) { this.supporterName = supporterName; }

    /* ************************* Get ************************* */

    public int    getPrayedForId()       { return prayedForId; }

    public String getPrayedForComments() { return prayedForComments; }

    public String getPrayedForDate()     { return date; }

    public int    getNoteId()            { return noteId; }

    public int    getSupporterId()       { return supporterId; }

    public String getSupporterName()     { return supporterName; }

}
