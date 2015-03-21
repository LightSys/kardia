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


public class OptionsActivity extends ActionBarActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        MenuItem logout = (MenuItem) findViewById(R.id.action_logout);
    }

    public void goToListPage(View v) {
        int viewId = v.getId();

        Fragment listPage = new ListActivity();
        Bundle arg = new Bundle();

        // 0 = gift, 1 = donors, 2 = prayers, 3 = funds, 4 = account, 5 = payroll, 6 = reports
        switch (viewId) {
            case 2131230794: //Gifts
                arg.putInt(ListActivity.ARG_TYPE, 0);
                break;
            case 2131230800: //Donors
                arg.putInt(ListActivity.ARG_TYPE, 4);
                break;
            case 2131230797: //Prayers
                arg.putInt(ListActivity.ARG_TYPE, 2);
                break;
            case 2131230798: //Funds
                arg.putInt(ListActivity.ARG_TYPE, 3);
                break;
            case 2131230795: //Account
                arg.putInt(ListActivity.ARG_TYPE, 1);
                break;
        /*//TODO: Reimplement
        case 2131230789: //Payroll
            arg.putInt(ListActivity.ARG_TYPE, 5);
            break;
        //TODO: Reimplement
        case 2131230792: //Reports
            arg.putInt(ListActivity.ARG_TYPE, 6);
            break;*/
            default:
                break;
        }
        listPage.setArguments(arg);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(R.id.container, listPage);
        transaction.addToBackStack("ToListPage" + viewId);
        transaction.commit();
    }

    public static class PageFragment extends Fragment {
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
    public boolean onOptionsItemSelected(MenuItem item) {
        Intent intent;
        Fragment fragment;
        switch (item.getItemId()) {
            case R.id.action_search:
                setTitle("Search");
                fragment = new SearchActivity();
                getSupportFragmentManager().beginTransaction().replace(R.id.container, fragment).commit();
                break;
            case R.id.action_home:
                intent = new Intent(this, OptionsActivity.class);
                startActivity(intent);
                finish();
                break;
            case R.id.action_logout:
                LocalDBHandler db = new LocalDBHandler(OptionsActivity.this, null, null, 1);
                db.deleteAll();
                intent = new Intent(this, MainActivity.class);
                startActivity(intent);
                finish();
                break;
        }
        return true;
    }
}
