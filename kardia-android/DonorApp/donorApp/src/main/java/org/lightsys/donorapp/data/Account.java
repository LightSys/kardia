package org.lightsys.donorapp.data;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * basic class used to organize user account data.
 * 
 * @author Andrew Cameron
 *
 *  Each user is represented by and Account object which stores all of their information as different properties
 *      id: unique to account, used as key to access other data from tables
 *      log in info such as password and servername are collected in the AccountsActivity class
 *
 */
public class Account {
	private int id;
	private String AccountName;
	private String AccountPassword;
	private String ServerName;
	private int donor_id;
    HashMap<String, Integer> prayedForRequests;
    HashMap<String, Integer> test = new HashMap<String, Integer>();

	public Account(){
        this.prayedForRequests = new HashMap<String, Integer>();
    }
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName, int donor_id){
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setDonorid(donor_id);
        this.prayedForRequests = new HashMap<String, Integer>();	}
	
	public Account(String AccountName, String AccountPassword, String ServerName, int donor_id){
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setDonorid(donor_id);
        this.prayedForRequests = new HashMap<String, Integer>();	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getAccountName() {
		return AccountName;
	}

	public void setAccountName(String accountName) {
		AccountName = accountName;
	}

	public String getAccountPassword() {
		return AccountPassword;
	}

	public void setAccountPassword(String accountPassword) {
		AccountPassword = accountPassword;
	}

	public String getServerName() {
		return ServerName;
	}

	public void setServerName(String serverName) {
		ServerName = serverName;
	}

	public int getDonorid() {
		return donor_id;
	}

	public void setDonorid(int donor_id) {
		this.donor_id = donor_id;
	}

    public void addPrayedForRequest(String id)
    {
        if(!prayedForRequests.containsKey(id)) {
            prayedForRequests.put(id, 0);
        }
    }

    public int getTimesPrayed(String id){
        return prayedForRequests.get(id);
    }

    public boolean isRequestPrayedFor(String id)
    {
        return prayedForRequests.containsKey(id) && (prayedForRequests.get(id) != 0);
    }

    public void PrayForRequest(String id)
    {
        prayedForRequests.put(id, getTimesPrayed(id) + 1);
    }
}
