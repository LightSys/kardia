package org.lightsys.missionaryapp.data;

public class Donor {
	
	private byte[] donorImg;
	private String cellnumber, email, name;
	private int id;
	
	public Donor(){
	}
	
	public Donor(int id, String name, String cellnumber, String email, byte[] donorImg){
		this.id = id;
		this.name = name;
		this.email = email;
		this.cellnumber = cellnumber;
        this.donorImg = donorImg;
	}

    public Donor(int id, String name) {
        this.id = id;
        this.name = name;
    }
	
	public void setId(int id){
		this.id = id;
	}
	
	public int getId(){
		return id;
	}
	
	public void setName(String name){
		this.name = name;
	}
	
	public String getName(){
		return name;
	}
	
	public void setEmail(String email){
		this.email = email;
	}
	
	public String getEmail(){
		return email;
	}
	
	public void setCellNumber(String cellNumber){
		this.cellnumber = cellNumber;
	}
	
	public String getCellNumber(){
		return cellnumber;
	}
	
	public void setDonorImage(byte[] donorImg){
		this.donorImg = donorImg;
	}
	
	public byte[] getDonorImg(){
		return donorImg;
	}
}
