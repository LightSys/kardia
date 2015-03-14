package org.lightsys.donorapp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;

import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Fund;
import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.PrayerRequest;
import org.lightsys.donorapp.data.Update;
import org.lightsys.donorapp.data.Year;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.Toast;

import com.example.donorapp.R;

/**
 * The main activity for the app. Creates the side-menu drawer used throughout the
 * app. This is used for switching between fragment activities.
 * This activity is also contains the dataConnection code for all api calls
 * @author Andrew Cameron
 * 
 */
public class MainActivity extends ActionBarActivity {
	private static final String Tag = "BasicAuth";
	private String[] mCategories;
	private DrawerLayout mDrawerLayout;
	private ActionBarDrawerToggle mDrawerToggle;
	private ListView mDrawerList;
	private CharSequence mTitle;
	private Fragment fragment;
	private ArrayList<Account> accts = new ArrayList<Account>();
	private static final long DAY_MILLI = 86400000;
	
	/**
	 * On first open it will open the account page. If not, starts the fund
	 * list view. Also Creates the drawer menu
	 */
	/*
	 * (non-Javadoc)
	 * The SuppressLint is used because at line 138 a method is used
	 * which is available in Ice_cream_sandwich (api 14) or later
	 * I have a build check to make sure it isn't called unless it matches 
	 * the requirements.
	 */
	@SuppressLint("NewApi")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.drawer_layout);

		/* Setting up the Drawer Navigation */

		mCategories = getResources().getStringArray(R.array.categories);
		mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
		mDrawerLayout.setDrawerShadow(R.drawable.drawer_shadow_v1, GravityCompat.START);
		
		mDrawerList = (ListView) findViewById(R.id.drawer);
		mDrawerList.setAdapter(new ArrayAdapter<String>(this, R.layout.drawer_list_item, mCategories));
		mDrawerList.setOnItemClickListener(new DrawerItemClickListener());
		
		mDrawerToggle = new ActionBarDrawerToggle(
				this,
				mDrawerLayout,
				R.drawable.ic_drawer,
				R.string.drawer_open,
				R.string.drawer_closed){
			
			public void onDrawerClosed(View view){
				getActionBar().setTitle(mTitle);
				invalidateOptionsMenu();
			}
			
			public void onDrawerOpened(View drawerView){
				getActionBar().setTitle("Quick Nav");
				invalidateOptionsMenu();
			}
		};
		
		mDrawerLayout.setDrawerListener(mDrawerToggle);
		
		getActionBar().setDisplayHomeAsUpEnabled(true);
		
		if(Build.VERSION.SDK_INT >= 14){
			getActionBar().setHomeButtonEnabled(true);
		}
		
		/* End of setting up the Drawer Navigation */
		
		/* Check for accounts, updates, and load content */
		
		LocalDBHandler dbh = new LocalDBHandler(this, null, null, 9);
		accts = dbh.getAccounts();
		
		//Pull up account page if no accounts exist yet
		if (savedInstanceState == null && accts.size() == 0) {
			if(dbh.getTimeStamp() != -1){
				dbh.deleteTimeStamp();
			}
			Intent login = new Intent(MainActivity.this, AccountsActivity.class);
			startActivity(login);
			if(dbh.getAccounts().size() > 0){
					new DataConnection().execute("");
					Log.w(Tag, "Creating a new timestamp: " + Calendar.getInstance().getTimeInMillis());
					dbh.addTimeStamp("" + Calendar.getInstance().getTimeInMillis());
			}
		}
		/*
		 * if account(s) do exist then start the fund list activity
		 * but check the time stamp, for whether or not to update data
		 */
		else if(savedInstanceState == null){
			long originalStamp = dbh.getTimeStamp();
			long currentTime = Calendar.getInstance().getTimeInMillis();
			
			if(currentTime > originalStamp + DAY_MILLI && originalStamp != -1){
				Log.w(Tag, "Updating the timestamp from: " + originalStamp + ", to: " + currentTime);
				new DataConnection().execute("");
				dbh.updateTimeStamp("" + originalStamp, "" + currentTime);
			}
			selectItem(0);
		}
	}// END OF onCreate
	
	/**
	 * Used to create the options menu
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu){
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);
		return super.onCreateOptionsMenu(menu);
	}
	
	
	@Override
	public boolean onPrepareOptionsMenu(Menu menu){
		boolean drawerOpen = mDrawerLayout.isDrawerOpen(mDrawerList);
		menu.findItem(R.id.action_search).setVisible(!drawerOpen);
		return super.onPrepareOptionsMenu(menu);
	}
	
	/**
	 * Used by the drawer to refresh the toggle button
	 * (on activity resume)
	 */
	@Override
	public void onPostCreate(Bundle savedInstanceState){
		super.onPostCreate(savedInstanceState);
		mDrawerToggle.syncState();
	}
	
	
	@Override
	public void onConfigurationChanged(Configuration newConfig){
		super.onConfigurationChanged(newConfig);
		mDrawerToggle.onConfigurationChanged(newConfig);
	}
	
	/**
	 * Used to handle click events for the action bar
	 */
	@Override
	public boolean onOptionsItemSelected(MenuItem item){
		if(mDrawerToggle.onOptionsItemSelected(item)){
			return true;
		}
		//Handle App search
		switch(item.getItemId()){
			case R.id.action_search:
				setTitle("Search");
				fragment = new SearchActivity();
				getSupportFragmentManager().beginTransaction().replace(R.id.content_frame, fragment).commit();
				break;
		}
		
		return super.onOptionsItemSelected(item);
	}

	/**
	 * The listener for the drawer menu. waits for a drawer item to be clicked.
	 * 
	 */
	private class DrawerItemClickListener implements ListView.OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			selectItem(position);
		}
	}

	/**
	 * Drawer click responses.
	 * 
	 * @param position
	 */
	private void selectItem(int position) {
		FragmentManager fragmentManager = getSupportFragmentManager();
		switch(position){
		case 0:
			setTitle("Fund List");
			fragment = new FundList();
			fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
			break;
		case 1:
			setTitle("Gifts");
			fragment = new GiftList();
			fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
			break;
		case 2:
			Toast.makeText(MainActivity.this, "To Be Implemented: General Donation Link", Toast.LENGTH_SHORT).show();
			Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.google.com")); //TODO: replace url with actually donation site
			//startActivity(browserIntent);
			break;
        case 3:
            setTitle("Updates");
            fragment = new UpdateList();
            fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
            break;
        case 4:
            setTitle("Prayer Requests");
            fragment = new PrayerRequestList();
            fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
            break;
        case 5:
           break;
        case 6:
            setTitle("Contact Missionary");
            fragment = new ContactMissionaryActivity();
            fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
            break;
		case 7:
			Intent accounts = new Intent(MainActivity.this, AccountsActivity.class);
			startActivity(accounts);
			break;
		case 8:
			Toast.makeText(MainActivity.this, "Checking for updates...", Toast.LENGTH_LONG).show();
			new DataConnection().execute("");
			LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
			long currentDate = Calendar.getInstance().getTimeInMillis();
			Log.w(Tag, "Updating the timestamp from: " + currentDate);
			db.updateTimeStamp("" + db.getTimeStamp(), "" + currentDate);
			break;
		}
		mDrawerList.setItemChecked(position, true);
		mDrawerLayout.closeDrawer(mDrawerList);
	}

	/**
	 * Sets the title of the action bar to the text selected in the menu drawer.
	 * (but only if they have Honeycomb or later)
	 */
	@Override
	public void setTitle(CharSequence title) {
		mTitle = title;
		getActionBar().setTitle(mTitle);
	}
	
	/**
	 * Detaches and Re-attaches the current fragment
	 * which allows them to refresh their view, to reflect a change in data.
	 * (delete, update, or added items)
	 */
	public void refreshFragments(){
		Fragment frags = getSupportFragmentManager().getFragments().get(0);
		final FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
		ft.detach(frags);
		ft.attach(frags);
		ft.commit();
	}

//    public void setNotificationButtonClicked(View view)
//    {
//        try{
//            ((PrayerRequestList)fragment).togglePopup(view);
//        }
//        catch (Exception e)
//        {
//            System.out.println(e);
//        }
//    }
	/**
	 * This is used to make sure that the content on screen is still up-to-date
	 * in case an account was created with-in the account activity
	 */
	@Override
	public void onResume(){
		super.onResume();
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
		ArrayList<Account> temp = db.getAccounts();
		if(temp.size() > accts.size()){
			new DataConnection().execute("");
		}else if(temp.size() < accts.size()){
			refreshFragments();
		}
	}

	/**
	 * Takes the user to an application that can open/view a pdf.
	 * 
	 * @param v
	 */
	public void sendToPDF(View v) {
		Toast.makeText(MainActivity.this, "Sorry, not implemented yet.", Toast.LENGTH_SHORT).show();
	}

	/**
	 * Takes the user to the 'by year' view. Which shows the years donoated
	 * with the total amount donated per year.
	 * 
	 * @param v
	 */
	public void viewByYTDAmounts(View v) {
		setTitle("Donations By Year");
		fragment = new YTDList();
		FragmentTransaction fragmentManager = getSupportFragmentManager().beginTransaction();
		fragmentManager.replace(R.id.content_frame, fragment);
		fragmentManager.addToBackStack("ToYearView");
		fragmentManager.commit();
	}

	//Data formating and storing methods Below
	
	//For All Funds: (related to account(s))
	// "http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Funds?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic"

	//For All Years donated (to single Fund)
	// "http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Years?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"
	
	//For All Related Years (to single Fund) (this is used in loop):
	// "http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Funds/" + Fund_Name + "/Years?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"

	//For All Related Gifts (inside of single year with-in loop):
	// "http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Funds/" + Fund_Name + "/Years/" + Year + "/Gifts?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"

	/**
	 * This class is used to pull json files (from the urls above)
	 * for every account and then format and store the formated data into the
	 * sqlite database
	 * 
	 * @author Andrew Cameron
	 *
	 */
public class DataConnection extends AsyncTask<String, Void, String>{
		
		private String Host_Name;
		private int Donor_ID;
		private String Password;
		private String AccountName;
		private int Account_ID;
		
		private static final String Tag = "DPS";
		
		@Override
		protected String doInBackground(String... params) {
			try{
			DataPull();
			}catch(Exception e){
				Log.w(Tag, "The DataPull failed. (probably not connected to internet or vmplayer): " 
						+ e.getLocalizedMessage());
			}
			return null;
		}
		
		@Override
		protected void onPostExecute(String params){
			refreshFragments();
		}

		/**
		 * This method runs through each account stored to pull info
		 */
		private void DataPull(){
            LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
//            db.onCreate(db.getWritableDatabase());
            for(Account a : db.getAccounts()){
				Host_Name = a.getServerName();
				Donor_ID = a.getDonorid();
				Password = a.getAccountPassword();
				AccountName = a.getAccountName();
				Account_ID = a.getId();
                loadNotes(db.getAccounts());

				for(Fund f : db.getFundsForAccount(Account_ID)){
					
					String Fund_Name = "";
					try {
						Fund_Name = URLEncoder.encode(f.getFullName(), "UTF-8");
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					}
					int fundid = f.getID();
					
					loadFundYears(GET("http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Funds/" 
							+ Fund_Name + "/Years?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"), fundid);
					
					for(Year y : db.getYears(fundid)){
						int yearid = y.getId();
						String Year = y.getName();
						
						loadGifts(GET("http://" + Host_Name + ":800/apps/kardia/api/donor/" + Donor_ID + "/Funds/" 
								+ Fund_Name + "/Years/" + Year + "/Gifts?cx__mode=rest&cx__res_format=attrs&cx__res_type=collection&cx__res_attrs=basic"),
								yearid, fundid);
					}
				}
			}
		}

		/**
		 * Attempts to do basic Http Authentication, and send a get request from the url
		 * 
		 * @param url for get request.
		 * @return string results of the query.
		 */
		public String GET(String url) {
			InputStream inputStream = null;
			String result = "";

			try {

				CredentialsProvider credProvider = new BasicCredentialsProvider();
				credProvider.setCredentials(new AuthScope(Host_Name, 800),
						new UsernamePasswordCredentials(AccountName, Password));

				DefaultHttpClient client = new DefaultHttpClient();

				client.setCredentialsProvider(credProvider);

				HttpResponse response = client.execute(new HttpGet(url));

				inputStream = response.getEntity().getContent();

				if (inputStream != null) {
					result = convertInputStreamToString(inputStream);
				} else {
					result = "Did not work.";
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}

		/**
		 * If there are results, change them into a string.
		 * 
		 * @param in, the inputStream containing the results of the query (if any)
		 * @return a string with the results of the query.
		 * @throws IOException
		 */
		private String convertInputStreamToString(InputStream in) throws IOException {
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));
			String line = "", result = "";

			while ((line = reader.readLine()) != null) {
				result += line;
			}
			in.close();
			return result;
		}
	
	/**
	 * formats the result string into funds and
	 * if a fund was not stored yet, adds it to 
	 * the local sqlite database in a fund table
	 * and it also adds a relation between the fund and the specific account
	 * (Notice, only adds the fund and/or relationship if one does not already exist)
	 * 
	 * @param result
	 * @throws JSONException 
	 */
	public void loadFunds(String result) {
		
		LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
		ArrayList<String> TestFundNamesList = db.getFundNames(Account_ID);
		JSONObject json = null;
		try{
			json = new JSONObject(result);
		}catch(JSONException e){
			e.printStackTrace();
		}
		JSONArray tempFunds = json.names();
		
		for (int x = 0; x < tempFunds.length(); x++) {
			try {
				if(!tempFunds.getString(x).equals("@id")){
				JSONObject fundObj = json.getJSONObject(tempFunds.getString(x));
				
				JSONObject giftObj = fundObj.getJSONObject("gift_total");
				int[] gifttotal = {
						Integer.parseInt(giftObj.getString("wholepart")),
						Integer.parseInt(giftObj.getString("fractionpart")) 
					};
				int giftcount = Integer.parseInt(fundObj.getString("gift_count"));
				
				Fund temp = new Fund();
				temp.setName(fundObj.getString("fund"));
				temp.setFullName(fundObj.getString("name"));
				temp.setFund_desc(fundObj.getString("fund_desc"));
				temp.setGift_count(giftcount);
				temp.setGift_total(gifttotal);
				temp.setGiving_url(fundObj.getString("giving_url"));
				
				if(!TestFundNamesList.contains(temp.getFullName())){ //returns only account specific fund names for testing
				
					db.addFund(temp);
					int fundId = db.getLastId("fund");
					db.addFund_Account(fundId, Account_ID);
				}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

    public void loadNotes(ArrayList<Account> accounts)
    {
        LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
        try{
            for(Account account :accounts)
                {
                    String supporterID = ""+account.getDonorid();
                    String missionaryJSON = GET("http://" + Host_Name+ ":800/apps/kardia/api/supporter/"+supporterID+"/Missionaries?cx__mode=rest&cx__res_type=collection");
                if(!missionaryJSON.contains("404")) {
                    JSONObject missionaries = new JSONObject(missionaryJSON);
                    Iterator<String> missionaryIDs = missionaries.keys();
                    while (missionaryIDs.hasNext()) {
                        String missionaryID = missionaryIDs.next();
                        if (!missionaryID.contains("id")) {
                            String request = "http://" + Host_Name + ":800/apps/kardia/api/missionary/" + missionaryID + "/Notes?cx__mode=rest&cx__res_type=collection&cx__res_format=attrs&cx__res_attrs=basic";
                            String requestJSON = GET(request);
                            JSONObject prayerRequest = new JSONObject(requestJSON);
                            Iterator<String> requestKeys = prayerRequest.keys();
                            while (requestKeys.hasNext()) {
                                String prayerKey = requestKeys.next();
                                if (!prayerKey.equals("@id")) {
                                    JSONObject noteJSON = (JSONObject) prayerRequest.get(prayerKey);
                                    boolean addNote = true;

                                    if(noteJSON.getString("note_type").equals("Pray")) {

                                        PrayerRequest tempRequest = new PrayerRequest();
                                        tempRequest.setId(noteJSON.getString("note_id"));
                                        JSONObject date = new JSONObject(noteJSON.getString("note_date"));
                                        tempRequest.setText(noteJSON.getString("note_text"));
                                        tempRequest.setSubject(noteJSON.getString("note_subject"));

                                        String day = date.getString("day");
                                        String month = date.getString("month");
                                        String year = date.getString("year");

                                        tempRequest.setDate(month + "-" + day + "-" + year);

                                        db.addRequest(tempRequest);

                                    }
                                    else if(noteJSON.getString("note_type").equals("Update"))
                                    {
                                        Update tempUpdate = new Update();
                                        tempUpdate.setId(noteJSON.getString("note_id"));
                                        tempUpdate.setText(noteJSON.getString("note_text"));
                                        tempUpdate.setSubject(noteJSON.getString("note_subject"));
                                        JSONObject date = new JSONObject(noteJSON.getString("note_date"));
                                        String day = date.getString("day");
                                        String month = date.getString("month");
                                        String year = date.getString("year");
                                        tempUpdate.setDate(month + "-" + day + "-" + year);

                                        db.addUpdate(tempUpdate);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }


    }
	/**
	 * This pulls the years related to a specific fund. 
	 * If they are not yet stored adds relationships between the fund and year
	 * (Notice only adds the relationship if one does not already exist)
	 * 
	 * @param result, the JSON information returned from the back-end
	 */
	private void loadFundYears(String result, int fundId){
		
		LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
		ArrayList<String> TestYearNamesList = db.getYearNames();
		ArrayList<String> TestYearConnection = db.getYearNamesFund(fundId);
		JSONObject json = null;
		try {
			json = new JSONObject(result);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		JSONArray tempYears = json.names();
		
		for(int x = 0; x < tempYears.length() -1; x++){
			
			try{
				if(!tempYears.getString(x).equals("@id")){
				JSONObject YearObj = json.getJSONObject(tempYears.getString(x));
				JSONObject giftObj = YearObj.getJSONObject("gift_total");
				int[] gifttotal = {
						Integer.parseInt(giftObj.getString("wholepart")),
						Integer.parseInt(giftObj.getString("fractionpart"))
				};
				String name = YearObj.getString("name");
				if(gifttotal[1] >= 100){
					gifttotal[1] /= 100;
				}
				Year temp = new Year();
				temp.setName(name);
				temp.setGift_total(gifttotal);
				
				//if connection between fund and year doesn't exist... add new connection
				if(TestYearNamesList.contains(name) && !TestYearConnection.contains(name)){
					int yearid = db.getYear(name).getId();
					db.addYear_Fund(yearid, fundId, gifttotal[0], gifttotal[1]);
				}
				//if the connection does exist, update the values
				else if(TestYearNamesList.contains(name) && TestYearConnection.contains(name)){
					int yearid = db.getYear(name).getId();
					db.updateYear_Fund(yearid, fundId, gifttotal[0], gifttotal[1]);
				}
				}
			}
			catch(JSONException e){
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * This formats the return json for every year related to an account
	 * if the year and/or relationship do not exist they will be added.
	 * 
	 * @param result
	 */
	private void loadYears(String result){
		
		LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
		ArrayList<String> TestYearNamesList = db.getYearNames();
		ArrayList<String> YearsForAccount = db.getYearNamesAccount(Account_ID);
		JSONObject json = null;
		try {
			json = new JSONObject(result);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		JSONArray tempYears = json.names();
		
		for(int x = 0; x < tempYears.length() -1; x++){
			
			try{
				if(!tempYears.getString(x).equals("@id")){
				JSONObject YearObj = json.getJSONObject(tempYears.getString(x));
				JSONObject giftObj = YearObj.getJSONObject("gift_total");
				int[] gifttotal = {
						Integer.parseInt(giftObj.getString("wholepart")),
						Integer.parseInt(giftObj.getString("fractionpart"))
				};
				String name = YearObj.getString("name");
				
				if(gifttotal[1] >= 100){
					gifttotal[1] /= 100;
				}
				
				Year temp = new Year();
				temp.setName(name);
				temp.setGift_total(gifttotal);
				
				if(!TestYearNamesList.contains(name)){ // if the year doesn't exist yet.. add it and add the relationship
					db.addYear(temp);
					int yearid = db.getLastId("year");
					db.addYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
				}
				else if(!YearsForAccount.contains(name)){ // if the year exists but isnt related yet.. add the relationship
					int yearid = db.getYear(name).getId();
					db.addYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
				}
				else if(YearsForAccount.contains(name)){ // if the year and the relationship exist, update the values
					int yearid = db.getYear(name).getId();
					db.updateYear_Account(yearid, Account_ID, gifttotal[0], gifttotal[1]);
				}
				}
			}
			catch(JSONException e){
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * This formats the return json into gifts and if the gift
	 * was not already stored add it and a relationship to the related fund through the Fund_ID
	 * and a relationship to the related year through the Year_ID
	 * 
	 * @param result
	 * @param Year_ID
	 * @param Fund_ID
	 */
	private void loadGifts(String result, int Year_ID, int Fund_ID){
		Log.w(Tag, "Loading Gifts For Fund " + Fund_ID);
		LocalDBHandler db = new LocalDBHandler(MainActivity.this, null, null, 9);
		ArrayList<String> TestGiftNameList = db.getGiftNames(Fund_ID, Year_ID);
		JSONObject json = null;
		try {
			json = new JSONObject(result);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		JSONArray tempGifts = json.names();

		for(int i = 0; i < tempGifts.length() - 1; i++){
			try{
				if(!tempGifts.getString(i).equals("@id")){
					JSONObject GiftObj = json.getJSONObject(tempGifts.getString(i));
					JSONObject dateObj = GiftObj.getJSONObject("gift_date");
					JSONObject amountObj = GiftObj.getJSONObject("gift_amount");
					int[] gifttotal = {
							Integer.parseInt(amountObj.getString("wholepart")),
							Integer.parseInt(amountObj.getString("fractionpart"))
					};
					String name = GiftObj.getString("name");

					String gift_fund = GiftObj.getString("gift_fund");
					String gift_fund_desc = GiftObj.getString("gift_fund_desc");
					String gift_year = dateObj.getString("year");
					String gift_month = dateObj.getString("month");
					gift_month = (gift_month.length() < 2)? "0" + gift_month : gift_month;
					String gift_day = dateObj.getString("day");
					gift_day = (gift_day.length() < 2)? "0" + gift_day : gift_day;
					String gift_date = gift_year + "-" 
							+ gift_month + "-" + gift_day;
							
					String gift_check_num = GiftObj.getString("gift_check_num");
					
					if(gifttotal[1] >= 100){
						gifttotal[1] /= 100;
					}
				
					Gift temp = new Gift();
					temp.setName(name);
					temp.setGift_fund(gift_fund);
					temp.setGift_fund_desc(gift_fund_desc);
					Log.w(Tag, "Gift Date: " + gift_date);
					temp.setGift_date(gift_date);
					temp.setGift_check_num(gift_check_num);
					temp.setGift_amount(gifttotal);
				
					// if it didn't exist... add gift, connection to year, fund, and account
					if(!TestGiftNameList.contains(temp.getName())){
						db.addGift(temp);
						int giftid = db.getLastId("gift");
						db.addGift_Year(giftid, Year_ID);
						db.addGift_Fund(giftid, Fund_ID);
						db.addGift_Account(giftid, Account_ID);
					}
				}
			}
			catch(JSONException e){
				e.printStackTrace();
			}
		}
	}
}
}
