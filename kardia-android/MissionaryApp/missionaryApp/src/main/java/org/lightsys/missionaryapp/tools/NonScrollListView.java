package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

/**
 * Created by Judah on 6/24/2016.
 *
 * a listview that doesn't scroll!
 * this is so that you can scroll the whole page of the detailed note views
 * rather than scrolling the tiny list view
 * it makes the whole thing more readable
 * it kind of sacrifices efficiency though as the listview now has to load all comments at once
 */

//I don't really know what is happening here
//I stole it from Dedaniya HirenKumar on stack overflow
public class NonScrollListView extends ListView {

    public NonScrollListView(Context context) {
        super(context);
    }
    public NonScrollListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }
    public NonScrollListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }
    @Override
    public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int heightMeasureSpec_custom = View.MeasureSpec.makeMeasureSpec(
                Integer.MAX_VALUE >> 2, View.MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec_custom);
        ViewGroup.LayoutParams params = getLayoutParams();
        params.height = getMeasuredHeight();
    }
}
