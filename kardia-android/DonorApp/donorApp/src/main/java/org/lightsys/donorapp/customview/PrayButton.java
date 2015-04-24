package org.lightsys.donorapp.customview;

import android.content.Context;
import android.widget.Button;

/**
 * Created by bosonBaas on 3/12/2015.
 */
public class PrayButton extends Button {
    int id;

    public PrayButton(Context context){
        super(context);
    }

    public PrayButton(android.content.Context context, android.util.AttributeSet attrs) { super(context, attrs); }

    public PrayButton(android.content.Context context, android.util.AttributeSet attrs, int defStyle) { super(context, attrs, defStyle); }

    public void onInitializeAccessibilityEvent(android.view.accessibility.AccessibilityEvent event) { super.onInitializeAccessibilityEvent(event); }

    public void onInitializeAccessibilityNodeInfo(android.view.accessibility.AccessibilityNodeInfo info) { super.onInitializeAccessibilityNodeInfo(info); }

    public int getPrayerId(){
        return id;
    }
    public void setPrayerId(int id){
        this.id = id;
    }
}
