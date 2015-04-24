package org.lightsys.donorapp.data;

/**
 * Created by JoshWorkman on 3/9/2015.
 *
 * Stuff to know
 *      PrayerRequest is a subtype of Note as defined by kardia api, Update is the other subtype we use
 *      PrayerRequest at least contains is, subject, text, dateSubmitted
 *      ID serves as unique identifier
 *      PrayerRequests are displayed through the PrayerRequestList class
 *
 */
public class PrayerRequest implements Comparable<PrayerRequest> {

   private String id;
   private String subject;
   private String text;
   private String date;
   private int missionaryId;


    public PrayerRequest()
   {
       subject = "Sample Prayer ";
       text = "Default Explanatory Text";
       date = "1-14-1997";
       id = "100";
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

    public void setId(String id) {
        this.id = id;
    }

    public String getId() { return this.id; }

    public int getIntId() { return Integer.parseInt(this.id);}

    public int compareTo(PrayerRequest p)
    {
        boolean same = true;
        same = same && subject.equals(p.getSubject());
        same = same && text.equals(p.getText());
        same = same && date.equals(p.getText());

        return same?0:1;
    }
}
