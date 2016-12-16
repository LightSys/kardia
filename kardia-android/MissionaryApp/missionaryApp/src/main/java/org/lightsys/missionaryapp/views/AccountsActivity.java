package org.lightsys.missionaryapp.views;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.tools.DataConnection;
import org.lightsys.missionaryapp.tools.GenericTextWatcher;
import org.lightsys.missionaryapp.tools.LocalDBHandler;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.FragmentManager;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

import static android.content.ContentValues.TAG;

/**
 * @author Andrew Cameron
 *
 * This class is used to change app account.
 */
public class AccountsActivity extends Activity{

	private EditText accountName, accountPass, serverName, UserId, port, protocal;

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
        port                 = (EditText) findViewById(R.id.portInput);
		Button connectButton = (Button)  findViewById(R.id.connectButton);
        protocal             = (EditText) findViewById(R.id.protocalInput);

		// Adds EditTexts to text listener for resetting errors
		accountName.addTextChangedListener(new GenericTextWatcher(accountName));
		accountPass.addTextChangedListener(new GenericTextWatcher(accountPass));
		serverName.addTextChangedListener(new GenericTextWatcher(serverName));
        UserId.addTextChangedListener(new GenericTextWatcher(UserId));

		connectButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
                connectAccount();
			}
		});
    }

	/**
	 * Adds the account to the local database from the text field on page.
	 */
	private void connectAccount(){
		String aName  = accountName.getText().toString();
		String aPass  = accountPass.getText().toString();
        String sName  = serverName.getText().toString();
        String sPort  = port.getText().toString();
        String dIdStr = UserId.getText().toString();
        String sProtocal = protocal.getText().toString();
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
        if(sPort.equals("")){
            serverName.setError("Invalid Port");
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
		Account account = new Account(dId, aName, aPass, sName, sPort, sProtocal, false);
		// Execute data connection to validate account and pull data if valid
		// DataConnection will close activity once complete if successful
        new DataConnection(this, this, account, -1).execute("");
	}
}

