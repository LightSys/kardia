package org.lightsys.missionaryapp.data;


/**
 * @author Laura DeOtte
 *
 *Basic Class used to organize information about Transactions for the user
 */
public class Transaction {
    private int Id;
    private String name;
    private String transactionFund;
    private int[] transactionAmount;
    private String transactionDate;
    private String transactionDonor;
    private int transactionDonorId;

    /* ************************* Construct ************************* */
    public Transaction() {
    }

    public Transaction(int Id, String name, String transactionFund, int[] transactionAmount,
                       String transactionDate, String transactionDonor, int transactionDonorId) {
        this.setId(Id);
        this.setName(name);
        this.setTransactionFund(transactionFund);
        this.setTransactionAmount(transactionAmount);
        this.setTransactionDate(transactionDate);
        this.setTransactionDonor(transactionDonor);
        this.setTransactionDonorId(transactionDonorId);
    }

	/* ************************* Set ************************* */

    public void setId(int Id) {
        this.Id = Id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setTransactionFund(String transactionFund) {
        this.transactionFund = transactionFund;
    }

    public void setTransactionAmount(int[] transactionAmount) {
        this.transactionAmount = transactionAmount;
    }

    public void setTransactionDate(String transactionDate) {
        this.transactionDate = transactionDate;
    }

    public void setTransactionDonor(String transactionDonor) {
        this.transactionDonor = transactionDonor;
    }

    public void setTransactionDonorId(int transactionDonorId) {
        this.transactionDonorId = transactionDonorId;
    }


    /* ************************* Get ************************* */
    public int getId() {
        return Id;
    }

    public String getName() {
        return name;
    }

    public String getTransactionFund() {
        return transactionFund;
    }

    public int[] getTransactionAmount() {
        return transactionAmount;
    }

    public String getTransactionDate() {
        return transactionDate;
    }

    public String getTransactionDonor() {
        return transactionDonor;
    }

    public int getTransactionDonorId() {
        return transactionDonorId;
    }
}