package org.lightsys.missionaryapp.views;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.GenericTextWatcher;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

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

import org.lightsys.missionaryapp.R;

/**
 * @author Andrew Cameron
 *
 * This class is used to manage (add/delete) accounts to the app.
 */
public class AccountsActivity extends Activity{

    private ListView accountsList;
	private EditText accountName, accountPass, serverName, donorID;
	private TextView connectedAccounts;
	private Account  account = new Account();
	private Button   finishButton;

	/**
	 * Creates the view, and loads any pre-existing accounts into the ListView
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.account_page_layout);
		
		accountsList         = (ListView)findViewById(R.id.connectedList);
		accountName          = (EditText)findViewById(R.id.usernameInput);
		accountPass          = (EditText)findViewById(R.id.passwordInput);
		serverName           = (EditText)findViewById(R.id.serverNameInput);
		donorID              = (EditText)findViewById(R.id.donorIdInput);
		connectedAccounts    = (TextView)findViewById(R.id.textView);
		Button connectButton = (Button)  findViewById(R.id.connectButton);
		finishButton         = (Button)  findViewById(R.id.finishButton);

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
				new AlertDialog.Builder(AccountsActivity.this)
						.setCancelable(false)
						.setTitle("Connect Account")
						.setMessage("This action will remove current account data and requires an internet connection to get new account data. Continue?")
						.setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int which) {
								connectAccount();
							}
						})
						.setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog, int which) {
							}
						})
						.setIcon(android.R.drawable.ic_dialog_alert)
						.show();
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
	 * SessionStorage accounts list, then populates a ListView with the accounts.
	 */
	private void loadAccountList(){
		LocalDBHandler db = new LocalDBHandler(this, null);
		
		account = db.getAccount();

		db.close();
		
		if(account!=null){
			finishButton.setVisibility(View.VISIBLE);
			connectedAccounts.setText("Connected Account:");
			List<HashMap<String,String>> aList = new ArrayList<HashMap<String,String>>();

			HashMap<String,String> tempMap = new HashMap<String,String>();
			tempMap.put("aName", account.getAccountName());
			tempMap.put("aServer", account.getServerName());
			aList.add(tempMap);

			String[] from = {"aName", "aServer"};
			int[] to = {R.id.title, R.id.server};
			SimpleAdapter adapter = new SimpleAdapter(this, aList, R.layout.account_listview_item, from, to);

			accountsList.setAdapter(adapter);
		}else{
			finishButton.setVisibility(View.INVISIBLE);
			connectedAccounts.setText("No Accounts Connected.");
		}
	}
	
	/**
	 * Adds the account to the local database from the text field on page.
	 */
	private void connectAccount(){
		String aName  = accountName.getText().toString();
		String aPass  = accountPass.getText().toString();
		String sName  = serverName.getText().toString();
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
        if(account.getAccountName().equals(aName) && account.getServerName().equals(sName) &&
                account.getAccountPassword().equals(aPass) && account.getId() == dId){
            Toast.makeText(this, "Account already connected", Toast.LENGTH_LONG).show();
            db.close();
            return;
        }
        // Two accounts with the same ID should never be stored
        if(account.getId() == dId) {
            Toast.makeText(this, "Account with this ID already connected", Toast.LENGTH_LONG).show();
            db.close();
            return;
        }
		Account account = new Account(dId, aName, aPass, sName);
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

		if (item.getTitle().equals("Delete")) {

			final Account temp = account;
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
							Account a =  db.getAccount();
                            new DataConnection(AccountsActivity.this, AccountsActivity.this, a).execute();

							loadAccountList();
						}
					})
					.setNegativeButton("No", new DialogInterface.OnClickListener() {
						public void onClick(DialogInterface dialog, int which) {
						}
					})
					.setIcon(android.R.drawable.ic_dialog_alert)
					.show();

		}else if (item.getTitle().equals("Edit")) {

			Account temp = account;

			// Launch EditAccountActivity and pass account details for activity set-up
			Intent intent = new Intent(this, EditAccountActivity.class);
			Log.w("BasicAuth", "The donor id being put into the intent: " + temp.getId());
			intent.putExtra("old_name", temp.getAccountName());
			intent.putExtra("old_pass", temp.getAccountPassword());
			intent.putExtra("old_server", temp.getServerName());
			intent.putExtra("old_donor_id", temp.getId());

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

