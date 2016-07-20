package org.lightsys.missionaryapp.data;

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

	public Gift() {}
	
	public Gift(int Id, String name, String giftFund, String gift_fund_desc, int[] gift_amount, String gift_date, String gift_check_num, String giftDonor, int giftDonorId){
		this.setId(Id);
		this.setName(name);
		this.setGiftFund(giftFund);
		this.setGift_amount(gift_amount);
		this.setGift_fund_desc(gift_fund_desc);
		this.setGift_date(gift_date);
		this.setGift_check_num(gift_check_num);
		this.setGiftDonor(giftDonor);
        this.setGiftDonorId(giftDonorId);
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

	public int[] getGift_amount() {
		return gift_amount;
	}

	public void setGift_amount(int[] gift_amount) {
		this.gift_amount = gift_amount;
	}

	public String getGift_fund_desc() {
		return gift_fund_desc;
	}

	public void setGift_fund_desc(String gift_fund_desc) {
		this.gift_fund_desc = gift_fund_desc;
	}

	public String getGift_date() {
		return gift_date;
	}

	public void setGift_date(String gift_date) {
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

}
