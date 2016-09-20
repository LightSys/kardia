package org.lightsys.missionaryapp.views;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Class formats a listview of all donors in database
 * Created by Andrew Lockridge on 6/11/2015.
 * edited from DonorApp to MissionaryApp by Laura DeOtte
 */
public class DonorList extends Fragment {

    private ArrayList<Donor> donors;
    private ArrayList<ContactInfo> contact;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        donors = db.getDonors();
        contact = db.getContactInfo();
        db.close();

        View v = inflater.inflate(R.layout.activity_main, container, false);
        getActivity().setTitle("Donors");

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>>itemList = generateListItems();
        String[] from = {"donorname", "email","phone"};
        int[] to = {R.id.subject, R.id.subject1,R.id.phone_text};

        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onDonorClicked());

        return v;
    }

        /**
         * Formats the donor information into a hashmap arraylist.
         *
         * @return a hashmap array with donor information, to be shown in a listview
         */

        private ArrayList<HashMap<String,String>> generateListItems(){
            ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
            for(Donor m : donors){
                HashMap<String,String> hm = new HashMap<String,String>();
                int ID = m.getId();
                String email = "";
                String phone = "";
                for (ContactInfo n : contact){
                    if (n.getPartnerId() == ID){
                        email = n.getEmail();
                        phone = n.getPhone();
                        if (!n.getCell().isEmpty()) {
                            phone = n.getCell();
                        }
                    }
                }

                hm.put("donorname", m.getName());
                hm.put("email", email);
                hm.put("phone", phone);


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

            LocalDBHandler db = new LocalDBHandler(getActivity(), null);
            ContactInfo contactinfo = db.getContactInfoById(ID);
            if (!contactinfo.getCell().isEmpty()) {
                args.putString("donor_phone", contactinfo.getCell());
            } else {
                args.putString("donor_phone", contactinfo.getPhone());
            }
            args.putString("donor_email", contactinfo.getEmail());

            DetailedDonor newfrag = new DetailedDonor();
            newfrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newfrag);
            transaction.addToBackStack("ToDetailedDonorView");
            transaction.commit();
        }
    }
}
