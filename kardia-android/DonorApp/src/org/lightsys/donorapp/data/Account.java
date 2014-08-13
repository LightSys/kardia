package org.lightsys.donorapp.data;

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
	private int donor_id;
	
	public Account(){}
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName, int donor_id){
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setDonorid(donor_id);
	}
	
	public Account(String AccountName, String AccountPassword, String ServerName, int donor_id){
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setDonorid(donor_id);
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

	public int getDonorid() {
		return donor_id;
	}

	public void setDonorid(int donor_id) {
		this.donor_id = donor_id;
	}
}
