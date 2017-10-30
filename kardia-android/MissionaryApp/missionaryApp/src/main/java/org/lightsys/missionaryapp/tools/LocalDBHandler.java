package org.lightsys.missionaryapp.tools;

import java.util.ArrayList;
import java.util.Calendar;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.JsonPost;
import org.lightsys.missionaryapp.data.NewItem;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.data.UpdateNotification;

import static android.content.ContentValues.TAG;

/**
 * Sets up a SQLite database for the application, which is used to
 * store the user accounts.
 * 
 * @author Andrew Cameron
 *
 * Edited by Joshua Workman & Andrew Baas
 *   Important information to know
 *      -Tables are only created once per device, unless dropped
 *      -Tables creation all handled in OnCreate()
 *   Table columns and names are all defined as constants at begining of file
 *   Items are added to tables by passing values in ContentValue objects
 *   Each table typically has at least a getObjects() which returns an array of all known elements,
 *      and an addObject(Object o) which adds the element(try to keep each element unique)
 *
 * Edited by Judah Sistrunk on 6/2/2016
 * 	added information relevent to the auto-updater
 *
 * 	Edited by otter57 for missionaryapp
 * 	 added information for prayer for
 * 	 removed Missionary Table
 *
 */
public class LocalDBHandler extends SQLiteOpenHelper {
	private static final int DATABASE_VERSION = 11;
	private static final String DATABASE_NAME = "missionary.db";
	//ACCOUNT TABLE
	private static final String TABLE_ACCOUNTS = "accounts";
	private static final String COLUMN_ID = "id";
	private static final String COLUMN_ACCOUNT_NAME = "account_name";
	private static final String COLUMN_ACCOUNT_PASSWORD = "account_password";
	private static final String COLUMN_SERVER_NAME = "server_name";
    private static final String COLUMN_PORT = "port";
    private static final String COLUMN_PROTOCAL = "protocal";
	private static final String COLUMN_PARTNER_NAME = "partner_name";
    private static final String COLUMN_ACCEPT_SSC = "accept_self_signed_cert";
	//FUND TABLE
	private static final String TABLE_FUND = "funds";
	private static final String COLUMN_NAME = "name";
	private static final String COLUMN_FUND_DESC = "fund_desc";
	private static final String COLUMN_FUND_CLASS = "fund_class";
	private static final String COLUMN_ANNOTATION = "annotation";
	//GIFT TABLE
	private static final String TABLE_GIFT = "gifts";
	private static final String COLUMN_FUND = "gift_fund";
	//private static final String COLUMN_FUND_DESC = "gift_fund_desc";
	//private static final String COLUMN_DATE = "gift_date";
	private static final String COLUMN_CHECK_NUM = "gift_check_num";
    private static final String COLUMN_DONOR_NAME = "donor_name";
    private static final String COLUMN_DONOR_ID = "donor_id";
    private static final String COLUMN_GIFT_TOTAL_PART = "gift_total_part";
    private static final String COLUMN_GIFT_TOTAL_WHOLE = "gift_total_whole";
	private static final String COLUMN_YEAR = "Year";
	private static final String COLUMN_MONTH = "Month";
    //TRANSACTION TABLE
    private static final String TABLE_TRANSACTION = "transactions";
    private static final String COLUMN_TRANSACTION_TOTAL_PART = "gift_total_part";
    private static final String COLUMN_TRANSACTION_TOTAL_WHOLE = "gift_total_whole";
    //NOTES TABLE
	private static final String TABLE_NOTES = "notes";
	private static final String COLUMN_TEXT = "text";
	private static final String COLUMN_SUBJECT = "subject";
	private static final String COLUMN_MISSIONARY_NAME = "missionary_name";
	private static final String COLUMN_MISSIONARY_ID = "missionary_id";
	private static final String COLUMN_TYPE = "type";
    private static final String COLUMN_PRAYED_FOR_NUM = "prayed_for_num";
	//LETTERS TABLE
	private static final String TABLE_LETTERS = "letters";
	private static final String COLUMN_TITLE = "title";
	private static final String COLUMN_FILENAME = "filename";
	private static final String COLUMN_FOLDER = "folder";
	//NOTIFICATIONS TABLE
	private static final String TABLE_NOTIFICATIONS = "notifications";
	private static final String COLUMN_NOTIFY_TIME = "notification_time";
	private static final String COLUMN_REQUEST_ID = "request_id";
	private static final String COLUMN_FREQUENCY = "notification_frequency";
	//DONOR TABLE
	private static final String TABLE_DONORS = "donors";
    private static final String COLUMN_LAST_NAME = "last_name";
    private static final String COLUMN_PROFILE_PICTURE = "profile_picture";
    private static final String COLUMN_EMAIL = "email";
    private static final String COLUMN_PHONE = "phone";
    private static final String COLUMN_ADDRESS = "address";
    private static final String COLUMN_PICTURE_NAME = "profile_picture_name";
	//FUND_ACCOUNT_MAP
	private static final String TABLE_FUND_ACCOUNT_MAP = "fund_account_map";
	private static final String COLUMN_ACCOUNT_ID = "account_id";
    private static final String COLUMN_FUND_ID = "fund_id";
	//TIME_STAMP
	private static final String TABLE_TIMESTAMP = "timestamp";
	private static final String COLUMN_DATE = "date";
	//COMMENT
	private static final String TABLE_COMMENT = "comment";
	private static final String COLUMN_COMMENT_ID = "comment_id";
	private static final String COLUMN_SENDER_ID = "sender_id";
	private static final String COLUMN_USER_NAME = "userName";
	private static final String COLUMN_NOTE_ID = "note_id";
	private static final String COLUMN_NOTE_TYPE = "note_type";
	private static final String COLUMN_COMMENT_TEXT = "comment_text";
	//REFRESH_PERIOD
	//not really a table, but a variable that needs to be accessed from multiple locations
	private static final String TABLE_REFRESH_PERIOD = "refresh_period";
	private static final String COLUMN_REFRESH = "refresh";
	//GIFT_PERIOD
	private static final String TABLE_GIFT_PERIOD = "gift_period";
	private static final String COLUMN_PERIOD = "period";
	//JSON_POST
	private static final String TABLE_JSON_POST = "json_post";
	private static final String COLUMN_JSON_ID = "id";
	private static final String COLUMN_JSON_STRING = "json_string";
	private static final String COLUMN_JSON_URL = "json_url";
	//PRAYER_FOR
	private static final String TABLE_PRAYED_FOR = "prayed_for";
	private static final String COLUMN_PRAYED_FOR_COMMENTS = "prayed_for_comments";
	private static final String COLUMN_PRAYED_FOR_ID = "prayed_for_id";
	private static final String COLUMN_PRAYED_FOR_DATE = "prayed_for_date";
	private static final String COLUMN_SUPPORTER_PARTNER_ID = "supporter_partner_id";
	private static final String COLUMN_SUPPORTER_PARTNER_NAME = "supporter_partner_name";
    //NEW EVENT
    private static final String TABLE_NEW_EVENT = "new_event";
    private static final String COLUMN_HEADER   = "header";
    private static final String COLUMN_CONTENT = "content";
    private static final String COLUMN_EVENT_ID = "event_id";
	
	/* ************************* Creation of Database and Tables ************************* */

	/**
	 * Creates an instance of the database
	 */
	public LocalDBHandler(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}

	/**
	 * Creates all the tables used to store accounts and donor information
	 * Called only when database is first created
	 */
	@Override
	public void onCreate(SQLiteDatabase db) {

		String CREATE_TABLE_TIMESTAMP = "CREATE TABLE " + TABLE_TIMESTAMP + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT)";
		db.execSQL(CREATE_TABLE_TIMESTAMP);

		String CREATE_ACCOUNTS_TABLE = "CREATE TABLE " + TABLE_ACCOUNTS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_ACCOUNT_NAME
				+ " TEXT," + COLUMN_ACCOUNT_PASSWORD + " TEXT,"
				+ COLUMN_SERVER_NAME + " TEXT," + COLUMN_PARTNER_NAME + " TEXT," + COLUMN_PORT + " TEXT,"
                + COLUMN_PROTOCAL + " TEXT," + COLUMN_ACCEPT_SSC + " INTEGER)";
		db.execSQL(CREATE_ACCOUNTS_TABLE);

		String CREATE_DONOR_TABLE = "CREATE TABLE " + TABLE_DONORS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," + COLUMN_LAST_NAME + " TEXT,"
                + COLUMN_PROFILE_PICTURE + " BLOB," + COLUMN_PHONE + " TEXT," + COLUMN_EMAIL + " TEXT,"
                + COLUMN_ADDRESS + " TEXT," + COLUMN_PICTURE_NAME + " TEXT)";
		db.execSQL(CREATE_DONOR_TABLE);

		String CREATE_NOTES_TABLE = "CREATE TABLE " + TABLE_NOTES + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TEXT + " TEXT," + COLUMN_SUBJECT + " TEXT,"
				+ COLUMN_MISSIONARY_NAME + " TEXT," + COLUMN_MISSIONARY_ID + " INTEGER,"
				+ COLUMN_TYPE + " TEXT," + COLUMN_PRAYED_FOR_NUM + " INTEGER)";
		db.execSQL(CREATE_NOTES_TABLE);

		String CREATE_LETTERS_TABLE = "CREATE TABLE " + TABLE_LETTERS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TITLE + " TEXT," + COLUMN_MISSIONARY_NAME + " TEXT,"
				+ COLUMN_FOLDER + " TEXT," + COLUMN_FILENAME + " TEXT,"
				+ COLUMN_MISSIONARY_ID + " INTEGER)";
		db.execSQL(CREATE_LETTERS_TABLE);

		String CREATE_NOTIFICATIONS_TABLE = "CREATE TABLE " + TABLE_NOTIFICATIONS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NOTIFY_TIME + " TEXT,"
				+ COLUMN_FREQUENCY + " TEXT," + COLUMN_REQUEST_ID + " TEXT)";
		db.execSQL(CREATE_NOTIFICATIONS_TABLE);

		String CREATE_FUND_TABLE = "CREATE TABLE " + TABLE_FUND + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_MISSIONARY_ID + " INTEGER, " +
                COLUMN_NAME + " TEXT," +
				COLUMN_FUND_DESC + " TEXT," +
				COLUMN_FUND_CLASS + " TEXT," + COLUMN_ANNOTATION + " TEXT)";
		db.execSQL(CREATE_FUND_TABLE);

		String CREATE_GIFT_TABLE = "CREATE TABLE " + TABLE_GIFT + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
				+ " TEXT," + COLUMN_FUND + " TEXT,"
				+ COLUMN_FUND_DESC + " TEXT," + COLUMN_GIFT_TOTAL_WHOLE
				+ " INTEGER," + COLUMN_GIFT_TOTAL_PART + " INTEGER,"
				+ COLUMN_DATE + " TEXT," + COLUMN_CHECK_NUM + " TEXT,"
                + COLUMN_DONOR_NAME + " TEXT," + COLUMN_DONOR_ID + " INTEGER," + COLUMN_YEAR + " TEXT,"
				+ COLUMN_MONTH + " TEXT)";
		db.execSQL(CREATE_GIFT_TABLE);

        String CREATE_TRANSACTION_TABLE = "CREATE TABLE " + TABLE_TRANSACTION + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
                + " TEXT," + COLUMN_FUND + " TEXT,"
                + COLUMN_FUND_DESC + " TEXT," + COLUMN_TRANSACTION_TOTAL_WHOLE
                + " INTEGER," + COLUMN_TRANSACTION_TOTAL_PART + " INTEGER,"
                + COLUMN_DATE + " TEXT," + COLUMN_DONOR_NAME + " TEXT,"
                + COLUMN_DONOR_ID + " INTEGER," + COLUMN_YEAR + " TEXT,"
                + COLUMN_MONTH + " TEXT)";
        db.execSQL(CREATE_TRANSACTION_TABLE);

		String CREATE_FUND_ACCOUNT_MAP_TABLE = "CREATE TABLE " + TABLE_FUND_ACCOUNT_MAP
				+ "(" + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_FUND_ID
				+ " INTEGER," + COLUMN_ACCOUNT_ID + " INTEGER)";
		db.execSQL(CREATE_FUND_ACCOUNT_MAP_TABLE);

		String CREATE_COMMENT_TABLE = "CREATE TABLE " + TABLE_COMMENT
				+ "(" + COLUMN_COMMENT_ID + " INTEGER PRIMARY KEY,"
				+ COLUMN_SENDER_ID + " INTEGER,"
				+ COLUMN_NOTE_ID + " INTEGER,"
				+ COLUMN_USER_NAME + " TEXT,"
				+ COLUMN_NOTE_TYPE + " TEXT,"
				+ COLUMN_DATE + " TEXT,"
				+ COLUMN_COMMENT_TEXT + " TEXT)";
		db.execSQL(CREATE_COMMENT_TABLE);

		String CREATE_REFRESH_PERIOD_TABLE = "CREATE TABLE " + TABLE_REFRESH_PERIOD
				+ "(" + COLUMN_REFRESH + " TEXT PRIMARY KEY)";
		db.execSQL(CREATE_REFRESH_PERIOD_TABLE);

		String CREATE_GIFT_PERIOD_TABLE = "CREATE TABLE " + TABLE_GIFT_PERIOD
				+ "(" + COLUMN_PERIOD + " TEXT PRIMARY KEY)";
		db.execSQL(CREATE_GIFT_PERIOD_TABLE);

		String CREATE_JSON_POST_TABLE = "CREATE TABLE " + TABLE_JSON_POST
				+ "(" + COLUMN_JSON_ID + " INTEGER PRIMARY KEY, "
				+ COLUMN_JSON_URL + " TEXT, " + COLUMN_JSON_STRING + " TEXT, "
				+ COLUMN_ACCOUNT_ID + " INTEGER)";
		db.execSQL(CREATE_JSON_POST_TABLE);

	String CREATE_PRAYED_FOR_TABLE = "CREATE TABLE " + TABLE_PRAYED_FOR
			+ "(" + COLUMN_PRAYED_FOR_ID + " INTEGER PRIMARY KEY,"
			+ COLUMN_PRAYED_FOR_COMMENTS + " TEXT,"
			+ COLUMN_PRAYED_FOR_DATE + " TEXT,"
			+ COLUMN_NOTE_ID + " INTEGER,"
			+ COLUMN_SUPPORTER_PARTNER_ID + " INTEGER,"
			+ COLUMN_SUPPORTER_PARTNER_NAME + " TEXT)";
	    db.execSQL(CREATE_PRAYED_FOR_TABLE);

    String CREATE_NEW_EVENT_TABLE = "CREATE TABLE " + TABLE_NEW_EVENT
            + "(" + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_TYPE
            + " TEXT," + COLUMN_EVENT_ID + " INTEGER," +  COLUMN_HEADER + " TEXT,"
            + COLUMN_CONTENT + " TEXT," + COLUMN_DATE + " TEXT)";
        db.execSQL(CREATE_NEW_EVENT_TABLE);
	}
	/**
	 * Since the SQLite Database is meant to stay local, it will never use this call
	 * and should never use this call, or else all accounts will be erased.
	 */
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion){
		//nothing. The database model won't be changed.
	}
	
	/* ************************* Add Queries ************************* */

	/**
	 * Adds a timestamp to the database
	 * @param date, date in standard millisecond form to be added
	 */
	public void addTimeStamp(String date){
		ContentValues values = new ContentValues();
		values.put(COLUMN_DATE, date);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_TIMESTAMP, null, values);
		db.close();
	}
	
	/**
	 * Replaces old account with current connected Account
	 * @param account, uses an Account object to retrieve needed data
	 */
	public void addAccount(Account account){
		deleteAccount();
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, account.getId());
		values.put(COLUMN_ACCOUNT_NAME, account.getAccountName());
		values.put(COLUMN_ACCOUNT_PASSWORD, account.getAccountPassword());
		values.put(COLUMN_SERVER_NAME, account.getServerName());
		values.put(COLUMN_PARTNER_NAME, account.getPartnerName());
        values.put(COLUMN_PORT, account.getPort());
        values.put(COLUMN_PROTOCAL, account.getProtocal());
        values.put(COLUMN_ACCEPT_SSC, account.getAcceptSSCert());

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_ACCOUNTS, null, values);
		db.close();
	}

    /**
     * Adds a donor to the database
     * @param donor, the Donor Object to be added
     */
    public void addDonor(Donor donor) {
        ContentValues values = new ContentValues();
        String name=donor.getName();
        values.put(COLUMN_ID, donor.getId());
        values.put(COLUMN_NAME, name);
        values.put(COLUMN_LAST_NAME, name.substring(name.indexOf(" ")+1));

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_DONORS, null, values);
        db.close();
    }

    /**
     * Adds a donor image to the database
     * @param Id, the Id of the Donor the image belongs to
     * @param image, the profile picture for the Donor
     */
    public void addDonorImage(byte[]image, int Id, String name) throws SQLiteException{
        ContentValues values = new ContentValues();
        values.put(COLUMN_PROFILE_PICTURE, image);
        values.put(COLUMN_PICTURE_NAME, name);

        SQLiteDatabase db = this.getWritableDatabase();
        db.update(TABLE_DONORS, values, COLUMN_ID + " = " + Id, null);
        db.close();
    }

    /**
     * Adds a note (prayer request or update) to the Notes table in the database
     * @param note, note to be added
     */
	public void addNote(Note note) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_TEXT, note.getNoteText());
        values.put(COLUMN_DATE, note.getDate());
        values.put(COLUMN_SUBJECT,note.getSubject());
        values.put(COLUMN_MISSIONARY_NAME,note.getMissionaryName());
		values.put(COLUMN_MISSIONARY_ID, note.getMissionaryID());
        values.put(COLUMN_ID, note.getNoteId());
		values.put(COLUMN_TYPE, note.getType());
		values.put(COLUMN_PRAYED_FOR_NUM,note.getNumberPrayed());

        SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_NOTES, null, values);
        db.close();
    }
    /**
     * Updates donor contact info
     * @param donorId, the donor to add the contact info to
     * @param email, the email address
     * @param phone, the phone number
     */
    public void addContactInfo(int donorId, String phone, String email) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_EMAIL, email);
        values.put(COLUMN_PHONE, phone);

        SQLiteDatabase db = this.getWritableDatabase();
        db.update(TABLE_DONORS, values, COLUMN_ID + " = " + donorId, null);
        db.close();
    }

    /**
     * Updates donor address
     * @param address, the address to be added
     */
    public void addAddress(int donorId, String address) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_ADDRESS, address);

        SQLiteDatabase db = this.getWritableDatabase();
        db.update(TABLE_DONORS, values, COLUMN_ID + " = " + donorId, null);
        db.close();
    }

	/**
	 * Adds a prayed for item for a prayer request to the database
	 * @param prayerForItem, the item to be added
	 */
	public void addPrayedFor(PrayedFor prayerForItem) {
        ContentValues values = new ContentValues();

        values.put(COLUMN_PRAYED_FOR_ID, prayerForItem.getPrayedForId());
        values.put(COLUMN_PRAYED_FOR_COMMENTS, prayerForItem.getPrayedForComments());
        values.put(COLUMN_PRAYED_FOR_DATE, prayerForItem.getPrayedForDate());
        values.put(COLUMN_NOTE_ID, prayerForItem.getNoteID());
        values.put(COLUMN_SUPPORTER_PARTNER_ID, prayerForItem.getSupporterId());
        values.put(COLUMN_SUPPORTER_PARTNER_NAME, prayerForItem.getSupporterName());

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_PRAYED_FOR, null, values);
        db.close();
    }

	/**
	 * Adds a prayer letter to the database
	 * @param letter, the letter to be added
	 */
	public void addPrayerLetter(PrayerLetter letter) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, letter.getId());
		values.put(COLUMN_DATE, letter.getDate());
		values.put(COLUMN_MISSIONARY_NAME, letter.getMissionaryName());
		values.put(COLUMN_TITLE, letter.getTitle());
		values.put(COLUMN_FOLDER, letter.getFolder());
		values.put(COLUMN_FILENAME, letter.getFilename());
		values.put(COLUMN_MISSIONARY_ID, letter.getMissionaryId());

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_LETTERS, null, values);
		db.close();
	}

	/**
	 * Adds a prayer notification to the database
	 * @param notification, notification to be stored
	 */
	public void addNotification(UpdateNotification notification) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, notification.getId());
		values.put(COLUMN_NOTIFY_TIME, Long.toString(notification.getTime()));
		values.put(COLUMN_FREQUENCY, notification.getFrequency());
		//todo values.put(COLUMN_REQUEST_ID, Integer.toString(notification.getRequestID()));

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_NOTIFICATIONS, null, values);
		db.close();
	}

	/**
	 * Adds a fund to the database
	 * @param fund, fund to be stored
	 */
	public void addFund(Fund fund) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, fund.getFundName());
        values.put(COLUMN_MISSIONARY_ID, fund.getMissionaryId());
		values.put(COLUMN_FUND_DESC, fund.getFundDesc());
		values.put(COLUMN_FUND_CLASS, fund.getFundClass());
		values.put(COLUMN_ANNOTATION, fund.getFundAnnotation());

		SQLiteDatabase db = this.getWritableDatabase();

		db.insert(TABLE_FUND, null, values);
		db.close();
	}
	
	/**
	 * Adds a gift to the database
	 * @param gift, gift to be stored
	 */
	public void addGift(Gift gift){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, gift.getName());
		values.put(COLUMN_FUND, gift.getGiftFund());
		values.put(COLUMN_FUND_DESC, gift.getGiftFundDesc());
		values.put(COLUMN_GIFT_TOTAL_WHOLE, gift.getGiftAmount()[0]);
		values.put(COLUMN_GIFT_TOTAL_PART, gift.getGiftAmount()[1]);
		values.put(COLUMN_DATE, gift.getGiftDate());
		values.put(COLUMN_CHECK_NUM, gift.getGiftCheckNum());
        values.put(COLUMN_DONOR_NAME, gift.getGiftDonor());
        values.put(COLUMN_DONOR_ID, gift.getGiftDonorId());
		values.put(COLUMN_YEAR, gift.getGiftYear());
		values.put(COLUMN_MONTH, gift.getGiftMonth());


		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFT, null, values);
		db.close();
	}

    /**
     * Adds a transaction to the database
     * @param transaction, transaction to be stored
     */
    public void addTransaction(Gift transaction){
        ContentValues values = new ContentValues();
        values.put(COLUMN_NAME, transaction.getName());
        values.put(COLUMN_FUND, transaction.getGiftFund());
        values.put(COLUMN_FUND_DESC, transaction.getGiftFundDesc());
        values.put(COLUMN_TRANSACTION_TOTAL_WHOLE, transaction.getGiftAmount()[0]);
        values.put(COLUMN_TRANSACTION_TOTAL_PART, transaction.getGiftAmount()[1]);
        values.put(COLUMN_DATE, transaction.getGiftDate());
        values.put(COLUMN_DONOR_NAME, transaction.getGiftDonor());
        values.put(COLUMN_DONOR_ID, transaction.getGiftDonorId());
        values.put(COLUMN_YEAR, transaction.getGiftYear());
        values.put(COLUMN_MONTH, transaction.getGiftMonth());


        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_TRANSACTION, null, values);
        db.close();
    }

    /**
     * Adds a gift to the database
     * @param type, type of event
     * @param eventId, id of event
     * @param header, header to be displayed for event
     * @param content, information from event
     * @param date, date event occurred
     */

    // id, type, eventid, header, content, date
    public void addNewEvent(String type, int eventId, String header, String content, String date){
        ContentValues values = new ContentValues();
        values.put(COLUMN_TYPE, type);
        values.put(COLUMN_EVENT_ID, eventId);
        values.put(COLUMN_HEADER, header);
        values.put(COLUMN_CONTENT, content);
        values.put(COLUMN_DATE, date);
        Log.d(TAG, "addNewEvent: " + date);

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_NEW_EVENT, null, values);
        db.close();
    }

    /**
     * Adds a comment on a note to the database
     * @param commentID, comment Identifier
     *
     */
	//adds comment
	public void addComment (int commentID, int senderID, int notedID, String userName, String noteType, String date, String comment){
		ContentValues values = new ContentValues();
		values.put(COLUMN_COMMENT_ID, commentID);
		values.put(COLUMN_SENDER_ID, senderID);
		values.put(COLUMN_NOTE_ID, notedID);
		values.put(COLUMN_USER_NAME, userName);
		values.put(COLUMN_NOTE_TYPE, noteType);
		values.put(COLUMN_DATE, date);
		values.put(COLUMN_COMMENT_TEXT, comment);

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_COMMENT, null, values);
		db.close();
	}

    /**
     * sets the current refresh period
     * @param period, refresh period
     *
     */
	public void addRefreshPeriod(String period){
		deleteRefreshPeriod();

		ContentValues values = new ContentValues();
		values.put(COLUMN_REFRESH, period);

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_REFRESH_PERIOD, null, values);
		db.close();
	}
    /**
     * sets the current gift period
     * @param period, Gift period
     **/
	public void addGiftPeriod (String period){
		deleteGiftPeriod();

		ContentValues values = new ContentValues();
		values.put(COLUMN_PERIOD, period);

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_GIFT_PERIOD, null, values);
		db.close();
	}
    /**
     * add JSON post
     *
     **/
	public void addJson_post(long jsonTableId, String url, String jsonString, int accountID){
		ContentValues values = new ContentValues();
		Log.e("dbh", "pre stuff");
		values.put(COLUMN_JSON_ID, jsonTableId);
		values.put(COLUMN_JSON_URL, url);
		values.put(COLUMN_JSON_STRING, jsonString);
		values.put(COLUMN_ACCOUNT_ID, accountID);
		Log.e("dbh", "post stuff");

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_JSON_POST, null, values);
		db.close();
		Log.e("dbh", "all the things done");

	}

	/* ************************* Deletion Queries ************************* */
	
	/**
	 * Deletes the timestamp table
	 */
	public void deleteTimeStamp(){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_TIMESTAMP, null, null);
		db.close();
	}
	
	/**
	 * Deletes the Account from the database (also any information linked with it)
	 */
	public void deleteAccount(){

		SQLiteDatabase db = this.getWritableDatabase();

		db.delete(TABLE_GIFT, null, null);
        db.delete(TABLE_FUND, null, null);
		db.delete(TABLE_FUND_ACCOUNT_MAP, null, null);

		db.delete(TABLE_NOTES, null, null);
		db.delete(TABLE_LETTERS, null, null);
		db.delete(TABLE_NOTIFICATIONS, null, null);
        db.delete(TABLE_COMMENT, null, null);
        db.delete(TABLE_PRAYED_FOR, null, null);

        db.delete(TABLE_DONORS, null, null);

		db.delete(TABLE_ACCOUNTS, null,null);
        db.delete(TABLE_NEW_EVENT, null, null);

		db.close();
	}

	/**
	 * delete a prayer notification from the database
	 * will be called once during boot up if notification time is already passed
	 * @param notification_id, id of notification to be deleted
	 */
	public void deleteNotification(int notification_id) {
		String[] notification = {String.valueOf(notification_id)};
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_NOTIFICATIONS, COLUMN_ID + " = ?", notification);
        db.close();
	}

    /**
     * delete Note from database
     * @param note, note to be deleted
     */
	public void deleteNote(Note note){
		String[] acct = {String.valueOf(note.getNoteId())};
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_NOTES, COLUMN_ID + " = ?", acct);
		db.close();
	}

    /**
     * delete NewEvent from database
     * @param id, note to be deleted
     */
    public void deleteNewEvent(int id){
        String[] acct = {String.valueOf(id)};
        SQLiteDatabase db = this.getReadableDatabase();
        db.delete(TABLE_NEW_EVENT, COLUMN_ID + " = ?", acct);
        db.close();
    }

    /**
     * delete comment from database
     * @param comment, comment to be deleted
     */
	public void deleteComment(Comment comment){
		String[] acct = {String.valueOf(comment.getCommentID())};
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_COMMENT, COLUMN_COMMENT_ID + " = ?", acct);
		db.close();
	}

    /**
     * delete Json Post
     * @param jsonId, Id of item to be deleted
     */
	public void deleteJsonPost(long jsonId){
		String[] json = {String.valueOf(jsonId)};
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_JSON_POST, COLUMN_JSON_ID + " = ?", json);
	}

    /**
     * deletes the period of refresh for the auto-updater
     */
	private void deleteRefreshPeriod(){
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_REFRESH_PERIOD, null, null);
		db.close();
	}

    /**
     * deletes the period to display on gift page
     */
	private void deleteGiftPeriod(){
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_GIFT_PERIOD, null, null);
		db.close();
	}

	/* ************************* Get Queries ************************* */

    /**
	 * Pulls the timestamp from the database
	 * @return A timestamp of the last update in millisecond form
	 */
	public long getTimeStamp() {
		String queryString = "SELECT " + COLUMN_DATE + " FROM " + TABLE_TIMESTAMP;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		long date = -1;

		if (c.moveToFirst()) {
			date = Long.parseLong(c.getString(0));
		}
		c.close();
		db.close();
		return date;
	}
    /**
     * Pulls periods for the gifts in a fund
     * @param fundId, identification of fund gifts are being pulled from
     * @param periodType, type of period (year or month) for which gifts are pulled
     * @return An ArrayList of all gift periods related to a fund
     */
	public ArrayList<Period> getFundPeriods(int fundId, String periodType) {
		ArrayList<Period> periods = new ArrayList<Period>();

		String qString = "SELECT DISTINCT " + periodType + " FROM " + TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_FUND_DESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE " + TABLE_FUND + "." + COLUMN_ID + " = " + fundId + " ORDER BY " + COLUMN_YEAR + " DESC, "
				+ COLUMN_MONTH + " DESC";

		SQLiteDatabase db = this.getReadableDatabase();

		Cursor c = db.rawQuery(qString, null);

		while (c.moveToNext()) {
            Period temp = new Period();
            temp.setPeriodName(c.getString(0));
			ArrayList<Gift> gifts = getGiftsForPeriod(fundId, periodType, c.getString(0));
            int Total[]= new int[2];
            for(Gift g:gifts){
                Total[0] += g.getGiftAmount()[0];
                Total[1] += g.getGiftAmount()[1];
            }
            if (Total[1]>=100){
               Total[0]+=Math.floor(Total[1]/100);
                Total[1]-=Math.floor(Total[1]/100)*100;
            }
            temp.setGiftTotal(Total);
			temp.setFundId(fundId);

			periods.add(temp);
		}
		db.close();
		c.close();
		return periods;
	}

	/**
	 * Pulls user account
	 * @return user accounts
	 */
	public Account getAccount(){
		Account temp = new Account();
		String queryString = "SELECT * FROM " + TABLE_ACCOUNTS;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setAccountName(c.getString(1));
			temp.setAccountPassword(c.getString(2));
			temp.setServerName(c.getString(3));
			temp.setPartnerName(c.getString(4));
            temp.setPort(c.getString(5));
            temp.setProtocal(c.getString(6));
            temp.setAcceptSSCert(c.getInt(7));

		}else {
			temp=null;
		}
		c.close();
		db.close();
		return temp;
	}
	
	/**
	 * Pulls a specific fund from an ID
	 * @param fundId, id of fund to retrieve
	 * @return fund with the id of fundId
	 */
    public Fund getFundByFundId(int fundId) {
        Fund fund = new Fund();

        String qString = "SELECT * FROM " + TABLE_FUND + " WHERE "
                + COLUMN_ID + " = " + fundId;

        SQLiteDatabase db = this.getReadableDatabase();

        Cursor c = db.rawQuery(qString, null);

        if (c.moveToFirst()) {
            fund.setFundId(Integer.parseInt(c.getString(0)));
            fund.setMissionaryId(c.getInt(1));
            fund.setFundName(c.getString(2));
            fund.setFundDesc(c.getString(3));
            fund.setFundClass(c.getString(4));
            fund.setFundAnnotation(c.getString(5));
        }
        db.close();
        c.close();
        return fund;
    }
	
	/**
	 * Pulls the last ID used in the table specified
	 * @param type, which table to pull from - 'fund','gift', or 'year'
	 * @return the id of the last element in the given table
	 *
	public int getLastId(String type){
		int id = 0;
		String queryString = "SELECT " + COLUMN_ID + " FROM ";
		if(type.equals("fund")){
			queryString += TABLE_FUND;
		} else if(type.equals("gift")){
			queryString += TABLE_GIFT;
		} else if (type.equals("notification")) {
			queryString += TABLE_NOTIFICATIONS;
		} else if (type.equals("account")) {
			queryString += TABLE_ACCOUNTS;
		}
		
		queryString += " ORDER BY " + COLUMN_ID + " DESC LIMIT 1";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			id = Integer.parseInt(c.getString(0));
		}
		c.close();
		db.close();
		return id;
		
	}*/
	
	/**
	 * This is used when pulling down information, it is used to compare funds,
	 * so that duplicates are not put into the database. based on the account
	 * @param Account_ID, Account ID to pull names from
	 * @return A list of names of all the funds in the database for a specific account
	 */
	public ArrayList<String> getFundNames(int Account_ID){
		ArrayList<String> fundNames = new ArrayList<String>();
		String queryString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_FUND
				+ " WHERE " + COLUMN_MISSIONARY_ID + " = " + Account_ID;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			fundNames.add(c.getString(0));
		}
		c.close();
		db.close();
		return fundNames;
	}
	
	/**
	 * Pulls all funds for a specific account
	 * @param Account_ID, Account ID to pull funds from
	 * @return All funds for an account as an ArrayList of Fund Objects ordered alphabetically
	 */
	public ArrayList<Fund> getFundsForMissionary(int Account_ID){
		ArrayList<Fund> funds = new ArrayList<Fund>();
		String queryString = "SELECT * FROM " + TABLE_FUND +
                " WHERE " + COLUMN_MISSIONARY_ID + " = " + Account_ID;

		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Fund temp = new Fund();
			temp.setFundId(Integer.parseInt(c.getString(0)));
			temp.setMissionaryId(c.getInt(1));
			temp.setFundName(c.getString(2));
			temp.setFundDesc(c.getString(3));
            temp.setFundClass(c.getString(4));
            temp.setFundAnnotation(c.getString(5));

			funds.add(temp);
		}
		c.close();
		db.close();
		return funds;
	}

    /**
     * Pulls all donors from the database
     * @return a list of all donors as an ArrayList of Donor Objects ordered alphabetically
     */
    public ArrayList<Donor> getDonors() {
        ArrayList<Donor> donors = new ArrayList<Donor>();
        String queryString = "SELECT * FROM " + TABLE_DONORS + " ORDER BY " +
                COLUMN_LAST_NAME;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            Donor temp = new Donor(Integer.parseInt(c.getString(0)), c.getString(1), c.getBlob(3), c.getString(4), c.getString(5), null, null);
            donors.add(temp);
        }
        c.close();
        db.close();
        return donors;
    }

    /**
     * Pulls all donor matching id from database
     * @param Id, id of the donor to be retrieved
     * @return a list of all donors as an ArrayList of Donor Objects ordered alphabetically
     */
    public Donor getDonorById(int Id) {
        Donor temp = new Donor();
        String queryString = "SELECT * FROM " + TABLE_DONORS + " WHERE " +
                COLUMN_ID + " = " + Id;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            temp = new Donor(Integer.parseInt(c.getString(0)), c.getString(1), c.getBlob(3), c.getString(4), c.getString(5), null, null);
        }
        c.close();
        db.close();
        return temp;
    }

    /**
     * Pulls donors with correct Ids from the database
     * @param donorId, ArrayList of IDs for the donors to be selected
     * @return a list donors as an ArrayList of Donor Objects ordered alphabetically
     */
    public ArrayList<Donor> getDonorsById(String donorId) {
        ArrayList<Donor> donors = new ArrayList<Donor>();
        String queryString = "SELECT * FROM " + TABLE_DONORS + " WHERE " + COLUMN_ID + " IN " + donorId
                + " ORDER BY " + COLUMN_LAST_NAME;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            //set Donor(id, name)
            Donor temp = new Donor(Integer.parseInt(c.getString(0)), c.getString(1), c.getBlob(3), c.getString(4), c.getString(5), null, null);
            donors.add(temp);
        }
        c.close();
        db.close();
        return donors;
    }

    /**
     * Pulls donors with correct Id from the database
     * @param donorId, IDs for the donors to be selected
     * @return a donor info as a Donor object
     */
    public Donor getDonorInfoById(int donorId) {
        String queryString = "SELECT " + COLUMN_ID + ", " + COLUMN_PHONE
                + ", " + COLUMN_EMAIL + ", " + COLUMN_ADDRESS + ", " + COLUMN_PROFILE_PICTURE
                + " FROM " + TABLE_DONORS + " WHERE " + COLUMN_ID + " = " + donorId;

        Donor temp = new Donor();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            //set Donor(id, name)
            temp.setId(Integer.parseInt(c.getString(0)));
            temp.setPhone(c.getString(1));
            temp.setEmail(c.getString(2));
            temp.setAddress(c.getString(3));
            temp.setImage(c.getBlob(4));
        }
        c.close();
        db.close();
        return temp;
    }

    /**
     * gets name of a donor's image
     * @param donorId, the Id of the Donor the image belongs to
     */
    public String getDonorImage(int donorId) {
        String name = "";
        String queryString = "SELECT " + COLUMN_PICTURE_NAME
                + " FROM " + TABLE_DONORS + " WHERE " + COLUMN_ID + " = " + donorId;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            //set Image name
            name = c.getString(0);
        }
        c.close();
        db.close();
        return name;
    }

    /**
     * Pulls all donors from the database associated with a gift
     * @return a list of donors who have donated as an ArrayList of Donor Objects ordered alphabetically
     */
    public ArrayList<String> getDonorsOfGifts() {
        ArrayList<String> donors = new ArrayList<String>();
        String queryString = "SELECT DISTINCT " + COLUMN_DONOR_NAME + " FROM " + TABLE_GIFT + " ORDER BY " +
                COLUMN_DONOR_NAME;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            String temp = c.getString(0);
            donors.add(temp);
        }
        c.close();
        db.close();
        return donors;
    }

    /**
     * Pulls all donors from the database associated with a gift
     * @return a list of donors who have donated as an ArrayList of Donor Objects ordered alphabetically
     */
    public ArrayList<NewItem> getNewEvents() {
        ArrayList<NewItem> events = new ArrayList<NewItem>();
        String queryString = "SELECT * FROM " + TABLE_NEW_EVENT + " ORDER BY " +
                COLUMN_DATE + " DESC";

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        Calendar date = Calendar.getInstance();
        long current = date.getTimeInMillis();


        // id, type, eventid, Name, content, date
        while (c.moveToNext()) {
            long eventDate = dateToLong(c.getString(5));

            //if items are older than 2 weeks, they will be removed
            //todo change to 2 weeks instead of 8
            if (current - eventDate < 8*6.048*Math.pow(10,8)){//6.048*Math.pow(10,8)){
                NewItem item = new NewItem();
                item.setId(c.getInt(0));
                item.setItemType(c.getString(1));
                item.setEventId(c.getInt(2));
                item.setHeader(c.getString(3));
                item.setContent(c.getString(4));
                item.setDate(c.getString(5).split(" ")[0]);
                events.add(item);
            }else{
                deleteNewEvent(c.getInt(0));
            }
        }
        c.close();
        db.close();
        return events;
    }

	/**
	 * Pulls all PrayedFor objects (updates and prayer requests) from the Prayed For table
	 * @return All Prayed for objects as an ArrayList
	 */
	public ArrayList<PrayedFor> getPrayedFor() {
		ArrayList<PrayedFor> prayedFor = new ArrayList<PrayedFor>();
		String queryString = "SELECT * FROM " + TABLE_PRAYED_FOR +" ORDER BY " + COLUMN_PRAYED_FOR_DATE + " DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			PrayedFor temp = new PrayedFor();
			temp.setPrayedForId(Integer.parseInt(c.getString(0)));
			temp.setPrayedForComments(c.getString(1));
			temp.setPrayedForDate(c.getString(2).split(" ")[0]);
			temp.setNoteID(Integer.parseInt(c.getString(3)));
			temp.setSupporterId(Integer.parseInt(c.getString(4)));
			temp.setSupporterName(c.getString(5));

			prayedFor.add(temp);
		}
		c.close();
		db.close();
		return prayedFor;

	}
	/**
	 * Pulls all notes (updates and prayer requests) from the Notes table for a missionary
	 * @param missionary_id id for the missionary
	 * @return All notes in the Notes table as an ArrayList of Notes Objects ordered from most recent to least recent
	 */
	public ArrayList<Note> getNotesForMissionary(int missionary_id) {
		ArrayList<Note> notes = new ArrayList<Note>();
		String queryString = "SELECT * FROM " + TABLE_NOTES + " WHERE " + COLUMN_MISSIONARY_ID + " = " + missionary_id +
				" ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Note temp = new Note();
			temp.setNoteId(Integer.parseInt(c.getString(0)));
			temp.setDate(c.getString(1).split(" ")[0]);
			temp.setNoteText(c.getString(2));
			temp.setSubject(c.getString(3));
			temp.setMissionaryName(c.getString(4));
			temp.setMissionaryID(c.getInt(5));
			temp.setType(c.getString(6));
			temp.setNumberPrayed(c.getInt(7));

			notes.add(temp);
		}
		c.close();
		db.close();
		return notes;

	}

	/**
	 * Pulls all notes (updates and prayer requests) from the Notes table
	 * @return All notes in the Notes table as an ArrayList of Notes Objects ordered from most recent to least recent
	 */
    public ArrayList<Note> getNotes() {
        ArrayList<Note> notes = new ArrayList<Note>();
        String queryString = "SELECT * FROM " + TABLE_NOTES +" ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while(c.moveToNext()){
            Note temp = new Note();
            temp.setNoteId(Integer.parseInt(c.getString(0)));
            temp.setDate(c.getString(1).split(" ")[0]);
            temp.setNoteText(c.getString(2));
            temp.setSubject(c.getString(3));
			temp.setMissionaryName(c.getString(4));
			temp.setMissionaryID(c.getInt(5));
			temp.setType(c.getString(6));
            temp.setNumberPrayed(c.getInt(7));

            notes.add(temp);
        }
		c.close();
        db.close();
        return notes;

    }


	/**
	 * Pulls a specific note from its ID
	 * @param note_id, Note Identification
	 * @return the specific note as a Note Object
	 */
	public Note getNoteForID(int note_id) {
		Note note = new Note();
		String queryString = "SELECT * FROM " + TABLE_NOTES +
				" WHERE " + COLUMN_ID + " = " + note_id;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			note.setNoteId(Integer.parseInt(c.getString(0)));
			note.setDate(c.getString(1).split(" ")[0]);
			note.setNoteText(c.getString(2));
			note.setSubject(c.getString(3));
			note.setMissionaryName(c.getString(4));
			note.setMissionaryID(c.getInt(5));
			note.setType(c.getString(6));
            note.setNumberPrayed(c.getInt(7));

		}
		c.close();
		db.close();
		return note;
	}

	/**
	 * Pulls all prayer letters from the database for missionary
	 * @param missionary_id id for missionary
	 * @return All prayer letters as an ArrayList of PrayerLetter Objects ordered from most recent to least recent
	 */
	public ArrayList<PrayerLetter> getPrayerLettersForMissionary(int missionary_id) {
		ArrayList<PrayerLetter> letterList = new ArrayList<PrayerLetter>();
		String queryString = "SELECT * FROM " + TABLE_LETTERS + " WHERE " + COLUMN_MISSIONARY_ID + " = " +
				missionary_id + " ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()) {
			//set PrayerLetter(id, Date, title, MissionaryName, folder, filename, missionaryId) {
			PrayerLetter temp = new PrayerLetter(Integer.parseInt(c.getString(0)), c.getString(1).split(" ")[0], c.getString(2),
					c.getString(3), c.getString(4), c.getString(5), c.getInt(6));
			letterList.add(temp);
		}
		c.close();
		db.close();
		return letterList;
	}

	/**
	 * Pulls all prayer letters from the database
	 * @return All prayer letters as an ArrayList of PrayerLetter Objects ordered from most recent to least recent
	 */
	public ArrayList<PrayerLetter> getPrayerLetters() {
		ArrayList<PrayerLetter> letterList = new ArrayList<PrayerLetter>();
		String queryString = "SELECT * FROM " + TABLE_LETTERS +" ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()) {
			//set PrayerLetter(id, Date, title, MissionaryName, folder, filename, missionaryId) {
			PrayerLetter temp = new PrayerLetter(Integer.parseInt(c.getString(0)), c.getString(1).split(" ")[0], c.getString(2),
					c.getString(3), c.getString(4), c.getString(5), c.getInt(6));

			letterList.add(temp);
		}
		c.close();
		db.close();
		return letterList;
	}

	/**
	 * pulls all notifications from the notifications table
	 * @return notifications as an ArrayList of UpdateNotification Objects
	 */
	public ArrayList<UpdateNotification> getNotifications() {
		ArrayList<UpdateNotification> notificationList = new ArrayList<UpdateNotification>();
		String queryString = "SELECT * FROM " + TABLE_NOTIFICATIONS;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			UpdateNotification temp = new UpdateNotification();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setTime(Long.parseLong(c.getString(1)));
			temp.setFrequency(c.getString(2));
			//todo: temp.setRequest_id(Integer.parseInt(c.getString(2)));

			notificationList.add(temp);
		}
		c.close();
		db.close();
		return notificationList;
	}

	/**
	 * Pulls all gifts from the gift table for a missionary's funds
	 * @return All gifts in the Gift table as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGifts(String fund_ids){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM "+ TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_FUND_DESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE " + TABLE_FUND + "." + COLUMN_ID + " IN (" + fund_ids + ") ORDER BY DATE("
				+ COLUMN_DATE + ") DESC";
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGiftFundDesc(c.getString(3));
			temp.setGiftAmount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGiftDate(c.getString(6).split(" ")[0]);
			temp.setGiftCheckNum(c.getString(7));
            temp.setGiftDonor(c.getString(8));
            temp.setGiftDonorId(c.getInt(9));

            gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
	}

	/**
	 * Pulls all gifts from the gift table that match the given donor id
	 * @param donor_id id for donor
	 * @return All gifts in the Gift table as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftsByDonor(int donor_id){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM " + TABLE_GIFT +
				" WHERE " + COLUMN_DONOR_ID + " = " + donor_id +
				" ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGiftFundDesc(c.getString(3));
			temp.setGiftAmount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGiftDate(c.getString(6).split(" ")[0]);
			temp.setGiftCheckNum(c.getString(7));
			temp.setGiftDonor(c.getString(8));
			temp.setGiftDonorId(c.getInt(9));

			gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
	}

	/**
	 * Pulls all gifts with correct fund id, and period
	 * @param fundId, Fund Identification
	 * @param period, period identification
	 * @param periodType, select which column to match period with
	 * @return an ArrayList of Gift Objects
	 */
	public ArrayList<Gift> getGiftsForPeriod(int fundId, String periodType, String period){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM "+ TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_FUND_DESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE (" + TABLE_FUND + "." + COLUMN_ID + " = " + fundId + " AND " + TABLE_GIFT + "." + periodType + " = '" + period + "') ORDER BY "
				+ COLUMN_YEAR + ", " + COLUMN_MONTH + " DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Gift gift = new Gift();
			gift.setId(Integer.parseInt(c.getString(0)));
			gift.setName(c.getString(1));
			gift.setGiftFund(c.getString(2));
			gift.setGiftFundDesc(c.getString(3));
			gift.setGiftAmount(new int []{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			gift.setGiftDate(c.getString(6).split(" ")[0]);
			gift.setGiftCheckNum(c.getString(7));
			gift.setGiftDonor(c.getString(8));
			gift.setGiftDonorId(c.getInt(9));

			gifts.add(gift);
		}
		c.close();
		db.close();
		return gifts;
	}


	/**
	 * Pulls a single gift with a specific ID
	 * @param id, Gift Identification
	 * @return gift with ID as a Gift Object
	 */
	public Gift getGift(int id, String name){
		Gift gift = new Gift();
        String queryString = "";
        if (name == null) {
            queryString = "SELECT * FROM " + TABLE_GIFT +
                    " WHERE " + COLUMN_ID + " = " + id;
        }else{
            queryString = "SELECT * FROM " + TABLE_GIFT +
                    " WHERE " + COLUMN_NAME + " = " + DatabaseUtils.sqlEscapeString(name);
        }
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		if(c.moveToFirst()){
			gift.setId(Integer.parseInt(c.getString(0)));
			gift.setName(c.getString(1));
			gift.setGiftFund(c.getString(2));
			gift.setGiftFundDesc(c.getString(3));
			gift.setGiftAmount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			gift.setGiftDate(c.getString(6).split(" ")[0]);
			gift.setGiftCheckNum(c.getString(7));
            gift.setGiftDonor(c.getString(8));
            gift.setGiftDonorId(c.getInt(9));
		}
		c.close();
		db.close();
		return gift;
	}

    /**
     * Pulls a single gift with a specific ID
     * @param id, Gift Identification
     * @return gift with ID as a Gift Object
     */
    public Gift getTransaction(int id, String name){
        Gift transaction = new Gift();
        String queryString = "";
        if (name == null) {
            queryString = "SELECT * FROM " + TABLE_GIFT +
                    " WHERE " + COLUMN_ID + " = " + id;
        }else{
            queryString = "SELECT * FROM " + TABLE_GIFT +
                    " WHERE " + COLUMN_NAME + " = " + name;
        }

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        if(c.moveToFirst()){
            transaction.setId(Integer.parseInt(c.getString(0)));
            transaction.setName(c.getString(1));
            transaction.setGiftFund(c.getString(2));
            transaction.setGiftFundDesc(c.getString(3));
            transaction.setGiftAmount(new int []{
                    Integer.parseInt(c.getString(4)),
                    Integer.parseInt(c.getString(5))
            });
            transaction.setGiftDate(c.getString(6).split(" ")[0]);
            transaction.setGiftDonor(c.getString(8));
            transaction.setGiftDonorId(c.getInt(9));
        }
        c.close();
        db.close();
        return transaction;
    }
	
	/**
	 * Pulls a list of gift names for a specific fund
	 * @param Fund_ID, Fund Identification
	 * @return Names of gifts for a fund in an ArrayList of Strings
	 */
	public ArrayList<String> getGiftNames(int Fund_ID){
		ArrayList<String> giftNames = new ArrayList<String>();
		String queryString = "SELECT " + TABLE_GIFT + "." + COLUMN_NAME + " FROM " + TABLE_GIFT + " INNER JOIN " + TABLE_FUND
                + " ON " + TABLE_GIFT + "." + COLUMN_FUND_DESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
                + " WHERE " + TABLE_FUND + "." + COLUMN_ID + " = " + Fund_ID;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			giftNames.add(c.getString(0));
		}
		c.close();
		db.close();
		return giftNames;
	}

    /**
     * Pulls a list of transaction names for a specific fund
     * @param Fund_ID, Fund Identification
     * @return Names of transactions for a fund in an ArrayList of Strings
     */
    public ArrayList<String> getTransactionNames(int Fund_ID){
        ArrayList<String> transactionNames = new ArrayList<String>();
        String queryString = "SELECT " + TABLE_TRANSACTION + "." + COLUMN_NAME + " FROM " + TABLE_TRANSACTION + " INNER JOIN " + TABLE_FUND
                + " ON " + TABLE_TRANSACTION + "." + COLUMN_FUND_DESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
                + " WHERE " + TABLE_FUND + "." + COLUMN_ID + " = " + Fund_ID;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while(c.moveToNext()){
            transactionNames.add(c.getString(0));
        }
        c.close();
        db.close();
        return transactionNames;
    }



    /**
	 * Pulls all gifts matching the parameters given for the search
	 * All null or empty parameters will be ignored in the search
	 * @param startDate, the specific date or beginning of date range in "YYYY-MM-DD HH:mm:ss" format
	 * @param endDate, the end of the date range in "YYYY-MM-DD HH:mm:ss" format
	 * @param startAmount, the specific amount or beginning of amount range
	 * @param endAmount, the end of the amount range
	 * @param donorName, the name of the donor
     * @param giftFund, the name of the fund
	 * @return all gifts that match the search parameters as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftSearchResults(String startDate, String endDate, String startAmount,
											String endAmount, String giftFund, String donorName){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String searchStatement = "SELECT * FROM " + TABLE_GIFT;
        startDate += " 00:00:00";
        endDate += " 23:59:59";

		// Build date portion of search statement
		if(!NullOrEmpty(startDate) && !NullOrEmpty(endDate)){
			searchStatement += " WHERE (" + COLUMN_DATE + " BETWEEN '" + startDate + "' AND '" + endDate + "')";
		}else if(!NullOrEmpty(startDate)){
			searchStatement += " WHERE (" + COLUMN_DATE + " = '" + startDate + "')";
		}

		// Build amount portion of search statement
		if(!NullOrEmpty(startAmount) && !NullOrEmpty(endAmount)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate)){
				searchStatement += " WHERE (" + COLUMN_GIFT_TOTAL_WHOLE + " BETWEEN " + startAmount + " AND " + endAmount + ")";
			}else{
				searchStatement += " AND (" + COLUMN_GIFT_TOTAL_WHOLE + " BETWEEN " + startAmount + " AND " + endAmount + ")";
			}
		}else if(!NullOrEmpty(startAmount)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate)){
				searchStatement += " WHERE (" + COLUMN_GIFT_TOTAL_WHOLE + " = " + startAmount + ")";
			}else{
				searchStatement += " AND (" + COLUMN_GIFT_TOTAL_WHOLE + " = " + startAmount + ")";
			}
		}

		// Build fund portion of search statement
		if(!NullOrEmpty(giftFund)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate) && NullOrEmpty(startAmount) && NullOrEmpty(endAmount)){
				searchStatement += " WHERE (" + COLUMN_FUND + " = '" + giftFund + "')";
			}else{
				searchStatement += " AND (" + COLUMN_FUND + " = '" + giftFund + "')";
			}
		}

        // Build fund portion of search statement
        if(!NullOrEmpty(donorName)){
            if(NullOrEmpty(startDate) && NullOrEmpty(endDate) && NullOrEmpty(startAmount) && NullOrEmpty(endAmount)
                    && NullOrEmpty(giftFund)){
                searchStatement += " WHERE (" + COLUMN_DONOR_NAME + " = '" + donorName + "')";
            }else{
                searchStatement += " AND (" + COLUMN_DONOR_NAME + " = '" + donorName + "')";
            }
        }

		// Order the resulting gifts by most recent to least recent
		searchStatement += " ORDER BY DATE(" + COLUMN_DATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(searchStatement, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGiftFundDesc(c.getString(3));
			temp.setGiftAmount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGiftDate(c.getString(6).split(" ")[0]);
			Log.w("BasicAuth", "The date is:" + c.getString(6));
			temp.setGiftCheckNum(c.getString(7));
            temp.setGiftDonor(c.getString(8));
            temp.setGiftDonorId(c.getInt(9));
			
			gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
	}

	/**
	 * Checks to see if the String is null or empty, used in constructing the gift search
	 * @param str, the String Object to be tested
	 * @return true if the String is null or empty(""), false if it is not null and has contents
	 */
	private boolean NullOrEmpty(String str) {
		return (str == null || str.equals(""));
	}

	//gets list of comments
	public ArrayList<Comment> getComments(){
		ArrayList<Comment> comments = new ArrayList<Comment>();
		String queryString = "SELECT * FROM " + TABLE_COMMENT + " ORDER BY " + COLUMN_DATE + " DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
            int commentId = c.getInt(0);
            int senderId = c.getInt(1);
            int noteId = c.getInt(2);
            String username = c.getString(3);
            String noteType = c.getString(4);
            String date = c.getString(5).split(" ")[0];
            String commentText = c.getString(6);

			comments.add(new Comment(commentId,senderId,noteId,username, noteType, date, commentText));
		}
		c.close();
		db.close();
		return comments;
	}

    //gets list of comments
    public Comment getCommentById(int id){
        Comment temp = new Comment();
        String queryString = "SELECT * FROM " + TABLE_COMMENT + " WHERE " + COLUMN_COMMENT_ID + " = " + id;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while(c.moveToNext()){
            int commentId = c.getInt(0);
            int senderId = c.getInt(1);
            int noteId = c.getInt(2);
            String username = c.getString(3);
            String noteType = c.getString(4);
            String date = c.getString(5).split(" ")[0];
            String commentText = c.getString(6);

            temp = new Comment(commentId,senderId,noteId,username, noteType, date, commentText);
        }
        c.close();
        db.close();
        return temp;
    }

    /**
     * 	gets the refresh period for the auto-updater
     * @return refresh period as a String
     */
	public String getRefreshPeriod(){
		ArrayList<String> refreshPeriods = new ArrayList<String>();
		String queryString = "SELECT *" + " FROM " + TABLE_REFRESH_PERIOD;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while (c.moveToNext()){
			refreshPeriods.add(c.getString(0));
		}

		c.close();
		db.close();
		if (refreshPeriods.size() > 0){
			return refreshPeriods.get(0);
		}
		else {
			return "Day";
		}
	}

    /**
     * gets the gift period for fund and gift displays
     * @return gift period as a string
     */
	public String getGiftPeriod(){
		ArrayList<String> giftPeriods = new ArrayList<String>();
		String queryString = "SELECT *" + " FROM " + TABLE_GIFT_PERIOD;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while (c.moveToNext()){
			giftPeriods.add(c.getString(0));
		}

		c.close();
		db.close();
		if (giftPeriods.size() > 0){
			return giftPeriods.get(0);
		}
		else {
			return "Year";
		}
	}

    /**
     * gets the JSON posts
     * @return ArrayList of Json posts
     */
	public ArrayList<JsonPost> getJsonPosts(){
		String queryString = "SELECT * FROM " + TABLE_JSON_POST;
		ArrayList<JsonPost> posts = new ArrayList<JsonPost>();

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while (c.moveToNext()){
			JsonPost jsonPost = new JsonPost(Long.parseLong(c.getString(0)), c.getString(1), c.getString(2), Integer.parseInt(c.getString(3)));
			posts.add(jsonPost);
		}

		c.close();
		db.close();

		return posts;
	}

	/* ************************* Update Queries ************************* */

	/**
	 * Updates the timestamp from the originalDate (in milli) to currentDate (in milli)
	 * @param originalDate, date (in milliseconds) of database timestamp before update
	 * @param currentDate, date (in milliseconds) to update the timestamp to
	 */
	public void updateTimeStamp(String originalDate, String currentDate){
		ContentValues values = new ContentValues();
		values.put(COLUMN_DATE, currentDate);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_TIMESTAMP, values, COLUMN_DATE + " = " + originalDate, null);
		db.close();
	}
	
	/**
	 * Allows the user to make changes to existing accounts in the database
	 * @param acceptSSC, whether user allows app to connect to server with self-signed SSL certificate
	 */
	public void updateAcceptSSCert(int acceptSSC){
		ContentValues values = new ContentValues();
		values.put(COLUMN_ACCEPT_SSC, acceptSSC);

        SQLiteDatabase db = this.getWritableDatabase();
        db.update(TABLE_ACCOUNTS, values, null, null);
		db.close();
	}

	/**
	 * Updates the partner name for the given account
	 * @param account_id, ID of account to be updated
	 * @param name, new partner name for the account
	 */
	public void updatePartnerNameForAccount(int account_id, String name) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_PARTNER_NAME, name);

		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_ACCOUNTS, values, COLUMN_ID + " = " + account_id, null);
		db.close();
	}

	/**
	 * Updates a specific note to set whether or not it has been prayed for
	 * @param id, id of note to be update
	 * @param numPrayedFor, boolean value to update whether the note has been prayed for or not
	 */
	public void updateNote(int id, int numPrayedFor) {
		ContentValues values = new ContentValues();
        values.put(COLUMN_PRAYED_FOR_NUM, numPrayedFor);


		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_NOTES, values, COLUMN_ID + " = " + id, null);
		db.close();
	}

	private long dateToLong(String dateString){
        Calendar date = Calendar.getInstance();

        String[] dateParts = dateString.split(" ");
        String[] datePartsDay = dateParts[0].split("-");
        date.set(Calendar.YEAR, Integer.parseInt(datePartsDay[0]));
        date.set(Calendar.MONTH, Integer.parseInt(datePartsDay[1])-1);
        date.set(Calendar.DAY_OF_MONTH, Integer.parseInt(datePartsDay[2]));
        String[] datePartsTime = dateParts[1].split(":");
        date.set(Calendar.HOUR_OF_DAY, Integer.parseInt(datePartsTime[0]));
        date.set(Calendar.MINUTE, Integer.parseInt(datePartsTime[1]));
        date.set(Calendar.SECOND, Integer.parseInt(datePartsTime[2]));

        return date.getTimeInMillis();
    }

}