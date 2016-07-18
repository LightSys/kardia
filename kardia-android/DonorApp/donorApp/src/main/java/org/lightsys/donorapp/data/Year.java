package org.lightsys.donorapp.data;
/**
 * Basic Class used to organize general data on years in which a user gave donations
 * 
 * @author Andrew Cameron
 *
 */
public class Year {
	private int Id;
	private String name;
	private int[] gift_total;
	
	public Year() {}
	
	public Year(int Id, String name, int[] gift_total){
		this.setId(Id);
		this.setName(name);
		this.setGift_total(gift_total);
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
	
	public int[] getGift_total() {
		return gift_total;
	}
	
	public void setGift_total(int[] gift_total) {
		this.gift_total = gift_total;
	}

}
