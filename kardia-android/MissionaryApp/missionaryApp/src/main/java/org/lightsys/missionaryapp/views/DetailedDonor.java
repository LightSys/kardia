package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by laura deotte on 3/12/2015.
 *
 * Shows Donor name, contact info, and donations
 * allows user to email, call, or text donor
 */
public class DetailedDonor extends Activity{

    private String donorName;
    private int donorId;
    private String donorEmail;
    private String donorPhone;
    private String donorCell;

    //@Override
    public void onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        View v = inflater.inflate(R.layout.activity_main, container, false);


        Bundle args = getIntent().getExtras();
        donorName = args.getString("donorname");
        donorId = args.getInt("donorid");
        donorEmail = args.getString("donoremail");
        donorPhone = args.getString("donorphone");
        donorCell = args.getString("donorcell");

        //ToDo get donation details
        // Map donation data fields to layout fields
        /*ArrayList<HashMap<String,String>>itemList = generateListItems();
        String[] from = {"donorname"};
        int[] to = {R.id.subject};

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

    /*private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        for(Donor m : donors){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("donorname", m.getName());

            aList.add(hm);
        }
        return aList;
    }/*

    /**
     * Sends the User to a contact form for the donor they click on
     */
    /*private class onDonorClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Intent contact = new Intent(getActivity(), ContactDonorActivity.class);
            contact.putExtra("donorname", donors.get(position).getName());
            contact.putExtra("donorid", donors.get(position).getNoteId());
            startActivity(contact);
        }*/
    }
}