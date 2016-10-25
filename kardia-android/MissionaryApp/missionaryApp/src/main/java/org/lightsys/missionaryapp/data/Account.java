package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Cameron
 *
 * basic class used to organize user account data
 *
 *  Each user is represented by an Account object which stores all of their information as different properties
 *      id: unique to account, used as key to access other data from tables
 *      log in info such as password and servername are collected in the AccountsActivity class
 *
 */
public class Account {
	private int    id; // Stored as the Missionary Id provided by user
	private String accountName;
	private String accountPassword;
	private String serverName;
	private String partnerName; //Name used for sending messages, different than accountName

	public Account() {}
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName) {
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
	}

	/* ************************* Set ************************* */
	public void setId(int id)                       { this.id = id; }

	public void setAccountName(String accountName)  { this.accountName = accountName; }

	public void setAccountPassword(String password) { this.accountPassword = password; }

	public void setServerName(String serverName)    { this.serverName = serverName; }

	public void setPartnerName(String name)         { partnerName = name; }

	/* ************************* Get ************************* */
	public int    getId()              { return id; }

	public String getAccountName()     { return accountName; }

	public String getAccountPassword() { return accountPassword; }

	public String getServerName()      { return serverName; }

	public String getPartnerName()     { return partnerName; }

}
