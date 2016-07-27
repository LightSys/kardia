package org.lightsys.missionaryapp.data;

/**
 * Class represents a donor that the user is connected with
 *
 * Created by Andrew Lockridge on 6/10/2015.
 */
public class Donor {

    private int id;
    private String name;
    private String email;
    private String phone;
    private String cell;

    public Donor() {}

    public Donor(int id, String name, String email, String phone, String cell) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.cell = cell;
    }

    public void setId(int id) {this.id = id;}

    public int getId() {return id;}

    public void setName(String name) {this.name = name;}

    public String getName() {return name;}

    public void setEmail(String email) {this.email = email;}

    public String getEmail() {return email;}

    public void setPhone(String phone) {this.phone = phone;}

    public String getPhone() {return phone;}

    public void setCell(String cell) {this.cell = cell;}

    public String getCell() {return cell;}

}
