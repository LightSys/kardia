package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by otter57 on 11/7/16.
 *
 * Creates list of donors for DonorList
 * allows profile pictures to be added to List
 */

public class DonorAdapter extends SimpleAdapter {

    private final ArrayList<Bitmap> bitmaps;

    public DonorAdapter(Context context, List<? extends Map<String,String>> data,
                        int resource, String[]from , int[] to, ArrayList<Bitmap> bitmaps)
    {
        super(context, data, resource, from, to);
        this.bitmaps = bitmaps;
    }

    @Override
    public View getView(int position, View v, ViewGroup parent)
    {
        View mView = super.getView(position, v, parent);

        ImageView profilePic = (ImageView) mView.findViewById(R.id.profilePicImage);

        if(bitmaps.get(position) != null) {
            profilePic.setImageBitmap(bitmaps.get(position));
        }else {
            profilePic.setImageResource(R.drawable.profile_picture_standard);
        }

        TextView userTxt = (TextView) mView.findViewById(R.id.userNameText);

        RelativeLayout.LayoutParams llp = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        llp.addRule(RelativeLayout.CENTER_VERTICAL);
        llp.addRule(RelativeLayout.RIGHT_OF, profilePic.getId());
        userTxt.setLayoutParams(llp);

        return mView;
    }

}