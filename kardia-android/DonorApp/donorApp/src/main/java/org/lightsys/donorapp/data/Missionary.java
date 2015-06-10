package org.lightsys.donorapp.data;

/**
 * Class represents a missionary that the user receives notes (updates, prayer requests) from
 *
 * Created by Andrew Lockridge on 6/10/2015.
 */
public class Missionary {

    private int id;
    private String name;

    public Missionary() {}

    public void setId(int id) {this.id = id;}

    public int getId() {return id;}

    public void setName(String name) {this.name = name;}

    public String getName() {return name;}

}
