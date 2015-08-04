package org.lightsys.donorapp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.DataConnection;
import org.lightsys.donorapp.data.GenericTextWatcher;
import org.lightsys.donorapp.data.LocalDBHandler;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
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
import android.widget.Toast;

import com.example.donorapp.R;

/**
 * This class is used to manage (add/delete) accounts to the app.
 * 
 * @author Andrew Cameron
 *
 */
public class AccountsActivity extends Activity{

	// Specifies the type of error if an account does not connect
	public enum ErrorType {
		Unauthorized, Server, NotFound
	}

	ListView accountsList;
	EditText accountName, accountPass, serverName, donorID;
	TextView connectedAccounts;
	ArrayList<Account> accounts = new ArrayList<Account>();

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
	 * @param v, current View
	 */
	public void returnHome(View v){
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
		ArrayList<Account> accounts = db.getAccounts();
		db.close();
		// If no accounts connected, do not close activity
		if (accounts.size() == 0) {
			Toast.makeText(this, "Please connect an account", Toast.LENGTH_SHORT).show();
		} else {
			finish();
		}
	}
	
	/**
	 * Adds the account to the local database from the text field on page.
	 *
	 */
	public void addAccount(View v){
		LocalDBHandler db = new LocalDBHandler(this, null, null, 9);

		accounts = db.getAccounts();

		String aName = accountName.getText().toString();
		String aPass = accountPass.getText().toString();
		String sName = serverName.getText().toString();
        String dIdStr = donorID.getText().toString();

		int dId = Integer.parseInt(dIdStr);
		int accountID = db.getLastId("account") + 1;

		// If account already stored, display message and return
		for(Account a : accounts){
			if(a.getAccountName().equals(aName) && a.getServerName().equals(sName) &&
					a.getAccountPassword().equals(aPass) && a.getDonorid() == dId){
				Toast.makeText(this, "Account already stored", Toast.LENGTH_LONG).show();
				db.close();
				return;
			}
		}
		// If any field does not have information provided, set an error in that field and return
		if(aName.equals("")){
			accountName.setError("Invalid Username");
			db.close();
			return;
		}	
		if(aPass.equals("")){
			accountPass.setError("Invalid Password");
			db.close();
			return;
		}	
		if(sName.equals("")){
			serverName.setError("Invalid Server Address");
			db.close();
			return;
		}	
		if(dIdStr.equals("")){
			donorID.setError("Invalid Donor ID.");
			db.close();
			return;
		}
		Account account = new Account(accountID, aName, aPass, sName, dId);
		// Execute data connection
		new DataConnection(this, account).execute("");

		// Wait for async task to signal whether account is valid or not
		while(isValidAccount == null) {
			continue;
		}

		if (isValidAccount) {
			db.addAccount(account);
			// Set asynchronous flags back to null for next attempted account
			isValidAccount = null;
			errorType = null;
			db.close();
		} else {
			// Set error statement based on error provided by async task
			String errorStatement;
			if (errorType == ErrorType.NotFound) {
				errorStatement = "No account with this Donor ID";
			} else if (errorType == ErrorType.Server) {
				errorStatement = "Could not connect to specified server";
			} else if (errorType == ErrorType.Unauthorized) {
				errorStatement = "Username or Password is incorrect";
			} else {
				errorStatement = "Unknown issue. \n 1) Check Internet connection" +
						"\n 2) Server may be down";
			}
			Toast.makeText(AccountsActivity.this, "Connecting account failed. \n -" + errorStatement,
					Toast.LENGTH_LONG).show();

			// set async flags back to null for next account connection
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
	 * @param item, item that was selected from menu (i.e. Delete, Edit, or Cancel)
	 */
	public boolean onContextItemSelected(MenuItem item) {
		AdapterView.AdapterContextMenuInfo info =
				(AdapterView.AdapterContextMenuInfo) item.getMenuInfo();

		if (item.getTitle().equals("Delete")) {

			Account temp = accounts.get(info.position);

			LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
			db.deleteAccount(temp.getId());
			db.close();
			
			loadAccountList();
			
		} else if (item.getTitle().equals("Edit")) {

			Account temp = accounts.get(info.position);

			// Launch editAccountActivity and pass account details for activity set-up
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
	 * Called after returning from the Edit Accounts page
	 * This refreshes the list of accounts. (in case a creation, edit or delete was made)
	 */
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data){
		loadAccountList();
	}

	/**
	 * Sets the validity of the account attempting to be connected
	 * @param isValid, if account was valid from validation
	 */
	public static void setValidation(boolean isValid) {
		isValidAccount = isValid;
	}

	/**
	 * Sets the error type if account is found to be invalid
	 * @param error, what error occurred
	 */
	public static void setErrorType(ErrorType error) {
		errorType = error;
	}

}

