package org.lightsys.missionaryapp.data;

/**
 * @author otter57
 *
 * Class used to organize gifts given to the user into time periods
 */

public class Period {
	private int    Id;
	private int    fundId;
	private String periodName; // example: 2014.06|DEMO
	private String date; // month and year example: June 2014
	private int[]  giftTotal;
	
	public Period() {}
	
	public Period(int Id, String periodName, String date, int[] giftTotal, int fundId){
		this.setId(Id);
		this.setPeriodName(periodName);
		this.setDate(date);
		this.setGiftTotal(giftTotal);
		this.setFundId(fundId);
	}

    /* ************************* Set ************************* */

	private void setId(int id)                 { Id = id; }

	public void  setPeriodName(String name)    { this.periodName = name; }

	private void setDate(String date)          { this.date = date; }

	public void  setGiftTotal(int[] giftTotal) {this.giftTotal = giftTotal; }

	public void  setFundId(int fundId)         { this.fundId = fundId;}

    /* ************************* Get ************************* */

    public int    getId()         { return Id; }

    public String getPeriodName() { return periodName; }

    public String getDate()       { return date; }

    public int[]  getGiftTotal()  {return giftTotal; }

    public int    getFundId()     { return fundId;}

    @Override
    public String toString() {
        String string = "";
        return string;
    }
	
}
