package org.lightsys.donorapp.data;

/**
 * Basic class used to organize information about funds, that a user has donated to
 * 
 * @author Andrew Cameron
 *
 */
public class Fund {
	private int Id; //identifier in database
	private String fullName; // (found as "name") an example looks like:  PRJ000|DEMO
	private String fund_desc;
	private String fund; // (found as "fund")
	private int gift_count; // (found as "gift_count")
	private int[] gift_total; // (found as "gift_total")
	private String giving_url; // (found as "giving_url")

	public Fund(){}
	
	public Fund(int ID, String fullName, String fundName, String fund_desc, int gift_count, int[] gift_total, String giving_url){
		this.setID(ID);
		this.setFullName(fullName);
		this.setFund_desc(fund_desc);
		this.setName(fundName);
		this.setGift_count(gift_count);
		this.setGift_total(gift_total);
		this.setGiving_url(giving_url);
	}

	public int getID() {
		return Id;
	}

	public void setID(int fundID) {
		this.Id = fundID;
	}
	
	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getName() {
		return fund;
	}

	public void setName(String fundName) {
		this.fund = fundName;
	}

	public int getGift_count() {
		return gift_count;
	}

	public void setGift_count(int gift_count) {
		this.gift_count = gift_count;
	}

	public int[] getGift_total() {
		return gift_total;
	}

	public void setGift_total(int[] gift_total) {
		this.gift_total = gift_total;
	}
	
	public String getGiving_url() {
		return giving_url;
	}

	public void setGiving_url(String donation_link) {
		this.giving_url = donation_link;
	}
	
	public String amountToString(){
		if(gift_total[1] <= 9){
			return "$" + gift_total[0] + ".0" + gift_total[1];
		}else{
			return "$" + gift_total[0] + "." + gift_total[1];
		}
	}

	public String getFund_desc() {
		return fund_desc;
	}

	public void setFund_desc(String fund_desc) {
		this.fund_desc = fund_desc;
	}
}
