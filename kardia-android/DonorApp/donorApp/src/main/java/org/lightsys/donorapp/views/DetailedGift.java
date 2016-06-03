package org.lightsys.donorapp.views;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.tools.DownloadPDF;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;

import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;

/**
 * This is used to display detailed information about a specific gift.
 * The gift is determined by the "position" int passed into the fragment
 * which then uses that to check the list of gifts and choose the one at
 * that spot. At which point it grabs all the needed information and displays
 * it in the gift_detailedview_layout.
 * 
 * @author Andrew Cameron
 *
 */
public class DetailedGift extends Fragment{
	
	final static String ARG_GIFT_ID = "gift_id";
	int gift_id = -1;
	private Bundle args;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

		getActivity().setTitle("Gift");

		if(savedInstanceState != null){
			gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
		}

		return inflater.inflate(R.layout.gift_detailedview_layout, container, false);
	}

	@Override
	public void onStart() {
		super.onStart();
		args = getArguments();

		if(args != null){
			updateGiftView(args.getInt(ARG_GIFT_ID));
		}
		else if(gift_id != -1) {
			updateGiftView(gift_id);
		}
	}
	
	/**
	 * Sets each text field with the detailed information about the gift
	 * @param gift_id, Gift Identification
	 */
	public void updateGiftView(int gift_id){
		TextView fundTitle = (TextView)getActivity().findViewById(R.id.fund);
		TextView date = (TextView)getActivity().findViewById(R.id.date);
		TextView amount = (TextView)getActivity().findViewById(R.id.giftamount);
		TextView checknum = (TextView)getActivity().findViewById(R.id.checknum);

		LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		Gift g = db.getGift(gift_id);
		db.close();
		
		fundTitle.setText("Gift to " + g.getGift_fund_desc());
		date.setText("Date: " + Formatter.getFormattedDate(g.getGift_date()));
		amount.setText("Amount: " + Formatter.amountToString(g.getGift_amount()));
		checknum.setText("Check Number: " + g.getGift_check_num());

		this.gift_id = gift_id;

		// Set up a link bar to donate to the fund with which the gift is associated
		LinkBar lb = new LinkBar();
		lb.setArguments(args);

		FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
		fragmentManager.beginTransaction().replace(R.id.bottom_bar, lb).commit();

		Button viewPDFButton = (Button)getActivity().findViewById(R.id.pdfButton);
		viewPDFButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Toast.makeText(getActivity(), "Sorry, not implemented yet.", Toast.LENGTH_SHORT).show();
				// Gift receipt pdfs not implemented yet
				// Will need to insert url and filename into DownloadPDF constructor to implement
				// See NoteList class for example on how to do this

//				Account account = accts.get(0);
//				String directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString();
//				DownloadPDF download = new DownloadPDF("INSERT URL", account.getServerName(), account.getAccountName(),
//						account.getAccountPassword(), directory, "INSERT FILE NAME", getActivity(), getActivity());
//				download.execute("");
			}
		});
	}


	/**
	 * Used to hold onto the id, in case the user comes back to this page
	 * (like if their phone goes into sleep mode or they temporarily leave the app)
	 */
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);	
		outState.putInt(ARG_GIFT_ID, gift_id);
	}
}
