package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.GenericTextWatcher;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;


/**
 * @author Andrew Cameron
 *
 * This activity receives the selected account's user name, user password,
 * and server name (address) and the id for that account from the SQLiteDatabase.
 * Populating editTexts with those things (except for the id), allowing the user
 * to change any of them and click the update button to save the changes to the
 * database.
 * 
 * After clicking update or the back button takes them back to account page.
 *
 */
public class EditAccountActivity extends Activity {

    private int account_id;
	private String name, pass, server;
	private EditText editName, editPass, editServer;

	/**
	 * Loads current data for the selected account.
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.account_edit_layout);

		editName = (EditText) findViewById(R.id.userName);
		editPass = (EditText) findViewById(R.id.userPass);
		editServer = (EditText) findViewById(R.id.serverName);
		TextView idText = (TextView) findViewById(R.id.donorId);
		Button submit = (Button) findViewById(R.id.submit);
		Button cancel = (Button) findViewById(R.id.cancel);

		// Adds EditTexts to text listener for resetting errors
		editName.addTextChangedListener(new GenericTextWatcher(editName));
		editPass.addTextChangedListener(new GenericTextWatcher(editPass));
		editServer.addTextChangedListener(new GenericTextWatcher(editServer));

		// Retrieve data from previous activity and set edit text fields to account data
		Intent intent = getIntent();

        String EXTRA_OLD_NAME = "old_name";
        String oldName = intent.getStringExtra(EXTRA_OLD_NAME);
        String EXTRA_OLD_PASS = "old_pass";
        String oldPass = intent.getStringExtra(EXTRA_OLD_PASS);
        String EXTRA_OLD_SERVER = "old_server";
        String oldServer = intent.getStringExtra(EXTRA_OLD_SERVER);
        String EXTRA_OLD_DONOR_ID = "old_donor_id";
        account_id = intent.getIntExtra(EXTRA_OLD_DONOR_ID, -1);

		editName.setText(oldName);
		editPass.setText(oldPass);
		editServer.setText(oldServer);
		idText.setText(Integer.toString(account_id));

		cancel.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View view) {
				finish();
			}
		});

		submit.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {

				name = editName.getText().toString();
				pass = editPass.getText().toString();
				server = editServer.getText().toString();

				// If any of the fields are blank or invalid, set error
				boolean allFieldsValid = true;
				if (name == null || name.equals("")) {
					editName.setError("Invalid Username");
					allFieldsValid = false;
				}
				if (pass == null || pass.equals("")) {
					editPass.setError("Invalid Password");
					allFieldsValid = false;
				}
				if (server == null || server.equals("")) {
					editServer.setError("Invalid Server Address");
					allFieldsValid = false;
				}
				if(!allFieldsValid) {
					return;
				}

				// If account already stored, display message and return
				LocalDBHandler db = new LocalDBHandler(EditAccountActivity.this, null);
				Account account = db.getAccount();
                db.close();
                if (account.getAccountName().equals(name) && account.getServerName().equals(server) &&
                        account.getAccountPassword().equals(pass)) {
                    Toast.makeText(EditAccountActivity.this, "Account already stored", Toast.LENGTH_LONG).show();
                    return;
                }
				Account a = new Account(account_id, name, pass, server);

				// Execute data connection to validate account and pull data if valid
				// DataConnection will close activity once complete if successful
				new DataConnection(EditAccountActivity.this, EditAccountActivity.this, a).execute("");

			}
		});
	}
}
