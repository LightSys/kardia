package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.Calendar;

import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.GenericTextWatcher;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import org.lightsys.missionaryapp.R;

public class Search extends Fragment{
	
	private Button date1, date2;
	private EditText amount1, amount2, checknum;
	private TextView dash1, dash2, dollarSign2;
	private CheckBox dateRange, amountRange;
	private ToggleButton toggleDate, toggleAmount, toggleCheck;
	private TableRow dateRow, amountRow;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.search_activity_layout, container, false);

		getActivity().setTitle("Gift Search");
		
		date1 = (Button)v.findViewById(R.id.datePickBtn);
		date2 = (Button)v.findViewById(R.id.datePickBtn2);
		Button search = (Button)v.findViewById(R.id.searchBtn);
		amount1 = (EditText)v.findViewById(R.id.amount1);
		amount2 = (EditText)v.findViewById(R.id.amount2);
		checknum = (EditText)v.findViewById(R.id.checkNumText);
		dateRange = (CheckBox)v.findViewById(R.id.dateRange);
		amountRange = (CheckBox)v.findViewById(R.id.amountRange);
		toggleDate = (ToggleButton)v.findViewById(R.id.toggleDate);
		toggleAmount = (ToggleButton)v.findViewById(R.id.toggleAmount);
		toggleCheck = (ToggleButton)v.findViewById(R.id.toggleCheck);
		dateRow = (TableRow)v.findViewById(R.id.dateRow);
		amountRow = (TableRow)v.findViewById(R.id.amountRow);
		dash1 = (TextView)v.findViewById(R.id.dashTextView);
		dash2 = (TextView)v.findViewById(R.id.dash2);
		dollarSign2 = (TextView)v.findViewById(R.id.dollarSign2);

		amount1.addTextChangedListener(new GenericTextWatcher(v));

		search.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				doSearch();
			}
		});
		
		dateRange.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v){
				changeDateRange();
			}
		});
		
		amountRange.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v){
				changeAmountRange();
			}
		});
		
		date1.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				openDatePicker(1);
			}
		});
		
		date2.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				openDatePicker(2);
			}
		});
		
		toggleDate.setOnClickListener(new OnClickListener(){
			
			@Override
			public void onClick(View v){
				// If date search is activated, set respective fields to visible
				// If date search is not activated, set fields to invisible and set to default
				if(toggleDate.isChecked()){
					dateRange.setVisibility(View.VISIBLE);
					dateRow.setVisibility(View.VISIBLE);
				}else{
					dateRange.setChecked(false);
					dateRange.setVisibility(View.INVISIBLE);
					date1.setText("Choose Date");
					date1.setError(null);
					date2.setText("Choose Date");
					dash1.setVisibility(View.INVISIBLE);
					date2.setVisibility(View.INVISIBLE);
					dateRow.setVisibility(View.INVISIBLE);
				}
			}
		});
		toggleAmount.setOnClickListener(new OnClickListener(){
			
			@Override
			public void onClick(View v){

				// If amount search is activated, set respective fields to visible
				// If amount search is not activated, set fields to invisible and set to default
				if(toggleAmount.isChecked()){
					amountRange.setVisibility(View.VISIBLE);
					amountRow.setVisibility(View.VISIBLE);
				}else{
					amountRange.setChecked(false);
					amountRange.setVisibility(View.INVISIBLE);
					amount1.setText("");
					amount1.setError(null);
					amount2.setText("");
					dash2.setVisibility(View.INVISIBLE);
					amount2.setVisibility(View.INVISIBLE);
					dollarSign2.setVisibility(View.INVISIBLE);
					amountRow.setVisibility(View.INVISIBLE);
				}
			}
		});
		
		toggleCheck.setOnClickListener(new OnClickListener(){
			
			@Override
			public void onClick(View v){
				// If check search is activated, set respective fields to visible
				// If check search is not activated, set fields to invisible and set to default
				if(toggleCheck.isChecked()){
					checknum.setVisibility(View.VISIBLE);
				}else{
					checknum.setText("");
					checknum.setVisibility(View.INVISIBLE);
				}
			}
		});
		return v;
	}

	private void openDatePicker(int btn_id) {
		int mYear;
		int mMonth;
		int mDay;

		// If calendar already has date, pull up that date
		// Otherwise pull up today's date
		String text1 = date1.getText().toString();
		String text2 = date2.getText().toString();
		if (btn_id == 1 && !text1.equals("Choose Date")) {
			String[] splitDateStr1 = text1.split("-");
			mYear = Integer.parseInt(splitDateStr1[0]);
			//Subtract one to agree with DatePicker month standards, Jan = 0, Feb = 1, etc.
			mMonth = Integer.parseInt(splitDateStr1[1]) - 1;
			mDay = Integer.parseInt(splitDateStr1[2]);
		} else if (btn_id == 2 && !text2.equals("Choose Date")) {
			String[] splitDateStr2 = text2.split("-");
			mYear = Integer.parseInt(splitDateStr2[0]);
			//Subtract one to agree with DatePicker month standards, Jan = 0, Feb = 1, etc.
			mMonth = Integer.parseInt(splitDateStr2[1]) - 1;
			mDay = Integer.parseInt(splitDateStr2[2]);
		} else {
			Calendar c = Calendar.getInstance();
			mYear = c.get(Calendar.YEAR);
			mMonth = c.get(Calendar.MONTH);
			mDay = c.get(Calendar.DAY_OF_MONTH);
		}

	    DatePickerDialog dialog = new DatePickerDialog(getActivity(),
	            new mDateSetListener(btn_id), mYear, mMonth, mDay);
	    dialog.show();
	}

	private void doSearch(){
		LocalDBHandler db = new LocalDBHandler(getActivity(), null);

		// Construct parameters to set for the database search
		String startDate = "";
		String endDate = "";
		String startAmount = "";
		String endAmount = "";
		String checkNumber = "";
		ArrayList<Fund> giftFund = db.getFundsForMissionary(db.getAccount().getId());
		if(toggleDate.isChecked()){
			startDate = (!date1.getText().toString().equals("Choose Date"))? date1.getText().toString() : "";
			endDate = (date2.isEnabled() && !date2.getText().toString().equals("Choose Date"))? date2.getText().toString() : "";
		}
		if(toggleAmount.isChecked()){
			startAmount = (!amount1.getText().toString().equals(""))? amount1.getText().toString() : "";
			endAmount = (amount2.isEnabled() && !amount2.getText().toString().equals(""))? amount2.getText().toString() : "";
		}
		if(toggleCheck.isChecked()){
			checkNumber = (!checknum.getText().toString().equals(""))?checknum.getText().toString() : "";
		}

		if (startDate.equals("") && endDate.equals("") && startAmount.equals("")
				&& endAmount.equals("") && checkNumber.equals("")) {
			Toast.makeText(getActivity(), "No values were provided for search", Toast.LENGTH_LONG).show();
		} else if (startDate.equals("") && !endDate.equals("")) {
			Toast.makeText(getActivity(), "Please select a start value for the range", Toast.LENGTH_LONG).show();
			date1.setError("Choose a start date");
		} else if (startAmount.equals("") && !endAmount.equals("")) {
			Toast.makeText(getActivity(), "Please select a start value for the range", Toast.LENGTH_LONG).show();
			amount1.setError("Set an amount value");
		} else {
			// Do search for gifts with constructed parameters
			ArrayList<Gift> results = null;
			for(Fund f:giftFund) {
				results = db.getGiftSearchResults(startDate, endDate, startAmount, endAmount, checkNumber, f.getFundName());
				db.close();
			}

			// Send to corresponding page depending on search results
			if(results == null) {
				Toast.makeText(getActivity(), "0 Gifts found.", Toast.LENGTH_SHORT).show();
			}else{
				if (results.size() == 0) {
					Toast.makeText(getActivity(), "0 Gifts found.", Toast.LENGTH_SHORT).show();
				} else if (results.size() == 1) {
					resetAll();
					Toast.makeText(getActivity(), "1 Gift found.", Toast.LENGTH_SHORT).show();
					sendToDetailedGift(results.get(0).getId(), results.get(0).getGiftDonorId(), results.get(0).getGiftDonor());
				} else {
					resetAll();
					Toast.makeText(getActivity(), results.size() + " Gifts found.", Toast.LENGTH_SHORT).show();
					sendToGiftList(results, giftFund);
				}
			}
		}
	}

	private void resetAll(){
		date1.setText("Choose Date");
		date1.setError(null);
		date2.setText("Choose Date");
		date2.setVisibility(View.INVISIBLE);
		dash1.setVisibility(View.INVISIBLE);
		amount1.setText("");
		amount1.setError(null);
		amount2.setText("");
		amount2.setVisibility(View.INVISIBLE);
		dash2.setVisibility(View.INVISIBLE);
		dollarSign2.setVisibility(View.INVISIBLE);
		checknum.setText("");
		dateRange.setChecked(false);
		amountRange.setChecked(false);
		toggleDate.setChecked(false);
		toggleAmount.setChecked(false);
		toggleCheck.setChecked(false);
		dateRow.setVisibility(View.INVISIBLE);
		amountRow.setVisibility(View.INVISIBLE);
		checknum.setVisibility(View.INVISIBLE);
	}

	private void sendToDetailedGift(int gift_id, int donor_id, String donor_name){
		Bundle args = new Bundle();
		args.putInt(DetailedGift.ARG_GIFT_ID, gift_id);
		args.putInt(DetailedGift.ARG_DONOR_ID, donor_id);
		args.putString(DetailedGift.ARG_DONOR_NAME, donor_name);
		
		DetailedGift detailedgift = new DetailedGift();
		detailedgift.setArguments(args);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, detailedgift);
		transaction.addToBackStack("ToDetailedGiftView");
		transaction.commit();
	}

	private void sendToGiftList(ArrayList<Gift> giftList, ArrayList<Fund> fundList){
		ArrayList<Integer> giftIDList = new ArrayList<Integer>();
		ArrayList<Integer> fundIDList = new ArrayList<Integer>();

		for (Gift g : giftList) {
			giftIDList.add(g.getId());
		}
		for (Fund f : fundList) {
			fundIDList.add(f.getFundId());
		}

		Bundle args = new Bundle();
		args.putIntegerArrayList("gift_ids", giftIDList);
		args.putIntegerArrayList("fund_ids", fundIDList);
		
		GiftList gl = new GiftList();
		gl.setArguments(args);

		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, gl);
		transaction.addToBackStack("ToGiftList");
		transaction.commit();
	}

	private void changeDateRange(){
		// If date range is activated, set respective fields as visible
		// If date range is not activated, set fields to invisible and set to default
		if(dateRange.isChecked()){
			dash1.setVisibility(View.VISIBLE);
			date2.setVisibility(View.VISIBLE);
		}else{
			date2.setVisibility(View.INVISIBLE);
			dash1.setVisibility(View.INVISIBLE);
			date2.setText("Choose Date");
		}
	}


	private void changeAmountRange(){
		// If amount range is activated, set respective fields as visible
		// If amount range is not activated, set fields to invisible and set to default
		if(amountRange.isChecked()){
			dash2.setVisibility(View.VISIBLE);
			amount2.setVisibility(View.VISIBLE);
			dollarSign2.setVisibility(View.VISIBLE);
		}else{
			amount2.setVisibility(View.INVISIBLE);
			dash2.setVisibility(View.INVISIBLE);
			dollarSign2.setVisibility(View.INVISIBLE);
			amount2.setText("");
		}
	}
	
	private class mDateSetListener implements DatePickerDialog.OnDateSetListener{
		
		private final int btn_id;
		
		public mDateSetListener(int btn_id){
			this.btn_id = btn_id;
		}
		
		@Override
		public void onDateSet(DatePicker view, int year, int monthOfYear,
				int dayOfMonth) {

			// DatePicker starts months at 0, January = 0, February = 1, etc
			// Add one to make it standard with donorApp month counting
			monthOfYear++;

			String month = (monthOfYear < 10)? "0" + monthOfYear : "" + monthOfYear;
			String day = (dayOfMonth < 10)? "0" + dayOfMonth : "" + dayOfMonth;
			
			if(btn_id == 1){
				date1.setText(year + "-" + month + "-" + day);
				date1.setError(null);
			}else{ // btn_id == 2
				date2.setText(year + "-" + month + "-" + day);
			}
		}
	}
}
