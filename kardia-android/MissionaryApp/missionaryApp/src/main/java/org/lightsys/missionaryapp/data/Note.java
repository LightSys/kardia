package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/24/2015
 *
 * Class represents an update or prayer request from a missionary
 */
public class Note {

    private int    noteId;
    private int    missionaryID;
    private String subject;
    private String noteText;
    private String date;
    private String missionaryName;
    private String noteType;
    private int    numberPrayed;

    /* ************************* Construct ************************* */
    public Note() {}

    public Note(int noteId, int missionaryID, String missionaryName, String noteType,
                String subject, String date, String noteText, int numberPrayed) {
        this.noteId        = noteId;
        this.subject        = subject;
        this.noteText       = noteText;
        this.date           = date;
        this.missionaryName = missionaryName;
        this.missionaryID   = missionaryID;
        this.noteType       = noteType;
        this.numberPrayed   = numberPrayed;
    }

    /* ************************* Set ************************* */

    public void setNoteId(int noteId)            { this.noteId = noteId; }

    public void setMissionaryName(String name)    { this.missionaryName = name; }

    public void setMissionaryID(int missionaryID) {this.missionaryID = missionaryID;}

    public void setSubject(String title)          { this.subject = title; }

    public void setNoteText(String noteText)      { this.noteText = noteText; }

    public void setDate(String date)              { this.date = date; }

    public void setType(String noteType)          { this.noteType = noteType; }

    public void setNumberPrayed(int numberPrayed) { this.numberPrayed = numberPrayed;}

    /* ************************* Get ************************* */

    public int    getNoteId()         { return noteId; }

    public String getMissionaryName() { return missionaryName; }

    public int    getMissionaryID()   { return missionaryID; }

    public String getSubject()        { return subject; }

    public String getNoteText()       { return noteText; }

    public String getDate()           { return date; }

    public String getType()           { return noteType; }

    public int    getNumberPrayed()   {return numberPrayed;}

}

