package org.lightsys.missionaryapp.data;

/**
 * @author Judah Sistrunk
 * created on 5/31/2016.
 *
 * Holds information about a new update/prayer request/whatever else the user needs to know about
 */
public class NewItem {

    private int id;
    private int eventId;
    private String itemType;    //holds item type (prayer request, update, etc.)
    private String header;
    private String content;
    private String date;

    /* ************************* Construct ************************* */
    public NewItem(){}

    public NewItem(int id, String ItemType, int eventId, String header, String content, String date) {
        this.id       = id;
        this.itemType = ItemType;
        this.header   = header;
        this.content  = content;
        this.date     = date;
        this.eventId  = eventId;
    }

    /* ************************* Set ************************* */

    public void setId(int id)                { this.id = id; }

    public void setItemType(String ItemType) { this.itemType = ItemType; }

    public void setHeader (String header)    { this.header = header; }

    public void setContent (String content)  { this.content = content; }

    public void setDate (String date)        { this.date = date; }

    public void setEventId (int eventId)     { this.eventId = eventId; }

    /* ************************* Get ************************* */

    public int getId()          { return id; }

    public String getItemType() { return itemType; }

    public String getHeader()   { return header; }

    public String getContent()  { return content; }

    public String getDate()     { return date; }

    public int getEventId()     { return eventId; }
}
