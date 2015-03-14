package org.lightsys.donorapp.data;

import java.sql.SQLOutput;
import java.util.ArrayList;
import java.util.Calendar;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

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
	private static final String COLUMN_DONOR_ID = "donorId";
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
    //PRAYER REQUEST TABLE
    private static final String TABLE_PRAYER = "prayers";
    private static final String COLUMN_NOTE_ID = "note_id";
    private static final String COLUMN_DATE_RESPONSE = "date_response";
    private static final String COLUMN_DATE_POST = "date_post";
    private static final String COLUMN_TEXT = "text";
    private static final String COLUMN_SUBJECT = "subject";
    private static final String COLUMN_MISSIONARY_ID = "missionary_id";
    //UPDATE TABLE
    private static final String TABLE_UPDATE = "updates";
    //MISSIONARY TABLE
    private static final String TABLE_MISSIONARIES = "missionaries";
    private static final String COLUMN_MISSIONARY_NAME = "missionary_name";
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
	
	/* ************************* Creation of Database and Tables ************************* */
	/**
	 * Creates an instance of the database
	 * 
	 * @param context
	 * @param name
	 * @param factory
	 * @param version
	 */
	public LocalDBHandler(Context context, String name, CursorFactory factory, int version){
		super(context, DATABASE_NAME, factory, DATABASE_VERSION);
	}
	
	/**
	 * Creates all the tables used to store accounts and donor information
	 */
	@Override
	public void onCreate(SQLiteDatabase db){
        db.execSQL( "DROP TABLE "+TABLE_UPDATE);
        String CREATE_UPDATE_TABLE = "CREATE TABLE " + TABLE_UPDATE + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NOTE_ID + " TEXT,"
                + COLUMN_DATE_RESPONSE + " TEXT,"
                + COLUMN_DATE_POST + " TEXT,"+ COLUMN_TEXT + " TEXT,"
                + COLUMN_SUBJECT + " TEXT,"+ COLUMN_MISSIONARY_ID + " TEXT)";
        db.execSQL(CREATE_UPDATE_TABLE);

        db.execSQL( "DROP TABLE "+TABLE_PRAYER);
        String CREATE_PRAYER_REQUEST_TABLE = "CREATE TABLE " + TABLE_PRAYER + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NOTE_ID + " TEXT,"
                + COLUMN_DATE_RESPONSE + " TEXT,"
                + COLUMN_DATE_POST + " TEXT,"+ COLUMN_TEXT + " TEXT,"
                + COLUMN_SUBJECT + " TEXT,"+ COLUMN_MISSIONARY_ID + " TEXT)";
        db.execSQL(CREATE_PRAYER_REQUEST_TABLE);

        String CREATE_TABLE_TIMESTAMP = "CREATE TABLE " + TABLE_TIMESTAMP + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_DATE + " TEXT)";
		db.execSQL(CREATE_TABLE_TIMESTAMP);
		
		String CREATE_ACCOUNTS_TABLE = "CREATE TABLE " + TABLE_ACCOUNTS + "("
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_ACCOUNTNAME 
				+ " TEXT," + COLUMN_ACCOUNTPASSWORD + " TEXT,"
				+ COLUMN_SERVERNAME + " TEXT,"
				+ COLUMN_DONOR_ID + " INTEGER)";
		db.execSQL(CREATE_ACCOUNTS_TABLE);
		
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
				+ COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
				+ " TEXT)";
		
		db.execSQL(CREATE_YEAR_TABLE);

        String CREATE_MISSIONARY_TABLE = "CREATE TABLE " + TABLE_MISSIONARIES + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY," + COLUMN_NAME
                + COLUMN_MISSIONARY_ID + "TEXT," + COLUMN_MISSIONARY_NAME + "TEXT)";

        db.execSQL(CREATE_MISSIONARY_TABLE);

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
	
	public void addTimeStamp(String date){
		ContentValues values = new ContentValues();
		values.put(COLUMN_DATE, date);
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_TIMESTAMP, null, values);
		db.close();
	}
	
	/**
	 * Adds an account to the row of the database.
	 * 
	 * @param account, uses an Account object to retrieve needed data
	 */
	public void addAccount(Account account){
		ContentValues values = new ContentValues();
		values.put(COLUMN_ACCOUNTNAME, account.getAccountName());
		values.put(COLUMN_ACCOUNTPASSWORD, account.getAccountPassword());
		values.put(COLUMN_SERVERNAME, account.getServerName());
		values.put(COLUMN_DONOR_ID, account.getDonorid());
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.insert(TABLE_ACCOUNTS, null, values);
		db.close();
	}

    /**
     * Adds a prayer request to the Prayer Request table in the database
     * @param request
     */
	public void addRequest(PrayerRequest request)
    {
        ContentValues values = new ContentValues();
        values.put(COLUMN_TEXT, request.getText());
        values.put(COLUMN_DATE_RESPONSE, request.getDate());
        values.put(COLUMN_DATE_POST, "10-3-2001"); //TODO: decide on initial value for response date
        values.put(COLUMN_SUBJECT,request.getSubject());
        values.put(COLUMN_MISSIONARY_ID,"100000");//decide on initial value for missionary id
        values.put(COLUMN_NOTE_ID, request.getId());

        boolean add = true;
        for(PrayerRequest r: getRequests())
        {
            if(r.getId().equals(request.getId()))
            {
                add = false;
                break;
            }
        }
        SQLiteDatabase db = this.getWritableDatabase();
        if(add)
            db.insert(TABLE_PRAYER, null, values);
        db.close();
    }

    /**
     * Adds an update to the Update table in the database
     * @param update
     */
    public void addUpdate(Update update)
    {
        ContentValues values = new ContentValues();
        values.put(COLUMN_TEXT, update.getText());
        values.put(COLUMN_DATE_RESPONSE, update.getDate());
        values.put(COLUMN_DATE_POST, "10-3-2001"); //TODO: decide on initial value for response date
        values.put(COLUMN_SUBJECT,update.getSubject());
        values.put(COLUMN_MISSIONARY_ID,"100000");//decide on initial value for missionary id
        values.put(COLUMN_NOTE_ID, update.getId());
        boolean add = true;
        for(Update r: getUpdates())
        {
            if(r.getId().equals(update.getId()))
            {
                add = false;
                break;
            }
        }
        SQLiteDatabase db = this.getWritableDatabase();
        if(add)
        {
            db.insert(TABLE_UPDATE, null, values);
        }
        db.close();
    }

	/**
	 * Adds a fund to the Fund table in the database
	 * @param fund
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
	 * @param gift
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
	 * @param year
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
	 * @param Fund_ID
	 * @param Account_ID
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
	 * @param Gift_ID
	 * @param Account_ID
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
	 * @param year_ID
	 * @param Account_ID
	 * @param amount_whole
	 * @param amount_part
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

	/* ************************* Deletion Queries ************************* */
	
	/**
	 * Deletes the timestamp table
	 */
	public void deleteTimeStamp(){
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.delete(TABLE_ACCOUNTS, null, null); 
		db.close();
	}
	
	/**
	 * Removes the account from the database, finds the account by the
	 * accountName, and serverName
	 * 
	 * @param accountName, User name of the account
	 * @param serverName, Server Address of the account
	 * @return true if the account was deleted. false if it wasn't
	 */
	public boolean deleteAccount(String accountName, String serverName){
		boolean result = false;
		
		String queryString = "SELECT * FROM " + TABLE_ACCOUNTS
				+ " WHERE " + COLUMN_ACCOUNTNAME + " = \"" + accountName + "\" AND "
				+ COLUMN_SERVERNAME + " = \"" + serverName + "\"";
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		Cursor c = db.rawQuery(queryString, null);
		
		
		
		if(c.moveToFirst()){
			int account_id = Integer.parseInt(c.getString(0));
			db.delete(TABLE_ACCOUNTS, COLUMN_ID + " = ?", new String[]{String.valueOf(account_id)});
			c.close();
			result = true;
		}
		db.close();
		return result;
	}
	
	/**
	 * Deletes the Account from the database (also any information linked with it)
	 * @param Account_ID
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
		
		//delete account
		db.delete(TABLE_ACCOUNTS, COLUMN_ID + " = ?", acct);
		
		db.close();
	}
	
	/**
	 * Deletes all stored information but user accounts
	 * (this will usually be called before pulling updated information)
	 */
	public void deleteAll(){
		SQLiteDatabase db = this.getWritableDatabase();
		
		String[] delStrings = {
		TABLE_FUND,
		TABLE_GIFT,
        TABLE_PRAYER,
		TABLE_YEAR,
		TABLE_YEARFUND_MAP,
		TABLE_GIFTFUND_MAP,
		TABLE_GIFTYEAR_MAP,
		TABLE_FUNDACCOUNT_MAP,
		TABLE_GIFTACCOUNT_MAP,
		TABLE_YEARACCOUNT_MAP
		};
		
		for(String s : delStrings){
			db.delete(s, null, null);
		}
		db.close();
	}
	
	/* ************************* Get Queries ************************* */
	
	/**
	 * @return A timestamp, in Milliseconds, from the last update
	 */
	public long getTimeStamp(){
		String queryString = "SELECT " + COLUMN_DATE + " FROM " + TABLE_TIMESTAMP;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(queryString, null);

		long date = -1;
		
		if(c.moveToFirst()){
			date = Long.parseLong(c.getString(0));
		}
		db.close();
		return date;
	}
	
	/**
	 * @return all accounts in the Account table as an ArrayList of Account Objects
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
			temp.setDonorid(Integer.parseInt(c.getString(4)));
			
			accounts.add(temp);
		}
		db.close();
		return accounts;
	}
	
	/**
	 * @return all funds in the Fund table as an ArrayList of Fund Objects
	 */
	public ArrayList<Fund> getFunds(){
		ArrayList<Fund> funds = new ArrayList<Fund>();
		int cal = Calendar.getInstance().get(Calendar.YEAR);

		
		String queryString = "SELECT F." + COLUMN_ID + ", F." + COLUMN_NAME + ", F." + COLUMN_FUND
				+ ", F." + COLUMN_GIFTCOUNT + ", YF." + COLUMN_GIFTTOTALWHOLE + ", YF." + COLUMN_GIFTTOTALPART
				+ ", F." + COLUMN_GIVINGURL + ", F." + COLUMN_FUNDDESC
				+ " FROM " + TABLE_FUND + " AS F INNER JOIN " 
				+ TABLE_YEARFUND_MAP + " AS YF ON F." + COLUMN_ID + " = YF." + COLUMN_FUND_ID
				+ " INNER JOIN " + TABLE_YEAR + " AS Y ON YF." + COLUMN_YEAR_ID + " = Y." + COLUMN_ID
				+ " WHERE Y." + COLUMN_NAME + " = \"" + cal + "\""
				+ " ORDER BY F." + COLUMN_FUNDDESC;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
            if(c.getString(0) == null){
                break;
            }
			Fund temp = new Fund();
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
			
			funds.add(temp);
		}
		db.close();
		return funds;
	}
	
	/**
	 * @param fund_id
	 * @return the fund with the id of fund_id
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
		db.close();
		return temp;
	}
	
	/**
	 * @param type, which table to pull from - 'fund','gift', or 'year'
	 * @return the id of the last element in the given table
	 */
	public int getLastId(String type){
		int id = 0;
		
		String queryString = "SELECT " + COLUMN_ID + " FROM ";
		if(type.equals("fund")){
			queryString += TABLE_FUND;
		}
		else if(type.equals("gift")){
			queryString += TABLE_GIFT;
		}
		else if(type.equals("year")){
			queryString += TABLE_YEAR;
		}
		
		queryString += " ORDER BY " + COLUMN_ID + " DESC LIMIT 1";
		
		SQLiteDatabase db = this.getReadableDatabase();
		Cursor c = db.rawQuery(queryString, null);
		if(c.moveToFirst()){
			id = Integer.parseInt(c.getString(0));
		}
		db.close();
		return id;
		
	}
	
	/**
	 * This is used when pulling down information, it is used to compare funds,
	 * so that duplicates are not put into the database. based on the account
	 * @return a list of names of all the funds in the database for a specific account
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
		db.close();
		return fundNames;
	}
	
	/**
	 * Pulls all funds for a specific account
	 * @param Account_ID
	 * @return a arraylist of Funds
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
					new int [] {
							Integer.parseInt(c.getString(4)),
							Integer.parseInt(c.getString(5))
							});
			temp.setGiving_url(c.getString(6));
			temp.setFund_desc(c.getString(7));
			funds.add(temp);
		}
		db.close();
		return funds;
	}

    public ArrayList<PrayerRequest> getRequests()
    {
        ArrayList<PrayerRequest> requests = new ArrayList<PrayerRequest>();
        String queryString = "SELECT * FROM " + TABLE_PRAYER+" ORDER BY DATE(" + COLUMN_DATE_POST + ") DESC";
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while(c.moveToNext()){
            PrayerRequest temp = new PrayerRequest();
            temp.setId(c.getString(1));
            temp.setDate(c.getString(2));
            temp.setText(c.getString(4));
            temp.setSubject(c.getString(5));

            requests.add(temp);
        }
        db.close();
        return requests;

    }

    public ArrayList<Update> getUpdates()
    {
        ArrayList<Update> updates = new ArrayList<Update>();
        String queryString = "SELECT * FROM " + TABLE_UPDATE+" ORDER BY DATE(" + COLUMN_DATE_POST + ") DESC";
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery(queryString, null);

        while(c.moveToNext()){
            Update temp = new Update();
            temp.setId(c.getString(1));
            temp.setDate(c.getString(2));
            temp.setText(c.getString(4));
            temp.setSubject(c.getString(5));

            updates.add(temp);
        }
        db.close();
        return updates;

    }
	/**
	 * @return all gifts in the Gift table as an ArrayList of Gift Objects
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
			temp.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		db.close();
		return gifts;
	}
	
	/**
	 * @param id of a gift
	 * @return the full gift object for the id
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
		db.close();
		return gift;
	}
	
	/**
	 * @param Fund_ID
	 * @param Year_ID
	 * @return a list of strings, of gift names for a certain fund, in a certain year
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
		db.close();
		return giftNames;
	}
	
	/**
	 * 
	 * @param Fund_ID
	 * @return the list of gifts donated to a given fund
	 */
	public ArrayList<Gift> getGiftsForFund(int Fund_ID){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		
		String queryString = "SELECT G.* FROM " + TABLE_GIFT + " AS G "
				+ "INNER JOIN " + TABLE_GIFTFUND_MAP + " AS GFM ON G." 
				+ COLUMN_ID + " = GFM." + COLUMN_GIFT_ID 
				+ " WHERE GFM." + COLUMN_FUND_ID + " = " + Fund_ID;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(queryString, null);
		
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
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		db.close();
		return gifts;
	}
	
	/**
	 * 
	 * @param Fund that the gift was given to
	 * @param Year that the gift was given
	 * @return a list of all gifts that were given during a certain year to a certain fund
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
			temp.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		db.close();
		return gifts;
	}
	
	/**
	 * 
	 * @param Year_ID
	 * @return the list of gifts donated in a given year
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
			temp.setGift_amount(new int []{
				Integer.parseInt(c.getString(4)),
				Integer.parseInt(c.getString(5))
			});
			temp.setGift_date(c.getString(6));
			Log.w("BasicAuth","The date is:" + c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		db.close();
		return gifts;
	}
	
	/**
	 * 
	 * @param pre-made query statement
	 * @return a list of gifts that match the search
	 */
	public ArrayList<Gift> getSearchResults(String searchStatement){
		ArrayList<Gift> gifts = new ArrayList<Gift>();
		
		
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
			Log.w("BasicAuth","The date is:" + c.getString(6));
			temp.setGift_check_num(c.getString(7));
			
			gifts.add(temp);
		}
		db.close();
		return gifts;
	}
	
	/**
	 * @return all years in the Year table as an ArrayList of Year Objects
	 */
	public ArrayList<Year> getFundYears(int fund_ID){
		ArrayList<Year> years = new ArrayList<Year>();
		
		String queryString = "SELECT Y." + COLUMN_ID + ", Y." + COLUMN_NAME
				+ " YF." + COLUMN_GIFTTOTALWHOLE + ", YF." + COLUMN_GIFTTOTALPART
				+ " FROM " + TABLE_YEAR + " AS Y INNER JOIN " + TABLE_YEARFUND_MAP
				+ " AS YF WHERE YF." + COLUMN_FUND_ID + " = " + fund_ID;
		
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
		db.close();
		return years;
	}
	
	/**
	 * @return All years
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
			temp.setGift_total(new int[] {
					Integer.parseInt(c.getString(2)),
					Integer.parseInt(c.getString(3))
			});
			
			years.add(temp);
		}
		db.close();
		return years;
	}
	
	/**
	 * 
	 * @param name
	 * @return the full year object, an ID and Name (the year)
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
		db.close();
		return year;
	}
	
	/**
	 * 
	 * @return list of strings of years
	 */
	public ArrayList<String> getYearNames(){
		ArrayList<String> yearNames = new ArrayList<String>();
		
		String queryString = "SELECT " + COLUMN_NAME + " FROM " + TABLE_YEAR;
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor c = db.rawQuery(queryString, null);
		
		while(c.moveToNext()){
			yearNames.add(c.getString(0));
		}
		db.close();
		return yearNames;
	}
	
	/**
	 * 
	 * @param Fund_ID
	 * @return a list of strings of years based on a fund (determined by the fund's ID)
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
		db.close();
		return yearNames;
	}
	
	/**
	 * 
	 * @param Account_ID
	 * @return list of strings of years based on a account (determined by the account's ID)
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
		db.close();
		return yearNames;
	}
	
	/**
	 * Pulls the year and the total amount for the fund 
	 * @param the fund to pull years for
	 * @return a list of years associated with the fund
	 */
	public ArrayList<Year> getYears(int Fund_ID){
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
		db.close();
		return years;
	}
	
	/**
	 * 
	 * @return the total year-to-date amount donated
	 */
	public String getYTDAmount(){
		Calendar c = Calendar.getInstance();
		int year = c.get(Calendar.YEAR);
		String queryString = "SELECT YA." + COLUMN_GIFTTOTALWHOLE
				+ ", YA." + COLUMN_GIFTTOTALPART + " FROM " + TABLE_YEARACCOUNT_MAP
				+ " AS YA INNER JOIN " + TABLE_YEAR + " AS Y ON YA." + COLUMN_YEAR_ID
				+ " = Y." + COLUMN_ID + " WHERE Y." + COLUMN_NAME + " = \"" + year + "\"";
		
		SQLiteDatabase db = this.getReadableDatabase();
		
		Cursor cursor = db.rawQuery(queryString, null);
		String returnVal = "";
		if(cursor.moveToFirst()){
			returnVal = "$" + cursor.getString(0) + "." + cursor.getString(1);
		}else{
			returnVal = "NA";
		}
		db.close();
		return returnVal;
	}	
	
	/* ************************* Update Queries ************************* */
	
	/**
	 * Updates the timestamp from the originalDate (in milli) to date (in milli)
	 * @param originalDate
	 * @param date
	 */
	public void updateTimeStamp(String originalDate, String date){
		ContentValues values = new ContentValues();
		values.put(COLUMN_DATE, date);
		
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
	 * @param newDonor_id, change the donor id to something new
	 */
	public void updateAccount(int id, String newName, String newPass, String newServer, int newDonor_id){
		
		ContentValues values = new ContentValues();
		values.put(COLUMN_ACCOUNTNAME, newName);
		values.put(COLUMN_ACCOUNTPASSWORD, newPass);
		values.put(COLUMN_SERVERNAME, newServer);
		values.put(COLUMN_DONOR_ID, newDonor_id);
		
		SQLiteDatabase db = this.getWritableDatabase();
		
		db.update(TABLE_ACCOUNTS, values, COLUMN_ID + " = " + id, null);
		db.close();
	}
	
	/**
	 * Updates the relationship between year_id and fund_id with a new gift total 
	 * based on gift_total_whole and gift_total_part
	 * @param year_id
	 * @param fund_id
	 * @param gift_total_whole
	 * @param gift_total_part
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
	 * Updates the relationship between year_id and account_id with a new gift total
	 * based on gift_total_whole and gift_total_part
	 * @param year_id
	 * @param account_id
	 * @param gift_total_whole
	 * @param gift_total_part
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