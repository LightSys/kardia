package org.lightsys.donorapp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
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
import android.os.Parcel;
import android.os.Parcelable;
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
				new DataConnection(this).execute("");
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
			setTitle("Donation");
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
			new DataConnection(this).execute("");
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
			new DataConnection(this).execute("");
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
}
