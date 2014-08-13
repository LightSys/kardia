package org.lightsys.missionaryapp.data;

public class Fund {
	private int Id;
	private String name;
	private String fund_desc;
	private String fund_class;
	private String annotation;
	
	public Fund(){}
	
	public Fund(int Id, String fullName, String fund_desc, String fund_class, String annotation){
		this.setId(Id);
		this.setName(fullName);
		this.setFund_desc(fund_desc);
		this.setFund_class(fund_class);
		this.setAnnotation(annotation);
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

	public void setName(String fullName) {
		this.name = fullName;
	}

	public String getFund_desc() {
		return fund_desc;
	}

	public void setFund_desc(String fund_desc) {
		this.fund_desc = fund_desc;
	}

	public String getFund_class() {
		return fund_class;
	}

	public void setFund_class(String fund_class) {
		this.fund_class = fund_class;
	}

	public String getAnnotation() {
		return annotation;
	}

	public void setAnnotation(String annotation) {
		this.annotation = annotation;
	}
	
	
}
