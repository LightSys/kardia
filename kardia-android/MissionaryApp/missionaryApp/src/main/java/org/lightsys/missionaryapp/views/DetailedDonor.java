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
import android.widget.RelativeLayout;
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
 * Created by otter57 on 3/12/2015.
 *
 * Shows Donor name, contact info, and donations
 * allows user to email, call, or text donor
 */
public class DetailedDonor extends Fragment{

    final static String ARG_DONOR_ID = "donor_id";
    final static String ARG_DONOR_NAME = "donor_name";
    final static String ARG_DONOR_EMAIL = "donor_email";
    final static String ARG_DONOR_PHONE = "donor_phone";

    private String donor_name = " ";
    private int donor_id;
    private String donor_email;
    private String donor_phone;
    private Bundle args;
    private ArrayList<Gift> gifts = new ArrayList<Gift>();
    final static String TAG = "DETAILED DONOR";
    private boolean isSpecificFund = false;
    ListView listview;

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        View v = inflater.inflate(R.layout.donor_detailed_view_layout, container, false);

        getActivity().setTitle("Donor");
        args=getArguments();

        if(savedInstanceState != null){
            donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            donor_name = savedInstanceState.getString(ARG_DONOR_NAME);
            donor_email = savedInstanceState.getString(ARG_DONOR_EMAIL);
            donor_phone = savedInstanceState.getString(ARG_DONOR_PHONE);
        }else if (args != null) {
            donor_id = args.getInt(ARG_DONOR_ID);
            donor_name = args.getString(ARG_DONOR_NAME);
            donor_email = args.getString(ARG_DONOR_EMAIL);
            donor_phone = args.getString(ARG_DONOR_PHONE);

        } else{
            donor_name="no name";
            donor_email="no email";
            donor_phone = "no phone";
        }
        TextView name = (TextView)v.findViewById(R.id.name_text);
        TextView email = (TextView)v.findViewById(R.id.email_text);
        TextView phone = (TextView)v.findViewById(R.id.phone_text);
        RelativeLayout donorinfo = (RelativeLayout)v.findViewById(R.id.donor_info_layout);
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
                String tele_call = "+" + donor_phone.replaceAll("[^0-9.]", "");
                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.fromParts("tel", tele_call, null));
                try {
                    startActivity(intent);
                } catch(android.content.ActivityNotFoundException ex) {
                    Toast.makeText(getActivity(),"no Phone app found", Toast.LENGTH_SHORT).show();
                }
            }
        });


        //put giftlist for donor
        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        gifts = db.getGiftsByDonor(donor_id);

        listview = (ListView)v.findViewById(R.id.info_list);

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>> itemList = generateListItems();

        // If list is for specific fund, display fund as smaller (not as subject)
        String[] from = {"fundname", "giftdate", "giftamount"};
        int[] to = {R.id.fund_name_text, R.id.date_text, R.id.amount_text};
        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.fund_layout, from, to );
        listview.setAdapter(adapter);

        listview.setOnItemClickListener(new onGiftClicked());

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
     * Formats the gift information into a hashmap arraylist.
     *
     * @return a hashmap array with gift information, to be used in a SimpleAdapter
     */
    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();

        for(Gift g : gifts){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("fundname", "Gift to: " + g.getGiftFundDesc());
            hm.put("giftamount", Formatter.amountToString(g.getGiftAmount()));
            hm.put("giftdate", Formatter.getFormattedDate(g.getGiftDate()));

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

            DetailedGift newfrag = new DetailedGift();
            newfrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newfrag);
            transaction.addToBackStack("ToDetailedGiftView");
            transaction.commit();
        }
    }
}