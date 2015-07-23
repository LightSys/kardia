package org.lightsys.donorapp.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;
import org.lightsys.donorapp.data.Missionary;
import org.lightsys.donorapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Class formats a listview of all missionaries in database
 * Created by Andrew Lockridge on 6/11/2015.
 */
public class MissionaryList extends Fragment {

    private ArrayList<Missionary> missionaries;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
        missionaries = db.getMissionaries();
        db.close();

        View v = inflater.inflate(R.layout.activity_main, container, false);
        getActivity().setTitle("Missionaries");

        // Map data fields to layout fields
        ArrayList<HashMap<String,String>>itemList = generateListItems();
        String[] from = {"missionaryname"};
        int[] to = {R.id.subject};

        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to);

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onMissionaryClicked());

        return v;
    }

        /**
         * Formats the missionary information into a hashmap arraylist.
         *
         * @return a hashmap array with missionary information, to be shown in a listview
         */
        private ArrayList<HashMap<String,String>> generateListItems(){

        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        for(Missionary m : missionaries){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("missionaryname", m.getName());

            aList.add(hm);
        }
        return aList;
    }

    /**
     * Sends the User to a contact form for the missionary they click on
     */
    private class onMissionaryClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Intent contact = new Intent(getActivity(), ContactMissionaryActivity.class);
            contact.putExtra("missionaryname", missionaries.get(position).getName());
            contact.putExtra("missionaryid", missionaries.get(position).getId());
            startActivity(contact);
        }
    }
}
