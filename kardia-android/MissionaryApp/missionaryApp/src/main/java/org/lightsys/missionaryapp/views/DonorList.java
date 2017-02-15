package org.lightsys.missionaryapp.views;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.tools.DonorAdapter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

import static android.content.ContentValues.TAG;

/**
 * @author Andrew Lockridge
 * created on 6/11/2015.
 * edited by Laura DeOtte from DonorApp to MissionaryApp
 *
 * Class formats a listview of all donors in database
 */

public class DonorList extends Fragment {

    final static String ARG_DONOR_ID = "donor_id";

    private ArrayList<Integer> donorId = new ArrayList<Integer>();

    private ArrayList<Donor> donors;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        LocalDBHandler db = new LocalDBHandler(getActivity());

        Bundle args = getArguments();
        //get donor info passed from donor list or saved instance state
        if(savedInstanceState != null){
            donorId = savedInstanceState.getIntegerArrayList(ARG_DONOR_ID);
        }else if (args != null) {
            donorId = args.getIntegerArrayList(ARG_DONOR_ID);
        } else{
            donorId = null;
        }

        if (donorId == null) {
            donors = db.getDonors();
        }else{
            String donorIdStr = "(" +android.text.TextUtils.join(", ", donorId) + ")";
            Log.d(TAG, "onCreateView: " + donorIdStr);
            donors = db.getDonorsById(donorIdStr);
        }


        db.close();

        View v = inflater.inflate(R.layout.activity_main_layout, container, false);
        getActivity().setTitle("Donors");

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>>itemList = generateListItems();
        ArrayList<Bitmap> bitmaps= getProfilePictures();
        String[] from = {"donor_name", "email","phone"};
        int[] to = {R.id.userNameText, R.id.emailText, R.id.phoneText};

        DonorAdapter adapter = new DonorAdapter(getActivity(), itemList, R.layout.donor_info_layout, from, to, bitmaps);

        ListView listview = (ListView)v.findViewById(R.id.infoList);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onDonorClicked());

        return v;
    }

        /**
         * collects profile pictures for donors.
         *
         * @return Bitmap image for each donor
         */

        private ArrayList<Bitmap> getProfilePictures(){
            ArrayList <Bitmap> bitmaps = new ArrayList<Bitmap>();
            LocalDBHandler db = new LocalDBHandler(getActivity());
            Bitmap bitmap;
            for (Donor d : donors) {
                byte[] bytes = d.getImage();

                if (bytes != null) {
                    bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
                }else{
                    bitmap = null;
                }

                bitmaps.add(bitmap);
            }
            db.close();
            return bitmaps;
        }


        /**
         * Formats the donor information into a HashMap ArrayList.
         *
         * @return a HashMap array with donor information, to be shown in a ListView
         */

        private ArrayList<HashMap<String,String>> generateListItems(){
            ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
            for(Donor m : donors){
                HashMap<String,String> hm = new HashMap<String,String>();

                hm.put("donor_name", m.getName());
                hm.put("email", m.getEmail());
                hm.put("phone", m.getPhone());

                aList.add(hm);
            }
            return aList;
        }
    /**
     * Sends the User to a contact form for the donor they click on
     */
    private class onDonorClicked implements AdapterView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            int ID = donors.get(position).getId();

            Bundle args = new Bundle();
            args.putString("donor_name", donors.get(position).getName());
            args.putInt("donor_id", ID);
            args.putByteArray("donor_image", donors.get(position).getImage());

            DetailedDonor newFrag = new DetailedDonor();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.contentFrame, newFrag, "DetailedDonor");
            transaction.addToBackStack("ToDetailedDonorView");
            transaction.commit();
        }
    }
}
