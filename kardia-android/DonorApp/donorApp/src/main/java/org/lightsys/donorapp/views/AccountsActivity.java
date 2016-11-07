package org.lightsys.donorapp.views;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.tools.DataConnection;
import org.lightsys.donorapp.tools.GenericTextWatcher;
import org.lightsys.donorapp.tools.LocalDBHandler;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
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


	ListView accountsList;
	EditText accountName, accountPass, serverName, donorID;
	TextView connectedAccounts;
	ArrayList<Account> accounts = new ArrayList<Account>();
	Button connectButton, finishButton;

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
		connectButton = (Button)findViewById(R.id.connect_button);
		finishButton = (Button)findViewById(R.id.finish_button);

		// Adds EditTexts to text listener for resetting errors
		accountName.addTextChangedListener(new GenericTextWatcher(accountName));
		accountPass.addTextChangedListener(new GenericTextWatcher(accountPass));
		serverName.addTextChangedListener(new GenericTextWatcher(serverName));
		donorID.addTextChangedListener(new GenericTextWatcher(donorID));

		loadAccountList();

		registerForContextMenu(accountsList);

		connectButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				addAccount();
			}
		});

		finishButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				finish();
			}
		});

		accountsList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
				openContextMenu(view);
			}
		});
	}

	
	/**
	 * Pulls all accounts (if any) out of the local SQLite Database and puts them into the
	 * SessionStorage accounts list, then populates a listview with the accounts.
	 */
	public void loadAccountList(){
		LocalDBHandler db = new LocalDBHandler(this, null);
		
		accounts = db.getAccounts();

		db.close();
		
		if(accounts.size() > 0){
			finishButton.setVisibility(View.VISIBLE);
			connectedAccounts.setText("Connected Accounts:");
		}else{
			finishButton.setVisibility(View.INVISIBLE);
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
	 * Adds the account to the local database from the text field on page.
	 */
	public void addAccount(){
		String aName = accountName.getText().toString();
		String aPass = accountPass.getText().toString();
		String sName = serverName.getText().toString();
        String dIdStr = donorID.getText().toString();

		// If any field does not have information provided, set an error in that field
		boolean allFieldsValid = true;
		if(aName.equals("")){
			accountName.setError("Invalid Username");
			allFieldsValid = false;
		}
		if(aPass.equals("")){
			accountPass.setError("Invalid Password");
			allFieldsValid = false;
		}
		if(sName.equals("")){
			serverName.setError("Invalid Server Address");
			allFieldsValid = false;
		}
		if(dIdStr.equals("")){
			donorID.setError("Invalid Donor ID.");
			allFieldsValid = false;
		}
		// If any field is invalid, break from function
		if (!allFieldsValid) {
			return;
		}

		int dId = Integer.parseInt(dIdStr);

		// If account already stored, display message and return
		LocalDBHandler db = new LocalDBHandler(this, null);
		accounts = db.getAccounts();
		for(Account a : accounts){
			if(a.getAccountName().equals(aName) && a.getServerName().equals(sName) &&
					a.getAccountPassword().equals(aPass) && a.getId() == dId){
				Toast.makeText(this, "Account already stored", Toast.LENGTH_LONG).show();
				db.close();
				return;
			}
			// Two accounts with the same ID should never be stored
			if(a.getId() == dId) {
				Toast.makeText(this, "Account with this ID already stored", Toast.LENGTH_LONG).show();
				db.close();
				return;
			}
		}


		Account account = new Account(dId, aName, aPass, sName, null, "http", "800");
		// Execute data connection to validate account and pull data if valid
		// DataConnection will close activity once complete if successful
		new DataConnection(this, this, account).execute("");
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

			final Account temp = accounts.get(info.position);
			new AlertDialog.Builder(AccountsActivity.this)
					.setCancelable(false)
					.setTitle("Delete Account?")
					.setMessage("Delete this account? All data connected with this account" +
							"will also be deleted.")
					.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {


							LocalDBHandler db = new LocalDBHandler(AccountsActivity.this, null);
							db.deleteAccount(temp.getId());
							db.close();

							// deleteAccount deletes all missionaries and notes
							// check for missionaries and notes for any remaining accounts
							for (Account a : db.getAccounts()) {
								new DataConnection(AccountsActivity.this, AccountsActivity.this, a).execute();
							}

							loadAccountList();
						}
					})
					.setNegativeButton("No", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
						}
					})
					.setIcon(android.R.drawable.ic_dialog_alert)
					.show();

			
		} else if (item.getTitle().equals("Edit")) {

			Account temp = accounts.get(info.position);

			// Launch EditAccountActivity and pass account details for activity set-up
			Intent intent = new Intent(this, EditAccountActivity.class);
			Log.w("BasicAuth", "The donor id being put into the intent: " + temp.getId());
			intent.putExtra("oldname", temp.getAccountName());
			intent.putExtra("oldpass", temp.getAccountPassword());
			intent.putExtra("oldserver", temp.getServerName());
			intent.putExtra("olddonorid", temp.getId());
			intent.putExtra("oldprotocol", temp.getProtocol());
			intent.putExtra("oldportnumber", temp.getPortNumber());

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
		super.onActivityResult(requestCode, resultCode, data);
		loadAccountList();
	}
}

