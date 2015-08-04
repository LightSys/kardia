package org.lightsys.missionaryapp.data;

public class Period {
	private int Id;
	private String name; // example: 2014.06|DEMO
	private String date; // month and year example: June 2014
	
	public Period(){}
	
	public Period(int Id, String name, String date){
		this.setId(Id);
		this.setName(name);
		this.setDate(date);
	}

	public int getId() {
		return Id;
	}

	public void setId(int id) {
		Id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getDate(){
		return date;
	}
	
	public void setDate(String date){
		this.date = date;
	}
	
}
