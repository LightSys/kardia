package org.lightsys.missionaryapp;


import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import org.lightsys.missionaryapp.data.LocalDBHandler;
import org.lightsys.missionaryapp.donorfragments.GiftDetailFrag;
import org.lightsys.missionaryapp.optionsfragments.AccountFragment;
import org.lightsys.missionaryapp.optionsfragments.DonorFragment;
import org.lightsys.missionaryapp.optionsfragments.GiftFragment;
import org.lightsys.missionaryapp.optionsfragments.PayrollFragment;
import org.lightsys.missionaryapp.optionsfragments.PrayerFragment;
import org.lightsys.missionaryapp.optionsfragments.ReportFragment;

public class OptionsActivity extends ActionBarActivity {

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

        // 0 = gift, 1 = donors, 2 = prayers, 3 = accounts, 4 = payroll, 5 = reports
		switch(viewId){
		/*case 2131230788: //Gifts
            arg.putInt(ListActivity.ARG_TYPE, 0);
            break;
		case 2131230791: //Donors
            arg.putInt(ListActivity.ARG_TYPE, 1);
		    break;
        case 2131230794: //Prayers
            arg.putInt(ListActivity.ARG_TYPE, 2);
            break;
        //TODO: Insert Funds
		case 2131230795: //Accounts
            arg.putInt(ListActivity.ARG_TYPE, 4);
		    break;
        //TODO: Reimplement
        *//*case 2131230789: //Payroll
            arg.putInt(ListActivity.ARG_TYPE, 5);
            break;
        //TODO: Reimplement
        case 2131230792: //Reports
            arg.putInt(ListActivity.ARG_TYPE, 6);
            break;*/
        default:
            System.out.println(viewId);
            break;
		}
		listPage.setArguments(arg);
		FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
		transaction.replace(R.id.container, listPage);
		transaction.addToBackStack("ToListPage" + viewId);
		transaction.commit();
	}

    public static class PageFragment extends Fragment{
        public static final String ARG_PAGE = "ARG_PAGE";


        public static PageFragment create(int page) {
            Bundle args = new Bundle();
            args.putInt(ARG_PAGE, page);
            PageFragment fragment = new PageFragment();
            fragment.setArguments(args);
            return fragment;
        }

        @Override
        public void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
        }
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
