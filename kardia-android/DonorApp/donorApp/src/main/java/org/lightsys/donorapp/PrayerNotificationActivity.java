package org.lightsys.donorapp;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.app.PendingIntent;
import android.app.TimePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
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

import com.example.donorapp.R;

import org.lightsys.donorapp.data.LocalDBHandler;
import org.lightsys.donorapp.data.NotifyAlarmReceiver;
import org.lightsys.donorapp.data.PrayerNotification;
import org.lightsys.donorapp.data.PrayerRequest;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by Andrew Lockridge on 6/1/2015.
 *
 * This activity allows the user to set up a notification system to remind them to pray
 */
public class PrayerNotificationActivity extends Activity {

    private PrayerRequest request;
    private ArrayList<String> alarmTimes = new ArrayList<String>();
    private String endDate;
    private final long DAY_IN_MILLIS = 86400000;
    private int requestid, notificationID, frequency;

    private Spinner frequencySpinner;
    private TableRow dateRow, timeRow1, timeRow2, timeRow3, timeRow4;
    private Button setNotificationButton, cancelButton, datePicker, timePicker1, timePicker2,
            timePicker3, timePicker4;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.prayer_notification_layout);

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
        LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
        request = db.getRequestForID(requestid);
        notificationID = db.getLastId("notification") + 1;
        db.close();

        frequencySpinner = (Spinner) this.findViewById(R.id.times_day);
        dateRow = (TableRow) this.findViewById(R.id.endDateRow);
        timeRow1 = (TableRow) this.findViewById(R.id.timeRow1);
        timeRow2 = (TableRow) this.findViewById(R.id.timeRow2);
        timeRow3 = (TableRow) this.findViewById(R.id.timeRow3);
        timeRow4 = (TableRow) this.findViewById(R.id.timeRow4);
        datePicker = (Button) this.findViewById(R.id.datePicker);
        timePicker1 = (Button) this.findViewById(R.id.timePicker1);
        timePicker2 = (Button) this.findViewById(R.id.timePicker2);
        timePicker3 = (Button) this.findViewById(R.id.timePicker3);
        timePicker4 = (Button) this.findViewById(R.id.timePicker4);
        setNotificationButton = (Button) this.findViewById(R.id.setNotification);
        cancelButton = (Button) this.findViewById(R.id.cancel);


        frequencySpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (frequencySpinner.getVisibility() == View.VISIBLE) {
                    // frequency is based on position (i.e 0 position = 1 time per week)
                    frequency = frequencySpinner.getSelectedItemPosition() + 1;
                    showRowsForFrequency(frequency);
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
                    new AlertDialog.Builder(PrayerNotificationActivity.this)
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
                    Toast.makeText(PrayerNotificationActivity.this, "There are unselected fields. " +
                            "Select date and times before continuing", Toast.LENGTH_LONG).show();
                }
            }
        });

        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Ask user if they are sure they do not want notifications
                new AlertDialog.Builder(PrayerNotificationActivity.this)
                        .setTitle("Cancel")
                        .setMessage("Are you sure you would not like reminders to pray for this " +
                                "request? You will not be able to set them later.")
                        .setPositiveButton("Yes, I'm sure", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                finish();
                            }
                        })
                        .setNegativeButton("No, let me set notifications", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                            }
                        })
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .show();
            }
        });

        datePicker.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openDatePicker();
            }
        });
        timePicker1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openTimePicker(1);
            }
        });
        timePicker2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openTimePicker(2);
            }
        });
        timePicker3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openTimePicker(3);
            }
        });
        timePicker4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openTimePicker(4);
            }
        });
    }

    /**
     * Check if all fields have valid data to set notifications
     * @return if all notification fields are valid
     */
    private boolean checkValidity()  {
        // If any visible field has not been selected, set to false, otherwise true
        if(dateRow.getVisibility() == View.VISIBLE && datePicker.getText().equals("Choose Date")   ||
           timeRow1.getVisibility() == View.VISIBLE && timePicker1.getText().equals("Choose Time") ||
           timeRow2.getVisibility() == View.VISIBLE && timePicker2.getText().equals("Choose Time") ||
           timeRow3.getVisibility() == View.VISIBLE && timePicker3.getText().equals("Choose Time") ||
           timeRow4.getVisibility() == View.VISIBLE && timePicker4.getText().equals("Choose Time")) {
            return false;
        } else {
            return true;
        }
    }

    /**
     * Display rows that pertain to the user's frequency of notifications
     * @param frequency, amount of times per day notifications should be sent
     */
    public void showRowsForFrequency(int frequency) {
        timeRow2.setVisibility(View.INVISIBLE);
        timeRow3.setVisibility(View.INVISIBLE);
        timeRow4.setVisibility(View.INVISIBLE);
        // switch falls through and makes each row visible that needs to be displayed
        switch (frequency) {
            case 4:
                timeRow4.setVisibility(View.VISIBLE);
            case 3:
                timeRow3.setVisibility(View.VISIBLE);
            case 2:
                timeRow2.setVisibility(View.VISIBLE);
            case 1:
                timeRow1.setVisibility(View.VISIBLE);

        }
    }

    /**
     * Sets notification with given data and exits the activity
     */
    public void setNotification() {
        remind(alarmTimes, endDate, request.getMissionaryName(), request.getSubject());
        finish();
    }

    /**
     * Sets alarms at specified times until the endDate for a specific request
     * @param times, times in the day to set notifications (e.g. "7:00" = 7 a.m., "15:00" = 3 p.m.)
     * @param date, last day to give notifications (given as "YYYY-MM-DD")
     * @param title, title for notification to display
     * @param message, message for notification to display
     */
    public void remind (ArrayList<String> times, String date, String title, String message)
    {
        PrayerNotification notification;
        Intent alarmIntent;
        PendingIntent pendingIntent;

        LocalDBHandler db = new LocalDBHandler(this, null, null, 9);
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

                        alarmIntent = new Intent(this, NotifyAlarmReceiver.class);
                        alarmIntent.putExtra("title", title);
                        alarmIntent.putExtra("message", message);
                        alarmIntent.putExtra("id", notificationID);

                        pendingIntent = PendingIntent.getBroadcast(this, notificationID, alarmIntent, 0);

                        notification = new PrayerNotification();
                        notification.setId(notificationID);
                        notification.setNotificationTime(alarmTime);
                        notification.setRequest_id(requestid);

                        db.addNotification(notification);

                        // Set alarm and increment notification ID
                        alarmManager.setExact(AlarmManager.RTC_WAKEUP, alarmTime, pendingIntent);

                        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.US);
                        Log.w("tag", "Alarm set for: " + format.format(alarmTime) + ", ID:" +
                        Integer.toString(notificationID) + ", Name:" + title);

                        notificationID++;
                    }
                    // Add one day for next notification
                    alarmTime += DAY_IN_MILLIS;
                }
            }
        } else {
            Toast.makeText(PrayerNotificationActivity.this, "Sorry, but your device " +
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

    private void openDatePicker() {
        int mYear;
        int mMonth;
        int mDay;

        // If calendar already has date, pull up that date
        // Otherwise pull up today's date
        String text1 = datePicker.getText().toString();
        if (!text1.equals("Choose Date")) {
            String[] splitDateStr1 = text1.split("-");
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
                new DateSetListener(), mYear, mMonth, mDay);
        dialog.show();
    }

    private class DateSetListener implements DatePickerDialog.OnDateSetListener{

        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear,
                              int dayOfMonth) {

            // DatePicker starts months at 0, January = 0, February = 1, etc
            // Add one to make it standard with donorApp month counting
            monthOfYear++;

            String month = (monthOfYear < 10)? "0" + monthOfYear : "" + monthOfYear;
            String day = (dayOfMonth < 10)? "0" + dayOfMonth : "" + dayOfMonth;

            String dateStr = year + "-" + month + "-" + day;
            datePicker.setText(dateStr);
            endDate = dateStr;
        }
    }

    private void openTimePicker(int btn_id) {
        int hour;
        int minute;
        String text;
        switch (btn_id) {
            case 1:
                text = timePicker1.getText().toString();
                break;
            case 2:
                text = timePicker2.getText().toString();
                break;
            case 3:
                text = timePicker3.getText().toString();
                break;
            case 4:
                text = timePicker4.getText().toString();
                break;
            default:
                text = "???";
        }

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


        TimePickerDialog tPicker = new TimePickerDialog(this, new TimeSetListener(btn_id),
                hour, minute, false);
        tPicker.show();
    }

    private class TimeSetListener implements TimePickerDialog.OnTimeSetListener{

        private int btn_id;

        public TimeSetListener(int btn_id){
            this.btn_id = btn_id;
        }
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
            switch (btn_id) {
                case 1:
                    timePicker1.setText(timeStr);
                    alarmTimes.set(0, timeStr24Hr);
                    break;
                case 2:
                    timePicker2.setText(timeStr);
                    alarmTimes.set(1, timeStr24Hr);
                    break;
                case 3:
                    timePicker3.setText(timeStr);
                    alarmTimes.set(2, timeStr24Hr);
                    break;
                case 4:
                    timePicker4.setText(timeStr);
                    alarmTimes.set(3, timeStr24Hr);
                    break;
            }
        }
    }
}
