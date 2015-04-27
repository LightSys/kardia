package org.lightsys.donorapp.data;

/**
 * Created by JoshWorkman on 3/9/2015.
 *
 *  Stuff to know
 *      Update is a subtype of Note as defined by kardia api, PrayerRequest is the other subtype we use
 *      Update at least contains is, subject, text, dateSubmitted
 *      ID serves as unique identifier
 */
public class Update implements Comparable<Update>{

    public static int count=0;
    private String id;
    private String subject;
    private String text;
    private String date;
    private int missionaryId;
    public Update()
    {
        count++;
        subject = "Sample Update"+count;
        text = "Default Explanatory Text";
        date = "11-24-1994";
        id = "100" + count;
    }

    public String formatedDate(String strDate){
        String[] date = strDate.split("-");
        date[0] = getMonth(Integer.parseInt(date[0]));
        return "" + date[1] + " " + date[0] + ", " + date[2];
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

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
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

    public String getId() {
        return id;
    }

    public int getIntId() {return Integer.parseInt(id);}

    public void setId(String id) {
        this.id = id;
    }

    public int compareTo(Update p)
    {
        boolean same = true;
        same = same && subject.equals(p.getSubject());
        same = same && text.equals(p.getText());
        same = same && date.equals(p.getText());

        return same?0:1;
    }
}
