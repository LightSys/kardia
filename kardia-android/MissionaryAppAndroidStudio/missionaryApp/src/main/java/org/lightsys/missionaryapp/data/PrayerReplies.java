package org.lightsys.missionaryapp.data;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by hannahbrown on 3/13/15.
 */
public class PrayerReplies {
    private int prayerID;
    private String Comment;
    private int ID;
    private String date;
    private String name;

    public PrayerReplies(){
        this.setDate();
    }

    public PrayerReplies(String comment, String date, int ID, int prayerID){
        this.setPrayerID(prayerID);
        this.setComment(comment);
        this.setDate(date);
        this.setID(ID);
    }

    public int getID() {return ID;}

    public void setID(int ID) {this.ID = ID;}

    public int getPrayerID() {
        return prayerID;
    }

    public void setPrayerID(int prayerID) {
        this.prayerID = prayerID;
    }

    public String getComment() {
        return Comment;
    }

    public void setComment(String comment) { this.Comment = comment;}

    public String getDate() {return date;}

    public void setDate() {
        Date date1 = new Date();
        Format formatter = new SimpleDateFormat("MM-dd-yyyy");
        this.date = formatter.format(date1);
    }
    public void setDate(String date) {
        this.date = date;
    }

    public String getName() {return name;}

    public void setName(String name) {this.name = name;}

    @Override
    public String toString() {
        String string = "Subject: " + this.getPrayerID() + "\nDesc: " + this.getComment()
                + "\nDate: " + this.getDate() + "\nID: " + this.getID();
        return string;
    }
}
