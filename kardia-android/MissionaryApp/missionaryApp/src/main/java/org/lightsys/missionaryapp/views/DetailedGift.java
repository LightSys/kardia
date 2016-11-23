package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.annotation.SuppressLint;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
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
 * it in the gift_detailed_layout.
 */
public class DetailedGift extends Fragment {

    final static String ARG_GIFT_ID = "gift_id";
    final static String ARG_DONOR_ID = "donor_id";
    final static String ARG_DONOR_NAME = "donor_name";
    final static String ARG_DONOR_IMAGE = "donor_image";

    private int giftId = -1, donorId = -1;
    private String donorName = "", phoneCell = "", emailInfo = "";
    private byte[] byteImage;

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.gift_detailed_layout, container, false);
        getActivity().setTitle("Gift");
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);

        if (savedInstanceState != null) {
            giftId = savedInstanceState.getInt(ARG_GIFT_ID);
            donorId = savedInstanceState.getInt(ARG_DONOR_ID);
            donorName = savedInstanceState.getString(ARG_DONOR_NAME);
            byteImage = savedInstanceState.getByteArray(ARG_DONOR_IMAGE);
        }

        return v;
    }

    @Override
    public void onStart() {
        super.onStart();
        Bundle args = getArguments();

        if (args != null) {
            updateGiftView(args.getInt(ARG_GIFT_ID), args.getInt(ARG_DONOR_ID), args.getString(ARG_DONOR_NAME), args.getByteArray(ARG_DONOR_IMAGE));
        } else if (giftId != -1) {
            updateGiftView(giftId, donorId, donorName, byteImage);
        }
    }

    /**
     * Sets each text field with the detailed information about the gift
     *
     * @param giftId, Gift Identification
     */
    @SuppressLint("SetTextI18n")
    private void updateGiftView(final int giftId, final int donorId, final String donorName, final byte[] byteImage) {
        TextView fundTitleText = (TextView) getActivity().findViewById(R.id.fundText);
        TextView dateText      = (TextView) getActivity().findViewById(R.id.dateText);
        TextView amountText    = (TextView) getActivity().findViewById(R.id.giftAmountText);
        TextView donorNameText = (TextView) getActivity().findViewById(R.id.userNameText);
        TextView emailText     = (TextView) getActivity().findViewById(R.id.emailText);
        TextView phoneText     = (TextView) getActivity().findViewById(R.id.phoneText);
        ImageView donorImage   = (ImageView) getActivity().findViewById(R.id.profilePicImage);


        LocalDBHandler db = new LocalDBHandler(getActivity());
        Gift g = db.getGift(giftId);
        ContactInfo contactinfo = db.getContactInfoById(donorId);
        db.close();

        // Map data fields to layout fields
        RelativeLayout DonorInfo = (RelativeLayout) getActivity().findViewById(R.id.donorInfoLayout);

        emailInfo = contactinfo.getEmail();
        phoneCell = contactinfo.getCell();
        if(phoneCell==null){
            phoneCell = contactinfo.getPhone();
        }
        //set profile picture
        Bitmap bitmap;
        if (byteImage != null) {
            bitmap = BitmapFactory.decodeByteArray(byteImage, 0, byteImage.length);
            donorImage.setImageBitmap(bitmap);
        }else{
            donorImage.setImageResource(R.drawable.profile_picture_standard);
        }

        donorNameText.setText(donorName);
        phoneText.setText(phoneCell);
        emailText.setText(emailInfo);

        fundTitleText.setText("Fund: " + g.getGiftFund());
        dateText.setText(Formatter.getFormattedDate(g.getGiftDate()));
        amountText.setText(Formatter.amountToString(g.getGiftAmount()));

        //if Donor clicked, send user to detailed donor page
        DonorInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle args = new Bundle();
                args.putString("donor_name", donorName);
                args.putInt("donor_id", donorId);
                args.putString("donor_email", emailInfo);
                args.putString("donor_phone", phoneCell);
                args.putByteArray("donor_image", byteImage);

                DetailedDonor newFrag = new DetailedDonor();
                newFrag.setArguments(args);

                FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
                transaction.replace(R.id.contentFrame, newFrag, "DetailedDonor");
                transaction.addToBackStack("ToDetailedDonorView");
                transaction.commit();
            }
        });

        this.giftId = giftId;
    }


    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_GIFT_ID, giftId);
        outState.putInt(ARG_DONOR_ID, donorId);
        outState.putString(ARG_DONOR_NAME, donorName);
    }
}
