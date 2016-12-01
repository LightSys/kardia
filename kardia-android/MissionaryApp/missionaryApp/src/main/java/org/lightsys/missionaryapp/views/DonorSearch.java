package org.lightsys.missionaryapp.views;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.util.ArrayList;

public class DonorSearch extends Fragment{
	
    private EditText nameText;
	private LinearLayout nameLayout;
    private Spinner nameType;
    private TextView selectName;
    private Button clearSearchButton;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.search_donor_activity_layout, container, false);

		getActivity().setTitle("Donor Search");

        Button search = (Button) v.findViewById(R.id.searchBtn);
		nameText = (EditText)v.findViewById(R.id.nameText);
        nameLayout = (LinearLayout)v.findViewById(R.id.nameLayout);
        nameType = (Spinner)v.findViewById(R.id.nameType);
        selectName = (TextView) v.findViewById(R.id.selectName);
        clearSearchButton = (Button)v.findViewById(R.id.clearSearchButton);


		search.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				doSearch();
			}
		});

        selectName.setOnClickListener(new OnClickListener(){

            @Override
            public void onClick(View v){

                // change visibility of fund search
                if(nameLayout.getVisibility() == View.GONE){
                    nameLayout.setVisibility(View.VISIBLE);
                }
            }
        });

        clearSearchButton.setOnClickListener(new OnClickListener(){

            @Override
            public void onClick(View v){
                //clear search criteria and close window
                nameText.setText("");
                nameLayout.setVisibility(View.GONE);
            }
        });
		return v;
	}

	private void doSearch(){
		LocalDBHandler db = new LocalDBHandler(getActivity());

		// Construct parameters to set for the database search
		String searchName   = "";

        if(nameLayout.getVisibility() == View.VISIBLE) {
            //searchName = (!nameText.getText().toString().equals("")) ? nameText.getText().toString() : "";
            searchName = nameText.getText().toString();
        }
		if (searchName.equals("")) {
			Toast.makeText(getActivity(), "No values were provided for search", Toast.LENGTH_LONG).show();
		} else {
			// Do search for gifts with constructed parameters
			ArrayList<Donor> allDonors = new ArrayList<Donor>();
            allDonors.addAll(db.getDonors());
            db.close();

            //filter donors to match search
            ArrayList<Donor> results = new ArrayList<Donor>();
            for (Donor d : allDonors){
                //get name to search
                String donorName = d.getName().toLowerCase();
                if (nameType.getSelectedItem().toString().equals("First Name:") && donorName.contains(" ")) {
                    String[] nameSplit = d.getName().split(" ", 2);
                    donorName = nameSplit[0].toLowerCase();
                }else if (nameType.getSelectedItem().toString().equals("Last Name:") && donorName.contains(" ")) {
                    String[] nameSplit = d.getName().split(" ", 2);
                    donorName = nameSplit[1].toLowerCase();
                }
                //check donor name to see if it matches search criteria
                if (donorName.contains(searchName.toLowerCase())){
                    results.add(d);
                }
            }

            // Send to corresponding page depending on search results
            if (results.size() == 0) {
                Toast.makeText(getActivity(), "0 Donors found.", Toast.LENGTH_SHORT).show();
            } else if (results.size() == 1) {
                resetAll();
                Toast.makeText(getActivity(), "1 Donor found.", Toast.LENGTH_SHORT).show();
                sendToDetailedDonor(results.get(0));
            } else {
                resetAll();
                Toast.makeText(getActivity(), results.size() + " Donor found.", Toast.LENGTH_SHORT).show();
                sendToDonorList(results);
            }
		}
	}

	private void resetAll(){
		nameText.setText(R.string.enter_name);
        nameType.setSelection(0);
        nameLayout.setVisibility(View.GONE);
	}

	private void sendToDetailedDonor(Donor d){
		Bundle args = new Bundle();
		args.putInt(DetailedGift.ARG_DONOR_ID, d.getId());
		args.putString(DetailedDonor.ARG_DONOR_NAME, d.getName());
        args.putByteArray(DetailedDonor.ARG_DONOR_IMAGE, d.getImage());

        DetailedDonor detailedDonor = new DetailedDonor();
        detailedDonor.setArguments(args);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, detailedDonor, "DetailedDonor");
		transaction.addToBackStack("ToDetailedDonorView");
        transaction.commit();
	}

	private void sendToDonorList(ArrayList<Donor> donorList){
		ArrayList<Integer> donorIdList = new ArrayList<Integer>();

		for (Donor d : donorList) {
			donorIdList.add(d.getId());
		}

		Bundle args = new Bundle();
		args.putIntegerArrayList(DonorList.ARG_DONOR_ID, donorIdList);
		
		DonorList dl = new DonorList();
		dl.setArguments(args);

		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, dl, "Donor")
                .addToBackStack("ToDonorList")
                .commit();
	}
}
