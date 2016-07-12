package org.lightsys.missionaryapp;

import org.lightsys.missionaryapp.data.LocalDBHandler;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

/**
 * This activity recieves the selected account's user name, user password, 
 * and server name (address) and the id for that account from the SQLiteDatabase.
 * Populating editTexts with those things (except for the id), allowing the user
 * to change any of them and click the update button to save the changes to the
 * database.
 * 
 * After clicking update or the back button takes them back to account page.  
 * 
 * @author Andrew Cameron
 *
 */
public class EditAccountActivity extends Activity{
	
	EditText editName, editPass, editServer, editDonorId;
	Button submit;
	
	/**
	 * Loads current data for the selected account.
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
    	setContentView(R.layout.account_edit_layout);
    	
    	editName = (EditText)findViewById(R.id.userName);
    	editPass = (EditText)findViewById(R.id.userPass);
    	editServer = (EditText)findViewById(R.id.serverName);
    	editDonorId = (EditText)findViewById(R.id.donorId);
    	submit = (Button)findViewById(R.id.submit);
    	
    	Intent intent = getIntent();
    	
    	final int id = intent.getIntExtra("theid", -1);
    	editName.setText(intent.getStringExtra("oldname"));
    	editPass.setText(intent.getStringExtra("oldpass"));
    	editServer.setText(intent.getStringExtra("oldserver"));
    	editDonorId.setText(intent.getIntExtra("olddonorid", -1) + "");
    	
    	submit.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View v) {
				LocalDBHandler db = new LocalDBHandler(EditAccountActivity.this, null, null, 9);
				
				if(editName == null || editName.getText().toString().equals("")){
					editName.setError("Invalid User Name");
					return;
				}	
				if(editPass == null || editPass.getText().toString().equals("")){
					editPass.setError("Invalid Password");
					return;
				}	
				if(editServer == null || editServer.getText().toString().equals("")){
					editServer.setError("Invalid Server Address");
					return;
				}	
				if(editDonorId.getText().toString().equals("")){
					editDonorId.setError("Invalid Donor Id.");
					return;
				}
				
				int newId = Integer.parseInt(editDonorId.getText().toString());
				
				db.updateAccount(id, editName.getText().toString(), editPass.getText().toString(), editServer.getText().toString(), newId);
				Toast.makeText(EditAccountActivity.this, "Account updated.", Toast.LENGTH_SHORT).show();
				finish();
			}
    	});
	}
}
