package org.lightsys.missionaryapp.data;

/**
 * @author Laura DeOtte
 * created on 7/6/16.
 * Stores Contact Info (Email, Phone, Cell) for contacting donors
 */
public class ContactInfo {
    private int partnerid;
    private String email;
    private String phone;
    private String cell;

    public ContactInfo() {
    }

    public ContactInfo(int partnerid, String email, String phone, String cell) {
        this.partnerid = partnerid;
        this.email = email;
        this.phone = phone;
        this.cell = cell;
    }

    public int getPartnerId() {
        return partnerid;
    }

    public void setPartnerId(int partnerid) {
        this.partnerid = partnerid;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCell() {return cell;}

    public void setCell(String cell) {this.cell = cell;}

}
