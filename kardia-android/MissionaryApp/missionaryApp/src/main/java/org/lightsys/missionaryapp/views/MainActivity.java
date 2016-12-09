package org.lightsys.missionaryapp.views;

import java.util.Calendar;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.AutoUpdater;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.LocalDBHandler;


import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
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

import org.lightsys.missionaryapp.R;

/**
 * @author Andrew Cameron
 *
 * The main activity for the app. Creates the side-menu drawer used throughout the
 * app. This is used for switching between fragment activities.
 * 
 */
public class MainActivity extends ActionBarActivity {
    private static final long     DAY_MILLI = 86400000;

    private DrawerLayout          mDrawerLayout;
	private ActionBarDrawerToggle mDrawerToggle;
	private ListView              mDrawerList;
	private CharSequence          mTitle;
	private Fragment              fragment;
    private int                   accountId = 0;
    private int                   currentFrag = 0;

	//stuff to automatically refresh the current fragment
	private final android.os.Handler refreshHandler = new android.os.Handler();
	private final Runnable refreshRunnable = new Runnable() {
		@Override
		public void run() {
		}
	};

    //if back button is pressed, return home instead of exiting
    @Override
    public void onBackPressed() {

        Fragment currentFragment = getSupportFragmentManager().findFragmentById(R.id.contentFrame);

        if (!currentFragment.getTag().equals("Home") && getSupportFragmentManager().getBackStackEntryCount() == 0) {
            selectItem(0);
        } else if (currentFragment.getTag().equals("Home")) {
            this.finish();
        } else {
            super.onBackPressed();
        }
    }

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

		/*set up auto updater*/
		Intent updateIntent = new Intent(getBaseContext(), AutoUpdater.class);
		startService(updateIntent);
		refreshHandler.postDelayed(refreshRunnable, 1000);

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
		LocalDBHandler db = new LocalDBHandler(this);

        Account account = db.getAccount();

		//Delete timestamp if no accounts exist
		//Launch login page to add account
		if (savedInstanceState == null && account == null) {
			if(db.getTimeStamp() != -1){
				db.deleteTimeStamp();
			}
			db.close();
			Intent login = new Intent(MainActivity.this, AccountsActivity.class);
			startActivityForResult(login, 0);
		}


		/*
		 * if account(s) do exist check the time stamp, for whether or not to update data
		 * send to fund list to begin
		 */
		else if(savedInstanceState == null){

			long originalStamp = db.getTimeStamp();
			long currentTime = Calendar.getInstance().getTimeInMillis();
			db.close();
			
			if(currentTime > originalStamp + DAY_MILLI && originalStamp != -1){
                new DataConnection(this, this, account, currentFrag).execute("");
			}
			selectItem(0);
		}
	}// END OF onCreate

	@Override
	public void onDestroy() {
		super.onDestroy();

	}

	/**
	 * Used to create the options menu
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu){
        Fragment currentFragment = getSupportFragmentManager().findFragmentById(R.id.contentFrame);
        if (currentFragment !=null) {
            String fragTag = currentFragment.getTag();
            if (fragTag != null) {
                if (fragTag.equals("Gift") || fragTag.equals("Donor") || fragTag.equals("GiftTime")) {
                    MenuInflater inflater = getMenuInflater();
                    inflater.inflate(R.menu.main, menu);
                }
            }else{
                menu.clear();
            }
        }
        return super.onCreateOptionsMenu(menu);
	}

	
	@Override
	public boolean onPrepareOptionsMenu(Menu menu){
		boolean drawerOpen = mDrawerLayout.isDrawerOpen(mDrawerList);
        if (menu.findItem(R.id.action_search) != null) {
            menu.findItem(R.id.action_search).setVisible(!drawerOpen);
        }
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
        int num = -1;
        String fragTag = getSupportFragmentManager().findFragmentById(R.id.contentFrame).getTag();
        if (fragTag.equals("Donor")){
            num = 0;
        }else if (fragTag.equals("Gift") || (fragTag.equals("GiftTime"))){
            num=1;
        }
        Bundle args = new Bundle();
		switch(num){
			case 0:
				setTitle("Donor Search");
				fragment = new DonorSearch();
                fragment.setArguments(args);
				getSupportFragmentManager().beginTransaction().replace(R.id.contentFrame, fragment).commit();
				break;
            case 1:
                setTitle("Gift Search");
                fragment = new GiftSearch();
                fragment.setArguments(args);
                getSupportFragmentManager().beginTransaction().replace(R.id.contentFrame, fragment).commit();
                break;
            case -1:
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
	public void selectItem(int position) {
		final LocalDBHandler db = new LocalDBHandler(this);
		FragmentManager fragmentManager = getSupportFragmentManager();
		Account account = db.getAccount();
		accountId = account.getId();


		db.close();
		switch(position) {
            //Gifts, Donor, Prayer requests/updates, Funds, Accounts, Options, Refresh
            case 0:
                currentFrag = position;
                fragment = new HomePage();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Home")
                        .commit();
                break;
            case 1:
                currentFrag = position;
                fragment = new GiftList();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Gift")
                        .commit();
                break;
            case 2:
                currentFrag = position;
                fragment = new DonorList();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Donor")
                        .commit();
                break;
            case 3:
                currentFrag = position;
                fragment = new NoteList();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Note")
                        .commit();
                break;
            case 4:
                currentFrag = position;
                fragment = new FundList();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Fund")
                        .commit();
                break;
            case 5:
                currentFrag = position;
                Options fragment = new Options();
                db.close();
                fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Option")
                        .commit();
                break;
            case 6:
                new DataConnection(this, this, account, currentFrag).execute("");
                break;
            case 7:
                new AlertDialog.Builder(MainActivity.this)
                        .setCancelable(false)
                        .setTitle("Logout")
                        .setMessage("This action will remove current account data. Continue?")
                        .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                db.deleteAccount();
                                Intent accounts = new Intent(MainActivity.this, AccountsActivity.class);
                                startActivity(accounts);
                            }
                        })
                        .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .show();
                break;
        }

        mDrawerList.setItemChecked(currentFrag, true);
		mDrawerLayout.closeDrawer(mDrawerList);
	}
	/**
	 * Reloads the current fragment to update view if content has changed
	 */
	public void refreshCurrentFragment() {
		Fragment currentFragment = getSupportFragmentManager().findFragmentById(R.id.contentFrame);
		final FragmentTransaction fragTransaction = getSupportFragmentManager().beginTransaction();
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
	 * Called after return from accounts activity if user just added first account
	 * Sends the user to the home page to begin
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		selectItem(0);
	}
	@Override
	public void onResume() {
		super.onResume();
		LocalDBHandler db = new LocalDBHandler(this);
		if(accountId != 0) {
			if (accountId != db.getAccount().getId()) {
				FragmentManager fragmentManager = getSupportFragmentManager();

				fragment = new HomePage();
				fragmentManager.beginTransaction().replace(R.id.contentFrame, fragment, "Home")
                        .commit();
			}
		}
	}
}
