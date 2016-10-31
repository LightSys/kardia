package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/26/2015.
 *
 * todo modify to allow user to publish a letter?
 * Class represents a prayer letter published by a missionary which is displayed as a pdf
 */
public class PrayerLetter {
    private int    id;
    private String missionaryName;
    private String title;
    private String folder;
    private String filename;
    private String date;
    private int    missionaryId;

    /* ************************* Construct ************************* */
    public PrayerLetter() {}

    public PrayerLetter(int id, String date, String title, String missionaryName,
                        String folder, String filename, int missionaryId) {
        this.id             = id;
        this.missionaryName = missionaryName;
        this.title          = title;
        this.folder         = folder;
        this.filename       = filename;
        this.date           = date;
        this.missionaryId   = missionaryId;
    }

    /* ************************* Set ************************* */

    public void setId(int id)                        { this.id = id; }

    public void setMissionaryName(String missionary) { this.missionaryName = missionary; }

    public void setTitle(String title)               { this.title = title; }

    public void setFolder(String folder)             { this.folder = folder; }

    public void setFilename(String filename)         { this.filename = filename; }

    public void setDate(String date)                 { this.date = date; }

    public void setMissionaryId(int missionaryId)    {this.missionaryId = missionaryId; }

    /* ************************* Get ************************* */

    public int    getId()             { return id; }

    public String getMissionaryName() { return missionaryName; }

    public String getTitle()          { return title; }

    public String getFolder()         { return folder; }

    public String getFilename()       { return filename; }

    public String getDate()           { return date; }

    public int    getMissionaryId()   { return missionaryId; }

}
