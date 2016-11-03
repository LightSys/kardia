package org.lightsys.missionaryapp.views;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author otter57 on 6/11/2015.
 *
 * Home Page for Missionary app
 * welcomes user and displays page buttons
 */
public class HomePage extends Fragment {

    private String[] mCategories;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        LocalDBHandler db = new LocalDBHandler(getActivity());
        Account account = db.getAccount();
        db.close();

        View v = inflater.inflate(R.layout.home_page_layout, container, false);
        getActivity().setTitle("Home");

        //layout welcome header
        TextView welcome = (TextView) v.findViewById(R.id.welcomeHeader);
        welcome.setVisibility(View.VISIBLE);
        welcome.setText("Welcome\n" + account.getPartnerName());

        // Map data fields to layout fields
        mCategories = getResources().getStringArray(R.array.categories);

        ArrayList<HashMap<String,String>>itemList = generateListItems();
        String[] from = {"list_item"};
        int[] to = {R.id.navigateButton};

        ListView listview = (ListView)v.findViewById(R.id.welcomeList);
        SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.home_button_listview_item, from, to);
        listview.setAdapter(adapter);
        listview.setOnItemClickListener(new onPageClicked());

        return v;
    }

    /**
     * Formats the donor information into a HashMap ArrayList.
     *
     * @return a HashMap array with donor information, to be shown in a ListView
     */

    private ArrayList<HashMap<String,String>> generateListItems(){
        ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        for (int m=1; m < mCategories.length ;m++){
            HashMap<String,String> hm = new HashMap<String,String>();
            hm.put("list_item", mCategories[m]);

            aList.add(hm);
        }
        return aList;
    }
    /**
     * Sends the User to a page for the button they click on
     */
    private class onPageClicked implements AdapterView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id){
            ((MainActivity)getActivity()).selectItem(position+1);
        }
    }

}