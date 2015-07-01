package org.lightsys.donorapp;

/**
 * Created by bosonBaas on 3/10/2015.
 *
 * This List controls the Update List UI.
 * It primarily is composed of list segments containing Date and Subject
 */

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.Update;

import java.util.ArrayList;
import java.util.HashMap;

public class UpdateList extends Fragment {

    private static ArrayList<Update> updates = new ArrayList<Update>();
    ArrayList<HashMap<String,String>> itemList;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main, container, false);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        updates = db.getUpdates();
        db.close();

        // Map data fields to layout fields
        itemList = generateListItems();
        String[] from = {"updateMissionary", "updateDate", "updateSubject"};
        int[] to = {R.id.subject, R.id.date, R.id.detail};

        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.main_listview_item_layout, from, to );

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onUpdateClicked());

        return v;
    }

    private class onUpdateClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Bundle args = new Bundle();
            args.putInt(DetailedUpdate.ARG_UPDATE_ID, updates.get(position).getId());

            DetailedUpdate newFrag = new DetailedUpdate();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newFrag);
            transaction.addToBackStack("ToDetailedUpdateView");
            transaction.commit();
            getActivity().setTitle("Update");
        }
    }
    // Generates hash for SimpleAdapter

    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        for(Update p : updates){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("updateSubject", p.getSubject());
            hm.put("updateDate", p.formattedDate());
            hm.put("updateMissionary", p.getMissionaryName());
            aList.add(hm);
        }
        return aList;
    }
}
