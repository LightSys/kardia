package org.lightsys.donorapp.bottombar;

import java.util.Calendar;

import org.lightsys.donorapp.data.LocalDBHandler;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.donorapp.R;

/**
 * Displays the button to send the user to a list of gifts by year
 * 
 * @author Andrew Cameron
 *
 */
public class TotalBar extends Fragment {
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.totalbar_layout, container, false);
		TextView totalText = (TextView)v.findViewById(R.id.viewytd);
		totalText.setText("View Gifts by Year");
		return v;
	}
}