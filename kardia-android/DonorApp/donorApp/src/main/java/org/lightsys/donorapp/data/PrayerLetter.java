package org.lightsys.donorapp.data;

/**
 * Class represents a prayer letter published by a missionary which is displayed as a pdf
 * Created by Andrew Lockridge on 6/26/2015.
 */
public class PrayerLetter {
    private int id;
    private String missionaryName;
    private String title;
    private String filename;
    private String date;

    public PrayerLetter() {}

    public PrayerLetter(int id, String missionaryName, String title, String filename, String date) {
        this.id = id;
        this.missionaryName = missionaryName;
        this.title = title;
        this.filename = filename;
        this.date = date;
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
}
