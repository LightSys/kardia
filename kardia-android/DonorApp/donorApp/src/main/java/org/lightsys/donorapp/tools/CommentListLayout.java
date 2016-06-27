package org.lightsys.donorapp.tools;

import android.content.Context;
import android.view.LayoutInflater;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.example.donorapp.R;

/**
 * Created by Judah on 6/20/2016.
 */
public class CommentListLayout extends RelativeLayout {

    TextView userNameView, dateView, textView;

    public CommentListLayout(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.comment_layout, this, true);
        userNameView = (TextView)findViewById(R.id.userName);
        dateView = (TextView)findViewById(R.id.date);
        textView = (TextView)findViewById(R.id.text);

    }

    public void setUserName(String userName){userNameView.setText(userName);}

    public void setDateText(String date) {dateView.setText(date);}

    public void setCommentText(String text) {textView.setText(text);}

}
