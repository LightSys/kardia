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

    /* ************************* Construct ************************* */
    public Donor() {}

    public Donor(int id, String name, byte[] image) {
        this.id   = id;
        this.name = name;
        this.image = image;
    }

    /* ************************* Set ************************* */
    public void setId(int id)        { this.id = id; }

    public void setName(String name) { this.name = name; }

    public void setImage(byte[] image) { this.image = image; }

    /* ************************* Get ************************* */
    public int    getId()   { return id; }

    public String getName() { return name; }

    public byte[] getImage() { return image; }

}
