package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.Calendar;

import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.data.LocalDBHandler;

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
import android.widget.Toast;
import android.widget.ToggleButton;

import com.example.donorapp.R;

public class SearchActivity extends Fragment{
	
	private Button date1, date2, search;
	private EditText amount1, amount2, checknum;
	private CheckBox dateRange, amountRange;
	private ToggleButton toggleDate, toggleAmount, toggleCheck;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.search_activity_layout, container, false);
		
		date1 = (Button)v.findViewById(R.id.datepick1);
		date2 = (Button)v.findViewById(R.id.datepick2);
		search = (Button)v.findViewById(R.id.searchbtn);
		amount1 = (EditText)v.findViewById(R.id.amount1);
		amount2 = (EditText)v.findViewById(R.id.amount2);
		checknum = (EditText)v.findViewById(R.id.checknum);
		dateRange = (CheckBox)v.findViewById(R.id.dateRange);
		amountRange = (CheckBox)v.findViewById(R.id.amountRange);
		toggleDate = (ToggleButton)v.findViewById(R.id.toggleDate);
		toggleAmount = (ToggleButton)v.findViewById(R.id.toggleAmount);
		toggleCheck = (ToggleButton)v.findViewById(R.id.toggleCheck);
		
		search.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v){
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
				if(toggleDate.isChecked()){
					dateRange.setEnabled(true);
					date1.setEnabled(true);
				}else{
					dateRange.setChecked(false);
					dateRange.setEnabled(false);
					date1.setText("Choose Date");
					date2.setText("Choose Date");
					date1.setEnabled(false);
					date2.setEnabled(false);
				}
			}
		});
		
		toggleAmount.setOnClickListener(new OnClickListener(){
			
			@Override
			public void onClick(View v){
				if(toggleAmount.isChecked()){
					amountRange.setEnabled(true);
					amount1.setEnabled(true);
				}else{
					amountRange.setChecked(false);
					amountRange.setEnabled(false);
					amount1.setText("");
					amount2.setText("");
					amount1.setEnabled(false);
					amount2.setEnabled(false);
				}
			}
		});
		
		toggleCheck.setOnClickListener(new OnClickListener(){
			
			@Override
			public void onClick(View v){
				if(toggleCheck.isChecked()){
					checknum.setEnabled(true);
				}else{
					checknum.setText("");
					checknum.setEnabled(false);
				}
			}
		});
		return v;
	}
	
	public void openDatePicker(int btn_id){
		Calendar c = Calendar.getInstance();
	    int mYear = c.get(Calendar.YEAR);
	    int mMonth = c.get(Calendar.MONTH);
	    int mDay = c.get(Calendar.DAY_OF_MONTH);
	    System.out.println("the selected " + mDay);
	    DatePickerDialog dialog = new DatePickerDialog(getActivity(),
	            new mDateSetListener(btn_id), mYear, mMonth, mDay);
	    dialog.show();
	}
	
	public void doSearch(){
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
		
		String selectStatement = "SELECT * FROM gifts";
		String dateSearch = "";
		String amountSearch = "";
		String checkSearch = "";
		
		if(toggleDate.isChecked()){
			String sDate = (!date1.getText().toString().equals("Choose Date"))? date1.getText().toString() : "";
			String eDate = (date2.isEnabled() && !date2.getText().toString().equals("Choose Date"))? date2.getText().toString() : "";
			
			if(!sDate.equals("") && !eDate.equals("")){
				dateSearch = " WHERE (gift_date BETWEEN '" + sDate + "' AND '" + eDate + "')";
			}else if(!sDate.equals("")){
				dateSearch = " WHERE (gift_date = '" + sDate + "')";
			}
		
			selectStatement += dateSearch;
		}
		
		if(toggleAmount.isChecked()){
			String sAmount = (!amount1.getText().toString().equals(""))? amount1.getText().toString() : "";
			String eAmount = (amount2.isEnabled() && !amount2.getText().toString().equals(""))? amount2.getText().toString() : "";
			
			if(!sAmount.equals("") && !eAmount.equals("")){
				if(dateSearch.equals("")){
					amountSearch = " WHERE (gift_total_whole BETWEEN " + sAmount + " AND " + eAmount + ")";
				}else{
					amountSearch = " AND (gift_total_whole BETWEEN " + sAmount + " AND " + eAmount + ")";
				}
			}else if(!sAmount.equals("")){
				if(dateSearch.equals("")){
					amountSearch = " WHERE (gift_total_whole = " + sAmount + ")";
				}else{
					amountSearch = " AND (gift_total_whole = " + sAmount + ")";
				}
			}
		
			selectStatement += amountSearch;
		}
		
		if(toggleCheck.isChecked()){
			String checkNum = (!checknum.getText().toString().equals(""))?checknum.getText().toString() : "";
			
			if(!checkNum.equals("")){
				if(dateSearch.equals("") && amountSearch.equals("")){
					checkSearch = " WHERE gift_check_num = " + checkNum;
				}else{
					checkSearch = " AND (gift_check_num = " + checkNum + ")";
				}
		}
		
		selectStatement += checkSearch;
		}
		ArrayList<Gift> results = db.getSearchResults(selectStatement);
		
		if(results.size() == 0){
			Toast.makeText(getActivity(), "0 Gifts found.", Toast.LENGTH_SHORT).show();
		}else if(results.size() == 1){
			resetAll();
			Toast.makeText(getActivity(), "1 Gift found.", Toast.LENGTH_SHORT).show();
			sendToDetailedGift(results.get(0).getId());
		}else{
			resetAll();
			Toast.makeText(getActivity(), results.size() + " Gift(s) found.", Toast.LENGTH_SHORT).show();
			sendToGiftList(selectStatement);
		}
	}
	
	public void resetAll(){
		date1.setText("Choose Date");
		date1.setEnabled(false);
		date2.setText("Choose Date");
		date2.setEnabled(false);
		amount1.setText("");
		amount1.setEnabled(false);
		amount2.setText("");
		amount2.setEnabled(false);
		checknum.setText("");
		checknum.setEnabled(false);
		dateRange.setChecked(false);
		dateRange.setEnabled(false);
		amountRange.setChecked(false);
		amountRange.setEnabled(false);
		toggleDate.setChecked(false);
		toggleAmount.setChecked(false);
		toggleCheck.setChecked(false);
	}
	
	public void sendToDetailedGift(int gift_id){
		Bundle args = new Bundle();
		args.putInt(DetailedGift.ARG_GIFT_ID, gift_id);
		
		DetailedGift detailedgift = new DetailedGift();
		detailedgift.setArguments(args);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.content_frame, detailedgift);
		transaction.addToBackStack("ToDetailedGiftView");
		transaction.commit();
	}
	
	public void sendToGiftList(String query){
		Bundle args = new Bundle();
		args.putString(GiftList.ARG_GIFT_QUERY, query);
		
		GiftList gl = new GiftList();
		gl.setArguments(args);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.content_frame, gl);
		transaction.addToBackStack("ToGiftList");
		transaction.commit();
	}
	
	public void changeDateRange(){
		if(date2.isEnabled()){
			date2.setText("Choose Date");
			date2.setEnabled(false);
		}else{
			date2.setEnabled(true);
		}
	}
	
	
	public void changeAmountRange(){
		if(amount2.isEnabled()){
			amount2.setText("");
			amount2.setEnabled(false);
		}else{
			amount2.setEnabled(true);
		}
	}
	
	private class mDateSetListener implements DatePickerDialog.OnDateSetListener{
		
		private int btn_id;
		
		public mDateSetListener(int btn_id){
			this.btn_id = btn_id;
		}
		
		@Override
		public void onDateSet(DatePicker view, int year, int monthOfYear,
				int dayOfMonth) {
			
			String month = (monthOfYear < 10)? "0" + monthOfYear : "" + monthOfYear;
			String day = (dayOfMonth < 10)? "0" + dayOfMonth : "" + dayOfMonth;
			
			if(btn_id == 1){
				date1.setText(year + "-" + month + "-" + day);
			}else{
				date2.setText(year + "-" + month + "-" + day);
			}
		}
	}
}
