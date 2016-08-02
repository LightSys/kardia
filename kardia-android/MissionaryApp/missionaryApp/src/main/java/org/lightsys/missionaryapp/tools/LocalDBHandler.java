package org.lightsys.missionaryapp.tools;

import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.lightsys.missionaryapp.data.Account;
import org.lightsys.missionaryapp.data.Comment;
import org.lightsys.missionaryapp.data.ContactInfo;
import org.lightsys.missionaryapp.data.Donor;
import org.lightsys.missionaryapp.data.Fund;
import org.lightsys.missionaryapp.data.Gift;
import org.lightsys.missionaryapp.data.JsonPost;
import org.lightsys.missionaryapp.data.NewItem;
import org.lightsys.missionaryapp.data.Note;
import org.lightsys.missionaryapp.data.Period;
import org.lightsys.missionaryapp.data.PrayedFor;
import org.lightsys.missionaryapp.data.PrayerLetter;
import org.lightsys.missionaryapp.data.PrayerNotification;

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
 *   Each table typically has at least a getObjects() which returns an array of all known elements, and an addObject(Object o) which adds the element(try to keep each element unique)
 *
 * Edited by Judah Sistrunk on 6/2/2016
 * 	added information relevent to the auto-updater
 *
 */
public class LocalDBHandler extends SQLiteOpenHelper {

	private Account activeaccount;

	private static final int DATABASE_VERSION = 11;
	private static final String DATABASE_NAME = "missionary.db";
	//ACCOUNT TABLE
	private static final String TABLE_ACCOUNTS = "accounts";
	private static final String COLUMN_ID = "id";
	private static final String COLUMN_ACCOUNTNAME = "accountName";
	private static final String COLUMN_ACCOUNTPASSWORD = "accountPassword";
	private static final String COLUMN_SERVERNAME = "serverName";
	private static final String COLUMN_PARTNER_NAME = "partnerName";
	//FUND TABLE
	private static final String TABLE_FUND = "funds";
	private static final String COLUMN_NAME = "name";
	private static final String COLUMN_FUND_DESC = "fund_desc";
	private static final String COLUMN_FUND_CLASS = "fund_class";
	private static final String COLUMN_ANNOTATION = "annotation";
	private static final String COLUMN_GIFTTOTALPART = "gift_total_part";
	private static final String COLUMN_GIFTTOTALWHOLE = "gift_total_whole";
	//GIFT TABLE
	private static final String TABLE_GIFT = "gifts";
	private static final String COLUMN_GIFTFUND = "gift_fund";
	private static final String COLUMN_GIFTFUNDDESC = "gift_fund_desc";
	private static final String COLUMN_GIFTDATE = "gift_date";
	private static final String COLUMN_CHECKNUM = "gift_check_num";
    private static final String COLUMN_DONOR_NAME = "donor_name";
    private static final String COLUMN_DONOR_ID = "donor_id";
	private static final String COLUMN_GIFTYEAR = "Year";
	private static final String COLUMN_GIFTMONTH = "Month";
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
	//CONTACT TABLE
	private static final String TABLE_CONTACT_INFO = "contact_info";
	private static final String COLUMN_EMAIL = "email";
	private static final String COLUMN_PHONE = "phone";
	private static final String COLUMN_CELL = "cell";
	//NOTIFICATIONS TABLE
	private static final String TABLE_NOTIFICATIONS = "notifications";
	private static final String COLUMN_NOTIFY_TIME = "notification_time";
	private static final String COLUMN_REQUEST_ID = "request_id";
	//DONOR TABLE
	private static final String TABLE_DONORS = "donors";
    private static final String COLUMN_LASTNAME = "lastname";
	//MISSIONARY TABLE
	private static final String TABLE_MISSIONARIES = "missionaries";

	private static final String COLUMN_FUND_ID = "fund_id";

	private static final String COLUMN_GIFT_ID = "gift_id";
	//FUND_ACCOUNT_MAP
	private static final String TABLE_FUNDACCOUNT_MAP = "fund_account_map";
	private static final String COLUMN_ACCOUNT_ID = "account_id";
	//GIFT_ACCOUNT_MAP
	private static final String TABLE_GIFTACCOUNT_MAP = "gift_account_map";
	//Time_Stamp
	private static final String TABLE_TIMESTAMP = "timestamp";
	private static final String COLUMN_DATE = "date";
	//comment table
	private static final String TABLE_COMMENT = "comment";
	private static final String COLUMN_COMMENT_ID = "comment_id";
	private static final String COLUMN_SENDER_ID = "sender_id";
	private static final String COLUMN_USER_NAME = "userName";
	private static final String COLUMN_NOTE_ID = "note_id";
	private static final String COLUMN_NOTE_TYPE = "note_type";
	private static final String COLUMN_COMMENT_TEXT = "comment_text";
	//new item table
	private static final String TABLE_NEW_ITEM = "new_item";
	private static final String COLUMN_NEW_ITEM_DATE = "new_item_date";
	private static final String COLUMN_MESSAGE = "message";
	//REFRESH_PERIOD
	//not really a table, but a variable that needs to be accessed from multiple locations
	private static final String TABLE_REFRESH_PERIOD = "refresh_period";
	private static final String COLUMN_REFRESH = "refresh";
	//GIFT_PERIOD
	private static final String TABLE_GIFT_PERIOD = "gift_period";
	private static final String COLUMN_PERIOD = "period";
	//json Posts
	private static final String TABLE_JSON_POST = "json_post";
	private static final String COLUMN_JSON_ID = "id";
	private static final String COLUMN_JSON_STRING = "json_string";
	private static final String COLUMN_JSON_URL = "json_url";
	//Table for Prayed for Posts
	private static final String TABLE_PRAYED_FOR = "prayed_for";
	private static final String COLUMN_PRAYED_FOR_COMMENTS = "prayedfor_comments";
	private static final String COLUMN_PRAYED_FOR_ID = "prayedfor_id";
	private static final String COLUMN_PRAYED_FOR_DATE = "prayedfor_date";
	private static final String COLUMN_SUPPORTER_PARTNER_ID = "supporter_partner_id";
	private static final String COLUMN_SUPPORTER_PARTNER_NAME = "supporter_partner_name";
	//Table for Time Periods
	private static final String TABLE_PERIOD = "period";
	
	/* ************************* Creation of Database and Tables ************************* */

	/**
	 * Creates an instance of the database
	 */
	public LocalDBHandler(Context context, CursorFactory factory) {
		super(context, DATABASE_NAME, factory, DATABASE_VERSION);
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
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_ACCOUNTNAME
				+ " TEXT," + COLUMN_ACCOUNTPASSWORD + " TEXT,"
				+ COLUMN_SERVERNAME + " TEXT," + COLUMN_PARTNER_NAME + " TEXT)";
		db.execSQL(CREATE_ACCOUNTS_TABLE);

		String CREATE_MISSIONARY_TABLE = "CREATE TABLE " + TABLE_MISSIONARIES + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT)";
		db.execSQL(CREATE_MISSIONARY_TABLE);

		String CREATE_DONOR_TABLE = "CREATE TABLE " + TABLE_DONORS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," + COLUMN_LASTNAME + " TEXT)";
		db.execSQL(CREATE_DONOR_TABLE);

		String CREATE_NOTES_TABLE = "CREATE TABLE " + TABLE_NOTES + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TEXT + " TEXT," + COLUMN_SUBJECT + " TEXT,"
				+ COLUMN_MISSIONARY_NAME + " TEXT," + COLUMN_MISSIONARY_ID + " INTEGER,"
				+ COLUMN_TYPE + " TEXT," + COLUMN_PRAYED_FOR_NUM + " INTEGER)";
		db.execSQL(CREATE_NOTES_TABLE);

		String CREATE_CONTACT_INFO_TABLE = "CREATE TABLE " + TABLE_CONTACT_INFO + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_EMAIL + " TEXT," +
				COLUMN_PHONE + " TEXT," + COLUMN_CELL + " TEXT)";
		db.execSQL(CREATE_CONTACT_INFO_TABLE);

		String CREATE_LETTERS_TABLE = "CREATE TABLE " + TABLE_LETTERS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TITLE + " TEXT," + COLUMN_MISSIONARY_NAME + " TEXT,"
				+ COLUMN_FOLDER + " TEXT," + COLUMN_FILENAME + " TEXT)";
		db.execSQL(CREATE_LETTERS_TABLE);

		String CREATE_NOTIFICATIONS_TABLE = "CREATE TABLE " + TABLE_NOTIFICATIONS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NOTIFY_TIME + " TEXT,"
				+ COLUMN_REQUEST_ID + " TEXT)";
		db.execSQL(CREATE_NOTIFICATIONS_TABLE);

		String CREATE_FUND_TABLE = "CREATE TABLE " + TABLE_FUND + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_MISSIONARY_ID + " INTEGER, " +
                COLUMN_NAME + " TEXT," +
				COLUMN_FUND_DESC + " TEXT," +
				COLUMN_FUND_CLASS + " TEXT," + COLUMN_ANNOTATION + " TEXT)";
		db.execSQL(CREATE_FUND_TABLE);

		String CREATE_GIFT_TABLE = "CREATE TABLE " + TABLE_GIFT + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
				+ " TEXT," + COLUMN_GIFTFUND + " TEXT,"
				+ COLUMN_GIFTFUNDDESC + " TEXT," + COLUMN_GIFTTOTALWHOLE
				+ " INTEGER," + COLUMN_GIFTTOTALPART + " INTEGER,"
				+ COLUMN_GIFTDATE + " TEXT," + COLUMN_CHECKNUM + " TEXT,"
                + COLUMN_DONOR_NAME + " TEXT," + COLUMN_DONOR_ID + " INTEGER," + COLUMN_GIFTYEAR + " TEXT,"
				+ COLUMN_GIFTMONTH + " TEXT)";
		db.execSQL(CREATE_GIFT_TABLE);

		String CREATE_PERIOD_TABLE = "CREATE TABLE " + TABLE_PERIOD + "(" +
				COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT," +
				COLUMN_DATE + " TEXT)";
		db.execSQL(CREATE_PERIOD_TABLE);

		String CREATE_FUNDACCOUNT_MAP_TABLE = "CREATE TABLE " + TABLE_FUNDACCOUNT_MAP
				+ "(" + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_FUND_ID
				+ " INTEGER," + COLUMN_ACCOUNT_ID + " INTEGER)";
		db.execSQL(CREATE_FUNDACCOUNT_MAP_TABLE);

		String CREATE_GIFTACCOUNT_MAP_TABLE = "CREATE TABLE " + TABLE_GIFTACCOUNT_MAP
				+ "(" + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_GIFT_ID
				+ " INTEGER," + COLUMN_ACCOUNT_ID + " INTEGER)";
		db.execSQL(CREATE_GIFTACCOUNT_MAP_TABLE);

		String CREATE_COMMENT_TABLE = "CREATE TABLE " + TABLE_COMMENT
				+ "(" + COLUMN_COMMENT_ID + " INTEGER PRIMARY KEY,"
				+ COLUMN_SENDER_ID + " INTEGER,"
				+ COLUMN_NOTE_ID + " INTEGER,"
				+ COLUMN_USER_NAME + " TEXT,"
				+ COLUMN_NOTE_TYPE + " TEXT,"
				+ COLUMN_DATE + " TEXT,"
				+ COLUMN_COMMENT_TEXT + " TEXT)";
		db.execSQL(CREATE_COMMENT_TABLE);

		String CREATE_NEW_ITEM_TABLE = "CREATE TABLE " + TABLE_NEW_ITEM
				+ "(" + COLUMN_NEW_ITEM_DATE + " TEXT," + COLUMN_TYPE
				+ " TEXT," + COLUMN_MESSAGE + " TEXT)";
		db.execSQL(CREATE_NEW_ITEM_TABLE);

		String CREATE_REFRESH_PERIOD_TABLE = "CREATE TABLE " + TABLE_REFRESH_PERIOD
				+ "(" + COLUMN_REFRESH + " TEXT PRIMARY KEY)";
		db.execSQL(CREATE_REFRESH_PERIOD_TABLE);

		String CREATE_GIFT_PERIOD_TABLE = "CREATE TABLE " + TABLE_GIFT_PERIOD
				+ "(" + COLUMN_PERIOD + " TEXT PRIMARY KEY)";
		db.execSQL(CREATE_GIFT_PERIOD_TABLE);

		String CREATE_JSON_POST_TABLE = "CREATE TABLE " + TABLE_JSON_POST
				+ "(" + COLUMN_JSON_ID + " INTEGER PRIMARY KEY, "
				+ COLUMN_JSON_URL + " TEXT, "
				+ COLUMN_JSON_STRING + " TEXT, "
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
	 * Adds an account to the row of the database.
	 * @param account, uses an Account object to retrieve needed data
	 */
	public void addAccount(Account account){
		deleteAccountTable();
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, account.getId());
		values.put(COLUMN_ACCOUNTNAME, account.getAccountName());
		values.put(COLUMN_ACCOUNTPASSWORD, account.getAccountPassword());
		values.put(COLUMN_SERVERNAME, account.getServerName());
		values.put(COLUMN_PARTNER_NAME, account.getPartnerName());
		values.put(COLUMN_PARTNER_NAME, account.getActive());

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_ACCOUNTS, null, values);
		db.close();
	}

    /**
     * Adds a donor to the database
     *
     * @param donor, the Donor Object to be added
     */
    public void addDonor(Donor donor) {
        ContentValues values = new ContentValues();
        String name=donor.getName();
        values.put(COLUMN_ID, donor.getId());
        values.put(COLUMN_NAME, name);
        values.put(COLUMN_LASTNAME, name.substring(name.indexOf(" ")+1));

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_DONORS, null, values);
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
     * Adds contact info to the database in the Contact Info Table
     *
     * @param contactinfo, the contact info to be added
     */
    public void addContactInfo(ContactInfo contactinfo) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_ID, contactinfo.getPartnerId());
        values.put(COLUMN_EMAIL, contactinfo.getEmail());
        values.put(COLUMN_PHONE, contactinfo.getPhone());
        values.put(COLUMN_CELL, contactinfo.getCell());

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_CONTACT_INFO, null, values);
        db.close();
    }

	/**
	 * Adds a prayer for item to the database in the PRAYED FOR TABLE
	 * @param prayedfor, the item to be added
	 */
	public void addPrayedFor(PrayedFor prayedfor) {
        ContentValues values = new ContentValues();

        values.put(COLUMN_PRAYED_FOR_ID, prayedfor.getPrayedForId());
        values.put(COLUMN_PRAYED_FOR_COMMENTS, prayedfor.getPrayedForComments());
        values.put(COLUMN_PRAYED_FOR_DATE, prayedfor.getPrayedForDate());
        values.put(COLUMN_NOTE_ID, prayedfor.getNoteId());
        values.put(COLUMN_SUPPORTER_PARTNER_ID, prayedfor.getSupporterId());
        values.put(COLUMN_SUPPORTER_PARTNER_NAME, prayedfor.getSupporterName());

        SQLiteDatabase db = this.getWritableDatabase();
        db.insert(TABLE_PRAYED_FOR, null, values);
        db.close();
    }

	/**
	 * Adds a prayer letter to the database in the Letter Table
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

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_LETTERS, null, values);
		db.close();
	}

	/**
	 * Adds a prayer notification to the database
	 * @param notification, notification to be stored
	 */
	public void addNotification(PrayerNotification notification) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, notification.getId());
		values.put(COLUMN_NOTIFY_TIME, Long.toString(notification.getNotificationTime()));
		values.put(COLUMN_REQUEST_ID, Integer.toString(notification.getRequestID()));

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_NOTIFICATIONS, null, values);
		db.close();
	}

	/**
	 * Adds a fund to the Fund table in the database
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
	 * Adds a gift to the Gift table in the database
	 * @param gift, gift to be stored
	 */
	public void addGift(Gift gift){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, gift.getName());
		values.put(COLUMN_GIFTFUND, gift.getGiftFund());
		values.put(COLUMN_GIFTFUNDDESC, gift.getGift_fund_desc());
		values.put(COLUMN_GIFTTOTALWHOLE, gift.getGift_amount()[0]);
		values.put(COLUMN_GIFTTOTALPART, gift.getGift_amount()[1]);
		values.put(COLUMN_GIFTDATE, gift.getGift_date());
		values.put(COLUMN_CHECKNUM, gift.getGift_check_num());
        values.put(COLUMN_DONOR_NAME, gift.getGiftDonor());
        values.put(COLUMN_DONOR_ID, gift.getGiftDonorId());
		values.put(COLUMN_GIFTYEAR, gift.getGiftYear());
		values.put(COLUMN_GIFTMONTH, gift.getGiftMonth());


		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFT, null, values);
		db.close();
	}

	/**
	 * Adds a connection between a fund and a account through their IDs
	 * @param Gift_ID, Gift Identifier
	 * @param Account_ID, Account Identifier
	 */
	public void addGift_Account(int Gift_ID, int Account_ID){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFT_ID, Gift_ID);
		values.put(COLUMN_ACCOUNT_ID, Account_ID);

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFTACCOUNT_MAP, null, values);
		db.close();
	}

	//ads comment
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

	//adds new notification item
	public void addNew_Item (String date, String type, String message) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_NEW_ITEM_DATE, date);
		values.put(COLUMN_TYPE, type);
		values.put(COLUMN_MESSAGE, message);

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_NEW_ITEM, null, values);
		db.close();
	}

	//sets the current refresh period
	public void addRefresh_Period (String period){
		deleteRefreshPeriod();

		ContentValues values = new ContentValues();
		values.put(COLUMN_REFRESH, period);

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_REFRESH_PERIOD, null, values);
		db.close();
	}
	//sets the current gift period
	public void addGiftPeriod (String period){
		deleteGiftPeriod();

		ContentValues values = new ContentValues();
		values.put(COLUMN_PERIOD, period);

		SQLiteDatabase db = this.getReadableDatabase();
		db.insert(TABLE_GIFT_PERIOD, null, values);
		db.close();
	}

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
	 * @param Account_ID, Account to be deleted
	 */
	public void deleteAccount(int Account_ID){
		
		String[] acct = {String.valueOf(Account_ID)};
		SQLiteDatabase db = this.getWritableDatabase();

		//delete gifts
		db.delete(TABLE_GIFT, TABLE_GIFT + "." + COLUMN_ID 
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete giftaccount connections
		db.delete(TABLE_GIFTACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete funds
		db.delete(TABLE_FUND, TABLE_FUND + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete fundaccount connections
		db.delete(TABLE_FUNDACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete missionaries and all notes, prayer letters, and prayer notifications
		db.delete(TABLE_MISSIONARIES, null, null);
		db.delete(TABLE_NOTES, null, null);
		db.delete(TABLE_LETTERS, null, null);
		db.delete(TABLE_NOTIFICATIONS, null, null);
		
		//delete account
		db.delete(TABLE_ACCOUNTS, COLUMN_ID + " = ?", acct);
		
		db.close();
	}

	public void deleteAccountTable(){
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_ACCOUNTS,null,null);
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
	}

	/**
	 * deletes the gifts from the database
	 * this is to solve a bug with the database not updating properly
	 * when data was removed from the server, the local DB wouldn't remove that data
	 * this clears the gifts before pulling from the server
	 * this should be used before pulling data from the server
	 * created by Judah Sistrunk on May 5, 2016
	 */
	public void deleteGifts(int Account_ID) {
		String[] acct = {String.valueOf(Account_ID)};
		SQLiteDatabase db = this.getWritableDatabase();

		//delete gifts
		db.delete(TABLE_GIFT, TABLE_GIFT + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete giftaccount connections
		db.delete(TABLE_GIFTACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete funds
		db.delete(TABLE_FUND, TABLE_FUND + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete fundaccount connections
		db.delete(TABLE_FUNDACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		db.close();
	}

	//delete note
	public void deleteNote(Note note){
		String[] acct = {String.valueOf(note.getNoteId())};
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_NOTES, COLUMN_ID + " = ?", acct);
		db.close();
	}

	//delete comment
	public void deleteComment(Comment comment){
		String[] acct = {String.valueOf(comment.getCommentID())};
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_COMMENT, COLUMN_COMMENT_ID + " = ?", acct);
		db.close();
	}

	public void deleteJsonPost(long jsonId){
		String[] json = {String.valueOf(jsonId)};
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_JSON_POST, COLUMN_JSON_ID + " = ?", json);
	}

	//deletes new items table
	public void deleteNewItems() {
		SQLiteDatabase db = this.getWritableDatabase();
		db.delete(TABLE_NEW_ITEM, null, null);
		db.close();
	}

	//deletes the period of refresh for the auto-updater
	public void deleteRefreshPeriod(){
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_REFRESH_PERIOD, null, null);
		db.close();
	}

	//deletes the period of refresh for the auto-updater
	public void deleteGiftPeriod(){
		SQLiteDatabase db = this.getReadableDatabase();
		db.delete(TABLE_GIFT_PERIOD, null, null);
		db.close();
	}

	/* ************************* Get Queries ************************* */

	/**
	 * Pulls the timestamp from the database
	 * @return A timestamp of the last update in millisecond form
	 */
	public long getTimeStamp(){
		String queryString = "SELECT " + COLUMN_DATE + " FROM " + TABLE_TIMESTAMP;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		long date = -1;
		
		if(c.moveToFirst()){
			date = Long.parseLong(c.getString(0));
		}
		c.close();
		db.close();
		return date;
	}
	//return all periods for all gifts
	public ArrayList<Period> getFundPeriods(String periodtype) {
		ArrayList<Period> periods = new ArrayList<Period>();


		String qString = "SELECT DISTINCT " + periodtype + " FROM " + TABLE_GIFT;

		SQLiteDatabase db = this.getReadableDatabase();

		Cursor c = db.rawQuery(qString, null);

		while (c.moveToNext()) {
            Period temp = new Period();
			temp.setPeriodName(c.getString(0));

            periods.add(temp);
		}
		db.close();
		c.close();
		return periods;
	}

	//return all periods for the gifts in a fund
	public ArrayList<Period> getFundPeriods(int fund_id, String periodtype) {
		ArrayList<Period> periods = new ArrayList<Period>();


		String qString = "SELECT DISTINCT " + periodtype + " FROM " + TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_GIFTFUNDDESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE " + TABLE_FUND + "." + COLUMN_ID + " = " + fund_id;

		SQLiteDatabase db = this.getReadableDatabase();

		Cursor c = db.rawQuery(qString, null);

		while (c.moveToNext()) {
            Period temp = new Period();
            temp.setPeriodName(c.getString(0));
            ArrayList<Gift> gifts = getGiftsForPeriod(fund_id, periodtype, c.getString(0));
            int Total[]= new int[2];
            for(Gift g:gifts){
                Total[0] += g.getGift_amount()[0];
                Total[1] += g.getGift_amount()[1];
            }
            if (Total[1]>=100){
               Total[0]+=Math.floor(Total[1]/100);
                Total[1]-=Math.floor(Total[1]/100)*100;
            }
            temp.setGiftTotal(Total);

			periods.add(temp);
		}
		db.close();
		c.close();
		return periods;
	}
	//return current period for the fund
	public Period getFundPeriodToDate(int fund_id, String periodtype, String period) {
		Period currentperiod = new Period();


		String qString = "SELECT DISTINCT " + periodtype + " FROM " + TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_GIFTFUNDDESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE (" + TABLE_FUND + "." + COLUMN_ID + " = " + fund_id + " AND " + TABLE_GIFT + "." + periodtype + " = " + period + ")";

		SQLiteDatabase db = this.getReadableDatabase();

		Cursor c = db.rawQuery(qString, null);

		if (c.moveToFirst()) {
			currentperiod.setPeriodName(c.getString(0));
			ArrayList<Gift> gifts = getGiftsForPeriod(fund_id, periodtype, c.getString(0));
			int Total[]= new int[2];
			for(Gift g:gifts){
				Total[0] += g.getGift_amount()[0];
				Total[1] += g.getGift_amount()[1];
			}
			if (Total[1]>=100){
				Total[0]+=Math.floor(Total[1]/100);
				Total[1]-=Math.floor(Total[1]/100)*100;
			}
			currentperiod.setGiftTotal(Total);
		}
		db.close();
		c.close();
		return currentperiod;
	}
	/**
	 * Pulls all accounts
	 * @return All accounts in the Account table as an ArrayList of Account Objects
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
		}else {
			temp=null;
		}
		c.close();
		db.close();
		return temp;
	}

	/**
	 * Pulls all accounts
	 * @return All accounts in the Account table as an ArrayList of Account Objects
	 */
	public ArrayList<Account> getAccounts(){
		ArrayList<Account> accounts = new ArrayList<Account>();
		String queryString = "SELECT * FROM " + TABLE_ACCOUNTS;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Account temp = new Account();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setAccountName(c.getString(1));
			temp.setAccountPassword(c.getString(2));
			temp.setServerName(c.getString(3));
			temp.setPartnerName(c.getString(4));

			accounts.add(temp);
		}
		c.close();
		db.close();
		return accounts;
	}
	
	/**
	 * Pulls a specific fund from an ID
	 * @param fund_id, id of fund to retrieve
	 * @return fund with the id of fund_id
	 */
    public Fund getFundByFundId(int fund_id) {
        Fund fund = new Fund();

        String qString = "SELECT * FROM " + TABLE_FUND + " WHERE "
                + COLUMN_ID + " = " + fund_id;

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
	 */
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
		
	}
	
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
                COLUMN_LASTNAME;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            Donor temp = new Donor();
            temp.setId(Integer.parseInt(c.getString(0)));
            temp.setName(c.getString(1));

            donors.add(temp);
        }
        c.close();
        db.close();
        return donors;
    }

    /**
     * Pulls contact info for a donor from the database
     * @param donor_id
     * @return contact info for donor id
     */

    public ContactInfo getContactInfoById(int donor_id) {
        String queryString = "SELECT * FROM " + TABLE_CONTACT_INFO
                + " WHERE " + COLUMN_ID + " = " + donor_id;

        ContactInfo contact = new ContactInfo();
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        if (c.moveToFirst()) {
            contact.setPartnerId(Integer.parseInt(c.getString(0)));
            contact.setEmail(c.getString(1));
            contact.setPhone(c.getString(2));
            contact.setCell(c.getString(3));

        }
        c.close();
        db.close();
        return contact;
    }

    /**
	 * Pulls a specific missionary from the database
	 * @param missionaryID, the ID for the missionary to be pulled
	 * @return the specified missionary as a Donor Object
	 */
	public Donor getMissionaryForID(int missionaryID) {
		Donor donor = new Donor();
		String queryString = "SELECT * FROM " + TABLE_MISSIONARIES +
				" WHERE " + COLUMN_ID + " = " + missionaryID;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			donor.setId(Integer.parseInt(c.getString(0)));
			donor.setName(c.getString(1));
		}
		c.close();
		db.close();
		return donor;
	}

	/**
	 * Pulls all notes (updates and prayer requests) from the Notes table
	 * @return All notes in the Notes table as an ArrayList of Notes Objects ordered from most recent to least recent
	 */
	public ArrayList<PrayedFor> getPrayedFor() {
		ArrayList<PrayedFor> prayedfor = new ArrayList<PrayedFor>();
		String queryString = "SELECT * FROM " + TABLE_PRAYED_FOR +" ORDER BY " + COLUMN_PRAYED_FOR_ID;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			PrayedFor temp = new PrayedFor();
			temp.setPrayedForId(Integer.parseInt(c.getString(0)));
			temp.setPrayedForComments(c.getString(1));
			temp.setPrayedForDate(c.getString(2));
			temp.setNoteId(Integer.parseInt(c.getString(3)));
			temp.setSupporterId(Integer.parseInt(c.getString(4)));
			temp.setSupporterName(c.getString(5));

			prayedfor.add(temp);
		}
		c.close();
		db.close();
		return prayedfor;

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
            temp.setDate(c.getString(1));
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
			note.setDate(c.getString(1));
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
     * Pulls contact info for all donors from the database
     * @return contact info as an ArrayList of ContactInfo Objects ordered by donor id
     */

    public ArrayList<ContactInfo> getContactInfo() {
        ArrayList<ContactInfo> contactInfoList = new ArrayList<ContactInfo>();
        String queryString = "SELECT * FROM " + TABLE_CONTACT_INFO + " ORDER BY " + COLUMN_ID;

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while (c.moveToNext()) {
            ContactInfo temp = new ContactInfo();
            temp.setPartnerId(Integer.parseInt(c.getString(0)));
            temp.setEmail(c.getString(1));
            temp.setPhone(c.getString(2));
			temp.setCell(c.getString(3));

            contactInfoList.add(temp);
        }
        c.close();
        db.close();
        return contactInfoList;
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
			PrayerLetter temp = new PrayerLetter();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setDate(c.getString(1));
			temp.setTitle(c.getString(2));
			temp.setMissionaryName(c.getString(3));
			temp.setFolder(c.getString(4));
			temp.setFilename(c.getString(5));

			letterList.add(temp);
		}
		c.close();
		db.close();
		return letterList;
	}

	/**
	 * pulls all notifications from the notifications table
	 * @return notifications as an ArrayList of PrayerNotification Objects
	 */
	public ArrayList<PrayerNotification> getNotifications() {
		ArrayList<PrayerNotification> notificationList = new ArrayList<PrayerNotification>();
		String queryString = "SELECT * FROM " + TABLE_NOTIFICATIONS;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			PrayerNotification temp = new PrayerNotification();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setNotificationTime(Long.parseLong(c.getString(1)));
			temp.setRequest_id(Integer.parseInt(c.getString(2)));

			notificationList.add(temp);
		}
		c.close();
		db.close();
		return notificationList;
	}

	/**
	 * Pulls all gifts from the gift table
	 * @return All gifts in the Gift table as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGifts(){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM " + TABLE_GIFT
				+ " ORDER BY DATE(" + COLUMN_GIFTDATE + ") DESC";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
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
	 * @param donor_id
	 * @return All gifts in the Gift table as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftsByDonor(int donor_id){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM " + TABLE_GIFT +
				" WHERE " + COLUMN_DONOR_ID + " = " + donor_id +
				" ORDER BY DATE(" + COLUMN_GIFTDATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
			temp.setGiftDonor(c.getString(8));
			temp.setGiftDonorId(c.getInt(9));

			gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
	}

	/**
	 * Pulls a single gift with a specific ID
	 * @param fund_id, Fund Identification
	 * @param period, period identification
	 * @param periodtype, select which column to match period with
	 * @return an arraylist of Gift Objects
	 */
	public ArrayList<Gift> getGiftsForPeriod(int fund_id, String periodtype, String period){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM "+ TABLE_GIFT + " INNER JOIN " + TABLE_FUND
				+ " ON " + TABLE_GIFT + "." + COLUMN_GIFTFUNDDESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
				+ " WHERE (" + TABLE_FUND + "." + COLUMN_ID + " = " + fund_id + " AND " + periodtype + " = " + period + ")";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Gift gift = new Gift();
			gift.setId(Integer.parseInt(c.getString(0)));
			gift.setName(c.getString(1));
			gift.setGiftFund(c.getString(2));
			gift.setGift_fund_desc(c.getString(3));
			gift.setGift_amount(new int []{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			gift.setGift_date(c.getString(6));
			gift.setGift_check_num(c.getString(7));
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
	public Gift getGift(int id){
		Gift gift = new Gift();
		String queryString = "SELECT * FROM " + TABLE_GIFT + 
				" WHERE " + COLUMN_ID + " = " + id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		if(c.moveToFirst()){
			gift.setId(Integer.parseInt(c.getString(0)));
			gift.setName(c.getString(1));
			gift.setGiftFund(c.getString(2));
			gift.setGift_fund_desc(c.getString(3));
			gift.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			gift.setGift_date(c.getString(6));
			gift.setGift_check_num(c.getString(7));
            gift.setGiftDonor(c.getString(8));
            gift.setGiftDonorId(c.getInt(9));
		}
		c.close();
		db.close();
		return gift;
	}
	
	/**
	 * Pulls a list of gift names for a specific fund in a specific year
	 * @param Fund_ID, Fund Identification

	 * @return Names of gifts for a fund in a year in an ArrayList of Strings
	 */
	public ArrayList<String> getGiftNames(int Fund_ID){
		ArrayList<String> giftNames = new ArrayList<String>();
		String queryString = "SELECT " + TABLE_GIFT + "." + COLUMN_NAME + " FROM " + TABLE_GIFT + " INNER JOIN " + TABLE_FUND
                + " ON " + TABLE_GIFT + "." + COLUMN_GIFTFUNDDESC + "=" + TABLE_FUND + "." + COLUMN_FUND_DESC
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
	 * Pulls all gifts matching the parameters given for the search
	 * All null or empty parameters will be ignored in the search
	 * @param startDate, the specific date or beginning of date range in "YYYY-MM-DD" format
	 * @param endDate, the end of the date range in "YYYY-MM-DD" format
	 * @param startAmount, the specific amount or beginning of amount range
	 * @param endAmount, the end of the amount range
	 * @param checkNumber, the check number
	 * @return all gifts that match the search parameters as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftSearchResults(String startDate, String endDate, String startAmount,
											String endAmount, String checkNumber){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String searchStatement = "SELECT * FROM " + TABLE_GIFT;

		// Build date portion of search statement
		if(!NullOrEmpty(startDate) && !NullOrEmpty(endDate)){
			searchStatement += " WHERE (" + COLUMN_GIFTDATE + " BETWEEN '" + startDate + "' AND '" + endDate + "')";
		}else if(!NullOrEmpty(startDate)){
			searchStatement += " WHERE (" + COLUMN_GIFTDATE + " = '" + startDate + "')";
		}

		// Build amount portion of search statement
		if(!NullOrEmpty(startAmount) && !NullOrEmpty(endAmount)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate)){
				searchStatement += " WHERE (" + COLUMN_GIFTTOTALWHOLE + " BETWEEN " + startAmount + " AND " + endAmount + ")";
			}else{
				searchStatement += " AND (" + COLUMN_GIFTTOTALWHOLE + " BETWEEN " + startAmount + " AND " + endAmount + ")";
			}
		}else if(!NullOrEmpty(startAmount)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate)){
				searchStatement += " WHERE (" + COLUMN_GIFTTOTALWHOLE + " = " + startAmount + ")";
			}else{
				searchStatement += " AND (" + COLUMN_GIFTTOTALWHOLE + " = " + startAmount + ")";
			}
		}

		// Build check number portion of search statement
		if(!NullOrEmpty(checkNumber)){
			if(NullOrEmpty(startDate) && NullOrEmpty(endDate) && NullOrEmpty(startAmount) && NullOrEmpty(endAmount)){
				searchStatement += " WHERE " + COLUMN_CHECKNUM + " = " + checkNumber;
			}else{
				searchStatement += " AND (" + COLUMN_CHECKNUM + " = " + checkNumber + ")";
			}
		}

		// Order the resulting gifts by most recent to least recent
		searchStatement += " ORDER BY DATE(" + COLUMN_GIFTDATE + ") DESC";

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(searchStatement, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGiftFund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			Log.w("BasicAuth", "The date is:" + c.getString(6));
			temp.setGift_check_num(c.getString(7));
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
		String queryString = "SELECT * FROM " + TABLE_COMMENT;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
            int commentid = c.getInt(0);
            int senderid = c.getInt(1);
            int noteid = c.getInt(2);
            String username = c.getString(3);
            String notetype = c.getString(4);
            String date = c.getString(5);
            String commenttext = c.getString(6);


			comments.add(new Comment(commentid,senderid,noteid,username, notetype, date, commenttext));
		}
		c.close();
		db.close();
		return comments;
	}

	//gets list of new prayer requests and updates
	public ArrayList<NewItem> getNewItems() {
		ArrayList<NewItem> newItems = new ArrayList<NewItem>();
		String queryString = "SELECT * FROM " + TABLE_NEW_ITEM;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			newItems.add(new NewItem(c.getString(1), c.getString(2)));
		}
		c.close();
		db.close();
		return newItems;
	}

	//gets the refresh period for the auto-updater
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

	//gets the gift period for fund and gift displays
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
	 * @param id, used to find the account within the database
	 * @param newName, change the user name to something new
	 * @param newPass, change the password to something new
	 * @param newServer, change the server address to something new
	 */
	public void updateAccount(int id, String newName, String newPass, String newServer){
		ContentValues values = new ContentValues();
		values.put(COLUMN_ACCOUNTNAME, newName);
		values.put(COLUMN_ACCOUNTPASSWORD, newPass);
		values.put(COLUMN_SERVERNAME, newServer);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_ACCOUNTS, values, COLUMN_ID + " = " + id, null);
		db.close();
	}
	/**
	 * Updates the contact info for the given id
	 * @param contactinfo, the contact info to be updated
	 */

	public void updateContactInfo(ContactInfo contactinfo) {
		ContentValues values = new ContentValues();
		int id = contactinfo.getPartnerId();
		values.put(COLUMN_EMAIL, contactinfo.getEmail());
		values.put(COLUMN_PHONE, contactinfo.getPhone());
		values.put(COLUMN_CELL, contactinfo.getCell());

		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_CONTACT_INFO, values, COLUMN_ID + " = " + id, null);
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
}