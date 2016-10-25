package org.lightsys.missionaryapp.data;

/**
 * Class represents a donor that the user is connected with
 *
 * Created by Andrew Lockridge on 6/10/2015.
 */
public class Donor {

    private int id;
    private String name;

    public Donor() {}

    public Donor(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public void setId(int id) {this.id = id;}

    public int getId() {return id;}

    public void setName(String name) {this.name = name;}

    public String getName() {return name;}
}
