package org.lightsys.donorapp.data;

/**
 * basic class used to organize user account data.
 * 
 * @author Andrew Cameron
 *
 *  Each user is represented by an Account object which stores all of their information as different properties
 *      id: unique to account, used as key to access other data from tables
 *      log in info such as password and servername are collected in the AccountsActivity class
 *
 */
public class Account {
	private int id; // Stored as the Donor ID provided by user
	private String AccountName;
	private String AccountPassword;
	private String ServerName;
	private String PartnerName; //Name used for sending messages, different than AccountName
	private String PortNumber;
	private String Protocol;

	public Account(){}
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName,
				    String PartnerName, String PortNumber, String Protocol){
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
		this.setPartnerName(PartnerName);
		this.setPortNumber(PortNumber);
		this.setProtocol(Protocol);

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

	public String getPartnerName() { return PartnerName; }

	public void setPartnerName(String name) { PartnerName = name; }

	public String getPortNumber(){return PortNumber;}

	public void setPortNumber(String portNumber){PortNumber = portNumber;}

	public String getProtocol(){return Protocol;}

	public void setProtocol(String protocol){Protocol = protocol;}
}
