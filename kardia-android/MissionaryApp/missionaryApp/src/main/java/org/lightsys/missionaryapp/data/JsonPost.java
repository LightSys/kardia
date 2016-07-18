package org.lightsys.missionaryapp.data;

/**
 * Created by Judah on 7/11/2016.
 * stores stuff so that a failed json post can be reposted later
 */
public class JsonPost {

    long id;
    private String url;
    private String jsonString;
    private int accountID;

    public JsonPost(long ID, String postUrl, String jSonString, int accountId)
    {
        id = ID;
        url = postUrl;
        jsonString = jSonString;
        accountID = accountId;
    }

    public  void setId(long id){
        this.id = id;
    }

    public void setUrl(String url){
        this.url = url;
    }

    public void setJsonString(String jsonString){
        this.jsonString = jsonString;
    }

    public void setAccountID(int accountID){
        this.accountID = accountID;
    }

    public long getId(){
        return id;
    }

    public String getUrl(){
        return url;
    }

    public String getJsonString(){
        return jsonString;
    }

    public int getAccountID(){
        return accountID;
    }

}
