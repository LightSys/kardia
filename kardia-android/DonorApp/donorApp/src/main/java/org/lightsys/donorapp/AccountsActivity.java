package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.MainActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import com.example.donorapp.R;

/**
 * This class is used to manage (add/delete) accounts to the app.
 * 
 * @author Andrew Cameron
 *
 * This class Activity handles user login, and editing of user accounts
 * Currently does not check the validity of servername or userid
 *
 */
public class AccountsActivity extends Activity{
	
	ListView accountsList;
	EditText accountName, accountPass, serverName, donorID;
	TextView connectedAccounts;
	ArrayList<Account> accounts = new ArrayList<Account>();

	
	/**
	 * Creates the view, and loads any pre-existing accounts into the listview
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.account_page_layout);
		
		accountsList = (ListView)findViewById(R.id.connected_list);
		accountName = (EditText)findViewById(R.id.username_input);
		accountPass = (EditText)findViewById(R.id.password_input);
		serverName = (EditText)findViewById(R.id.servername_input);
		donorID = (EditText)findViewById(R.id.donor_id_input);
		connectedAccounts = (TextView)findViewById(R.id.textView2);

		loadAccountList();
		
		registerForContextMenu(accountsList);
	}
	
	/**
	 * Pulls all accounts (if any) out of the local SQLite Database and puts them into the
	 * SessionStorage accounts list, then populates a listview with the accounts.
	 */
	public void loadAccountList(){
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
		
		accounts = db.getAccounts();
		
		if(accounts.size() > 0){	
			connectedAccounts.setText("Connected Accounts:");
		}else{
			connectedAccounts.setText("No Accounts Connected.");
		}
		
		List<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();
		
		for(Account a : accounts){
			
			HashMap<String,String> tempMap = new HashMap<String,String>();
			tempMap.put("aName", a.getAccountName());
			tempMap.put("aServer", a.getServerName());
			
			aList.add(tempMap);
		}
		
		String[] from = {"aName", "aServer"};
		int[] to = {R.id.title, R.id.server};
		SimpleAdapter adapter = new SimpleAdapter(this, aList, R.layout.account_listview_item, from, to);
		
		accountsList.setAdapter(adapter);
	}
	
	/**
	 * This function is called when the "home" button is pressed.
	 * This method just returns the user to the page that it was called from.
	 * (from within the MainActivity)
	 * 
	 * @param v
	 */
	public void returnHome(View v){
		finish();
	}
	
	/**
	 * Adds the account to the local database.
	 * 
	 * @param v
	 */
	public void addAccount(View v){
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);

		accounts = db.getAccounts();

		String aName = accountName.getText().toString();
		String aPass = accountPass.getText().toString();
		String sName = serverName.getText().toString();
        String dIdStr = donorID.getText().toString();
		
		for(Account a : accounts){
			if(a.getAccountName().equals(aName) && a.getServerName().equals(sName)){
				serverName.setError("This Account is already being stored.");
				return;
			}
		}	
		if(aName.equals("") || aName == null){
			accountName.setError("Invalid User Name");
			return;
		}	
		if(aPass.equals("") || aPass == null){
			accountPass.setError("Invalid Password");
			return;
		}	
		if(sName.equals("") || sName == null){
			serverName.setError("Invalid Server Address");
			return;
		}	
		if(dIdStr.equals("") || dIdStr == null){
			donorID.setError("Invalid Donor Id.");
			return;
		}

        int dId = Integer.parseInt(dIdStr);
		
		Account account = new Account(aName, aPass, sName, dId);
		db.addAccount(account);
		accounts = db.getAccounts();

		// Create new data connection
		new DataConnection(this).execute("");



		//reset data fields to blank
		accountName.setText("");
		accountPass.setText("");
		serverName.setText("");
		donorID.setText("");

		loadAccountList();
	}
	
	/**
	 * This option menu is used to manage existing accounts
	 * allowing the user to edit, delete or do nothing to the selected account.
	 */
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo){
		super.onCreateContextMenu(menu, v, menuInfo);
		menu.add(0, v.getId(), 0, "Edit");
		menu.add(0, v.getId(), 0, "Delete");
		menu.add(0, v.getId(), 0, "Cancel");
	}
	
	/**
	 * This carries out the request made by the ContextMenu (above)...
	 * If delete was selected, it will delete the account from the DB
	 * If edit was selected, it will open the edit activity
	 */
	public boolean onContextItemSelected(MenuItem item) {
		AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) item
				.getMenuInfo();
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);

		if (item.getTitle().equals("Delete")) {
			
			Account temp = accounts.get(info.position);

			db.deleteAccount(temp.getId());
			
			loadAccountList();
			
		} else if (item.getTitle().equals("Edit")) {
			
			Account temp = accounts.get(info.position);

			Intent intent = new Intent(this, EditAccountActivity.class);
			Log.w("BasicAuth", "The donor id being put into the intent: " + temp.getDonorid());
			intent.putExtra("theid", temp.getId());
			intent.putExtra("oldname", temp.getAccountName());
			intent.putExtra("oldpass", temp.getAccountPassword());
			intent.putExtra("oldserver", temp.getServerName());
			intent.putExtra("olddonorid", temp.getDonorid());

			startActivityForResult(intent, 0);

		} else {
			return false;
		}
		return true;
	}
	
	/**
	 * This refreshes the list of accounts. (in case a creation, edit or delete was made)
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data){
		loadAccountList();
	}
}