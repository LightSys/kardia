package org.lightsys.missionaryapp.data;

public class Fund {
	private int FundId;
	private int missionaryId;
	private String fundName;
	private String fundDesc;
	private String fundClass;
	private String annotation;

	public Fund(){}

	public Fund(int FundId, int missionaryId, String fundName, String fundDesc, String fundClass, String annotation){
		this.setFundId(FundId);
		this.setMissionaryId(missionaryId);
		this.setFundName(fundName);
		this.setFundDesc(fundDesc);
		this.setFundClass(fundClass);
		this.setFundAnnotation(annotation);
	}

	public int getFundId() {return FundId;}

	public void setFundId(int fundid) {FundId = fundid;}

	public int getMissionaryId() {return missionaryId;}

	public void setMissionaryId(int missionaryId) {this. missionaryId = missionaryId;}

	public String getFundName() {
		return fundName;
	}

	public void setFundName(String fundName) {
		this.fundName = fundName;
	}

	public String getFundDesc() {
		return fundDesc;
	}

	public void setFundDesc(String fundDesc) {
		this.fundDesc = fundDesc;
	}

	public String getFundClass() {
		return fundClass;
	}

	public void setFundClass(String fundClass) {
		this.fundClass = fundClass;
	}

	public String getFundAnnotation() {
		return annotation;
	}

	public void setFundAnnotation(String annotation) {
		this.annotation = annotation;
	}


}
