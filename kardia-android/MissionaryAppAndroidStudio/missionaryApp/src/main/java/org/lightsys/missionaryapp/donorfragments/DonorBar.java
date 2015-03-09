package org.lightsys.missionaryapp.donorfragments;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.R.id;
import org.lightsys.missionaryapp.R.layout;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.LocalDBHandler;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Acts as the page header, used for obtaining quick information
 * on the donor and accessing their history quickly.
 * 
 * @author Andrew Cameron
 *
 */
public class DonorBar extends Fragment{
	
	final static String ARG_DONOR_ID = "donor_id";
	int donor_id = -1;
	private View v;
	private Donor donor;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		Bundle args = getArguments(); 
		v = inflater.inflate(R.layout.donor_listview_item, container, false);
		if(savedInstanceState != null){
			donor_id = savedInstanceState.getInt(ARG_DONOR_ID);
		}
		else if(args != null){
			updateView(args.getInt(ARG_DONOR_ID));
		}
		else if(donor_id != -1){
			updateView(donor_id);
		}
		
		return v;
	}
	
	public void updateView(int donor_id){
		RelativeLayout donor_bar = (RelativeLayout)v.findViewById(R.id.donor_bar);
		ImageView donorImg = (ImageView)v.findViewById(R.id.quickContact);
		TextView name = (TextView)v.findViewById(R.id.name);
		TextView email = (TextView)v.findViewById(R.id.email);
		TextView cellnumber = (TextView)v.findViewById(R.id.cellnumber);
		
		LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 1);
		donor = db.getDonor(donor_id);
		
		name.setText(donor.getName());
		email.setText(donor.getEmail());
		cellnumber.setText(donor.getCellNumber());
		if(donor.getDonorImg() != null){
			Bitmap map = BitmapFactory.decodeByteArray(donor.getDonorImg(), 0, donor.getDonorImg().length);
			donorImg.setImageBitmap(map);
		}
		registerForContextMenu(donor_bar);
	}
	
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo){
		super.onCreateContextMenu(menu, v, menuInfo);
		menu.add(0, v.getId(), 0, "Call");
		menu.add(0, v.getId(), 0, "Text");
		menu.add(0, v.getId(), 0, "Email");
	}
	
	public boolean onContextItemSelected(MenuItem item){
		
		if(item.getTitle().equals("Call")){
			
			Intent callIntent = new Intent(Intent.ACTION_CALL);
			callIntent.setData(Uri.parse("tel:" + donor.getCellNumber()));
			startActivity(callIntent);
			
		}else if(item.getTitle().equals("Text")){
			
			Intent textIntent = new Intent(Intent.ACTION_SENDTO);
			textIntent.setData(Uri.parse("smsto:" + donor.getCellNumber()));
			startActivity(textIntent);
			
		}else if(item.getTitle().equals("Email")){
			
			Intent emailIntent = new Intent(Intent.ACTION_SEND);
			emailIntent.setType("message/rfc822");
			emailIntent.putExtra(Intent.EXTRA_EMAIL, new String[] {donor.getEmail()});
			emailIntent.setType("message/rfc822");
			
			try{
				startActivity(Intent.createChooser(emailIntent, "Send Email"));
			}catch(android.content.ActivityNotFoundException ex){
				Toast.makeText(getActivity(), "An email client is not Installed.", Toast.LENGTH_SHORT).show();
			}
		}else{
			return false;
		}
		return true;
	}
	
	@Override
	public void onSaveInstanceState(Bundle outState){
		super.onSaveInstanceState(outState);
		outState.putInt(ARG_DONOR_ID, donor_id);
	}

}
