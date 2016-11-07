package org.lightsys.missionaryapp.views;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.tools.DownloadPDF;
import org.lightsys.missionaryapp.tools.Formatter;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *  * @author Laura DeOtte
 *
 * This page displays a list of all fund reports for the user.
 * 
 * shows report time period
 * allows user to select report for full pdf
 */
public class ReportList extends Fragment{
	
	private ArrayList<String> reportPeriod;

	/**
	 * Pulls all relevant reportPeriods
	 */
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){
		
		LocalDBHandler db = new LocalDBHandler(getActivity());

		// Select reports for account
        int accountID = db.getAccount().getId();
        //todo reportPeriod = db.getFundsForMissionary(accountID);
        reportPeriod = new ArrayList<String>();
        reportPeriod.add("Hello user");
        reportPeriod.add("this is period 1");
        reportPeriod.add("this is period 2");

		db.close();

		View v = inflater.inflate(R.layout.activity_main_layout, container, false);

        getActivity().setTitle("Reports");

		if (reportPeriod == null) {
			return v;
		}

		// Map data fields to layout fields
		ArrayList<HashMap<String,String>>itemList = generateListItems();
		String[] from = {"report_title"};
		int[] to = {R.id.nameText};
		
		SimpleAdapter adapter = new SimpleAdapter(getActivity(), itemList, R.layout.report_listview_item, from, to);
		
		ListView listview = (ListView)v.findViewById(R.id.infoList);
		listview.setAdapter(adapter);
		//listview.setOnItemClickListener(new onReportClicked());
		
		return v;
	}
	
	/**
	 * Formats the report information into a HashMap ArrayList.
	 * 
	 * @return a HashMap array with report information, to be shown in a ListView
	 */
	private ArrayList<HashMap<String,String>> generateListItems(){

		ArrayList<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
        LocalDBHandler db = new LocalDBHandler(getActivity());

		for(String R : reportPeriod){
			HashMap<String,String> hm = new HashMap<String,String>();
			hm.put("report_title", R);
            Log.d("ReportList", "generateListItems: " + R);
            aList.add(hm);
		}
		return aList;
	}
	
	/**
	 * Opens PDF of report
	 */
    /*private class onReportClicked implements OnItemClickListener{

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            //todo create Report class - store filename
            String report = (String) reportPeriod.get(position);
            LocalDBHandler db = new LocalDBHandler(getActivity());
            Account account = db.getAccount();
            db.close();

            // Look through downloads to see if file has been downloaded
            File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);
            boolean fileFoundInDownloads = false;
            String[] downloads = path.list();
            if (downloads != null && downloads.length != 0) {
                for (String name : downloads) {
                    if (name.equals(letter.getFilename())) {
                        fileFoundInDownloads = true;
                    }
                }
            }
            if (!fileFoundInDownloads) {
                // Download file from API
                String directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString();
                String url = "http://" + account.getServerName() + ":800" + letter.getFolder() + "/" +
                        letter.getFilename();
                DownloadPDF download = new DownloadPDF(url, account.getServerName(), account.getAccountName(),
                        account.getAccountPassword(), directory, letter.getFilename(), getActivity(),
                        getActivity());
                download.execute("");
            } else {
                // Launch a PDF viewing application
                try {
                    Intent pdfIntent = new Intent(Intent.ACTION_VIEW);
                    File file = new File(path, letter.getFilename());
                    pdfIntent.setDataAndType(Uri.fromFile(file), "application/pdf");
                    startActivity(pdfIntent);
                } catch (ActivityNotFoundException e) {
                    // If no application is found on device, send a message to the user
                    Toast.makeText(getActivity(), "To view this document, you first must" +
                            "install a PDF viewing application", Toast.LENGTH_LONG).show();
                    e.printStackTrace();
                }

            }
		}
	}*/

}