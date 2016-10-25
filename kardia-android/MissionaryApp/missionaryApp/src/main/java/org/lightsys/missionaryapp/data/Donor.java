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

    public Donor() {}

    public Donor(int id, String name) {
        this.id   = id;
        this.name = name;
    }

    /* ************************* Set ************************* */
    public void setId(int id)        { this.id = id; }

    public void setName(String name) { this.name = name; }


    /* ************************* Get ************************* */
    public int    getId()   { return id; }

    public String getName() { return name; }
}
