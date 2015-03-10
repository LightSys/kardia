package org.lightsys.missionaryapp.data;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by hannahbrown on 3/10/15.
 */
public class Prayer {
    private String Subject;
    private String Description;
    private int ID;
    private String date;

    public Prayer(){
        this.setDate();
    }

    public Prayer(String Subject, String Description, int ID){
        this.setSubject(Subject);
        this.setDescription(Description);
        this.setDate();
        this.setID(ID);
    }

    public int getID() {return ID;}

    public void setID(int ID) {this.ID = ID;}

    public String getSubject() {
        return Subject;
    }

    public void setSubject(String Subject) {
      this.Subject = Subject;
    }

    public String getDescription() {
        return Description;
    }

    public void setDescription(String Description) { this.Description = Description;}

    public void Update(String text) {
        setDate();
        String newDescription = "\n\nUpdate " + getDate() + ": " + text;
        setDescription(newDescription);
    }

    public String getDate() {return date;}

    public void setDate() {
        Date date1 = new Date();
        Format formatter = new SimpleDateFormat("MM-dd-yyyy");
        this.date = formatter.format(date1);
    }
    public void setDate(String date) {
        this.date = date;
    }
}
