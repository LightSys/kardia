package org.lightsys.missionaryapp.data;

/**
 * Class represents a Fund connected with the user
 */
public class Fund {
	private int    fundId;
	private int    missionaryId;
	private String fundName;
	private String fundDesc;
	private String fundClass;
	private String annotation;

	public Fund() {}

	public Fund(int FundId, int missionaryId, String fundName, String fundDesc,
				String fundClass, String annotation) {
		this.setFundId(FundId);
		this.setMissionaryId(missionaryId);
		this.setFundName(fundName);
		this.setFundDesc(fundDesc);
		this.setFundClass(fundClass);
		this.setFundAnnotation(annotation);
	}

	/* ************************* Set ************************* */
	public void setFundId(int fundId)                { this.fundId = fundId;}

	public void setMissionaryId(int missionaryId)    { this. missionaryId = missionaryId;}

	public void setFundName(String fundName) 		 { this.fundName = fundName; }

	public void setFundDesc(String fundDesc) 		 { this.fundDesc = fundDesc; }

	public void setFundClass(String fundClass) 		 { this.fundClass = fundClass; }

	public void setFundAnnotation(String annotation) { this.annotation = annotation; }

	/* ************************* Get ************************* */
	public int    getFundId()         {return fundId;}

	public int    getMissionaryId()   { return missionaryId;}

	public String getFundName()       { return fundName; }

	public String getFundDesc()       { return fundDesc; }

	public String getFundClass()      { return fundClass; }

	public String getFundAnnotation() { return annotation; }

}
