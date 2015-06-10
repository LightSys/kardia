package org.lightsys.donorapp;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;

import android.view.ViewGroup;
import android.widget.AdapterView;

import android.widget.ListView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.PrayerRequest;

import java.util.ArrayList;
import java.util.HashMap;

/*
@author Josh Workman
 */
public class PrayerRequestList extends Fragment {

    private ArrayList<PrayerRequest> prayerRequests = new ArrayList<PrayerRequest>();
    private ArrayList<HashMap<String,String>> itemList = new ArrayList<HashMap<String, String>>();
    private ArrayList<Boolean> itemPrayedForList = new ArrayList<Boolean>();


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main, container, false);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        prayerRequests = db.getRequests();
        db.close();

        // Map data fields to layout fields
        generateListItems();
        String[] from = {"prayerSubject", "prayerDate", "prayerMissionary"};
        int[] to = {R.id.subject,  R.id.date, R.id.missionaryName};

        PrayerAdapter adapter = new PrayerAdapter(getActivity(), itemList,
                itemPrayedForList, R.layout.prayer_request_listview_item, from, to);

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onPrayerRequestClicked());

        return v;
    }

    private class onPrayerRequestClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Bundle args = new Bundle();
            args.putInt(DetailedPrayerRequest.ARG_REQUEST_ID, prayerRequests.get(position).getId());

            DetailedPrayerRequest newFrag = new DetailedPrayerRequest();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newFrag);
            transaction.addToBackStack("ToDetailedRequestView");
            transaction.commit();
            getActivity().setTitle("Prayer Request");
        }
    }

    private void generateListItems(){

        for(PrayerRequest p : prayerRequests){
            HashMap<String,String> hm = new HashMap<String,String>();

            hm.put("prayerDate", p.formattedDate());
            hm.put("prayerSubject", p.getSubject());
            hm.put("prayerMissionary", p.getMissionaryName());

            itemList.add(hm);
            itemPrayedForList.add(p.getIsPrayedFor());
        }
    }
}
