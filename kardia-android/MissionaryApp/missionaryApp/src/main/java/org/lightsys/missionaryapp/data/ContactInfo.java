package org.lightsys.missionaryapp.data;

/**
 * @author otter57
 * created on 7/6/16.
 *
 * Class that stores Contact Info (Email, Phone, Cell) for contacting donors
 */
public class ContactInfo {
    private int    partnerId;
    private String email;
    private String phone;
    private String cell;

    /* ************************* Construct ************************* */
    public ContactInfo() {}

    public ContactInfo(int partnerId, String email, String phone, String cell) {
        this.partnerId = partnerId;
        this.email     = email;
        this.phone     = phone;
        this.cell      = cell;
    }

    /* ************************* Set ************************* */

    public void setPartnerId(int id)   { this.partnerId = id; }

    public void setEmail(String email) { this.email = email; }

    public void setPhone(String phone) { this.phone = phone; }

    public void setCell(String cell)   { this.cell = cell;}

    /* ************************* Get ************************* */
    public int getPartnerId()    { return partnerId; }

    public     String getEmail() { return email; }

    public     String getPhone() { return phone; }

    public     String getCell()  { return cell;}

}
