package org.lightsys.missionaryapp.data;


/**
 * @author Andrew Cameron
 *
 *Basic Class used to organize information about Gifts given by the user
 */
public class Gift {
	private int    Id;
	private String name;
	private String giftFund;
	private String giftFundDesc;
	private int[]  giftAmount;
	private String giftDate;
	private String giftCheckNum;
	private String giftDonor;
	private int    giftDonorId;
	private String giftYear;
	private String giftMonth;

    /* ************************* Construct ************************* */
    public Gift() {}
	
	public Gift(int Id, String name, String giftFund, String gift_fund_desc, int[] gift_amount,
				String gift_date, String gift_check_num, String giftDonor, int giftDonorId,
				String giftYear, String giftMonth) {
		this.setId(Id);
		this.setName(name);
		this.setGiftFund(giftFund);
		this.setGiftAmount(gift_amount);
		this.setGiftFundDesc(gift_fund_desc);
		this.setGiftDate(gift_date);
		this.setGiftCheckNum(gift_check_num);
		this.setGiftDonor(giftDonor);
        this.setGiftDonorId(giftDonorId);
		this.setGiftMonth(giftMonth);
		this.setGiftYear(giftYear);
	}

	/* ************************* Set ************************* */

	public void setId(int Id)					 { this.Id = Id; }

	public void setName(String name)             { this.name = name; }

	public void setGiftFund(String giftFund)     { this.giftFund = giftFund; }

	public void setGiftAmount(int[] gift_amount) { this.giftAmount = gift_amount; }

	public void setGiftFundDesc(String desc)     { this.giftFundDesc = desc; }

	public void setGiftDate(String gift_date)	 { this.giftDate = gift_date; }

	public void setGiftCheckNum(String CheckNum) { this.giftCheckNum = CheckNum; }

	public void setGiftDonor(String giftDonor)   {this.giftDonor = giftDonor; }

    public void setGiftDonorId(int giftDonorId)  {this.giftDonorId = giftDonorId; }

	public void setGiftYear(String giftYear)     {this.giftYear = giftYear; }

	public void setGiftMonth(String giftMonth)   {this.giftMonth = giftMonth; }

	/* ************************* Get ************************* */
	public int    getId()			  { return Id; }

	public String getName() 		  { return name; }

	public String getGiftFund()       { return giftFund; }

	public int[]  getGiftAmount()     { return giftAmount; }

	public String getGiftFundDesc()   { return giftFundDesc; }

	public String getGiftDate()       { return giftDate; }

	public String getGiftCheckNum()   { return giftCheckNum; }

	public String getGiftDonor()      { return giftDonor;}

	public int 	  getGiftDonorId()    { return giftDonorId;}

	public String getGiftYear()       { return giftYear;}

	public String getGiftMonth()      { return giftMonth;}
}
