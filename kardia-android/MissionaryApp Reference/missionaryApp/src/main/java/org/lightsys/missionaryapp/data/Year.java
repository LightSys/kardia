package org.lightsys.missionaryapp.data;

/**
 * Created by Breven on 3/10/2015.
 */
public class Year {
    private int Id;
    private String name;
    private int[] gift_total;

    public Year() {}

    public Year(int Id, String name, int[] gift_total){
        this.setId(Id);
        this.setName(name);
        this.setGift_total(gift_total);
    }

    public int getId() {
        return Id;
    }

    public void setId(int Id) {
        this.Id = Id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int[] getGift_total() {
        return gift_total;
    }

    public void setGift_total(int[] gift_total) {
        this.gift_total = gift_total;
    }

    public String amountToString(){
        if(gift_total[1] <= 9){
            return "$" + gift_total[0] + ".0" + gift_total[1];
        }else{
            return "$" + gift_total[0] + "." + gift_total[1];
        }
    }

}
