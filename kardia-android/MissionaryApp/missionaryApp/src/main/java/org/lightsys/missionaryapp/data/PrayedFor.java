package org.lightsys.missionaryapp.data;

/**
 * Class represents a Prayer for a prayer request or update
 * Created by Andrew Lockridge on 6/24/2015.
 * Edited from DonorApp to MissionaryApp by Laura DeOtte
 */
public class PrayedFor {

    private int prayedForId;
    private String prayedForComments;
    private String date;
    private int noteId;
    private int supporterId;
    private String supporterName;

    public PrayedFor() {}

    public PrayedFor(int prayedForId, String prayedForComments, String date, int noteId, int supporterId, String supporterName) {
        this.prayedForId = prayedForId;
        this.prayedForComments = prayedForComments;
        this.date = date;
        this.noteId = noteId;
        this.supporterId = supporterId;
        this.supporterName = supporterName;

    }

    public int getPrayedForId() { return prayedForId; }

    public void setPrayedForId(int prayedForId) {
        this.prayedForId = prayedForId;
    }

    public String getPrayedForComments() { return prayedForComments; }

    public void setPrayedForComments(String prayedForComments) {this.prayedForComments = prayedForComments;}

    public String getPrayedForDate() { return date; }

    public void setPrayedForDate(String date) {
        this.date = date;
    }

    public int getNoteId() { return noteId; }

    public void setNoteId(int noteId) {
        this.noteId = noteId;
    }

    public int getSupporterId() { return supporterId; }

    public void setSupporterId(int supporterId) {
        this.supporterId = supporterId;
    }

    public String getSupporterName() { return supporterName; }

    public void setSupporterName(String supporterName) {
        this.supporterName = supporterName;
    }


}
