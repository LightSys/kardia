package org.lightsys.donorapp.views;

import java.util.ArrayList;
import java.util.Calendar;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Missionary;
import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.data.PrayerLetter;
import org.lightsys.donorapp.tools.DataConnection;
import org.lightsys.donorapp.tools.LocalDBHandler;


import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
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
 * @author Andrew Cameron
 * 
 */
public class MainActivity extends ActionBarActivity {
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

		String [] mCategories = getResources().getStringArray(R.array.categories);
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
				getSupportActionBar().setTitle(mTitle);
				invalidateOptionsMenu();
			}

			public void onDrawerOpened(View drawerView){
				getSupportActionBar().setTitle("Navigation");
				invalidateOptionsMenu();
			}
		};

		mDrawerLayout.setDrawerListener(mDrawerToggle);

		getSupportActionBar().setDisplayHomeAsUpEnabled(true);

		if(Build.VERSION.SDK_INT >= 14){
			getSupportActionBar().setHomeButtonEnabled(true);
		}
		
		/* End of setting up the Drawer Navigation */

		/* Check for accounts, updates, and load content */
		
		LocalDBHandler dbh = new LocalDBHandler(this, null, null, 9);

//		Note testUpdate = new Note();
//		testUpdate.setMissionaryName("Tyler Jefferson");
//		testUpdate.setDate("2014-06-23");
//		testUpdate.setId(28);
//		testUpdate.setSubject("Monthly Update");
//		testUpdate.setType("Update");
//		testUpdate.setText("This is is a monthly update on how the mission is going");
//		dbh.addNote(testUpdate);
//
//		Note testUpdate2 = new Note();
//		testUpdate2.setMissionaryName("The Franklin Family");
//		testUpdate2.setDate("2015-02-08");
//		testUpdate2.setId(39);
//		testUpdate2.setSubject("Franklin Family Update");
//		testUpdate2.setType("Update");
//		testUpdate2.setText("Here is an update on how our family is doing as we prepare to go");
//		dbh.addNote(testUpdate2);
//
//		Note testRequest = new Note();
//		testRequest.setMissionaryName("John and Mary Doe");
//		testRequest.setDate("2014-12-20");
//		testRequest.setId(14);
//		testRequest.setSubject("Christmas Program");
//		testRequest.setType("Pray");
//		testRequest.setText("We will have a Christmas program at the church and have invited " +
//				"may visitors to come");
//		dbh.addNote(testRequest);
//
//		Note testRequest2 = new Note();
//		testRequest2.setMissionaryName("James Smith");
//		testRequest2.setDate("2015-04-07");
//		testRequest2.setId(16);
//		testRequest2.setSubject("Bible Study");
//		testRequest2.setType("Pray");
//		testRequest2.setText("I am having a Bible study at my home tonight");
//		dbh.addNote(testRequest2);
//
//		Note testRequest3 = new Note();
//		testRequest3.setMissionaryName("Harry and Jane Lincoln");
//		testRequest3.setDate("2015-05-20");
//		testRequest3.setId(17);
//		testRequest3.setSubject("Vacation Bible School");
//		testRequest3.setType("Pray");
//		testRequest3.setText("Pray for our VBS next week at the church");
//		dbh.addNote(testRequest3);
//
//		Missionary testMissionary = new Missionary();
//		testMissionary.setId(1);
//		testMissionary.setName("Tyler Jefferson");
//		dbh.addMissionary(testMissionary);
//
//		Missionary testMissionary2 = new Missionary();
//		testMissionary2.setId(2);
//		testMissionary2.setName("The Franklin Family");
//		dbh.addMissionary(testMissionary2);
//
//		Missionary testMissionary3 = new Missionary();
//		testMissionary3.setId(3);
//		testMissionary3.setName("John and Mary Doe");
//		dbh.addMissionary(testMissionary3);
//
//		PrayerLetter testLetter = new PrayerLetter();
//		testLetter.setId(2839);
//		testLetter.setDate("2015-02-07");
//		testLetter.setMissionaryName("Bob Brown");
//		testLetter.setTitle("August Prayer Letter");
//		testLetter.setFilename("testFilname.pdf");
//		dbh.addPrayerLetter(testLetter);
//
//		PrayerLetter testLetter2 = new PrayerLetter();
//		testLetter2.setId(2886);
//		testLetter2.setDate("2014-10-01");
//		testLetter2.setMissionaryName("Peter and Joan Wellington");
//		testLetter2.setTitle("October Prayer Letter");
//		testLetter2.setFilename("testFilname.pdf");
//		dbh.addPrayerLetter(testLetter2);

		accts = dbh.getAccounts();
		
		//Delete timestamp if no accounts exist
		//Launch login page to add account
		if (savedInstanceState == null && accts.size() == 0) {
			if(dbh.getTimeStamp() != -1){
				dbh.deleteTimeStamp();
			}
			dbh.close();
			Intent login = new Intent(MainActivity.this, AccountsActivity.class);
			startActivityForResult(login, 0);
		}
		/*
		 * if account(s) do exist check the time stamp, for whether or not to update data
		 * send to fund list to begin
		 */
		else if(savedInstanceState == null){

			long originalStamp = dbh.getTimeStamp();
			long currentTime = Calendar.getInstance().getTimeInMillis();
			dbh.close();
			
			if(currentTime > originalStamp + DAY_MILLI && originalStamp != -1){
				for (Account a : accts) {
					new DataConnection(this, this, a).execute("");
				}
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
				setTitle("Gift Search");
				fragment = new Search();
				getSupportFragmentManager().beginTransaction().replace(R.id.content_frame, fragment).commit();
				break;
		}
		
		return super.onOptionsItemSelected(item);
	}

	/**
	 * The listener for the drawer menu. waits for a drawer item to be clicked.
	 */
	private class DrawerItemClickListener implements ListView.OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			selectItem(position);
		}
	}

	/**
	 * Drawer click responses.
	 * @param position, position of the drawer that has been selected
	 */
	private void selectItem(int position) {
		FragmentManager fragmentManager = getSupportFragmentManager();
		switch(position){
		case 0:
			fragment = new FundList();
			fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
			break;
		case 1:
			fragment = new YTDList();
			fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
			break;
		case 2:
			Toast.makeText(MainActivity.this, "To Be Implemented: General Donation Link", Toast.LENGTH_SHORT).show();
			Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.google.com")); //TODO: replace url with actually donation site
			//startActivity(browserIntent);
			break;
        case 3:
            fragment = new NoteList();
            fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
            break;
        case 4:
            fragment = new MissionaryList();
            fragmentManager.beginTransaction().replace(R.id.content_frame, fragment).commit();
            break;
		case 5:
			Intent accounts = new Intent(MainActivity.this, AccountsActivity.class);
			startActivity(accounts);
			break;
		case 6:
			LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
			accts = db.getAccounts();
			db.close();
			for (Account a : accts) {
				new DataConnection(this, this, a).execute("");
			}
			break;
		}
		mDrawerList.setItemChecked(position, true);
		mDrawerLayout.closeDrawer(mDrawerList);
	}

	/**
	 * Reloads the current fragment to update view if content has changed
	 */
	public void refreshCurrentFragment() {
		Fragment currentFragment = getSupportFragmentManager().findFragmentById(R.id.content_frame);
		FragmentTransaction fragTransaction = getSupportFragmentManager().beginTransaction();
		fragTransaction.detach(currentFragment);
		fragTransaction.attach(currentFragment);
		fragTransaction.commit();
	}

	/**
	 * Sets the title of the action bar to the text selected in the menu drawer.
	 * (but only if they have Honeycomb or later)
	 */
	@Override
	public void setTitle(CharSequence title) {
		mTitle = title;
		getSupportActionBar().setTitle(title);
	}

	/**
	 * Takes the user to an application that can open/view a pdf.
	 */
	public void sendToPDF(View v) {
		Toast.makeText(MainActivity.this, "Sorry, not implemented yet.", Toast.LENGTH_SHORT).show();
	}

	/**
	 * Takes the user to the 'by year' view. Which shows the years donated
	 * with the total amount donated per year.
	 */
	public void viewByYTDAmounts(View v) {
		fragment = new YTDList();
		FragmentTransaction fragmentManager = getSupportFragmentManager().beginTransaction();
		fragmentManager.replace(R.id.content_frame, fragment);
		fragmentManager.addToBackStack("ToYearView");
		fragmentManager.commit();
	}

	/**
	 * Called after return from accounts activity if user just added first account
	 * Sends the user to the designations page to begin
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		selectItem(0);
	}
}
