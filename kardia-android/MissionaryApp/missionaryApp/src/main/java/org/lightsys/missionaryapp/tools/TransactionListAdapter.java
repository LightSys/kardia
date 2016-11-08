package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;
import org.lightsys.missionaryapp.data.Transaction;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by otter57 on 11/7/16.
 */

public class TransactionListAdapter extends SimpleAdapter {

    private Context mContext;
    private int id;
    private List<? extends Map<String,String>> itemList;

    public TransactionListAdapter(Context context, List<? extends Map<String,String>> data,
                                  int resource, String[]from , int[] to )
    {
        super(context, data, resource, from, to);
        this.itemList = data;
        this.mContext = context;
        this.id = resource;
    }

    @Override
    public View getView(int position, View v, ViewGroup parent)
    {
        View mView = super.getView(position, v, parent);

        TextView text = (TextView) mView.findViewById(R.id.amountText);

        if(itemList.get(position).get("amount").contains("-")) {
            text.setText(itemList.get(position).get("amount").replace("-",""));
            text.setTextColor(Color.RED);
        }

        return mView;
    }

}