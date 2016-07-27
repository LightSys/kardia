package org.lightsys.missionaryapp.data;

/**
 * Class used to organize gifts given to the user into time periods
 *
 * @author Laura DeOtte
 *
 */

public class Period {
	private int Id;
	private String periodname; // example: 2014.06|DEMO
	private String date; // month and year example: June 2014
	private int[] giftTotal;
	
	public Period(){}
	
	public Period(int Id, String periodname, String date, int[] giftTotal){
		this.setId(Id);
		this.setPeriodName(periodname);
		this.setDate(date);
		this.setGiftTotal(giftTotal);
	}

	public int getId() {
		return Id;
	}

	public void setId(int id) {
		Id = id;
	}

	public String getPeriodName() {
		return periodname;
	}

	public void setPeriodName(String periodname) {
		this.periodname = periodname;
	}
	
	public String getDate(){
		return date;
	}
	
	public void setDate(String date){
		this.date = date;
	}

	public int[] getGiftTotal() {return giftTotal; }

	public void setGiftTotal(int[] giftTotal){this.giftTotal = giftTotal; }

    @Override
    public String toString() {
        String string = "";
        return string;
    }
	
}
