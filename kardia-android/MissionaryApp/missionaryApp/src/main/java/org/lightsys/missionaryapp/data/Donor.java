package org.lightsys.missionaryapp.data;

/**
 * @author Andrew Lockridge
 * created on 6/10/2015.
 *
 * Class represents a donor connected with the user
 */
public class Donor {

    private int    id;
    private String name;
    private byte[] image;
    private String email;
    private String phone;
    private String address;
    private String date;

    /* ************************* Construct ************************* */
    public Donor() {}

    public Donor(int id, String name, byte[] image, String phone, String email, String address, String date) {
        this.id   = id;
        this.name = name;
        this.image = image;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.date = date;
    }

    /* ************************* Set ************************* */
    public void setId(int id)               { this.id = id; }

    public void setName(String name)        { this.name = name; }

    public void setImage(byte[] image)      { this.image = image; }

    public void setEmail (String email)     { this.email = email; }

    public void setPhone (String phone)     { this.phone = phone; }

    public void setAddress (String address) { this.address = address; }

    public void setDate (String date)       { this.date = date; }

    /* ************************* Get ************************* */
    public int    getId()      { return id; }

    public String getName()    { return name; }

    public byte[] getImage()   { return image; }

    public String getEmail()   { return email; }

    public String getPhone()   { return phone; }

    public String getAddress() { return address; }

    public String getDate()    { return date; }

}
