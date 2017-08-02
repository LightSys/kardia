package org.lightsys.missionaryapp.tools;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.lightsys.missionaryapp.R;

/**
 * @author Judah Sistrunk
 * created on 6/20/2016.
 *
 * sets values to the comment layout
 */
public class CommentListLayout extends RelativeLayout {

    private final TextView userNameView, dateView, textView;
    private final ImageView imageView;

    public CommentListLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.comment_item, this, true);
        userNameView = (TextView)findViewById(R.id.userName);
        dateView     = (TextView)findViewById(R.id.dateText);
        textView     = (TextView)findViewById(R.id.noteText);
        imageView    = (ImageView)findViewById(R.id.prayingImage);

    }

    /* ************************* Set ************************* */

    public void setUserName(String userName){userNameView.setText(userName);}

    public void setDateText(String date)    {dateView.setText(date);}

    public void setCommentText(String text) {textView.setText(text);}

    public void setPrayer(boolean pray) {
        if (pray) {
            imageView.setVisibility(VISIBLE);
            imageView.setImageDrawable(getResources().getDrawable(R.drawable.active_praying_hands_icon));
        }else{
            imageView.setVisibility(GONE);
        }
    }

}
