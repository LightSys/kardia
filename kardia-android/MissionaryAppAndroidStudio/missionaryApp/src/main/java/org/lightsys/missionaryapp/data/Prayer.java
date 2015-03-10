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
    private static int number = 0;
    private String date;

    public Prayer(){
        this.setDate();
        number++;
    }

    public Prayer(String Subject, String Description){
        this.setSubject(Subject);
        this.setDescription(Description);
        this.setDate();
        number++;
    }

    public int getNumber() {
        return number;
    }

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

    public String getDate() {return (String)date;}

    public void Update(String text) {
        setDate();
        String newDescription = "\n\nUpdate " + getDate() + ": " + text;
        setDescription(newDescription);
    }

    public void setDate() {
        Date date1 = new Date();
        Format formatter = new SimpleDateFormat("MM-dd-yyyy");
        this.date = formatter.format(date1);
    }
    public void setDate(String date) {
        this.date = date;
    }
}
