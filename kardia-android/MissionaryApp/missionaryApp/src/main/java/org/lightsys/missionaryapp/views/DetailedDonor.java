package org.lightsys.missionaryapp.views;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

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

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        View v = inflater.inflate(R.layout.donor_detailed_view_layout, container, false);
        getActivity().setTitle("Donor");
        args=this.getArguments();
        if(savedInstanceState != null){
            donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            donor_name = savedInstanceState.getString(ARG_DONOR_NAME);
            donor_email = savedInstanceState.getString(ARG_DONOR_EMAIL);
            donor_phone = savedInstanceState.getString(ARG_DONOR_PHONE);
        }else if (args!= null) {
            donor_id = args.getInt(ARG_DONOR_ID);
            donor_name = args.getString(ARG_DONOR_NAME);
            donor_email = args.getString(ARG_DONOR_EMAIL);
            donor_phone = args.getString(ARG_DONOR_PHONE);
        }

        //put giftlist for donor

        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        gifts = db.getGiftsByDonor(donor_id);

        ListView listview = (ListView)v.findViewById(R.id.info_list);

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>> itemList = generateListItems();

        // If list is for specific fund, display fund as smaller (not as subject)
        String[] from = {"fundname", "giftdate", "giftamount"};
        if (isSpecificFund) {
            int[] to = {R.id.fundName, R.id.subject, R.id.detail};
            SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
            listview.setAdapter(adapter);
        } else {
            int[] to = {R.id.subject, R.id.date, R.id.detail};
            SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );
            listview.setAdapter(adapter);
        }

        listview.setOnItemClickListener(new onGiftClicked());

        return v;
    }

    @Override
    public void onStart() {
        super.onStart();
        args = this.getArguments();
        if (args != null) {
            updateDonorView(args.getInt(ARG_DONOR_ID), args.getString(ARG_DONOR_NAME), args.getString(ARG_DONOR_EMAIL), args.getString(ARG_DONOR_PHONE));
        } else if (!donor_name.equals(" ")) {
            updateDonorView(donor_id, donor_name, donor_email, donor_phone);
        }
    }

    /**
     * Sets each text field with the detailed information about the donor
     *
     * @param donor_id
     * @param donor_name
     * @param donor_email
     * @param donor_phone
     */
    public void updateDonorView(final int donor_id , final String donor_name, final String donor_email, final String donor_phone) {
        //set Donor information header
        TextView name = (TextView)getActivity().findViewById(R.id.name);
        TextView email = (TextView)getActivity().findViewById(R.id.email);
        TextView phone = (TextView)getActivity().findViewById(R.id.phone);

        name.setText(donor_name);
        email.setText(donor_email);
        phone.setText(donor_phone);

















        /*DonorInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle args = new Bundle();
                args.putString("donorname", donor_name);
                args.putInt("donorid", donor_id);
                args.putString("donor_email", email_info);
                args.putString("donorPhone", phone_cell);

                DetailedDonor newfrag = new DetailedDonor();
                newfrag.setArguments(args);

                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.content_frame, newfrag);
                transaction.addToBackStack("ToDetailedDonorView");
                transaction.commit();
            }
        });*/
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

            hm.put("fundname", "Gift to: " + g.getGift_fund_desc());
            hm.put("giftamount", Formatter.amountToString(g.getGift_amount()));
            hm.put("giftdate", Formatter.getFormattedDate(g.getGift_date()));

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