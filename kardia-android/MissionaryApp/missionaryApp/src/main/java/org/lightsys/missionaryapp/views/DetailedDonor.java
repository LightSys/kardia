package org.lightsys.missionaryapp.views;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.support.v4.app.Fragment;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupMenu;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.zip.Inflater;

import static android.content.ContentValues.TAG;

/**
 * @author otter57
 *
 * Shows Donor name, contact info, and donations
 * allows user to email, call, or text donor
 */
public class DetailedDonor extends Fragment{

    final static String ARG_DONOR_ID    = "donor_id";
    final static String ARG_DONOR_NAME  = "donor_name";
    final static String ARG_DONOR_IMAGE = "donor_image";

    private int    donorId = 0;
    private String donorEmail;
    private String donorPhone;
    private String donorName = " ";
    private byte[] byteImage;
    private String donorAddress;

    private ArrayList<Gift> gifts = new ArrayList<Gift>();

    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        View v = inflater.inflate(R.layout.donor_detailed_layout, container, false);
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);

        getActivity().setTitle("Donor");
        Bundle args = getArguments();

        //get donor info passed from donor list or saved instance state
        if(savedInstanceState != null){
            donorId    = savedInstanceState.getInt(ARG_DONOR_ID);
            donorName  = savedInstanceState.getString(ARG_DONOR_NAME);
            byteImage = savedInstanceState.getByteArray(ARG_DONOR_IMAGE);
        }else if (args != null) {
            donorId    = args.getInt(ARG_DONOR_ID);
            donorName  = args.getString(ARG_DONOR_NAME);
            byteImage = args.getByteArray(ARG_DONOR_IMAGE);

        } else{
            donorName  = "no name";
        }

        LocalDBHandler db = new LocalDBHandler(getActivity());
        if(donorId != 0) {
            Donor donorInfo = db.getDonorInfoById(donorId);
            donorEmail = donorInfo.getEmail();
            donorPhone = donorInfo.getPhone();
            donorAddress = donorInfo.getAddress();

        }

        TextView name   = (TextView)v.findViewById(R.id.userNameText);
        TextView email  = (TextView)v.findViewById(R.id.emailText);
        TextView phone  = (TextView)v.findViewById(R.id.phoneText);
        final TextView address = (TextView)v.findViewById(R.id.addressText);
        ImageView image = (ImageView)v.findViewById(R.id.profilePicImage);

        name.setText(donorName);
        if (!donorEmail.equals("") && donorEmail != null) {
            email.setText(donorEmail);
            email.setVisibility(View.VISIBLE);
        }
        if (!donorPhone.equals("") && donorPhone != null) {
            phone.setText(donorPhone);
            phone.setVisibility(View.VISIBLE);
        }
        if (!donorAddress.equals("") && donorAddress != null) {
            address.setText(donorAddress);
            address.setVisibility(View.VISIBLE);
        }

        //set profile picture
        Bitmap bitmap;
        if (byteImage != null) {
            bitmap = BitmapFactory.decodeByteArray(byteImage, 0, byteImage.length);
            image.setImageBitmap(bitmap);
        }else{
            image.setImageResource(R.drawable.profile_picture_standard);
        }


        //open maps for address
        address.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new AlertDialog.Builder(getActivity())
                        .setCancelable(false)
                        .setMessage("Go to maps?")
                        //.setMessage("Server uses self-signed certificate. Allow connection?")
                        .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                Intent intent = new Intent(android.content.Intent.ACTION_VIEW,
                                        Uri.parse("google.navigation:q=" + donorAddress));
                                try {
                                    startActivity(intent);
                                } catch (android.content.ActivityNotFoundException ex) {
                                    Toast.makeText(getActivity(), "No Map app Found", Toast.LENGTH_SHORT).show();
                                }
                            }
                        })
                        .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .show();
            }
        });


        //send email to donor
        email.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent email_send = new Intent(Intent.ACTION_SENDTO, Uri.fromParts("mailto", donorEmail, null));
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
                new AlertDialog.Builder(getActivity())
                        .setCancelable(false)
                        .setMessage("Go to phone?")
                        //.setMessage("Server uses self-signed certificate. Allow connection?")
                        .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                String phoneCall = "+" + donorPhone.replaceAll("[^0-9.]", "");
                                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.fromParts("tel", phoneCall, null));
                                try {
                                    startActivity(intent);
                                } catch(android.content.ActivityNotFoundException ex) {
                                    Toast.makeText(getActivity(),"no Phone app found", Toast.LENGTH_SHORT).show();
                                }
                            }
                        })
                        .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .show();
            }
        });

        //pull gift list for donor
        gifts = db.getGiftsByDonor(donorId);

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
        outState.putInt(ARG_DONOR_ID, donorId);
        outState.putString(ARG_DONOR_NAME, donorName);
        outState.putByteArray(ARG_DONOR_IMAGE, byteImage);

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

            hm.put("fund_name", "Gift to: " + g.getGiftFundDesc());
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
            transaction.replace(R.id.contentFrame, newFrag, "DetailedGift");
            transaction.addToBackStack("ToDetailedGiftView");
            transaction.commit();
        }
    }
}