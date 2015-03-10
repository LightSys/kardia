package org.lightsys.missionaryapp.data;

import java.util.Date;

/**
 * Created by hannahbrown on 3/10/15.
 */
public class Prayer {
    private String Subject;
    private String Description;
    private static int number = 0;
    private Date date;

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

    public Date getDate() {return date;}

    public void setDate() {this.date = new Date();}
}
