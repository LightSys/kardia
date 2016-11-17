package org.lightsys.missionaryapp.views;

import android.annotation.SuppressLint;
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

    @SuppressLint("SetTextI18n")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        LocalDBHandler db = new LocalDBHandler(getActivity());
        Account account = db.getAccount();
        db.close();

        View v = inflater.inflate(R.layout.home_page_layout, container, false);
        getActivity().setTitle("Home");

        //layout welcome header
        TextView welcome = (TextView) v.findViewById(R.id.welcomeHeader);
        welcome.setText("Welcome\n\n" + account.getPartnerName() + "\n\n");

        return v;
    }
}
