package org.lightsys.missionaryapp.data;

/**
 * basic class used to organize user account data.
 * 
 * @author Andrew Cameron
 *
 */
public class Account {
	private int id;
	private String AccountName;
	private String AccountPassword;
	private String ServerName;
	private int AccountID;
	
	public Account(){}
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName, int AccountID){
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setAccountID(AccountID);
	}
	
	public Account(String AccountName, String AccountPassword, String ServerName, int AccountID){
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setAccountID(AccountID);
	}

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
	
	public void setAccountID(int AccountID){
		this.AccountID = AccountID;
	}
	
	public int getAccountID(){
		return this.AccountID;
	}
	
}
