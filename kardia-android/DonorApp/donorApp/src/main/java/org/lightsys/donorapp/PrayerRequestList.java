package org.lightsys.donorapp;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.PopupWindow;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;

import android.view.ViewGroup;
import android.widget.AdapterView;

import android.widget.ListView;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.PrayerRequest;

import java.util.ArrayList;
import java.util.HashMap;

/*
@author Josh Workman
 */
public class PrayerRequestList extends Fragment {

    private static ArrayList<PrayerRequest> prayerRequests = new ArrayList<PrayerRequest>();
    private static ArrayList<Account> accounts;
    private ArrayList<HashMap<String,Object>> itemList;
    private LocalDBHandler db;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.activity_main, container, false);

        db = new LocalDBHandler(getActivity(), null, null, 9);
        accounts = db.getAccounts();


        prayerRequests = db.getRequests();

        itemList = generateListItems();
        String[] from = {"prayerName", "prayerDate"};
        int[] to = {R.id.title,  R.id.date};

        PrayerAdapter adapter = new PrayerAdapter(getActivity(), itemList, R.layout.prayer_request_listview_item, from, to, accounts.get(0) );

        ListView listview = (ListView)v.findViewById(R.id.info_list);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onPrayerRequestClicked());

        return v;
    }

    public static ArrayList<PrayerRequest> getPrayerRequests()
    {
        return prayerRequests;
    }

    private class onPrayerRequestClicked implements AdapterView.OnItemClickListener {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Bundle args = new Bundle();
            args.putInt(DetailedPrayerRequest.ARG_REQUEST_ID, prayerRequests.get(position).getIntId());

            DetailedPrayerRequest newFrag = new DetailedPrayerRequest();
            newFrag.setArguments(args);

            FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.content_frame, newFrag);
            transaction.addToBackStack("ToDetailedRequestView");
            transaction.commit();
        }
    }

    private ArrayList<HashMap<String,Object>> generateListItems(){
        ArrayList<HashMap<String,Object>> aList = new ArrayList<HashMap<String,Object>>();

        for(PrayerRequest p : prayerRequests){
            HashMap<String,Object> hm = new HashMap<String,Object>();

            hm.put("prayerName", (Object)(p.getSubject()+p.getId()));
            hm.put("prayerDate", (Object)p.formatedDate(p.getDate()));
            boolean isPrayedFor = false;
            for (int i = 0; i < accounts.size(); i++) {
                if(accounts.get(i).isRequestPrayedFor(p.getId())){
                    isPrayedFor = true;
                    break;
                }
            }
            hm.put("prayedFor", isPrayedFor);
            hm.put("prayerId", p.getIntId());
            aList.add(hm);
        }
        return aList;
    }

    private void setPrayedFor(int position, boolean status, View button){
        itemList.get(position).put("prayedFor", status);
        if(status) {
            button.setBackground(getResources().getDrawable(R.drawable.kardiabeat_v2));
        } else {
            button.setBackground(getResources().getDrawable(R.drawable.ic_action_search));
        }
    }
}
