package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Fund;
import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.MainActivity;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.app.FragmentManager;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;

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

	public static enum ErrorType {
		Unauthorized, Server, NotFound
	};

	ListView accountsList;
	EditText accountName, accountPass, serverName, donorID;
	TextView connectedAccounts;
	ArrayList<Account> accounts = new ArrayList<Account>();
	boolean accountAdded = false;
	// Use Boolean abstraction to be able to set to null
	// Null value signifies the async thread has not set the validation value
	private static Boolean isValidAccount = null;
	private static ErrorType errorType = null;

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

		// Adds EditTexts to text listener for resetting errors
		accountName.addTextChangedListener(new GenericTextWatcher(accountName));
		accountPass.addTextChangedListener(new GenericTextWatcher(accountPass));
		serverName.addTextChangedListener(new GenericTextWatcher(serverName));
		donorID.addTextChangedListener(new GenericTextWatcher(donorID));

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

		db.close();
		
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
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
		ArrayList<Account> accounts = db.getAccounts();
		db.close();
		if (accounts.size() == 0) {
			Toast.makeText(this, "Please connect an account", Toast.LENGTH_SHORT).show();
		} else {
			finish();
		}
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

		int dId = Integer.parseInt(dIdStr);
		
		for(Account a : accounts){
			if(a.getAccountName().equals(aName) && a.getServerName().equals(sName) &&
					a.getAccountPassword().equals(aPass) && a.getDonorid() == dId){
				Toast.makeText(this, "Account already stored", Toast.LENGTH_LONG).show();
				db.close();
				return;
			}
		}	
		if(aName.equals("") || aName == null){
			accountName.setError("Invalid Username");
			db.close();
			return;
		}	
		if(aPass.equals("") || aPass == null){
			accountPass.setError("Invalid Password");
			db.close();
			return;
		}	
		if(sName.equals("") || sName == null){
			serverName.setError("Invalid Server Address");
			db.close();
			return;
		}	
		if(dIdStr.equals("") || dIdStr == null){
			donorID.setError("Invalid Donor ID.");
			db.close();
			return;
		}
		
		Account account = new Account(aName, aPass, sName, dId);

		// Execute data connection
		new DataConnection(this, account).execute("");

		while(isValidAccount == null) {
			continue;
		}

		if (isValidAccount) {
			db.addAccount(account);
			accountAdded = true;
			isValidAccount = null;
			errorType = null;
			db.close();
		} else {
			String errorStatement;
			if (errorType == ErrorType.NotFound) {
				errorStatement = "Username or Password is incorrect";
			} else if (errorType == ErrorType.Server) {
				errorStatement = "Could not connect to specified server";
			} else if (errorType == ErrorType.Unauthorized) {
				errorStatement = "No account with this Donor ID";
			} else {
				errorStatement = "Unknown issue. \n 1) Check Internet connection" +
						"\n 2) Server may be down";
			}
			Toast.makeText(AccountsActivity.this, "Connecting account failed. \n -" + errorStatement,
					Toast.LENGTH_LONG).show();
			isValidAccount = null;
			errorType = null;
			db.close();
			return;
		}

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
			db.close();
			
			loadAccountList();
			
		} else if (item.getTitle().equals("Edit")) {

			db.close();
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


	// Sets the validity of the account attempting to be connected
	public static void setValidation(boolean isValid) {
		isValidAccount = isValid;
	}

	// Sets the error type if account is found to be invalid
	public static void setErrorType(ErrorType error) {
		errorType = error;
	}

}

