package org.lightsys.missionaryapp.data;

/**
 * @author Judah
 * created on 6/7/2016.
 *
 * class that stores all the things about comments
 */
public class Comment {

    private int    commentID;
    private int    noteID;
    private int    senderID;
    private String userName;
    private String noteType;
    private String date;
    private String comment;

    /* ************************* Construct ************************* */
    public Comment() {}

    public Comment (int CommentID, int SenderID, int NoteID, String UserName,
                    String NoteType, String Date, String CommentText) {
        commentID = CommentID;
        noteID    = NoteID;
        senderID  = SenderID;
        userName  = UserName;
        noteType  = NoteType;
        date      = Date;
        comment   = CommentText;
    }

    /* ************************* Set ************************* */
    public void setCommentID (int CommentID)  { commentID = CommentID; }

    public void setNoteID (int NoteID)        { noteID = NoteID; }

    public void setSenderID (int SenderID)    { senderID = SenderID; }

    public void setUserName (String Username) {userName = Username;}

    public void setNoteType (String NoteType) { noteType = NoteType; }

    public void setDate (String Date)         { date = Date; }

    public void setComment (String Comment)   { comment = Comment; }

    /* ************************* Get ************************* */
    public int    getCommentID() { return commentID; }

    public int    getNoteID ()   { return noteID; }

    public int    getSenderID()  { return senderID; }

    public String getUserName()  { return userName; }

    public String getNoteType()  { return noteType; }

    public String getDate()      { return date; }

    public String getComment()   { return comment; }
}
