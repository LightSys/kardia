package org.lightsys.donorapp.data;

/**
 * Created by JoshWorkman on 3/9/2015.
 *
 * Stuff to know
 *      PrayerRequest is a subtype of Note as defined by kardia api, Update is the other subtype
 *      PrayerRequest at least contains is, subject, text, dateSubmitted, missionaryName
 *      ID serves as unique identifier
 */
public class PrayerRequest implements Comparable<PrayerRequest> {


    private int id;
    private String subject;
    private String text;
    private String date;
    private String missionaryName;
    private boolean isPrayedFor;

    public PrayerRequest() {}

    public String formattedDate(){
        String[] formattedDate = date.split("-");
        formattedDate[1] = getMonth(Integer.parseInt(formattedDate[1]));
        if (formattedDate[2].substring(0,1).equals("0")) {
            formattedDate[2] = formattedDate[2].substring(1);
        }
        return formattedDate[1] + " " + formattedDate[2] + ",  " + formattedDate[0];
    }

    private String getMonth(int num){
        switch(num){
            case 1: return "January";
            case 2: return "February";
            case 3: return "March";
            case 4: return "April";
            case 5: return "May";
            case 6: return "June";
            case 7: return "July";
            case 8: return "August";
            case 9: return "September";
            case 10: return "October";
            case 11: return "November";
            case 12: return "December";
            default: return "";
        }
    }

    public String getMissionaryName() {return missionaryName;}

    public void setMissionaryName(String name) {
        this.missionaryName = name;
    }

    public String getSubject() {
        return subject;
    }

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

    public void setId(int id) {
        this.id = id;
    }

    public int getId() { return id; }

    public boolean getIsPrayedFor() {
        return isPrayedFor;
    }

    public void setIsPrayedFor(boolean isPrayedFor) {
        this.isPrayedFor = isPrayedFor;
    }

    public int compareTo(PrayerRequest p)
    {
        boolean same = missionaryName.equals(p.getMissionaryName());
        same = same && subject.equals(p.getSubject());
        same = same && text.equals(p.getText());
        same = same && date.equals(p.getText());

        return same?0:1;
    }
}
