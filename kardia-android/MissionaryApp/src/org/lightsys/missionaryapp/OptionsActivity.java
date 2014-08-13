package org.lightsys.missionaryapp;

import org.lightsys.missionaryapp.data.LocalDBHandler;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

/**
 * This is used to determine which content the user wants
 * to access.
 * 
 * @author Andrew Cameron
 *
 */
public class OptionsActivity extends ActionBarActivity{

	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		MenuItem logout = (MenuItem)findViewById(R.id.action_logout);
	}
	
	public void goToListPage(View v){
		int viewId = v.getId();
		
		Fragment listPage = new ListActivity();
		Bundle arg = new Bundle();
		
		switch(viewId){
		case 2131034192 : arg.putInt(ListActivity.ARG_TYPE, 0);
		break;
		case 2131034193 : arg.putInt(ListActivity.ARG_TYPE, 1);
		break;
		case 2131034195 : arg.putInt(ListActivity.ARG_TYPE, 2);
		break;
		case 2131034196 : arg.putInt(ListActivity.ARG_TYPE, 3);
		break;
		case 2131034197 : arg.putInt(ListActivity.ARG_TYPE, 4);
		break;
		}
		listPage.setArguments(arg);
		FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.container, listPage);
		transaction.addToBackStack("ToListPage" + viewId);
		transaction.commit();
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item){
		switch(item.getItemId()){
		case R.id.action_search:
			break;
		case R.id.action_logout:
			LocalDBHandler db = new LocalDBHandler(OptionsActivity.this, null, null, 1);
			db.deleteAll();
			Intent intent = new Intent(this, MainActivity.class);
			startActivity(intent);
			finish();
			break;
		}
		return true;
	}
}
