package org.lightsys.donorapp;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.example.donorapp.R;

/**
 * Created by JoshWorkman on 3/12/2015.
 *
 * This is currently only a blank interface that will be used to contact missionaries with prayer requests, praises, or updates
 */
public class ContactMissionaryActivity extends Fragment{

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.missionary_contact_form_layout, container, false);
    }
}
