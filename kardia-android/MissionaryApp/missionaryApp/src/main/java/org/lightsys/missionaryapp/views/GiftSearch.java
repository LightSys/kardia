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
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

public class GiftSearch extends Fragment{

	private Button       date1, date2;
    private EditText     amount1, amount2;
	private TextView     dash1, dash2, dollarSign2, donorText, fundText;
    private TextView     selectDate, selectAmount, selectDonor, selectFund;
	private CheckBox     dateRange, amountRange;
    private ListView     donorList, fundList;
	private LinearLayout dateLayout, amountLayout;
    private RelativeLayout donorLayout, fundLayout;
    private ArrayList<String> donorArray, fundArray;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		View v = inflater.inflate(R.layout.search_gift_activity_layout, container, false);

		getActivity().setTitle("Gift Search");
		
		date1         = (Button)v.findViewById(R.id.datePickBtn);
		date2         = (Button)v.findViewById(R.id.datePickBtn2);
        Button search = (Button) v.findViewById(R.id.searchBtn);
        Button clear  = (Button)v.findViewById(R.id.clearBtn);
		amount1       = (EditText)v.findViewById(R.id.amount1);
		amount2       = (EditText)v.findViewById(R.id.amount2);
		dateRange     = (CheckBox)v.findViewById(R.id.dateRange);
		amountRange   = (CheckBox)v.findViewById(R.id.amountRange);
        donorList     = (ListView) v.findViewById(R.id.donorList);
        fundList      = (ListView) v.findViewById(R.id.fundList);
        dateLayout    = (LinearLayout)v.findViewById(R.id.dateLayout);
		amountLayout  = (LinearLayout)v.findViewById(R.id.amountLayout);
        donorLayout   = (RelativeLayout)v.findViewById(R.id.donorLayout);
        fundLayout    = (RelativeLayout)v.findViewById(R.id.fundLayout);
        dash1         = (TextView)v.findViewById(R.id.dashTextView);
		dash2         = (TextView)v.findViewById(R.id.dash2);
		dollarSign2   = (TextView)v.findViewById(R.id.dollarSign2);
        donorText     = (TextView)v.findViewById(R.id.donorText);
        fundText      = (TextView)v.findViewById(R.id.fundText);
        selectDate    = (TextView)v.findViewById(R.id.refreshTitle);
        selectAmount  = (TextView)v.findViewById(R.id.selectAmount);
        selectDonor  = (TextView)v.findViewById(R.id.selectDonor);
        selectFund  = (TextView)v.findViewById(R.id.selectFund);

        amount1.addTextChangedListener(new GenericTextWatcher(v));
        fundText.addTextChangedListener(new GenericTextWatcher(v));
        fundText.addTextChangedListener(new GenericTextWatcher(v));

		search.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				doSearch();
			}
		});

        clear.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                resetAll();
                Toast.makeText(getActivity(), "Search data cleared", Toast.LENGTH_SHORT).show();
            }
        });

        LocalDBHandler db = new LocalDBHandler(getActivity());

        donorArray = db.getDonorsOfGifts();
        fundArray  = db.getFundNames(db.getAccount().getId());
        db.close();

        ArrayAdapter<String> donorAdapter = new ArrayAdapter<String>(getActivity(), R.layout.search_listview_item, donorArray);
        donorList.setAdapter(donorAdapter);
        ArrayAdapter<String> fundAdapter = new ArrayAdapter<String>(getActivity(), R.layout.search_listview_item, fundArray);
        fundList.setAdapter(fundAdapter);
        if(fundAdapter.getCount() > 5){
            View item = fundAdapter.getView(0, null, fundList);
            item.measure(0, 0);
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) (5 * item.getMeasuredHeight()));
            fundList.setLayoutParams(params);
        }
        if(donorAdapter.getCount() > 5){
            View item = donorAdapter.getView(0, null, donorList);
            item.measure(0, 0);
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) (5 * item.getMeasuredHeight()));
            donorList.setLayoutParams(params);
        }

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

		selectDate.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v){
                selectDate();
			}
		});
		selectAmount.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v){
                selectAmount();
			}
		});

        selectDonor.setOnClickListener(new OnClickListener(){

            @Override
            public void onClick(View v){
                selectDonor();
            }
        });

        selectFund.setOnClickListener(new OnClickListener(){

            @Override
            public void onClick(View v){
                selectFund();
            }
        });

        donorText.setOnClickListener(new OnClickListener(){
            @Override
            public void onClick(View v){

                // change visibility of donorList
                if(donorLayout.getVisibility() == View.VISIBLE){
                    donorLayout.setVisibility(View.GONE);
                }else{
                    donorLayout.setVisibility(View.VISIBLE);
                }
            }
        });
        fundText.setOnClickListener(new OnClickListener(){
            @Override
            public void onClick(View v){

                // change visibility of fundList
                if(fundLayout.getVisibility() == View.VISIBLE){
                    fundLayout.setVisibility(View.GONE);
                }else{
                    fundLayout.setVisibility(View.VISIBLE);
                }
            }
        });

        donorList.setOnItemClickListener(new onDonorClicked());
        fundList.setOnItemClickListener(new onFundClicked());

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
		LocalDBHandler db = new LocalDBHandler(getActivity());

		// Construct parameters to set for the database search
		String startDate   = "";
		String endDate     = "";
		String startAmount = "";
		String endAmount   = "";
		String donorName   = "";
        String fundName    = "";

		ArrayList<Fund> giftFund = db.getFundsForMissionary(db.getAccount().getId());
        if(dateLayout.getVisibility() == View.VISIBLE){
			startDate = (!date1.getText().toString().equals("Choose Date"))? date1.getText().toString() : "";
			endDate = (date2.isEnabled() && !date2.getText().toString().equals("Choose Date"))? date2.getText().toString() : "";
		}
		if(amountLayout.getVisibility() == View.VISIBLE){
			startAmount = (!amount1.getText().toString().equals(""))? amount1.getText().toString() : "";
			endAmount = (amount2.isEnabled() && !amount2.getText().toString().equals(""))? amount2.getText().toString() : "";
		}
        if(donorText.getVisibility() == View.VISIBLE){
            donorName = (!donorText.getText().toString().equals(""))? donorText.getText().toString():"";
        }
        if(fundText.getVisibility() == View.VISIBLE){
            fundName = (!fundText.getText().toString().equals(""))? fundText.getText().toString():"";
        }
		if (startDate.equals("") && endDate.equals("") && startAmount.equals("")
				&& endAmount.equals("") && donorName.equals("") && fundName.equals("")) {
			Toast.makeText(getActivity(), "No values were provided for search", Toast.LENGTH_LONG).show();
		} else if (startDate.equals("") && !endDate.equals("")) {
			Toast.makeText(getActivity(), "Please select a start value for the range", Toast.LENGTH_LONG).show();
			date1.setError("Choose a start date");
		} else if (startAmount.equals("") && !endAmount.equals("")) {
			Toast.makeText(getActivity(), "Please select a start value for the range", Toast.LENGTH_LONG).show();
			amount1.setError("Set an amount value");
		} else {
			// Do search for gifts with constructed parameters
			ArrayList<Gift> results = new ArrayList<Gift>();
            results.addAll(db.getGiftSearchResults(startDate, endDate, startAmount, endAmount, fundName, donorName));
            db.close();

            // Send to corresponding page depending on search results
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

	private void resetAll(){

        //clear date
        dateRange.setChecked(false);
        dateRange.setVisibility(View.GONE);
        dateLayout.setVisibility(View.GONE);
        dash1.setVisibility(View.INVISIBLE);
        date2.setVisibility(View.INVISIBLE);
        date2.setText(R.string.choose_date);
        date1.setText(R.string.choose_date);
        date1.setError(null);
        //clear amount
        amountRange.setVisibility(View.GONE);
        amountLayout.setVisibility(View.GONE);
        dash2.setVisibility(View.INVISIBLE);
        dollarSign2.setVisibility(View.INVISIBLE);
        amount2.setVisibility(View.INVISIBLE);
        amount1.setText("");
        amount1.setError(null);
        amount2.setText("");
        amountRange.setChecked(false);
        //clear donor
        donorText.setVisibility(View.GONE);
        donorText.setText("");
        donorLayout.setVisibility(View.GONE);
        //clear fund
        fundText.setVisibility(View.GONE);
        fundText.setText("");
        fundLayout.setVisibility(View.GONE);

	}

	private void sendToDetailedGift(int gift_id, int donor_id, String donor_name){
		Bundle args = new Bundle();
		args.putInt(DetailedGift.ARG_GIFT_ID, gift_id);
		args.putInt(DetailedGift.ARG_DONOR_ID, donor_id);
		args.putString(DetailedGift.ARG_DONOR_NAME, donor_name);
		
		DetailedGift detailedgift = new DetailedGift();
		detailedgift.setArguments(args);
		
		FragmentTransaction transaction = getActivity().getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.contentFrame, detailedgift, "DetailedGift");
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
		transaction.replace(R.id.contentFrame, gl, "Gift")
                .addToBackStack("ToGiftList")
                .commit();
	}

	private void changeDateRange(){
		// If date range is activated, set respective fields as visible
		// If date range is not activated, set fields to gone and set to default
		if(dateRange.isChecked()){
			dash1.setVisibility(View.VISIBLE);
			date2.setVisibility(View.VISIBLE);
		}else{
			date2.setVisibility(View.INVISIBLE);
			dash1.setVisibility(View.INVISIBLE);
			date2.setText(R.string.choose_date);
		}
	}


	private void changeAmountRange(){
		// If amount range is activated, set respective fields as visible
		// If amount range is not activated, set fields to gone and set to default
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
    /**
     * set text if donor clicked
     */
    private class onDonorClicked implements AdapterView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            donorText.setText(donorArray.get(position));
            donorLayout.setVisibility(View.GONE);
        }
    }

    /**
     *set text if fund clicked
     **/
    private class onFundClicked implements AdapterView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            fundText.setText(fundArray.get(position));
            fundLayout.setVisibility(View.GONE);
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

    private void selectDate(){
        // If date search is activated, set respective fields to visible
        // If date search is not activated, set fields to gone and set to default
        if(dateLayout.getVisibility() == View.GONE){
            dateRange.setVisibility(View.VISIBLE);
            dateLayout.setVisibility(View.VISIBLE);
        }else{
            dateRange.setChecked(false);
            dateRange.setVisibility(View.GONE);
            date1.setText(R.string.choose_date);
            date1.setError(null);
            date2.setText(R.string.choose_date);
            dash1.setVisibility(View.INVISIBLE);
            date2.setVisibility(View.INVISIBLE);
            dateLayout.setVisibility(View.GONE);
        }
    }
    private void selectAmount(){
        // If amount search is activated, set respective fields to visible
        // If amount search is not activated, set fields to gone and set to default
        if(amountLayout.getVisibility() == View.GONE){
            amountRange.setVisibility(View.VISIBLE);
            amountLayout.setVisibility(View.VISIBLE);
        }else{
            amountRange.setChecked(false);
            amountRange.setVisibility(View.GONE);
            amount1.setText("");
            amount1.setError(null);
            amount2.setText("");
            dash2.setVisibility(View.INVISIBLE);
            amount2.setVisibility(View.INVISIBLE);
            dollarSign2.setVisibility(View.INVISIBLE);
            amountLayout.setVisibility(View.GONE);
        }
    }
    private void selectDonor(){
        // change visibility of donor search
        if(donorText.getVisibility() == View.GONE){
            donorText.setVisibility(View.VISIBLE);
        }else{
            donorText.setText("");
            donorText.setVisibility(View.GONE);
            donorLayout.setVisibility(View.GONE);
        }
    }
    private void selectFund(){
        // change visibility of fund search
        if(fundText.getVisibility() == View.GONE){
            fundText.setVisibility(View.VISIBLE);
        }else{
            fundText.setText("");
            fundLayout.setVisibility(View.GONE);
            fundText.setVisibility(View.GONE);
        }
    }
}
