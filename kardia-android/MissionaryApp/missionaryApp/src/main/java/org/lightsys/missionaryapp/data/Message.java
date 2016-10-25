package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/11/2015
 *
 * Class representing a message sent from the user to a missionary
 */
public class Message {

    public enum MessageType { Update, Prayer, Praise, Other }

    private String      subject;
    private String      text;
    private String      sender;
    private MessageType type;
    private String      missionaryName;
    private int         missionaryId;

    public Message() {}

    public Message(String subject, String text, String sender, MessageType type,
                   String missionaryName, int missionaryId) {
        this.subject        = subject;
        this.text           = text;
        this.sender         = sender;
        this.type           = type;
        this.missionaryName = missionaryName;
        this.missionaryId   = missionaryId;
    }

    /* ************************* Set ************************* */

    public void setSubject(String subject)     { this.subject = subject; }

    public void setText(String message)        { this.text = message; }

    public void setSender(String sender)       { this.sender = sender; }

    public void setType(MessageType type)      { this.type = type; }

    public void setMissionaryName(String name) { this.missionaryName = name; }

    public void setMissionaryId(int id)        { this.missionaryId = id; }

	/* ************************* Get ************************* */
    public String      getSubject()        { return subject; }

    public String      getText()           { return text; }

    public String      getSender()         { return sender; }

    public MessageType getType()           { return type; }

    public String      getMissionaryName() { return missionaryName; }

    public int         getMissionaryId()   { return missionaryId; }

}
