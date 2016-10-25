package org.lightsys.missionaryapp.data;

/**
 * @author Judah Sistrunk
 * created on 5/31/2016.
 *
 * Holds information about a new update/prayer request/whatever else the user needs to know about
 */
public class NewItem {

    private String itemType; //holds item type (prayer request, update, etc.)
    private String itemMessage;

    public NewItem(String ItemType, String ItemMessage) {
        itemType    = ItemType;
        itemMessage = ItemMessage;
    }

    /* ************************* Set ************************* */

    public void setItemType(String ItemType)       { itemType = ItemType; }

    public void setItemMessage(String ItemMessage) { itemMessage = ItemMessage; }

    /* ************************* Get ************************* */

    public String getItemType()    { return itemType; }

    public String getItemMessage() { return itemMessage; }
}
