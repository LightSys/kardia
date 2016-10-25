package org.lightsys.missionaryapp.data;

/**
 * Class represents a prayer letter published by a missionary which is displayed as a pdf
 * Created by Andrew Lockridge on 6/26/2015.
 */
public class PrayerLetter {
    private int id;
    private String missionaryName;
    private String title;
    private String folder;
    private String filename;
    private String date;
    private int missionaryId;

    public PrayerLetter() {}

    public PrayerLetter(int id, String date, String title, String missionaryName, String folder, String filename, int missionaryId) {
        this.id = id;
        this.missionaryName = missionaryName;
        this.title = title;
        this.folder = folder;
        this.filename = filename;
        this.date = date;
        this.missionaryId = missionaryId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMissionaryName() {
        return missionaryName;
    }

    public void setMissionaryName(String missionaryName) {
        this.missionaryName = missionaryName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getFolder() { return folder; }

    public void setFolder(String folder) { this.folder = folder; }

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getMissionaryId() { return missionaryId; }

    public void setMissionaryId(int missionaryId) {this.missionaryId = missionaryId; }
}
