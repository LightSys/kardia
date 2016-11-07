package org.lightsys.missionaryapp.views;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Laura DeOtte
 *
 * Shows Donor name, contact info, and donations
 * allows user to email, call, or text donor
 */
public class DetailedDonor extends Fragment{

    private final static String ARG_DONOR_ID    = "donor_id";
    private final static String ARG_DONOR_NAME  = "donor_name";
    private final static String ARG_DONOR_EMAIL = "donor_email";
    private final static String ARG_DONOR_PHONE = "donor_phone";

    private int             donor_id;
    private String          donor_email;
    private String          donor_phone;
    private String          donor_name = " ";

    private ArrayList<Gift> gifts = new ArrayList<Gift>();

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        View v = inflater.inflate(R.layout.donor_detailed_layout, container, false);

        getActivity().setTitle("Donor");
        Bundle args = getArguments();

        //get donor info passed from donor list or saved instance state
        if(savedInstanceState != null){
            donor_id    = savedInstanceState.getInt(ARG_DONOR_ID);
            donor_name  = savedInstanceState.getString(ARG_DONOR_NAME);
            donor_email = savedInstanceState.getString(ARG_DONOR_EMAIL);
            donor_phone = savedInstanceState.getString(ARG_DONOR_PHONE);
        }else if (args != null) {
            donor_id    = args.getInt(ARG_DONOR_ID);
            donor_name  = args.getString(ARG_DONOR_NAME);
            donor_email = args.getString(ARG_DONOR_EMAIL);
            donor_phone = args.getString(ARG_DONOR_PHONE);

        } else{
            donor_name  = "no name";
            donor_email = "no email";
            donor_phone = "no phone";
        }

        TextView name  = (TextView)v.findViewById(R.id.userNameText);
        TextView email = (TextView)v.findViewById(R.id.emailText);
        TextView phone = (TextView)v.findViewById(R.id.phoneText);

        if(donor_name.length()>29){
            donor_name = donor_name.substring(0,28);
        }
        if(donor_phone.length()>18){
            donor_phone = donor_phone.substring(0,17);
        }

        name.setText(donor_name);
        email.setText(donor_email);
        phone.setText(donor_phone);

        //send email to donor
        email.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent email_send = new Intent(Intent.ACTION_SENDTO, Uri.fromParts("mailto", donor_email, null));
                try {
                    startActivity(Intent.createChooser(email_send, "Send email..."));
                } catch (android.content.ActivityNotFoundException ex) {
                    Toast.makeText(getActivity(),"No Email app Found", Toast.LENGTH_SHORT).show();
                }
            }
        });
        //call/text donor
        phone.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String phoneCall = "+" + donor_phone.replaceAll("[^0-9.]", "");
                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.fromParts("tel", phoneCall, null));
                try {
                    startActivity(intent);
                } catch(android.content.ActivityNotFoundException ex) {
                    Toast.makeText(getActivity(),"no Phone app found", Toast.LENGTH_SHORT).show();
                }
            }
        });

        //pull gift list for donor
        LocalDBHandler db = new LocalDBHandler(getActivity());
        gifts = db.getGiftsByDonor(donor_id);

        TextView totalText = (TextView)v.findViewById(R.id.totalAmountText);
        ListView listview = (ListView) v.findViewById(R.id.infoList);

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>> itemList = generateListItems();

        // put info into ListView underneath donor info
        String[] from = {"fund_name", "gift_date", "gift_amount"};
        int[] to = {R.id.nameText, R.id.dateText, R.id.amountText};
        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.funds_listview_item, from, to );
        listview.setAdapter(adapter);

        listview.setOnItemClickListener(new onGiftClicked());

        int [] total = {0,0};
        for (Gift g : gifts){
            total[0]+=g.getGiftAmount()[0];
            total[1]+=g.getGiftAmount()[1];
        }

        totalText.setText(Formatter.amountToString(total));


        return v;
    }

    /**
     * Used to store the current ids in case the user navigates
     * away from the app but leaves the app open.
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_DONOR_ID, donor_id);
        outState.putString(ARG_DONOR_EMAIL, donor_email);
        outState.putString(ARG_DONOR_NAME, donor_name);
        outState.putString(ARG_DONOR_PHONE, donor_phone);

    }

    /**
     * Formats the gift information into a HashMap ArrayList.
     *
     * @return a HashMap array with gift information, to be used in a SimpleAdapter
     */
    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();

        for(Gift g : gifts){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("fund_name", "Gift to: " + g.getGiftFund());
            hm.put("gift_amount", Formatter.amountToString(g.getGiftAmount()));
            hm.put("gift_date", Formatter.getFormattedDate(g.getGiftDate()));

            aList.add(hm);
        }

        return aList;
    }

    /**
     * Loads the specific details of the selected gift.
     */
    private class onGiftClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

            Bundle args = new Bundle();
            args.putInt(DetailedGift.ARG_GIFT_ID, gifts.get(position).getId());
            args.putInt(DetailedGift.ARG_DONOR_ID, gifts.get(position).getGiftDonorId());
            args.putString(DetailedGift.ARG_DONOR_NAME, gifts.get(position).getGiftDonor());

            DetailedGift newFrag = new DetailedGift();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.contentFrame, newFrag);
            transaction.addToBackStack("ToDetailedGiftView");
            transaction.commit();
        }
    }
}