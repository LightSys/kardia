package org.lightsys.missionaryapp.optionsfragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.LocalDBHandler;

import java.util.ArrayList;

/**
 * Created by Breven on 3/10/2015.
 */
public class AccountFragment extends Fragment {
    /*ListView accountsList;
    EditText accountName, accountPass, serverName, donorID;
    TextView connectedAccounts;
    ArrayList<Account> accounts = new ArrayList<Account>();*/

    final static String ARG_ACCOUNT_ID = "account_id";
    int account_id = -1;


    //@Override
    public View onCreate(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState){

        if(savedInstanceState != null){
            account_id = savedInstanceState.getInt(ARG_ACCOUNT_ID);
        }

        return inflater.inflate(R.layout.accounts_listview_item, container, false);
    }

    /*@Override
    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateAccountsView(args.getInt(ARG_ACCOUNT_ID));
        }
        else if(account_id != -1){
            updateAccountsView(account_id);
        }
    }

    private void updateAccountsView(int account_id) {
        TextView account_name = (TextView)getActivity().findViewById(R.id.account_id);
        TextView balance = (TextView)getActivity().findViewById(R.id.account_balance);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        Account a = db.getAccount();

        account_name.setText(a.getAccountName());
        balance.setText(a.getAccountBalance());

        this.account_id = account_id;
    }*/

    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_ACCOUNT_ID, account_id);
    }
}
