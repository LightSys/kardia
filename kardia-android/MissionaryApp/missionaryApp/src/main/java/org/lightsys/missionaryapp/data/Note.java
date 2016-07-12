package org.lightsys.missionaryapp.data;

/**
 * Class represents an update or prayer request from a missionary
 * Created by Andrew Lockridge on 6/24/2015.
 */
public class Note {

    private int id;
    private int missionaryID;
    private String subject;
    private String text;
    private String date;
    private String missionaryName;
    private String noteType;
    private boolean isPrayedFor;

    public Note() {}

    public Note(int id, String subject, String text, String date, String missionaryName, int missionaryID, String noteType, boolean isPrayedFor) {
        this.id = id;
        this.subject = subject;
        this.text = text;
        this.date = date;
        this.missionaryName = missionaryName;
        this.missionaryID = missionaryID;
        this.noteType = noteType;
        this.isPrayedFor = isPrayedFor;
    }

    public String getMissionaryName() {return missionaryName;}

    public void setMissionaryName(String name) {
        this.missionaryName = name;
    }

    public void setMissionaryID(int missionaryID) {this.missionaryID = missionaryID;}

    public int getMissionaryID() {return missionaryID;}

    public String getSubject() {return subject;}

    public void setSubject(String title) {
        this.subject = title;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getId() { return id; }

    public void setId(int id) {
        this.id = id;
    }

    public String getType() { return noteType; }

    public void setType(String noteType) { this.noteType = noteType; }

    public boolean getIsPrayedFor() {
        return isPrayedFor;
    }

    public void setIsPrayedFor(boolean isPrayedFor) {
        this.isPrayedFor = isPrayedFor;
    }
}
