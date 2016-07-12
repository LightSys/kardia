package org.lightsys.missionaryapp.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
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
        int[] to = {R.id.subject, R.id.email,R.id.phone};

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
                    if (!n.getCell().equals("null")) {
                        phone = n.getCell();
                    }
                }
            }

            hm.put("donorname", m.getName());
            hm.put("email", "Email: " + email);
            hm.put("phone", "Phone: " + phone);


            aList.add(hm);
        }
        return aList;
    }
    private ArrayList<HashMap<String,String>> generateContactItems() {
        ArrayList<HashMap<String, String>> aList = new ArrayList<HashMap<String, String>>();
        for (Donor m : donors) {
            HashMap<String, String> hm = new HashMap<String, String>();

            hm.put("donorid", Integer.toString(m.getId()));

            aList.add(hm);
        }
        return aList;
    }

    /**
     * Sends the User to a contact form for the donor they click on
     */
    private class onDonorClicked implements AdapterView.OnItemClickListener {
        //todo change Intent to DetailedDonor.class
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Intent contact = new Intent(getActivity(), ContactDonorActivity.class);
            contact.putExtra("donorname", donors.get(position).getName());
            contact.putExtra("donorid", donors.get(position).getId());
            //contact.putExtra("donorEmail",donors.get(position).getEmail());
            //contact.putExtra("donorPhone",donors.get(position).getPhone());
           // contact.putExtra("donorCell",donors.get(position).getCell());

            startActivity(contact);
        }
    }
}
