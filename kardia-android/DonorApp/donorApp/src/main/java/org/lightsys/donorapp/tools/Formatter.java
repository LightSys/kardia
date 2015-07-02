package org.lightsys.donorapp.tools;

/**
 * Class created to provide date formatting functionality for dates and amounts
 * Created by Andrew on 6/30/2015.
 */
public class Formatter {

    /**
     * Converts date from "YYYY-MM-DD" to "Month DD, YYYY" form
     * @param date, the date in "YYYY-MM-DD" form that needs conversion
     * @return the date in "Month DD, YYYY" form (e.g. "March 10, 2011")
     */
    public static String getFormattedDate(String date){
        String[] formattedDate = date.split("-");
        formattedDate[1] = getMonth(Integer.parseInt(formattedDate[1]));
        if (formattedDate[2].substring(0,1).equals("0")) {
            formattedDate[2] = formattedDate[2].substring(1);
        }
        return formattedDate[1] + " " + formattedDate[2] + ",  " + formattedDate[0];
    }

    private static String getMonth(int num){
        switch(num){
            case 1: return "January";
            case 2: return "February";
            case 3: return "March";
            case 4: return "April";
            case 5: return "May";
            case 6: return "June";
            case 7: return "July";
            case 8: return "August";
            case 9: return "September";
            case 10: return "October";
            case 11: return "November";
            case 12: return "December";
            default: return "";
        }
    }

    /**
     * Converts a monetary amount from an array of integers to a readable money form
     * @param gift_total, the amount as an array of integers
     *                    gift_total[0] = dollars, gift_total[1] = cents
     * @return the amount as a standard monetary string as $Dollars.Cents (e.g. "$24.05")
     */
    public static String amountToString(int[] gift_total){
        if(gift_total[1] <= 9){
            return "$" + gift_total[0] + ".0" + gift_total[1];
        }else{
            return "$" + gift_total[0] + "." + gift_total[1];
        }
    }
}
