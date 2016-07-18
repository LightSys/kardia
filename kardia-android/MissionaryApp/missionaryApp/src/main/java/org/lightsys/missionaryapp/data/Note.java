package org.lightsys.missionaryapp.data;

/**
 * Class represents an update or prayer request from a missionary
 * Created by Andrew Lockridge on 6/24/2015.
 */
public class Note {
    //public enum NoteType {Update, Pray, Praise, Other}

    private int note_id;
    private int missionaryID;
    private String subject;
    private String notetext;
    private String date;
    private String missionaryName;
    private String noteType;
    private int numberPrayed;

    public Note() {}

    public Note(int note_id, int missionaryID, String missionaryName, String noteType, String subject, String date, String notetext, int numberPrayed) {
        this.note_id = note_id;
        this.subject = subject;
        this.notetext = notetext;
        this.date = date;
        this.missionaryName = missionaryName;
        this.missionaryID = missionaryID;
        this.noteType = noteType;
        this.numberPrayed = numberPrayed;
    }

    public int getNoteId() { return note_id; }

    public void setNoteId(int note_id) {
        this.note_id = note_id;
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

    public String getNoteText() {
        return notetext;
    }

    public void setNoteText(String notetext) {
        this.notetext = notetext;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getType() { return noteType; }

    public void setType(String noteType) { this.noteType = noteType; }

    public void setNumberPrayed(int numberPrayed){ this.numberPrayed = numberPrayed;}

    public int getNumberPrayed(){return numberPrayed;}

}
