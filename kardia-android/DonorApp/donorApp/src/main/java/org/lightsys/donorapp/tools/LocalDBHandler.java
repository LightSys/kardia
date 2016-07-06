package org.lightsys.donorapp.tools;

import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import org.lightsys.donorapp.data.Account;
import org.lightsys.donorapp.data.Comment;
import org.lightsys.donorapp.data.Fund;
import org.lightsys.donorapp.data.Gift;
import org.lightsys.donorapp.data.Missionary;
import org.lightsys.donorapp.data.NewItem;
import org.lightsys.donorapp.data.Note;
import org.lightsys.donorapp.data.PrayerLetter;
import org.lightsys.donorapp.data.PrayerNotification;
import org.lightsys.donorapp.data.Year;

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
public class LocalDBHandler extends SQLiteOpenHelper{
	
	private static final int DATABASE_VERSION = 11;
	private static final String DATABASE_NAME = "donor.db";
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
	private static final String COLUMN_FUND = "fund";
	private static final String COLUMN_FUNDDESC = "fund_desc";
	private static final String COLUMN_GIFTCOUNT = "gift_count";
	private static final String COLUMN_GIFTTOTALWHOLE = "gift_total_whole";
	private static final String COLUMN_GIFTTOTALPART = "gift_total_part";
	private static final String COLUMN_GIVINGURL = "giving_url";
	//GIFT TABLE
	private static final String TABLE_GIFT = "gifts";
	private static final String COLUMN_GIFTFUND = "gift_fund";
	private static final String COLUMN_GIFTFUNDDESC = "gift_fund_desc";
	private static final String COLUMN_GIFTDATE = "gift_date";
	private static final String COLUMN_CHECKNUM = "gift_check_num";
    //NOTES TABLE
    private static final String TABLE_NOTES = "notes";
    private static final String COLUMN_TEXT = "text";
    private static final String COLUMN_SUBJECT = "subject";
    private static final String COLUMN_MISSIONARY_NAME = "missionary_name";
	private static final String COLUMN_MISSIONARY_ID = "missionary_id";
	private static final String COLUMN_TYPE = "type";
	private static final String COLUMN_PRAYED_FOR = "prayed_for";
	//LETTERS TABLE
	private static final String TABLE_LETTERS = "letters";
	private static final String COLUMN_TITLE = "title";
	private static final String COLUMN_FILENAME = "filename";
	private static final String COLUMN_FOLDER = "folder";
	//NOTIFICATIONS TABLE
	private static final String TABLE_NOTIFICATIONS = "notifications";
	private static final String COLUMN_NOTIFY_TIME = "notification_time";
	private static final String COLUMN_REQUEST_ID = "request_id";
    //MISSIONARY TABLE
    private static final String TABLE_MISSIONARIES = "missionaries";
	//YEAR TABLE
	private static final String TABLE_YEAR = "years";
	//YEAR_FUND_MAP
	private static final String TABLE_YEARFUND_MAP = "year_fund_map";
	private static final String COLUMN_FUND_ID = "fund_id";
	private static final String COLUMN_YEAR_ID = "year_id";
	//YEAR_ACCOUNT_MAP
	private static final String TABLE_YEARACCOUNT_MAP = "year_account_map";
	//GIFT_FUND_MAP
	private static final String TABLE_GIFTFUND_MAP = "gift_fund_map";
	private static final String COLUMN_GIFT_ID = "gift_id";
	//GIFT_YEAR_MAP
	private static final String TABLE_GIFTYEAR_MAP = "gift_year_map";
	//FUND_ACCOUNT_MAP
	private static final String TABLE_FUNDACCOUNT_MAP = "fund_account_map";
	private static final String COLUMN_ACCOUNT_ID = "account_id";
	//GIFT_ACCOUNT_MAP
	private static final String TABLE_GIFTACCOUNT_MAP = "gift_account_map";
	//Time_Stamp
	private static final String TABLE_TIMESTAMP = "timestamp";
	private static final String COLUMN_DATE  = "date";
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

	
	/* ************************* Creation of Database and Tables ************************* */
	/**
	 * Creates an instance of the database
	 */
	public LocalDBHandler(Context context, CursorFactory factory){
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
				+ COLUMN_SERVERNAME + " TEXT," 	+ COLUMN_PARTNER_NAME + " TEXT)";
		db.execSQL(CREATE_ACCOUNTS_TABLE);

		String CREATE_MISSIONARY_TABLE = "CREATE TABLE " + TABLE_MISSIONARIES + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT)";
		db.execSQL(CREATE_MISSIONARY_TABLE);

		String CREATE_NOTES_TABLE = "CREATE TABLE " + TABLE_NOTES + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TEXT + " TEXT," + COLUMN_SUBJECT + " TEXT,"
				+ COLUMN_MISSIONARY_NAME + " TEXT," + COLUMN_MISSIONARY_ID + " INTEGER,"
				+ COLUMN_TYPE + " TEXT," + COLUMN_PRAYED_FOR + " TEXT)";
		db.execSQL(CREATE_NOTES_TABLE);

		String CREATE_LETTERS_TABLE = "CREATE TABLE " + TABLE_LETTERS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT,"
				+ COLUMN_TITLE + " TEXT," + COLUMN_MISSIONARY_NAME + " TEXT,"
				+ COLUMN_FOLDER + " TEXT," + COLUMN_FILENAME + " TEXT)";
		db.execSQL(CREATE_LETTERS_TABLE);

		String CREATE_NOTIFICATIONS_TABLE = "CREATE TABLE " + TABLE_NOTIFICATIONS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NOTIFY_TIME + " TEXT,"
				+ COLUMN_REQUEST_ID + " TEXT)";
		db.execSQL(CREATE_NOTIFICATIONS_TABLE);
		
		String CREATE_FUND_TABLE = "CREATE TABLE " + TABLE_FUND + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME 
				+ " TEXT," + COLUMN_FUND + " TEXT,"
				+ COLUMN_GIFTCOUNT + " INTEGER," + COLUMN_GIFTTOTALWHOLE
				+ " INTEGER," + COLUMN_GIFTTOTALPART + " INTEGER,"
				+ COLUMN_GIVINGURL + " TEXT, " + COLUMN_FUNDDESC + " TEXT)";
		db.execSQL(CREATE_FUND_TABLE);
		
		String CREATE_GIFT_TABLE = "CREATE TABLE " + TABLE_GIFT + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
				+ " TEXT," + COLUMN_GIFTFUND + " TEXT,"
				+ COLUMN_GIFTFUNDDESC + " TEXT," + COLUMN_GIFTTOTALWHOLE
				+ " INTEGER," + COLUMN_GIFTTOTALPART + " INTEGER,"
				+ COLUMN_GIFTDATE + " TEXT," + COLUMN_CHECKNUM + " TEXT)";
		db.execSQL(CREATE_GIFT_TABLE);
		
		String CREATE_YEAR_TABLE = "CREATE TABLE " + TABLE_YEAR + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME + " TEXT)";
		db.execSQL(CREATE_YEAR_TABLE);

		String CREATE_YEARFUND_MAP_TABLE = "CREATE TABLE " + TABLE_YEARFUND_MAP + "("
				+ COLUMN_ID + "INTEGER PRIMARY KEY," + COLUMN_FUND_ID
				+ " INTEGER," + COLUMN_YEAR_ID + " INTEGER,"
				+ COLUMN_GIFTTOTALWHOLE + " INTEGER,"
				+ COLUMN_GIFTTOTALPART + " INTEGER)";
		db.execSQL(CREATE_YEARFUND_MAP_TABLE);
		
		String CREATE_GIFTFUND_MAP_TABLE = "CREATE TABLE " + TABLE_GIFTFUND_MAP + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_FUND_ID
				+ " INTEGER," + COLUMN_GIFT_ID + " INTEGER)";
		db.execSQL(CREATE_GIFTFUND_MAP_TABLE);
		
		String CREATE_YEARACCOUNT_MAP_TABLE = "CREATE TABLE " + TABLE_YEARACCOUNT_MAP + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_YEAR_ID + " INTEGER,"
				+ COLUMN_ACCOUNT_ID + " INTEGER," + COLUMN_GIFTTOTALWHOLE
				+ " INTEGER," + COLUMN_GIFTTOTALPART + " INTEGER)";
		db.execSQL(CREATE_YEARACCOUNT_MAP_TABLE);
		
		String CREATE_GIFTYEAR_MAP_TABLE = "CREATE TABLE " + TABLE_GIFTYEAR_MAP + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_YEAR_ID
				+ " INTEGER," + COLUMN_GIFT_ID + " INTEGER)";
		db.execSQL(CREATE_GIFTYEAR_MAP_TABLE);
		
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
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, account.getId());
		values.put(COLUMN_ACCOUNTNAME, account.getAccountName());
		values.put(COLUMN_ACCOUNTPASSWORD, account.getAccountPassword());
		values.put(COLUMN_SERVERNAME, account.getServerName());
		values.put(COLUMN_PARTNER_NAME, account.getPartnerName());
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_ACCOUNTS, null, values);
		db.close();
	}

	/**
	 * Adds a missionary to the database
	 * @param missionary, the Missionary Object to be added
	 */
	public void addMissionary(Missionary missionary) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_ID, missionary.getId());
		values.put(COLUMN_NAME, missionary.getName());

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_MISSIONARIES, null, values);
		db.close();
	}

    /**
     * Adds a note (prayer request or update) to the Notes table in the database
     * @param note, note to be added
     */
	public void addNote(Note note) {
        ContentValues values = new ContentValues();
        values.put(COLUMN_TEXT, note.getText());
        values.put(COLUMN_DATE, note.getDate());
        values.put(COLUMN_SUBJECT,note.getSubject());
        values.put(COLUMN_MISSIONARY_NAME,note.getMissionaryName());
		values.put(COLUMN_MISSIONARY_ID, note.getMissionaryID());
        values.put(COLUMN_ID, note.getId());
		values.put(COLUMN_TYPE, note.getType());
		values.put(COLUMN_PRAYED_FOR, note.getIsPrayedFor());

        SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_NOTES, null, values);
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
	public void addFund(Fund fund){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME, fund.getFullName());
		values.put(COLUMN_FUND, fund.getName());
		values.put(COLUMN_FUNDDESC, fund.getFund_desc());
		values.put(COLUMN_GIFTCOUNT, fund.getGift_count());
		values.put(COLUMN_GIFTTOTALWHOLE, fund.getGift_total()[0]);
		values.put(COLUMN_GIFTTOTALPART, fund.getGift_total()[1]);
		values.put(COLUMN_GIVINGURL, fund.getGiving_url());
		
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
		values.put(COLUMN_GIFTFUND, gift.getGift_fund());
		values.put(COLUMN_GIFTFUNDDESC, gift.getGift_fund_desc());
		values.put(COLUMN_GIFTTOTALWHOLE, gift.getGift_amount()[0]);
		values.put(COLUMN_GIFTTOTALPART, gift.getGift_amount()[1]);
		values.put(COLUMN_GIFTDATE, gift.getGift_date());
		values.put(COLUMN_CHECKNUM, gift.getGift_check_num());
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFT, null, values);
		db.close();
	}
	
	/**
	 * Adds a year to the Year table in the database
	 * @param year, year to be stored
	 */
	public void addYear(Year year){
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME , year.getName());
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_YEAR, null, values);
		db.close();
	}
	
	/**
	 * Adds a connection between a Gift and a Fund through their IDs
	 * @param Gift_ID, Gift Identifier
	 * @param Fund_ID, Fund Identifier
	 */
	public void addGift_Fund(int Gift_ID, int Fund_ID){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFT_ID, Gift_ID);
		values.put(COLUMN_FUND_ID, Fund_ID);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFTFUND_MAP, null, values);
		db.close();
	}
	
	/**
	 * Adds a connection between a Gift and a Year through their IDs
	 * @param Gift_ID, Gift Identifier
	 * @param Year_ID, Year Identifier
	 */
	public void addGift_Year(int Gift_ID, int Year_ID){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFT_ID, Gift_ID);
		values.put(COLUMN_YEAR_ID, Year_ID);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_GIFTYEAR_MAP, null, values);
		db.close();
	}
	
	/**
	 * Adds a connection between a Year and a Fund through their IDs
	 * @param Year_ID, Year Identifier
	 * @param Fund_ID, Fund Identifier
	 */
	public void addYear_Fund(int Year_ID, int Fund_ID, int Amount_whole, int Amount_part){
		ContentValues values = new ContentValues();
		values.put(COLUMN_YEAR_ID, Year_ID);
		values.put(COLUMN_FUND_ID, Fund_ID);
		values.put(COLUMN_GIFTTOTALWHOLE, Amount_whole);
		values.put(COLUMN_GIFTTOTALPART, Amount_part);

		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_YEARFUND_MAP, null, values);
		db.close();
	}
	
	/**
	 * Adds a connection between a fund and a account through their IDs
	 * @param Fund_ID, Fund Identifier
	 * @param Account_ID, Account Identifier
	 */
	public void addFund_Account(int Fund_ID, int Account_ID){
		ContentValues values = new ContentValues();
		values.put(COLUMN_FUND_ID, Fund_ID);
		values.put(COLUMN_ACCOUNT_ID, Account_ID);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_FUNDACCOUNT_MAP, null, values);
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
	
	/**
	 * Adds a connection between a year and a account with 
	 * a total amount (amount_whole and amount_part)
	 * @param year_ID, Year Identifier
	 * @param Account_ID, Account Identifier
	 * @param amount_whole, Whole value for gifts of the account in the year
	 * @param amount_part, Fractional value of the gifts of the account in the year
	 */
	public void addYear_Account(int year_ID, int Account_ID, int amount_whole, int amount_part){
		ContentValues values = new ContentValues();
		values.put(COLUMN_YEAR_ID, year_ID);
		values.put(COLUMN_ACCOUNT_ID, Account_ID);
		values.put(COLUMN_GIFTTOTALWHOLE, amount_whole);
		values.put(COLUMN_GIFTTOTALPART, amount_part);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.insert(TABLE_YEARACCOUNT_MAP, null, values);
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
		
		//delete giftyear connections
		db.delete(TABLE_GIFTYEAR_MAP, TABLE_GIFTYEAR_MAP + "." + COLUMN_GIFT_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete giftfund connections
		db.delete(TABLE_GIFTFUND_MAP, TABLE_GIFTFUND_MAP + "." + COLUMN_GIFT_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete gifts
		db.delete(TABLE_GIFT, TABLE_GIFT + "." + COLUMN_ID 
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete giftaccount connections
		db.delete(TABLE_GIFTACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);
		
		//delete yearfund connections
		db.delete(TABLE_YEARFUND_MAP, TABLE_YEARFUND_MAP + "." + COLUMN_FUND_ID 
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete funds
		db.delete(TABLE_FUND, TABLE_FUND + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);
		
		//delete fundaccount connections
		db.delete(TABLE_FUNDACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);
		
		//delete yearaccount connections
		db.delete(TABLE_YEARACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete missionaries and all notes, prayer letters, and prayer notifications
		db.delete(TABLE_MISSIONARIES, null, null);
		db.delete(TABLE_NOTES, null, null);
		db.delete(TABLE_LETTERS, null, null);
		db.delete(TABLE_NOTIFICATIONS, null, null);
		
		//delete account
		db.delete(TABLE_ACCOUNTS, COLUMN_ID + " = ?", acct);
		
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

		//delete giftyear connections
		db.delete(TABLE_GIFTYEAR_MAP, TABLE_GIFTYEAR_MAP + "." + COLUMN_GIFT_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete giftfund connections
		db.delete(TABLE_GIFTFUND_MAP, TABLE_GIFTFUND_MAP + "." + COLUMN_GIFT_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete gifts
		db.delete(TABLE_GIFT, TABLE_GIFT + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_GIFTACCOUNT_MAP + "." + COLUMN_GIFT_ID
				+ " FROM " + TABLE_GIFTACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete giftaccount connections
		db.delete(TABLE_GIFTACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete yearfund connections
		db.delete(TABLE_YEARFUND_MAP, TABLE_YEARFUND_MAP + "." + COLUMN_FUND_ID
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete funds
		db.delete(TABLE_FUND, TABLE_FUND + "." + COLUMN_ID
				+ " IN (SELECT " + TABLE_FUNDACCOUNT_MAP + "." + COLUMN_FUND_ID + " FROM "
				+ TABLE_FUNDACCOUNT_MAP + " WHERE " + COLUMN_ACCOUNT_ID + " = ?)", acct);

		//delete fundaccount connections
		db.delete(TABLE_FUNDACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		//delete yearaccount connections
		db.delete(TABLE_YEARACCOUNT_MAP, COLUMN_ACCOUNT_ID + " = ?", acct);

		db.close();
	}

	//delete note
	public void deleteNote(Note note){
		String[] acct = {String.valueOf(note.getId())};
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
	 * @param fund_id, Fund ID to retrieve
	 * @return The fund with the id of fund_id
	 */
	public Fund getFundById(int fund_id){
		Fund temp = new Fund();
		String queryString = "SELECT * FROM " + TABLE_FUND 
				+ " WHERE " + COLUMN_ID + " = " + fund_id;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		if(c.moveToFirst()){
			temp.setID(Integer.parseInt(c.getString(0)));
			temp.setFullName(c.getString(1));
			temp.setName(c.getString(2));
			temp.setGift_count(Integer.parseInt(c.getString(3)));
			temp.setGift_total(
					new int [] {
							Integer.parseInt(c.getString(4)),
							Integer.parseInt(c.getString(5))
							});
			temp.setGiving_url(c.getString(6));
			temp.setFund_desc(c.getString(7));
		}
		c.close();
		db.close();
		return temp;
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
		} else if(type.equals("year")){
			queryString += TABLE_YEAR;
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
		String queryString = "SELECT F." + COLUMN_NAME + " FROM " + TABLE_FUND
				+ " AS F INNER JOIN " + TABLE_FUNDACCOUNT_MAP + " AS FA ON F." 
				+ COLUMN_ID + " = FA." + COLUMN_FUND_ID + " WHERE FA."
				+ COLUMN_ACCOUNT_ID + " = " + Account_ID;
		
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
	public ArrayList<Fund> getFundsForAccount(int Account_ID){
		ArrayList<Fund> funds = new ArrayList<Fund>();
		String queryString = "SELECT F.* FROM " + TABLE_FUND
				+ " AS F INNER JOIN " + TABLE_FUNDACCOUNT_MAP + " AS FA ON F." 
				+ COLUMN_ID + " = FA." + COLUMN_FUND_ID + " WHERE FA."
				+ COLUMN_ACCOUNT_ID + " = " + Account_ID
				+ " ORDER BY F." + COLUMN_FUNDDESC;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			Fund temp = new Fund();
			temp.setID(Integer.parseInt(c.getString(0)));
			temp.setFullName(c.getString(1));
			temp.setName(c.getString(2));
			temp.setGift_count(Integer.parseInt(c.getString(3)));
			temp.setGift_total(
					new int[]{
							Integer.parseInt(c.getString(4)),
							Integer.parseInt(c.getString(5))
					});
			temp.setGiving_url(c.getString(6));
			temp.setFund_desc(c.getString(7));

			funds.add(temp);
		}
		c.close();
		db.close();
		return funds;
	}

	/**
	 * Pulls all missionaries from the database
	 * @return a list of all missionaries as an ArrayList of Missionary Objects ordered alphabetically
	 */
	public ArrayList<Missionary> getMissionaries() {
		ArrayList<Missionary> missionaries = new ArrayList<Missionary>();
		String queryString = "SELECT * FROM " + TABLE_MISSIONARIES + " ORDER BY " +
				COLUMN_NAME;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while (c.moveToNext()) {
			Missionary temp = new Missionary();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));

			missionaries.add(temp);
		}
		c.close();
		db.close();
		return missionaries;
	}

	/**
	 * Pulls a specific missionary from the database
	 * @param missionaryID, the ID for the missionary to be pulled
	 * @return the specified missionary as a Missionary Object
	 */
	public Missionary getMissionaryForID(int missionaryID) {
		Missionary missionary = new Missionary();
		String queryString = "SELECT * FROM " + TABLE_MISSIONARIES +
				" WHERE " + COLUMN_ID + " = " + missionaryID;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			missionary.setId(Integer.parseInt(c.getString(0)));
			missionary.setName(c.getString(1));
		}
		c.close();
		db.close();
		return missionary;
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
            temp.setId(Integer.parseInt(c.getString(0)));
            temp.setDate(c.getString(1));
            temp.setText(c.getString(2));
            temp.setSubject(c.getString(3));
			temp.setMissionaryName(c.getString(4));
			temp.setMissionaryID(c.getInt(5));
			temp.setType(c.getString(6));
			String booleanStr = c.getString(7);
			// Database stores boolean values as "0" and "1"
			if (booleanStr.equals("1")) {
				temp.setIsPrayedFor(true);
			} else {
				temp.setIsPrayedFor(false);
			}

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
			note.setId(Integer.parseInt(c.getString(0)));
			note.setDate(c.getString(1));
			note.setText(c.getString(2));
			note.setSubject(c.getString(3));
			note.setMissionaryName(c.getString(4));
			note.setMissionaryID(c.getInt(5));
			note.setType(c.getString(6));
			String booleanStr = c.getString(7);
			// Database stores boolean string values as "0" and "1"
			if (booleanStr.equals("1")) {
				note.setIsPrayedFor(true);
			} else {
				note.setIsPrayedFor(false);
			}
		}
		c.close();
		db.close();
		return note;
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
			temp.setGift_fund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
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
			gift.setGift_fund(c.getString(2));
			gift.setGift_fund_desc(c.getString(3));
			gift.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			gift.setGift_date(c.getString(6));
			gift.setGift_check_num(c.getString(7));
		}
		c.close();
		db.close();
		return gift;
	}
	
	/**
	 * Pulls a list of gift names for a specific fund in a specific year
	 * @param Fund_ID, Fund Identification
	 * @param Year_ID, Year Identification
	 * @return Names of gifts for a fund in a year in an ArrayList of Strings
	 */
	public ArrayList<String> getGiftNames(int Fund_ID, int Year_ID){
		ArrayList<String> giftNames = new ArrayList<String>();
		String queryString = "SELECT Gift." + COLUMN_NAME + " FROM " + TABLE_GIFT + " AS Gift "
				+ " INNER JOIN " + TABLE_GIFTFUND_MAP + " AS FundMap ON Gift." + COLUMN_ID + " = "
				+ " FundMap." + COLUMN_GIFT_ID + " INNER JOIN " + TABLE_GIFTYEAR_MAP
				+ " AS YearMap ON Gift." + COLUMN_ID + " = Yearmap." + COLUMN_GIFT_ID
				+ " WHERE (FundMap." + COLUMN_FUND_ID + " = " + Fund_ID + ") AND (YearMap."
				+ COLUMN_YEAR_ID + " = " + Year_ID + ")";
		
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
	 * Pulls all gifts for a specific fund for a specific year
	 * @param Fund_ID, Fund Identification
	 * @param Year_ID, Year Identification
	 * @return All gifts given to a fund in a year as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftsForFund(int Fund_ID, int Year_ID){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT G.* FROM " + TABLE_GIFT + " AS G "
				+ "INNER JOIN " + TABLE_GIFTYEAR_MAP + " AS GYM ON G."
				+ COLUMN_ID + " = GYM." + COLUMN_GIFT_ID + " INNER JOIN "
				+ TABLE_GIFTFUND_MAP + " AS GFM ON G." + COLUMN_ID
				+ " = GFM." + COLUMN_GIFT_ID + " WHERE (GYM." + COLUMN_YEAR_ID
				+ " = " + Year_ID + ") AND (GFM." + COLUMN_FUND_ID + " = "
				+ Fund_ID + ")"
				+ " ORDER BY DATE(" + COLUMN_GIFTDATE + ") DESC";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGift_fund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
	}
	
	/**
	 * Pulls all gifts for a specific year
	 * @param Year_ID, Year Identification
	 * @return All gifts in a year as an ArrayList of Gift Objects ordered from most recent to least recent
	 */
	public ArrayList<Gift> getGiftsForYear(int Year_ID){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		String queryString = "SELECT * FROM " + TABLE_GIFT + " AS G "
				+ "INNER JOIN " + TABLE_GIFTYEAR_MAP + " AS GYM ON G."
				+ COLUMN_ID + " = GYM." + COLUMN_GIFT_ID
				+ " WHERE GYM." + COLUMN_YEAR_ID + " = " + Year_ID
				+ " ORDER BY DATE(" + COLUMN_GIFTDATE + ") DESC";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Gift temp = new Gift();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGift_fund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int[]{
					Integer.parseInt(c.getString(4)),
					Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			Log.w("BasicAuth", "The date is:" + c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		c.close();
		db.close();
		return gifts;
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
			temp.setGift_fund(c.getString(2));
			temp.setGift_fund_desc(c.getString(3));
			temp.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			Log.w("BasicAuth", "The date is:" + c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
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
	
	/**
	 * Pulls all years
	 * @return All years in the Year Table as an ArrayList of Year Objects
	 */
	public ArrayList<Year> getYears(){
		ArrayList<Year> years = new ArrayList<Year>();
		String queryString = "SELECT Y." + COLUMN_ID + ", Y." + COLUMN_NAME
				+ ", SUM(YF." + COLUMN_GIFTTOTALWHOLE + "), SUM(YF." + COLUMN_GIFTTOTALPART
				+ ") FROM " + TABLE_YEAR + " AS Y INNER JOIN " + TABLE_YEARACCOUNT_MAP
				+ " AS YF ON Y." + COLUMN_ID  + " = YF." + COLUMN_YEAR_ID + " GROUP BY Y." + COLUMN_NAME
				+ " ORDER BY Y." + COLUMN_NAME + " DESC";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Year temp = new Year();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGift_total(new int[]{
					Integer.parseInt(c.getString(2)),
					Integer.parseInt(c.getString(3))
			});
			
			years.add(temp);
		}
		c.close();
		db.close();
		return years;
	}
	
	/**
	 * Pulls a specific year from the year's name
	 * @param name, name of the year (e.g. "2015")
	 * @return The year with the given name as a Year Object
	 */
	public Year getYear(String name){
		Year year = new Year();
		String queryString = "SELECT * FROM " + TABLE_YEAR
				+ " WHERE " + COLUMN_NAME + " = \"" + name + "\"";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		if(c.moveToFirst()){
			year.setId(Integer.parseInt(c.getString(0)));
			year.setName(c.getString(1));
		}
		c.close();
		db.close();
		return year;
	}

	/**
	 * Pulls a specific year from the year's ID
	 * @param yearID, ID of year to be pulled from database
	 * @return the specific year as a Year Object
	 */
	public Year getYearForID(int yearID) {
		Year year = new Year();
		String queryString = "SELECT * FROM " + TABLE_YEAR +
				" WHERE " + COLUMN_ID + " = " + yearID;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		if(c.moveToFirst()){
			year.setId(Integer.parseInt(c.getString(0)));
			year.setName(c.getString(1));
		}
		c.close();
		db.close();
		return year;
	}
	
	/**
	 * Pulls all year names
	 * @return a list of names of years (e.g. "2015") in an ArrayList of Strings
	 */
	public ArrayList<String> getYearNames(){
		ArrayList<String> yearNames = new ArrayList<String>();
		String queryString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_YEAR;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			yearNames.add(c.getString(0));
		}
		c.close();
		db.close();
		return yearNames;
	}
	
	/**
	 * Pulls all year names for a specific fund
	 * @param Fund_ID, Fund Identification
	 * @return All year names (e.g. "2015") for a specific fund as an ArrayList of Strings
	 */
	public ArrayList<String> getYearNamesFund(int Fund_ID){
		ArrayList<String> yearNames = new ArrayList<String>();
		String queryString = "SELECT Y." + COLUMN_NAME + " FROM " + TABLE_YEAR + " AS Y "
				+ "INNER JOIN " + TABLE_YEARFUND_MAP + " AS YFM ON Y."
				+ COLUMN_ID + " = YFM." + COLUMN_YEAR_ID
				+ " WHERE YFM." + COLUMN_FUND_ID + " = " + Fund_ID;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			yearNames.add(c.getString(0));
		}
		c.close();
		db.close();
		return yearNames;
	}
	
	/**
	 * Pulls all year names for a specific account
	 * @param Account_ID, Account Identification
	 * @return all year names (e.g. "2015") for a specific account in an ArrayList of Strings
	 */
	public ArrayList<String> getYearNamesAccount(int Account_ID){
		ArrayList<String> yearNames = new ArrayList<String>();
		String queryString = "SELECT Y." + COLUMN_NAME + " FROM " + TABLE_YEAR + " AS Y "
				+ "INNER JOIN " + TABLE_YEARACCOUNT_MAP + " AS YFM ON Y."
				+ COLUMN_ID + " = YFM." + COLUMN_YEAR_ID
				+ " WHERE YFM." + COLUMN_ACCOUNT_ID + " = " + Account_ID;
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			yearNames.add(c.getString(0));
		}
		c.close();
		db.close();
		return yearNames;
	}
	
	/**
	 * Pulls all years for a specific fund
	 * @param Fund_ID, Fund Identification
	 * @return all years for a specific fund as an ArrayList of Year Objects
	 */
	public ArrayList<Year> getYearsForFund(int Fund_ID){
		ArrayList<Year> years = new ArrayList<Year>();
		String queryString = "SELECT Y." + COLUMN_ID + ", Y." + COLUMN_NAME
				+ ", YFM." + COLUMN_GIFTTOTALWHOLE + ", YFM." + COLUMN_GIFTTOTALPART
				+ " FROM " + TABLE_YEAR + " AS Y "
				+ "INNER JOIN " + TABLE_YEARFUND_MAP + " AS YFM ON "
				+ "Y." + COLUMN_ID + " = YFM." + COLUMN_YEAR_ID
				+ " WHERE YFM." + COLUMN_FUND_ID + " = " + Fund_ID
				+ " ORDER BY Y." + COLUMN_NAME + " DESC";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			Year temp = new Year();
			temp.setId(Integer.parseInt(c.getString(0)));
			temp.setName(c.getString(1));
			temp.setGift_total(new int[] {
					Integer.parseInt(c.getString(2)),
					Integer.parseInt(c.getString(3))
			});
			
			years.add(temp);
		}
		c.close();
		db.close();
		return years;
	}

	//gets list of comments
	public ArrayList<Comment> getComments(){
		ArrayList<Comment> comments = new ArrayList<Comment>();
		String queryString = "SELECT *" + " FROM " + TABLE_COMMENT;

		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);

		while(c.moveToNext()){
			comments.add(new Comment(c.getInt(0), c.getInt(1), c.getInt(2), c.getString(3), c.getString(4), c.getString(5), c.getString(6)));
		}
		c.close();
		db.close();
		return comments;
	}

	//gets list of new prayer requests and updates
	public ArrayList<NewItem> getNewItems() {
		ArrayList<NewItem> newItems = new ArrayList<NewItem>();
		String queryString = "SELECT *" + " FROM " + TABLE_NEW_ITEM;

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
	 * @param isPrayedFor, boolean value to update whether the note has been prayed for or not
	 */
	public void updateNote(int id, boolean isPrayedFor) {
		ContentValues values = new ContentValues();
		values.put(COLUMN_PRAYED_FOR, isPrayedFor);

		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_NOTES, values, COLUMN_ID + " = " + id, null);
		db.close();
	}
	
	/**
	 * Updates the relationship between a specific year and a specific fund with a new gift total
	 * @param year_id, Year Identification
	 * @param fund_id, Fund Identification
	 * @param gift_total_whole, Updated whole part of gift total
	 * @param gift_total_part, Updated fractional part of gift total
	 */
	public void updateYear_Fund(int year_id, int fund_id, int gift_total_whole, int gift_total_part){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFTTOTALWHOLE, gift_total_whole);
		values.put(COLUMN_GIFTTOTALPART, gift_total_part);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_YEARFUND_MAP, values, COLUMN_YEAR_ID + " = " + year_id 
				+ " AND " + COLUMN_FUND_ID + " = " + fund_id, null);
		db.close();
	}
	
	/**
	 * Updates the relationship between a specific year and a specific fund with a new gift total
	 * @param year_id, Year Identification
	 * @param account_id, Account Identification
	 * @param gift_total_whole, Updated whole part of gift total
	 * @param gift_total_part, Updated fractional part of gift total
	 */
	public void updateYear_Account(int year_id, int account_id, int gift_total_whole, int gift_total_part){
		ContentValues values = new ContentValues();
		values.put(COLUMN_GIFTTOTALWHOLE, gift_total_whole);
		values.put(COLUMN_GIFTTOTALPART, gift_total_part);
		
		SQLiteDatabase db = this.getWritableDatabase();
		db.update(TABLE_YEARACCOUNT_MAP, values, COLUMN_YEAR_ID + " = " + year_id 
				+ " AND " + COLUMN_ACCOUNT_ID + " = " + account_id, null);
		db.close();
	}
}