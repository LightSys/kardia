package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.GenericTextWatcher;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

/**
 * @author Andrew Cameron
 *
 * This class is used to change app account.
 */
public class AccountsActivity extends Activity{

	private EditText accountName, accountPass, serverName, UserId;
	private TextView connectedAccount, server, userName;
	private Account  account = new Account();
	private Button   finishButton;

	/**
	 * Creates the view, and loads current account if available
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.account_page_layout);

		accountName          = (EditText)findViewById(R.id.usernameInput);
		accountPass          = (EditText)findViewById(R.id.passwordInput);
		serverName           = (EditText)findViewById(R.id.serverNameInput);
		UserId               = (EditText)findViewById(R.id.userIdInput);
		connectedAccount     = (TextView)findViewById(R.id.connectedHeader);
        server               = (TextView)findViewById(R.id.server);
        userName             = (TextView)findViewById(R.id.userName);
		Button connectButton = (Button)  findViewById(R.id.connectButton);
		finishButton         = (Button)  findViewById(R.id.finishButton);

		// Adds EditTexts to text listener for resetting errors
		accountName.addTextChangedListener(new GenericTextWatcher(accountName));
		accountPass.addTextChangedListener(new GenericTextWatcher(accountPass));
		serverName.addTextChangedListener(new GenericTextWatcher(serverName));
        UserId.addTextChangedListener(new GenericTextWatcher(UserId));

		loadAccount();

		connectButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				new AlertDialog.Builder(AccountsActivity.this)
						.setCancelable(false)
						.setTitle("Connect Account")
						.setMessage("This action will remove current account data. Continue?")
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

	}

	
	/**
	 * Pulls account (if connected) out of the local SQLite Database
     * and sets header with connected account.
	 */
	private void loadAccount(){
		LocalDBHandler db = new LocalDBHandler(this);
		account = db.getAccount();
		db.close();
		
		if(account!=null){
			finishButton.setVisibility(View.VISIBLE);
			connectedAccount.setText("Connected Account:");
            userName.setText(account.getAccountName());
            server.setText(account.getServerName());

		}else{
			finishButton.setVisibility(View.INVISIBLE);
			connectedAccount.setText("No Accounts Connected.");
		}
	}
	
	/**
	 * Adds the account to the local database from the text field on page.
	 */
	private void connectAccount(){
		String aName  = accountName.getText().toString();
		String aPass  = accountPass.getText().toString();
		String sName  = serverName.getText().toString();
        String dIdStr = UserId.getText().toString();

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
            UserId.setError("Invalid Donor ID.");
			allFieldsValid = false;
		}
		// If any field is invalid, break from function
		if (!allFieldsValid) {
			return;
		}

		int dId = Integer.parseInt(dIdStr);

		// If account already stored, display message and return
        LocalDBHandler db = new LocalDBHandler(this);
        if(account!=null) {
            if (account.getAccountName().equals(aName) && account.getServerName().equals(sName) &&
                    account.getAccountPassword().equals(aPass) && account.getId() == dId) {
                Toast.makeText(this, "Account already connected", Toast.LENGTH_LONG).show();
                db.close();
                return;
            }
            // Checks that current account does not have the same Id as new account
            if (account.getId() == dId) {
                Toast.makeText(this, "Account with this ID already connected", Toast.LENGTH_LONG).show();
                db.close();
                return;
            }
        }
		Account account = new Account(dId, aName, aPass, sName);
		// Execute data connection to validate account and pull data if valid
		// DataConnection will close activity once complete if successful
		new DataConnection(this, this, account).execute("");
	}
}

