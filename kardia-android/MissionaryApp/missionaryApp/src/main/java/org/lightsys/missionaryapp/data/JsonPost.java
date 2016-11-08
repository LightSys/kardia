package org.lightsys.missionaryapp.data;

/**
 * @author Judah
 * created on 7/11/2016.
 *
 * class that stores stuff so that a failed json post can be reposted later
 */
public class JsonPost {

    private long Id;
    private String url;
    private String jsonString;
    private int accountID;

    /* ************************* Construct ************************* */
    public JsonPost(long Id, String postUrl, String jSonString, int accountId) {
        this.Id = Id;
        this.url = postUrl;
        this.jsonString = jSonString;
        this.accountID = accountId;
    }

	/* ************************* Set ************************* */

    public void setId(long Id)                   { this.Id = Id; }

    public void setUrl(String url)               { this.url = url; }

    public void setJsonString(String jsonString) { this.jsonString = jsonString; }

    public void setAccountID(int accountID)      { this.accountID = accountID; }

	/* ************************* Get ************************* */

    public long   getId()          { return Id; }

    public String getUrl()         { return url; }

    public String getJsonString()  { return jsonString; }

    public int    getAccountID()   { return accountID; }
}
