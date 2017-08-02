package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Cameron
 *
 * basic class used to organize user account data
 *
 *  user is represented by an Account object which stores all of his/her information as different properties
 *      id: unique to account, used as key to access other data from tables
 *      log in info such as password and servername are collected in the LoginActivity class
 *
 */
public class Account {
	private int    id;              // Stored as the Missionary Id provided by user
	private String accountName;
	private String accountPassword;
	private String serverName;
    private String port;
    private String protocal;
	private String partnerName;     //Name used for sending messages, different than accountName
    private int    acceptSSCert;   //allows app to accept self signed SSL certificates for https

    /* ************************* Construct ************************* */
    public Account() {}
	
	public Account(int id, String AccountName, String AccountPassword, String ServerName, String port, String protocal, int acceptSSCert) {
		this.setId(id);
		this.setAccountName(AccountName);
		this.setAccountPassword(AccountPassword);
		this.setServerName(ServerName);
        this.setPort(port);
        this.setProtocal(protocal);
        this.setAcceptSSCert(acceptSSCert);
	}

	/* ************************* Set ************************* */
	public void setId(int id)                       { this.id = id; }

	public void setAccountName(String accountName)  { this.accountName = accountName; }

	public void setAccountPassword(String password) { this.accountPassword = password; }

	public void setServerName(String serverName)    { this.serverName = serverName; }

    public void setPort(String port)                { this.port = port; }

    public void setProtocal(String protocal)        { this.protocal = protocal; }

	public void setPartnerName(String name)         { partnerName = name; }

    public void setAcceptSSCert(int acceptSSC)      { acceptSSCert = acceptSSC; }

	/* ************************* Get ************************* */
	public int    getId()              { return id; }

	public String getAccountName()     { return accountName; }

	public String getAccountPassword() { return accountPassword; }

	public String getServerName()      { return serverName; }

    public String getPort()            { return port; }

    public String getProtocal()        { return protocal; }

	public String getPartnerName()     { return partnerName; }

    public int    getAcceptSSCert()   { return acceptSSCert; }

}
