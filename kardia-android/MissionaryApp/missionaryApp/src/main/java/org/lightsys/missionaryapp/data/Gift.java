package org.lightsys.missionaryapp.data;

import java.text.DateFormatSymbols;

/**
 * Basic Class used to organize information about Gifts given by the user
 * 
 * @author Andrew Cameron
 *
 */
public class Gift {
	private int Id;
	private String name; // (found as "name") example:  DEMO|100006|1|1
	private String giftFund; // (found as "giftFund")
	private String gift_fund_desc; // (found as "gift_fund_desc")
	private int[] gift_amount; // (found as "gift_amount")
	private String gift_date; // (found as "gift_date")
	private String gift_check_num; // (found as "gift_check_num")
	private String giftDonor;
	private int giftDonorId;
	private String giftYear;
	private String giftMonth;

	public Gift() {}
	
	public Gift(int Id, String name, String giftFund, String gift_fund_desc, int[] gift_amount, String gift_date, String gift_check_num, String giftDonor, int giftDonorId, String giftYear, String giftMonth){
		this.setId(Id);
		this.setName(name);
		this.setGiftFund(giftFund);
		this.setGiftAmount(gift_amount);
		this.setGiftFundDesc(gift_fund_desc);
		this.setGiftDate(gift_date);
		this.setGift_check_num(gift_check_num);
		this.setGiftDonor(giftDonor);
        this.setGiftDonorId(giftDonorId);
		this.setGiftMonth(giftMonth);
		this.setGiftYear(giftYear);
	}
	
	public int getId() {
		return Id;
	}

	public void setId(int Id) {
		this.Id = Id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getGiftFund() {
		return giftFund;
	}

	public void setGiftFund(String giftFund) {
		this.giftFund = giftFund;
	}

	public int[] getGiftAmount() {return gift_amount;}

	public void setGiftAmount(int[] gift_amount) {
		this.gift_amount = gift_amount;
	}

	public String getGiftFundDesc() {
		return gift_fund_desc;
	}

	public void setGiftFundDesc(String gift_fund_desc) {
		this.gift_fund_desc = gift_fund_desc;
	}

	public String getGiftDate() {
		return gift_date;
	}

	public void setGiftDate(String gift_date) {
		this.gift_date = gift_date;
	}

	public String getGift_check_num() {
		return gift_check_num;
	}

	public void setGift_check_num(String gift_check_num) {
		this.gift_check_num = gift_check_num;
	}

	public String getGiftDonor() {return giftDonor;}

	public void setGiftDonor(String giftDonor) {this.giftDonor = giftDonor; }

    public int getGiftDonorId() {return giftDonorId;}

    public void setGiftDonorId(int giftDonorId) {this.giftDonorId = giftDonorId; }

	public String getGiftYear() {return giftYear;}

	public void setGiftYear(String giftYear) {this.giftYear = giftYear; }

	public String getGiftMonth() {return giftMonth;}

	public void setGiftMonth(String giftMonth) {this.giftMonth = giftMonth; }

}
