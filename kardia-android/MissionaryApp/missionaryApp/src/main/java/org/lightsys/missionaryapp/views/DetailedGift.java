package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.tools.DownloadPDF;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

/**
 * This is used to display detailed information about a specific gift.
 * The gift is determined by the "position" int passed into the fragment
 * which then uses that to check the list of gifts and choose the one at
 * that spot. At which point it grabs all the needed information and displays
 * it in the gift_detailedview_layout.
 * 
 * @author Andrew Cameron
 *
 * @edited Laura DeOtte
 * from donorapp setup to missionaryapp setup
 *
 */
public class DetailedGift extends Fragment{
	
	final static String ARG_GIFT_ID = "gift_id";
    final static String ARG_DONOR_ID = "donor_id";
    final static String ARG_DONOR_NAME = "donor_name";

    int gift_id = -1, donor_id=-1;
    String donor_name = "";
	private Bundle args;
	private Gift gift;
	private Context context;

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
        View v = inflater.inflate(R.layout.gift_detailedview_layout, container, false);
		getActivity().setTitle("Gift");

		if(savedInstanceState != null){
			gift_id = savedInstanceState.getInt(ARG_GIFT_ID);
            donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
            donor_name = savedInstanceState.getString(ARG_DONOR_NAME);
        }

		context = inflater.getContext();

		return v;
	}

	@Override
	public void onStart() {
		super.onStart();
		args = getArguments();

		if(args != null){
			updateGiftView(args.getInt(ARG_GIFT_ID),args.getInt(ARG_DONOR_ID),args.getString(ARG_DONOR_NAME));
		}
		else if(gift_id != -1) {
			updateGiftView(gift_id,donor_id,donor_name);
		}
	}
	/**
	 * Sets each text field with the detailed information about the gift
	 * @param gift_id, Gift Identification
	 */
	public void updateGiftView(final int gift_id, final int donor_id, final String donor_name){
		TextView fundTitle = (TextView)getActivity().findViewById(R.id.fund);
		TextView date = (TextView)getActivity().findViewById(R.id.date);
		TextView amount = (TextView)getActivity().findViewById(R.id.giftamount);
		TextView checknum = (TextView)getActivity().findViewById(R.id.checknum);
        TextView donorName = (TextView)getActivity().findViewById(R.id.subject);
        TextView email = (TextView)getActivity().findViewById(R.id.subsubject1);
        TextView phone = (TextView)getActivity().findViewById(R.id.subsubject2);


        LocalDBHandler db = new LocalDBHandler(getActivity(), null);
		Gift g = db.getGift(gift_id);
        ContactInfo contactinfo = db.getContactInfoById(donor_id);
		//todo remove? unnecessary?
        gift = g;
		db.close();

        // Map data fields to layout fields
        RelativeLayout DonorInfo = (RelativeLayout)getActivity().findViewById(R.id.donor_info_layout);
        //DonorInfo.setOnItemClickListener(new onDonorClicked());
        donorName.setText(donor_name);
        email.setText(contactinfo.getEmail());
        if (!contactinfo.getCell().isEmpty()) {
            phone.setText(contactinfo.getCell());
        }else {
            phone.setText(contactinfo.getPhone());
        }
        fundTitle.setText("Gift to " + g.getGift_fund_desc());
		date.setText("Date: " + Formatter.getFormattedDate(g.getGift_date()));
		amount.setText("Amount: " + Formatter.amountToString(g.getGift_amount()));
		//checknum.setText("Comments: " + g.getGift_check_num());

		this.gift_id = gift_id;

		// Set up a link bar to donate to the fund with which the gift is associated
		LinkBar lb = new LinkBar();
		lb.setArguments(args);

		/*FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
		fragmentManager.beginTransaction().replace(R.id.bottom_bar, lb).commit();*/

		Button viewPDFButton = (Button)getActivity().findViewById(R.id.pdfButton);
		viewPDFButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {

				LocalDBHandler db = new LocalDBHandler(context, null);
				Account account = db.getAccounts().get(0);
				String giftID = gift.getName().replace("|", "%7C");
				String directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString();
				String url = "http://" + account.getServerName() + ":800/apps/kardia/api/donor/" + account.getId() + "/Gifts/" + giftID + "/Receipt";
				DownloadPDF download = new DownloadPDF(url, account.getServerName(), account.getAccountName(),
						account.getAccountPassword(), directory, "Receipt for " + gift.getName() + ".pdf", getActivity(), getActivity());
				download.execute("");

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

   /* private class onDonorClicked implements AdapterView.OnItemClickListener {
        //todo change Intent to DetailedDonor.class
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            Intent contact = new Intent(getActivity(), ContactDonorActivity.class);
            contact.putExtra("donorname", donors.get(position).getName());
            contact.putExtra("donorid", donors.get(position).getId());
            //contact.putExtra("donorEmail",donors.get(position).getEmail());
            //contact.putExtra("donorPhone",donors.get(position).getPhone());
            // contact.putExtra("donorCell",donors.get(position).getCell());

            startActivity(contact);
        }
    }*/
}
