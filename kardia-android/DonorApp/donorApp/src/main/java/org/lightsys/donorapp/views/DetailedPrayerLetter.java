package org.lightsys.donorapp.views;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.example.donorapp.R;

import org.lightsys.donorapp.data.PrayerLetter;
import org.lightsys.donorapp.tools.Formatter;
import org.lightsys.donorapp.tools.LocalDBHandler;

/**
 * Class displays a detailed view of info about the prayer letter and a button allowing the user
 * to view the prayer letter in pdf format
 * Created by Andrew Lockridge on 6/26/2015.
 */
public class DetailedPrayerLetter extends Fragment {

    final static String ARG_LETTER_ID = "request_id";
    int letter_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.prayer_letter_detailedview, container, false);
        getActivity().setTitle("Prayer Letter");
        return v;
    }

    public void onStart(){
        super.onStart();

        Bundle args = getArguments();

        if(args != null){
            updateLetterView(args.getInt(ARG_LETTER_ID));
        }
        else if(letter_id != -1){
            updateLetterView(letter_id);
        }
    }

    /**
     * This function sets the text for the letter's information
     *
     * @param letter_id, the gift's id.
     */
    public void updateLetterView(int letter_id){

        TextView missionaryName = (TextView)getActivity().findViewById(R.id.missionaryName);
        TextView subject = (TextView)getActivity().findViewById(R.id.subject);
        TextView date = (TextView)getActivity().findViewById(R.id.date);
        Button viewPDF = (Button)getActivity().findViewById(R.id.pdfButton);

        LocalDBHandler db = new LocalDBHandler(getActivity(), null, null, 9);
        PrayerLetter letter = db.getPrayerLetterForID(letter_id);
        db.close();

        missionaryName.setText(letter.getMissionaryName());
        subject.setText(letter.getTitle());
        date.setText("Date Posted: " + Formatter.getFormattedDate(letter.getDate()));

        this.letter_id = letter_id;

        viewPDF.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(getActivity(), "Not implemented yet", Toast.LENGTH_SHORT).show();
                // Will need to implement showing pdf from letter.filename
            }
        });
    }

    /**
     * Used to hold onto the id, in case the user comes back to this page
     * (like if their phone goes into sleep mode or they temporarily leave the app)
     */
    @Override
    public void onSaveInstanceState(Bundle outState){
        super.onSaveInstanceState(outState);
        outState.putInt(ARG_LETTER_ID, letter_id);
    }
}
