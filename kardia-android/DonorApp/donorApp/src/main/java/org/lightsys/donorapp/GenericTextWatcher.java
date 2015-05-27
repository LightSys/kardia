package org.lightsys.donorapp;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;

import com.example.donorapp.R;

/**
 * Created by Andrew Lockridge on 5/27/2015.
 *
 * This class enables multiple EditText fields to be added to a TextWatcher
 * When the text fields are changed, the errors will be cleared
 *
 */
public class GenericTextWatcher implements TextWatcher {

    private View view;
    public GenericTextWatcher(View view) {
        this.view = view;
    }

    public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {}
    public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
        ((EditText)view).setError(null);
    }
    public void afterTextChanged(Editable editable) {}
}
