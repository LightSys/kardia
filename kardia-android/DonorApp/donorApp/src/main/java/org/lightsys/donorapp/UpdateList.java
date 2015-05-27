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
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.Update;
import org.lightsys.donorapp.DetailedUpdate;

import java.util.ArrayList;
import java.util.HashMap;

public class UpdateList extends Fragment {

    private static ArrayList<Update> updates = new ArrayList<Update>();
    private LocalDBHandler db;
    ArrayList<HashMap<String,String>> itemList;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main, container, false);

        db = new LocalDBHandler(getActivity(), null, null, 9);
        updates = db.getUpdates();
        db.close();

        itemList = generateListItems();
        String[] from = {"updateName",  "updateDate"};
        int[] to = {R.id.title, R.id.date};

        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.update_listview_item, from, to );

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onUpdateClicked());

        return v;
    }

    public static ArrayList<Update> getUpdates()
    {
        return updates;
    }

    private class onUpdateClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Bundle args = new Bundle();
            args.putInt(DetailedUpdate.ARG_REQUEST_ID, updates.get(position).getIntId());

            DetailedUpdate newFrag = new DetailedUpdate();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newFrag);
            transaction.addToBackStack("ToDetailedUpdateView");
            transaction.commit();
        }
    }
    // Generates hash for SimpleAdapter

    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        for(Update p : updates){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("updateName", p.getSubject());
            hm.put("updateDate", p.formatedDate(p.getDate()));
            aList.add(hm);
        }
        return aList;
    }
}
