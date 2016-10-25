package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

/**
 *  * @author Andrew Cameron
 *
 * edited by Laura DeOtte from donorapp setup to missionaryapp setup
 *
 * This is used to display detailed information about a specific gift.
 * The gift is determined by the "position" int passed into the fragment
 * which then uses that to check the list of gifts and choose the one at
 * that spot. At which point it grabs all the needed information and displays
 * it in the gift_detailedview_layout.
 */
public class DetailedGift extends Fragment {

    final static String ARG_GIFT_ID = "gift_id";
    final static String ARG_DONOR_ID = "donor_id";
    final static String ARG_DONOR_NAME = "donor_name";

    private int gift_id = -1, donor_id = -1;
    private String donor_name = "", phone_cell = "", email_info = "";
    private Bundle args;

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.gift_detailedview_layout, container, false);
        getActivity().setTitle("Gift");

        if (savedInstanceState != null) {
            gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
            donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            donor_name = savedInstanceState.getString(ARG_DONOR_NAME);
        }

        return v;
    }

    @Override
    public void onStart() {
        super.onStart();
        args = getArguments();

        if (args != null) {
            updateGiftView(args.getInt(ARG_GIFT_ID), args.getInt(ARG_DONOR_ID), args.getString(ARG_DONOR_NAME));
        } else if (gift_id != -1) {
            updateGiftView(gift_id, donor_id, donor_name);
        }
    }

    /**
     * Sets each text field with the detailed information about the gift
     *
     * @param gift_id, Gift Identification
     */
    private void updateGiftView(final int gift_id, final int donor_id, final String donor_name) {
        TextView fundTitle = (TextView) getActivity().findViewById(R.id.fundText);
        TextView date      = (TextView) getActivity().findViewById(R.id.dateText);
        TextView amount    = (TextView) getActivity().findViewById(R.id.giftAmountText);
        TextView donorName = (TextView) getActivity().findViewById(R.id.nameText);
        TextView email     = (TextView) getActivity().findViewById(R.id.emailText);
        TextView phone     = (TextView) getActivity().findViewById(R.id.phoneText);


        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        Gift g = db.getGift(gift_id);
        ContactInfo contactinfo = db.getContactInfoById(donor_id);
        db.close();

        // Map data fields to layout fields
        RelativeLayout DonorInfo = (RelativeLayout) getActivity().findViewById(R.id.donorInfoLayout);
        //DonorInfo.setOnItemClickListener(new onDonorClicked());
        donorName.setText(donor_name);
        email_info = contactinfo.getEmail();
        email.setText(email_info);
        phone_cell = contactinfo.getCell();
        if(phone_cell==null){
            phone_cell = contactinfo.getPhone();
        }
        phone.setText(phone_cell);
        fundTitle.setText("Gift to: " + g.getGiftFund());
        date.setText("Date: " + Formatter.getFormattedDate(g.getGiftDate()));
        amount.setText("Amount: " + Formatter.amountToString(g.getGiftAmount()));


        DonorInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle args = new Bundle();
                args.putString("donor_name", donor_name);
                args.putInt("donor_id", donor_id);
                args.putString("donor_email", email_info);
                args.putString("donor_phone", phone_cell);

                DetailedDonor newfrag = new DetailedDonor();
                newfrag.setArguments(args);

                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.contentFrame, newfrag);
                transaction.addToBackStack("ToDetailedDonorView");
                transaction.commit();
            }
        });

        this.gift_id = gift_id;
    }


    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_GIFT_ID, gift_id);
        outState.putInt(ARG_DONOR_ID, donor_id);
        outState.putString(ARG_DONOR_NAME, donor_name);
    }
}
