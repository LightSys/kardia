package org.lightsys.missionaryapp.views;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.PendingIntent;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.Spinner;
import android.widget.TableRow;
import android.widget.TimePicker;
import android.widget.Toast;

import org.lightsys.missionaryapp.R;

import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.UpdateNotification;
import org.lightsys.missionaryapp.tools.LocalDBHandler;
import org.lightsys.missionaryapp.tools.NotifyAlarmReceiver;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by Andrew Lockridge on 6/1/2015.
 *
 * This activity allows the user to set up a notification system to remind them to pray
 *
 * edited for missionaryapp from donorapp by otter57 on 9/22/2016
 */
public class UpdateNotificationActivity extends Activity {

    private Note request;
    private ArrayList<String> alarmTimes = new ArrayList<String>();
    private String endDate, Date, startDate;
    private final long DAY_IN_MILLIS = 86400000;
    private int requestid, notificationID, frequency;

    private Spinner frequencySpinner;
    private TableRow startDateRow, endDateRow, timeRow, frequencyRow;
    private Button startDateButton, endDateButton, timeButton;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_notification_layout);
        if (getActionBar() != null) {
            getActionBar().setTitle("Update Notification Setup");
        }

        Bundle args = getIntent().getExtras();

        if (args != null) {
            requestid = args.getInt("requestid");
        }

        // default alarm times
        alarmTimes.add("7:00");
        alarmTimes.add("12:00");
        alarmTimes.add("17:00");
        alarmTimes.add("19:00");

        // For next ID, retrieve last ID from database and add 1
        LocalDBHandler db = new LocalDBHandler(this, null);
        request = db.getNoteForID(requestid);
        notificationID = db.getLastId("notification") + 1;
        db.close();

        startDateRow = (TableRow) this.findViewById(R.id.start_date_row);
        endDateRow = (TableRow) this.findViewById(R.id.end_date_row);
        timeRow = (TableRow) this.findViewById(R.id.time_row);
        frequencyRow = (TableRow) this.findViewById(R.id.frequency_row);
        frequencySpinner = (Spinner) this.findViewById(R.id.frequency_spinner);
        startDateButton = (Button) this.findViewById(R.id.start_date_button);
        endDateButton = (Button) this.findViewById(R.id.end_date_button);
        timeButton = (Button) this.findViewById(R.id.time_button);

        Button setNotificationButton = (Button) this.findViewById(R.id.setNotification);
        Button cancelButton = (Button) this.findViewById(R.id.cancel);


        frequencySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (frequencySpinner.getVisibility() == View.VISIBLE) {
                    //todo functionalize frequency
                }
            }
            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {}
        });

        setNotificationButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean inputIsValid = checkValidity();
                if (inputIsValid) {
                    // Ask user if notifications should be set as they can not be edited later
                    new AlertDialog.Builder(UpdateNotificationActivity.this)
                            .setCancelable(false)
                            .setTitle("Set Notifications")
                            .setMessage("Should we set these notifications? You will not be able to edit this later.")
                            .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                    setNotification();
                                }
                            })
                            .setNegativeButton(android.R.string.no, new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int which) {
                                }
                            })
                            .setIcon(android.R.drawable.ic_dialog_alert)
                            .show();
                } else {
                    Toast.makeText(UpdateNotificationActivity.this, "There are unselected fields. " +
                            "Select date and times before continuing", Toast.LENGTH_LONG).show();
                }
            }
        });

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Ask user to confirm leaving activity without setting notifications
                showCancelConfirmation();
            }
        });
        startDateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openDatePicker(startDateButton);
            }
        });

        endDateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openDatePicker(endDateButton);
            }
        });
        timeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openTimePicker(1);
            }
        });
    }

    // Called when the user presses the back button on the bottom of the screen
    @Override
    public void onBackPressed() {
        showCancelConfirmation();
    }

    // Displays a confirmation dialog asking whether they would like to leave the page
    private void showCancelConfirmation() {
        new AlertDialog.Builder(UpdateNotificationActivity.this)
                .setCancelable(false)
                .setTitle("Cancel")
                .setMessage("Exit without setting notifications? You will not be able" +
                        " to set any notifications later for this item.")
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        finish();
                    }
                })
                .setNegativeButton("No", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                    }
                })
                .setIcon(android.R.drawable.ic_dialog_alert)
                .show();
    }

    /**
     * Check if all fields have valid data to set notifications
     * @return if all notification fields are valid
     */
    private boolean checkValidity()  {
        // If any visible field has not been selected, set to false, otherwise true
        if(endDateRow.getVisibility() == View.VISIBLE && endDateButton.getText().equals("Choose Date")   ||
           startDateRow.getVisibility() == View.VISIBLE && startDateButton.getText().equals("Choose Date") ||
           timeRow.getVisibility() == View.VISIBLE && timeButton.getText().equals("Choose Time")) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * Sets notification with given data and exits the activity
     */
    private void setNotification() {
        new NotificationCreator().execute("");
        finish();
    }

    /**
     * Open the dialog enabling the user to set a date
     */
    private void openDatePicker(Button dateButton) {
        int mYear;
        int mMonth;
        int mDay;

        // If calendar already has date, pull up that date
        // Otherwise pull up today's date
        String date = dateButton.getText().toString();
        if (!date.equals("Choose Date")) {
            String[] splitDateStr1 = date.split("-");
            mYear = Integer.parseInt(splitDateStr1[0]);
            //Subtract one to agree with DatePicker month standards, Jan = 0, Feb = 1, etc.
            mMonth = Integer.parseInt(splitDateStr1[1]) - 1;
            mDay = Integer.parseInt(splitDateStr1[2]);
        } else {
            Calendar c = Calendar.getInstance();
            mYear = c.get(Calendar.YEAR);
            mMonth = c.get(Calendar.MONTH);
            mDay = c.get(Calendar.DAY_OF_MONTH);
        }

        DatePickerDialog dialog = new DatePickerDialog(this,
                new DateSetListener(dateButton), mYear, mMonth, mDay);
        //todo enddate/startDate
        dialog.show();
    }

    private class DateSetListener implements DatePickerDialog.OnDateSetListener{
        Button dateButton;
        public DateSetListener(Button dateButton){this.dateButton = dateButton;}
        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear,
                              int dayOfMonth) {

            // DatePicker starts months at 0, January = 0, February = 1, etc
            // Add one to make it standard with missionaryApp month counting
            monthOfYear++;

            String month = (monthOfYear < 10)? "0" + monthOfYear : "" + monthOfYear;
            String day = (dayOfMonth < 10)? "0" + dayOfMonth : "" + dayOfMonth;

            String dateStr = year + "-" + month + "-" + day;
            dateButton.setText(dateStr);
            Date = dateStr;
        }
    }

    /**
     * open dialog allowing user to choose a time
     * @param btn_id, which time button is being selected
     */
    private void openTimePicker(int btn_id) {
        int hour;
        int minute;
        String text;

        text = timeButton.getText().toString();

        if (!text.equals("Choose Time")) {

            // Split into "hour:min" and "am/pm"
            String[] splitText = text.split(" ");
            String time = splitText[0];
            String amPM = splitText[1];

            // Split "hour:min" into "hour" and "min"
            String[] splitTime = time.split(":");
            hour = Integer.parseInt(splitTime[0]);
            minute = Integer.parseInt(splitTime[1]);

            // Add 12 hours for PM if not in the 12 o'clock hour
            if (amPM.equals("PM") && hour != 12) {
                hour += 12;
            }
            // If in the 12 o'clock am hour, set hour to 0
            if (amPM.equals("AM") && hour == 12) {
                hour = 0;
            }
        } else {
            Calendar c = Calendar.getInstance();
            hour = c.get(Calendar.HOUR_OF_DAY);
            minute = c.get(Calendar.MINUTE);
        }


        TimePickerDialog tPicker = new TimePickerDialog(this, new TimeSetListener(),
                hour, minute, false);
        tPicker.show();
    }

    private class TimeSetListener implements TimePickerDialog.OnTimeSetListener{

        @Override
        public void onTimeSet(TimePicker view, int hour, int minute) {
            String hourStr = "" + hour;
            String minStr = "" + minute;
            String timeStr24Hr = hourStr + ":" + minStr;

            // convert 24 hour clock to 12 hour clock
            if (hour != 12 && hour != 0) {
                hourStr = "" + (hour % 12);
            } else {
                hourStr = "12";
            }
            String amPmStr;
            if (hour >= 12) {
                amPmStr = "PM";
            } else {
                amPmStr = "AM";
            }
            minStr = minStr.length() < 2? "0" + minStr : minStr;
            String timeStr = hourStr + ":" + minStr + " " + amPmStr;

            // Switch to determine which time to set
            // Set visual timePicker with 12 hour clock format
            // Set alarmTimes field with 24 hour clock format

                    timeButton.setText(timeStr);
                    alarmTimes.set(0, timeStr24Hr);
        }
    }

    // Class uses an asynchronous thread to set alarms as it may take some time
    private class NotificationCreator extends AsyncTask<String, Void, String> {

        public NotificationCreator() {}

        @Override
        protected String doInBackground(String... params) {
            remind(alarmTimes, endDate, request.getMissionaryName(), request.getSubject());
            return null;
        }

        /**
         * Sets alarms at specified times until the endDate for a specific request
         * @param times, times in the day to set notifications (e.g. "7:00" = 7 a.m., "15:00" = 3 p.m.)
         * @param date, last day to give notifications (given as "YYYY-MM-DD")
         * @param title, title for notification to display
         * @param message, message for notification to display
         */
        private void remind (ArrayList<String> times, String date, String title, String message)
        {
            UpdateNotification notification;
            Intent alarmIntent;
            PendingIntent pendingIntent;

            LocalDBHandler db = new LocalDBHandler(UpdateNotificationActivity.this, null);
            AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);

            String[] dateSplitStr = date.split("-");
            Calendar c = Calendar.getInstance();
            // Set year, month, and day of calendar for end date
            c.set(Integer.parseInt(dateSplitStr[0]), Integer.parseInt(dateSplitStr[1])-1,
                    Integer.parseInt(dateSplitStr[2]));
            long endDateinMillis = c.getTimeInMillis();
            // Add 1 to ensure alarms set for current day get set
            int numberOfDays = daysUntilFutureDate(endDateinMillis) + 1;

            // alarm times will be set and stored in millisecond form
            long alarmTime;

            // Setting alarms requires sdk version 19 or higher
            if (Build.VERSION.SDK_INT >= 19) {

                // Loop through all times until the end date, setting a notification at each one
                for (int i = 0; i < frequency; i++) {
                    String[] timeSplit = times.get(i).split(":");
                    c = Calendar.getInstance();
                    c.set(Calendar.HOUR_OF_DAY, Integer.parseInt(timeSplit[0]));
                    c.set(Calendar.MINUTE, Integer.parseInt(timeSplit[1]));
                    c.set(Calendar.SECOND, 0);
                    alarmTime = c.getTimeInMillis();
                    for (int j = 0; j < numberOfDays; j++) {

                        // If alarm time is not in the past, set alarm for notification
                        if (alarmTime > Calendar.getInstance().getTimeInMillis()) {

                            alarmIntent = new Intent(UpdateNotificationActivity.this, NotifyAlarmReceiver.class);
                            alarmIntent.putExtra("title", title);
                            alarmIntent.putExtra("message", message);
                            alarmIntent.putExtra("id", notificationID);

                            pendingIntent = PendingIntent.getBroadcast(UpdateNotificationActivity.this,
                                    notificationID, alarmIntent, 0);

                            notification = new UpdateNotification();
                            notification.setId(notificationID);
                            notification.setNotificationTime(alarmTime);

                            db.addNotification(notification);

                            // Set alarm and increment notification ID
                            alarmManager.setExact(AlarmManager.RTC_WAKEUP, alarmTime, pendingIntent);

                            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.US);
                            Log.w("tag", "Alarm set for: " + format.format(alarmTime) + ", ID:" +
                                    Integer.toString(notificationID));

                            notificationID++;
                        }
                        // Add one day for next notification
                        alarmTime += DAY_IN_MILLIS;
                    }
                }
            } else {
                Toast.makeText(UpdateNotificationActivity.this, "Sorry, but your device " +
                                "does not have the proper update to support this feature",
                        Toast.LENGTH_LONG).show();
            }
            db.close();
        }

        /**
         * return the number of days between today and a future date
         * @param futureDate, future date in milliseconds
         * @return number of days between today and future date
         */
        private int daysUntilFutureDate(long futureDate) {
            long presentDate = Calendar.getInstance().getTimeInMillis();
            // Add 100000 to ensure time delay does not throw off results
            if (futureDate + 100000 > presentDate) {
                return (int)((futureDate - presentDate) / DAY_IN_MILLIS);
            } else {
                return -1;
            }
        }
    }
}
